B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=7.3
@EndOfDesignText@
Sub Class_Globals
	Private masterPrinter As PrinterMain				'Ignore (the variable is actually used, the ide is buggy)
	Private statusItem As PrinterStatusSVItem	'Reference to item in StatusScreen
	Private DebugReceiptTextSize As Int = 16
	
	Public PrinterChars As Int					'Number of printer characters. Used for width measure
	Private MeasureLabel As Label				'Invisible label used for MeasuredWidth & MeasuredHeight calculations
	Private MeasuredWidth, MeasuredHeight As Float
	Private PrintBaseSV As ScrollView2D
	Private ScreenTarget As Panel
	
	Private fiscalMemoryMode As Boolean
	Private Jobs As List
	Private scripts As PrinterScripts
	
	Private printersMap As Map					'Hold all printers

	Private IDselectedPrinter As Int			'ID of the selected printer
	Private IDPrefix As Int						'ID prefix for all printers
	Private IDcounter As Int = 0				'ID Counter. Used to set next ID.
	
	Private Contents As List					'The contents to be printed (used list instead of bytes builder for easier visualization)
	Private priceCalculator As PrinterPriceCalculator	'Used to calculate prices
	
	'Settings
	Private ConnectionParameters As TConnectionParameters
	Private DeviceParameters As TDeviceParameters
	Private DeviceSettingsRequirements As Map	'Contains needed settings for selected device ("IP","Port".)
	
	Private VirtualOnScreenPrinter As Int
	
	'Output types
	Private OutputType As Int = 0				'CurrentOutput
	Private Const Output_Screen As Int = 1		'Outputs to screen
	
End Sub

'Initialize the Virtual printer
Public Sub Initialize (masterP As PrinterMain, IDPref As Int)
	MeasureLabel.Initialize("")
	MeasureLabel.Typeface = Typeface.MONOSPACE
	
	ScreenTarget.Initialize("")
	Contents.Initialize
	IDPrefix = IDPref
	masterPrinter = masterP
	
	printersMap.Initialize
	fillMap
	DeviceParameters.Initialize
	DeviceSettingsRequirements.Initialize
	priceCalculator.Initialize
	Jobs.Initialize
End Sub

'Fill map with unique ID's and printer name. 
'If new printer is added then add it to setSelected_Printer() too!
Private Sub fillMap
	VirtualOnScreenPrinter = AddPrinter("Virtual On-Screen Printer", Countries.Universe)
End Sub

'Set the parameter correct to work with the give printer.
Public Sub setSelected_Printer(id As Int)
	IDselectedPrinter = id
	
	Select IDselectedPrinter
		Case VirtualOnScreenPrinter
			setDeviceParams(48, 48)
			fiscalMemoryMode = False
			DeviceSettingsRequirements.Clear
			OutputType = Output_Screen

	End Select
End Sub

Public Sub doJobs
	statusItem.changeStatus(PrinterConstants.Printing)
	
	For Each job As Object In Jobs
		Select True
			Case job Is TPrnJobFiscalOpen: 			FiscalOpen(job)
			Case job Is TPrnJobFiscalSellItem:		FiscalSellItem(job)
			Case job Is TPrnJobFiscalPrintText:		FiscalPrintText(job)
			Case job Is TPrnJobFiscalPayment:		FiscalPayment(job)
			Case job Is TPrnJobFiscalClose:			FiscalClose(job)
			Case job Is TPrnJobNonFiscalOpen:		NonFiscalOpen(job)
			Case job Is TPrnJobNonFiscalPrintText:	NonFiscalPrintText(job)
			Case job Is TPrnJobNonFiscalClose:		NonFiscalClose(job)
			Case job Is TPrnJobPrintBarcode:		PrintBarcode(job)
			Case job Is TPrnJobReport:				Reports(job)
			Case job Is TPrnJobPayInOut:			PayInOut(job)
			Case job Is TPrnJobCashDrawerOpen:		CashDrawerOpen(job)
		End Select
	Next
	
	Wait For JobsFinished
	Jobs.Clear
End Sub

Private Sub FiscalOpen(job As TPrnJobFiscalOpen)
	priceCalculator.Reset
	If Not (Contents.IsInitialized) Then Contents.Initialize
	Contents.Clear
	AddHeader
End Sub

Private Sub FiscalSellItem(job As TPrnJobFiscalSellItem)
	For Each text As String In ScriptMaster.RunDetailScript(scripts.Details,job, DeviceParameters.fiscalChars, PrinterConstants.ESC_POS_1)
		Send(text)
	Next
	priceCalculator.addItem(job)
End Sub

Private Sub FiscalPrintText(job As TPrnJobFiscalPrintText)
	Send(job.Text)
End Sub

Private Sub FiscalPayment(job As TPrnJobFiscalPayment)
	priceCalculator.AddPayment(job)
	For Each text As String In ScriptMaster.RunTotalScript(scripts.Totals, DeviceParameters.FiscalChars, priceCalculator, PrinterConstants.ESC_POS_1)
		Send(text)
	Next
End Sub

Private Sub FiscalClose(job As TPrnJobFiscalClose)
	ConnectToPrinter
End Sub

Private Sub NonFiscalOpen(job As TPrnJobNonFiscalOpen)
	priceCalculator.Reset
	If Not (Contents.IsInitialized) Then Contents.Initialize
	Contents.Clear
	AddHeader
End Sub

Private Sub NonFiscalPrintText(job As TPrnJobNonFiscalPrintText)
	Send(job.Text)
End Sub

Private Sub NonFiscalClose(job As TPrnJobNonFiscalClose)
	ConnectToPrinter
End Sub

Private Sub PrintBarcode(job As TPrnJobPrintBarcode)
End Sub

Private Sub Reports(job As TPrnJobReport)

End Sub

Private Sub PayInOut(job As TPrnJobPayInOut)
End Sub

Private Sub CashDrawerOpen(job As TPrnJobCashDrawerOpen)
End Sub

'Акумулиране на данни за печат в буфера
Private Sub Send(s As String)
'	If (HelperFunctions.ContainsArabic(s)) Then s = HelperFunctions.PrepareArabicForPrint(s)
	If s.Length > 0 Then
		Contents.Add(s)
	End If
End Sub

#Region Common subs
Public Sub Assign_Scripts(printerScripts As PrinterScripts)
	scripts = printerScripts
End Sub

'Copy current object
Public Sub getPrinter_Instance As PrinterVirtual
	Dim objectCopy As PrinterVirtual
	objectCopy.Initialize(masterPrinter, IDPrefix)
	Return objectCopy
End Sub

'Return ID 
Private Sub AddPrinter(name As String, country As Int) As Int
	
	Dim id As Int = IDPrefix + IDcounter
	IDcounter = IDcounter + 1
	
	printersMap.Put(id,name)
	Return id
End Sub

public Sub getPrintersMap As Map
	Return printersMap
End Sub

Public Sub getFiscal_MemoryMode As Boolean
	Return fiscalMemoryMode
End Sub

'Configure device parameters
Private Sub setDeviceParams(FiscalChars As Int, nonFiscalChars As Int)
	DeviceParameters.FiscalChars = FiscalChars
	DeviceParameters.NonFiscalChars = nonFiscalChars
	PrinterChars = nonFiscalChars
End Sub

Public Sub setStatus_Item (item As PrinterStatusSVItem)
	statusItem = item
End Sub

'Set Connection parameters
Public Sub SetConnection_Parameters(connectionParams As TConnectionParameters)
	ConnectionParameters = connectionParams
End Sub

'Return current device parameters
Public Sub GetDevice_Parameters As TDeviceParameters
	Return DeviceParameters
End Sub

'Return connection parameters
Public Sub getConnection_Parameters As TConnectionParameters
	Return ConnectionParameters
End Sub

'Return device settings requirements
Public Sub getDevice_SettingsRequirements As Map
	Return DeviceSettingsRequirements
End Sub

Public Sub addJob(job As Object)
	Jobs.Add(job)
End Sub

#End Region

'Measures the needed width and height to display a line / Измерва нужната ширина и височина за да покаже линията.
Private Sub MeasureChars
	Dim CVN As Canvas
	CVN.Initialize(ScreenTarget)
	MeasureLabel.Text = ""
	
	For i = 0 To PrinterChars - 1
		MeasureLabel.Text = MeasureLabel.Text & "#"
	Next
	
	MeasuredWidth = CVN.MeasureStringWidth(MeasureLabel.Text, Typeface.MONOSPACE, DebugReceiptTextSize)
	MeasuredHeight = CVN.MeasureStringHeight(MeasureLabel.Text, Typeface.MONOSPACE, DebugReceiptTextSize) * 2 'MeasureStringHeight returns half height so multiply by 2
End Sub

Private Sub ConnectToPrinter
	AddFooter
		Select OutputType
			Case Output_Screen 	: PrintOnScreen
		End Select
End Sub

'Headers for reciept
Private Sub AddHeader
	For Each text As String In ScriptMaster.RunPostProcessing(scripts.Headers, DeviceParameters.FiscalChars, PrinterConstants.ESC_POS_1)
		Send(text)
	Next
End Sub

'Footers for the reciept
Private Sub AddFooter
	For Each text As String In ScriptMaster.RunPostProcessing(scripts.Footers, DeviceParameters.FiscalChars, PrinterConstants.ESC_POS_1)
		Send(text)
	Next
End Sub

'Shows the reciept on-screen / Показва бележката на екрана
Private Sub PrintOnScreen
	ScreenTarget = CallSub(Main, "Reference_Activity")
	MeasureChars
	Dim heightPerLine As Int = MeasuredHeight
	If PrintBaseSV.IsInitialized Then btnClose_Click
	PrintBaseSV.Initialize(MeasuredWidth, 200%y, "")
	PrintBaseSV.Color = Colors.ARGB(220, 0, 0, 0)
	PrintBaseSV.Panel.Color = Colors.DarkGray
	ScreenTarget.AddView(PrintBaseSV, 0, 0, 100%x, 100%y)
	
	For i = 0 To Contents.Size - 1
		Dim l As Label
		l.Initialize("")
		l.Typeface = Typeface.MONOSPACE
		l.Text = Contents.Get(i)
		l.Color = Colors.White
		l.TextColor = Colors.Black
		l.TextSize = DebugReceiptTextSize
		PrintBaseSV.Panel.AddView(l, 0, heightPerLine * i, MeasuredWidth, heightPerLine)
	Next
	
	If statusItem.IsInitialized Then statusItem.changeStatus(PrinterConstants.ERR_NoError)'statusItem.printingFinished
	
	Dim btnClose As Button
	btnClose.Initialize("btnClose")
	btnClose.Text = "Close"
	PrintBaseSV.Panel.AddView(btnClose, 0, l.Top + l.height, PrintBaseSV.Panel.Width, 52dip)
	FitViewsInScroll(PrintBaseSV)
End Sub

'Closes the On-Screen Printer / Затваря екрана с принтера
Private Sub btnClose_Click
	PrintBaseSV.Panel.RemoveAllViews
	PrintBaseSV.RemoveView
End Sub

'Resize ScrollView inner panel so all views are visible. / Преоразмерява вътрешния панел на ScrollView за да се виждат всички елементи.
Private Sub FitViewsInScroll(targetScroll As ScrollView2D)
	Private viewLast As View = Find_LastView(targetScroll.Panel)
	If viewLast.IsInitialized Then targetScroll.Panel.Height = (viewLast.Top + viewLast.Height) + 12dip
	targetScroll.SmoothScrollTo(0, 0)
End Sub

'Finds the last view / Намира последния контрол(изглед) 
Private Sub Find_LastView (pan As Panel) As View
	Private LastView As View
	LastView = pan.GetView(pan.NumberOfViews - 1)
	Return LastView
End Sub
