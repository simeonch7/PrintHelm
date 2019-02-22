B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=7.3
@EndOfDesignText@
Private Sub Class_Globals
	Type Printer(id As Int,name As String,ref As Object)
	Type PrinterScripts(Headers As List, Footers As List, Details As List, Totals As List)
	Type TActivePrinter(id As Int, driver As Object,name As String,connectionParams As TConnectionParameters, ScriptsTemplate As PrinterScripts)
	
	Type TPrnJobFiscalOpen(Phone As String, Refund As Boolean)
	Type TPrnJobFiscalSellItem(ItemName As String, Price As Double, Quantity As Double, Description As String, PLU As Long, ItemMeasure As String, VATIndex As Int, VATPercent As Double)
	Type TPrnJobFiscalPrintText(Text As String)
	Type TPrnJobFiscalPayment(PaySum As Double, PayType As Int)
	Type TPrnJobFiscalClose(Result As Int)
	Type TPrnJobNonFiscalOpen(Result As Int)
	Type TPrnJobNonFiscalPrintText(Text As String)
	Type TPrnJobNonFiscalClose(Result As Int)
	Type TPrnJobPrintBarcode(Barcode As String)
	Type TPrnJobReport(ReportType As Int, ParamFrom As String, ParamTo As String)
	Type TPrnJobPayInOut(PaySum As Double, PayType As Int)
	Type TPrnJobCashDrawerOpen(Result As Int)
	Type TPrnJobDelay(time As Int)
	
	Type TDeviceParameters(NonFiscalChars As Int, FiscalChars As Int)
	Type TConnectionParameters(UserID As String, Password As String, SerialPort As String, BaudRate As Long, IPAddress As String, IPPort As Long, DeviceMAC As String)
	
	Private defaultScripts As PrinterScripts
	
	Private Jobs As List							'Hold all the jobs
	Public mapPrinters As Map						'Public needed for ReadPrinters method. Holds all printers. <key,value> = <PrinterName.name,PrinterName>
	Public savedPrinters As List

	Private IDPrefix As Int = 0						'Current ID
	Private Const IDPrefixStep As Int = 500			'Step to Next ID
	Private callBack As Object						'CallBack = POSScreen
	
	Private ScreenProgress As PrinterStatusScreen

	
	Public ActivePrinters As List
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(CB As Object)
	savedPrinters.Initialize
	ActivePrinters.Initialize
	LoadSavedPrinters
	
	PrinterConstants.initCommandSets
	generateDefaultScripts
	DisableStrictMode				'Allow Network on main thread (this is needed only once for app runtime)
	callBack = CB
	Jobs.Initialize
	mapPrinters.Initialize
	
	initAllPrinterDrivers
End Sub

Public Sub initPrintingScreen(parent As Panel, buttonHolder As Panel)
	ScreenProgress.Initialize(Me, callBack)
	ScreenProgress.BuildScreen(parent, buttonHolder)
	ReadPrinters
End Sub

'Init all printer drivers and add their names in mapPrinters
Private Sub initAllPrinterDrivers

	Dim printPOS As PrinterPOS
	printPOS.Initialize(Me, IDPrefix)
	addToPrintersMap(printPOS.getPrintersMap, printPOS)
		
		
		
	Dim printVirtual As PrinterVirtual
	printVirtual.Initialize(Me, IDPrefix)
	addToPrintersMap(printVirtual.getPrintersMap, printVirtual)
End Sub

'increment id before initialize next printer dirver
Private Sub incrementIDPrefix
	IDPrefix = IDPrefix + IDPrefixStep
End Sub

'Add printer to Main.ActivePrinters
Public Sub addToActivePrinter(printer As TActivePrinter)
	'First try to find the printer by name.
	'If not found tries to find the printer by ID
	'If found by ID and the printers are from old version there is chance that the driver will not be set curectly
	Dim initPrinter As Printer
	initPrinter = getInitialPrinterByName(printer.name)
	If initPrinter <> Null Then
		printer.id = initPrinter.id
	Else
		initPrinter = getInitialPrinterByID(printer.id)
		If initPrinter <> Null Then
			printer.name = initPrinter.name
		Else
			Log("Unknown printer: " & printer.id & " " & printer.name)
			Return
		End If
	End If
	
	'Configure Active Printer
	Dim oPrinter As Object = CallSub(initPrinter.ref, "getPrinter_Instance")'MakeNewPrinterInstance(printer)
	CallSub2(oPrinter,"setSelected_Printer", printer.id)
	CallSub2(oPrinter,"SetConnection_Parameters", printer.connectionParams)
	printer.driver = oPrinter
	
	'Add to Active Printers
	ActivePrinters.Add(printer)
	ScreenProgress.AddPrinter(printer)
	
End Sub

Public Sub removeFromActivePrinter(index As Int)
	ActivePrinters.RemoveAt(index)
	ScreenProgress.removePrinter(index)

End Sub

'Add printers to local map of all printers.
Private Sub addToPrintersMap(m As Map, ref As Object)

	incrementIDPrefix
	
	For i = 0 To m.Size - 1
		Dim p As Printer
		p.Initialize
		p.id = m.GetKeyAt(i)
		p.Name = m.GetValueAt(i)
		p.ref = ref
		
		mapPrinters.Put(p.id, p)
	Next
	
End Sub

'return list full of PrinterName(id As Int,Name As String,ref As Object)
Public Sub getPrintersList As List
	
	Dim l As List
	l.Initialize

	For Each printer As Printer In mapPrinters.Values
		l.Add(printer.name)
	Next
	
	Return l
	
End Sub

'get printer by Printer Name
'Return null if not found
Public Sub getInitialPrinterByName(printerName As String) As Printer
	For Each printer As Printer In mapPrinters.Values
		If printer.name = printerName Then Return printer
	Next
	Return Null
End Sub

'get printer by Printer ID
'Return null if not found
Public Sub getInitialPrinterByID(printerID As Int) As Printer
	If mapPrinters.ContainsKey(printerID) Then Return mapPrinters.Get(printerID)
	Return Null
End Sub

'Add the given job to List
Public Sub AddJob(PrinterJob As Object)
	Jobs.Add(PrinterJob)
End Sub

'Send Jobs to all Printers in Main.ActivePrinter
Public Sub DoJobs
	
	ScreenProgress.FloatingButton.ResetCounterButton
	For i = 0 To ActivePrinters.Size - 1
		Dim APrinter As TActivePrinter = ActivePrinters.Get(i)
		Dim fiscalMemoryMode As Boolean = CallSub(APrinter.driver, "getFiscal_MemoryMode")
		
		Dim tempDevParams As TDeviceParameters
		tempDevParams = CallSub(APrinter.driver,"GetDevice_Parameters")
		
		Dim ScriptsProcess,tempScripts As PrinterScripts
		ScriptsProcess.Initialize
		
		'DON'T CHANGE: Use temp scripts, not Aprinter.Scripts
		tempScripts.Initialize
		tempScripts.Headers.Initialize
		tempScripts.Headers.AddAll(APrinter.ScriptsTemplate.Headers)
		If tempScripts.Headers.Size = 0 And fiscalMemoryMode = False Then tempScripts.Headers = defaultScripts.Headers
		
		tempScripts.Footers.Initialize
		tempScripts.Footers.AddAll(APrinter.ScriptsTemplate.Footers)
		If tempScripts.Footers.Size = 0 And fiscalMemoryMode = False Then tempScripts.Footers = defaultScripts.Footers
		
		tempScripts.Details.Initialize
		tempScripts.Details.AddAll(APrinter.ScriptsTemplate.Details)
		If tempScripts.Details.Size = 0 Then tempScripts.Details = defaultScripts.Details
		
		
		tempScripts.Totals.Initialize
		tempScripts.Totals.AddAll(APrinter.ScriptsTemplate.Totals)
		If tempScripts.Totals.Size = 0 Then tempScripts.Totals = defaultScripts.Totals
		
		
'		Pre Processing Header
		Dim HeaderResultMap As Map = ScriptMaster.RunPreProcessing(tempScripts.Headers, tempDevParams.FiscalChars)
		Dim HeaderscriptJobs As List = HeaderResultMap.Get("jobs")
		Dim HeaderScriptNormal As List = HeaderResultMap.Get("script")
		ScriptsProcess.Headers = HeaderScriptNormal
		
		For Each job As Object In HeaderscriptJobs
			CallSub2(APrinter.driver, "AddJob", job)
		Next
		
		'Jobs
		For Each job As Object In Jobs
			CallSub2(APrinter.driver, "AddJob", job)
		Next
		
		'Pre Processing Footer
		Dim FooterResultMap As Map = ScriptMaster.RunPreProcessing(tempScripts.Footers, tempDevParams.FiscalChars)
		Dim FooterScriptJobs As List = FooterResultMap.Get("jobs")
		Dim FootersScriptNormal As List = FooterResultMap.Get("script")
		ScriptsProcess.Footers = FootersScriptNormal
				
		For Each job As Object In FooterScriptJobs
			CallSub2(APrinter.driver, "AddJob", job)
		Next
		
		'Add details and totals scripts
		ScriptsProcess.Details = tempScripts.Details
		ScriptsProcess.Totals = tempScripts.Totals
		
'		set the driver scripts
		CallSub2(APrinter.driver,"Assign_Scripts",ScriptsProcess)
	
		CallSub(APrinter.driver,"doJobs")
'		CallSubDelayed(APrinter.driver,"doJobs")
	Next
	
	Jobs.Clear
End Sub

'Loads all active printers from "Printers.config"
private Sub LoadSavedPrinters
	Try
		If File.Exists(Main.SHAREDFolder, "Printers.config") Then
			Dim RAF As RandomAccessFile
			RAF.Initialize(Main.SHAREDFolder, "Printers.config", False)
			Dim readPrinterList As List
			readPrinterList.Initialize
			readPrinterList = RAF.ReadEncryptedObject(ProgramData.rafEncPass, RAF.CurrentPosition)
			savedPrinters = readPrinterList
			RAF.Close
		End If
	Catch
		Msgbox("","Warrning")
		Log(LastException)
	End Try
End Sub
'
Private Sub ReadPrinters
	'Clear printer settings file for debuging
	'If File.Exists(File.DirDefaultExternal, "Printers.config") Then File.Delete(File.DirDefaultExternal, "Printers.config")
	Try
		ActivePrinters.Clear
		If savedPrinters.Size > 0 Then
		
			For i = 0 To savedPrinters.Size - 1
				
				'Get current printer
				Dim tmpPrint, PrinterToAdd As TActivePrinter
				tmpPrint = savedPrinters.Get(i)
				PrinterToAdd.Initialize
				PrinterToAdd.name = tmpPrint.name
				PrinterToAdd.id = tmpPrint.id
				
				'Set Connection Params
				If tmpPrint.connectionParams.IsInitialized Then
					PrinterToAdd.connectionParams = tmpPrint.connectionParams
				Else
					Log("Invalid connection parameters: " &  tmpPrint.name)
					Continue
				End If
				
				'Set scripts
				If (tmpPrint.ScriptsTemplate = Null) Then
					PrinterToAdd.ScriptsTemplate.Initialize
					PrinterToAdd.ScriptsTemplate.Headers.Initialize
					PrinterToAdd.ScriptsTemplate.Details.Initialize
					PrinterToAdd.ScriptsTemplate.Totals.Initialize
					PrinterToAdd.ScriptsTemplate.Footers.Initialize
				Else
					PrinterToAdd.ScriptsTemplate = tmpPrint.ScriptsTemplate
				End If
				
				'Add to Active Printers
				addToActivePrinter(PrinterToAdd)
				
			Next
		End If
	Catch
		Log(LastException)
	End Try
End Sub

'Check if the printer exists in savedPrinters.
'First check by name then check by ID
Public Sub SavedPrintersContains(name As String, ID As String) As Boolean
	For Each printer As TActivePrinter In savedPrinters
		If printer.name.EqualsIgnoreCase(name) Then Return True
	Next
	
	For Each printer As TActivePrinter In savedPrinters
		If printer.ID = ID Then Return True
	Next
	Return False
End Sub

private Sub generateDefaultScripts
	defaultScripts.Initialize
	defaultScripts.Headers.Initialize
	defaultScripts.Details.Initialize
	defaultScripts.Footers.Initialize
	defaultScripts.Totals.Initialize
'	
	defaultScripts.Headers.Add("")
	defaultScripts.Headers.Add("<Center>Добре дошли!")
	defaultScripts.Headers.Add("<Center><Object>")
	defaultScripts.Headers.Add("<Center><Owner>")
	defaultScripts.Headers.Add("<Center><OwnerAddress>")
	defaultScripts.Headers.Add("<Center><OwnerMOL>")
	defaultScripts.Headers.Add("<Center><Operator>")
	defaultScripts.Headers.Add("<Symbol>-")
	
	defaultScripts.Details.Add("<ItemName>")
	defaultScripts.Details.Add("<ItemQtty> x <ItemPrice>      <ItemTotal><Right>")

	defaultScripts.Totals.Add("<Symbol>-")
	defaultScripts.Totals.Add("<Right><TotalCaption> <Total>")
	defaultScripts.Totals.Add("<Right><PaymentsCaption> <Payments>")
	defaultScripts.Totals.Add("<Right><ChangeCaption> <Change>")
	'
	defaultScripts.Details.Add("<empty>")
	defaultScripts.Footers.Add("<Center>Благодарим ви!")
	defaultScripts.Footers.Add("<Right><Date> <Time>")
	
End Sub

Private Sub DisableStrictMode
	Dim jo As JavaObject
	jo.InitializeStatic("android.os.Build.VERSION")
   
	If jo.GetField("SDK_INT") > 9 Then
		Dim policy As JavaObject
		policy = policy.InitializeNewInstance("android.os.StrictMode.ThreadPolicy.Builder", Null)
		policy = policy.RunMethodJO("permitAll", Null).RunMethodJO("build", Null)
		Dim sm As JavaObject
		sm.InitializeStatic("android.os.StrictMode").RunMethod("setThreadPolicy", Array(policy))
	End If
End Sub