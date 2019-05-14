B4A=true
Group=Printers\PrintersDrivers
ModulesStructureVersion=1
Type=Class
Version=7.3
@EndOfDesignText@
Sub Class_Globals
	'General
	Private masterPrinter As PrinterMain				'Ignore (the variable is actually used, the ide is buggy)
	Private statusItem As PrinterStatusSVItem	'Reference to item in StatusScreen
	Private userAction As ResumableSub			'Used to get action when error interupt printing.
	
	Private selectedCmdSet As Int 
	
	Private printersMap As Map					'Hold all printers

	Private IDselectedPrinter As Int			'ID of the selected printer
	Private IDPrefix As Int						'ID prefix for all printers
	Private IDcounter As Int = 0				'ID Counter. Used to set next ID.
	
	Private fiscalMemoryMode As Boolean
	Private Jobs As List
	Private scripts As PrinterScripts
	
	Private priceCalculator As PrinterPriceCalculator	'Used to calculate prices
	
	'Buffer
	Private NumberEmptyLines As Int = 3
	
	'Settings
	Private ConnectionParameters As TConnectionParameters
	Private DeviceParameters As TDeviceParameters
	Private DeviceSettingsRequirements As Map	'Contains needed settings for selected device ("IP","Port".)
	
	'Connection
	Private PrinterCodePage As String = ""
	Private PrinterInitString As String = ""
	Private PrinterCutterString As String = ""
	Private BTAdmin As BluetoothAdmin
	Private BTPort As Serial
	Private MySocket As Socket
	Private USBAdmin As UsbManager
	Private USBSerial As felUsbSerial
	Private PrinterTX As AsyncStreams
	Private Contents As BytesBuilder
	Private TryLoops = 3 As Int
		
	'Printers
	Private APrinterAP58D As Int
	Private APrinterAP80COM As Int
	Private APrinterAP80LAN As Int
	Private GenericBT32 As Int
	Private GenericBT40 As Int
	Private GenericBT48 As Int
	Private GenericLAN32 As Int
	Private GenericLAN40 As Int
	Private GenericLAN48 As Int
	Private GenericSerial32 As Int
	Private GenericSerial40 As Int
	Private GenericSerial48 As Int
	Private DatecsDPP250 As Int
	Private DatecsDPP350 As Int
	Private DatecsDPP450 As Int
	Private DatecsCMP10 As Int
	Private StarWSPi350 As Int
	Private BixolonSPPR300 As Int
	Private RongtaRPP02 As Int
	Private RongtaRP326LAN As Int
	Private RongtaRP326COM As Int
	Private PR300 As Int
	Private BrostC230BT As Int
	Private BrostC230LAN As Int
	Private PosTechnology80 As Int
	Private ArabicBT32 As Int
	Private ArabicBT40 As Int
	Private ArabicBT48 As Int
	Private ArabicLAN32 As Int
	Private ArabicLAN40 As Int
	Private ArabicLAN48 As Int
	Private ArabicSerial32 As Int
	Private ArabicSerial40 As Int
	Private ArabicSerial48 As Int

	Private Const Conn_BT As Int = 1				'Комуникация чрез Bluetooth
	Private Const Conn_LAN As Int = 2				'Комуникация чрез LAN
	Private Const Conn_COM As Int = 3				'Комуникация чрез Serial Port
	Private DeviceConnection As Int = 0				'Текущ режим на комуникация на устройството

	'Control Commands
	Private Const ESC As String = Chr(27) 				'DEC = 27 HEX = 0x1B
	Private Const GS As String = Chr(29) 				'DEC = 29 HEX = 0x1D
End Sub

'Initializes the object
Public Sub Initialize(masterP As PrinterMain, IDPref As Int)
	IDPrefix = IDPref
	masterPrinter = masterP
	
	printersMap.Initialize
	fillMap
	
	DeviceParameters.Initialize
	DeviceSettingsRequirements.Initialize
	
	priceCalculator.Initialize
	
	Jobs.Initialize
	USBAdmin.Initialize
	Contents.Initialize
End Sub

'Fill map with unique ID's and printer name. 
'If new printer is added then add it to setSelected_Printer() too!
Private Sub fillMap
	APrinterAP58D = 	AddPrinter("APrinter AP-58D Serial", Countries.Universe)
	APrinterAP80COM = 	AddPrinter("APrinter POS-801 Serial", Countries.Universe)
	APrinterAP80LAN = 	AddPrinter("APrinter POS-801 LAN", Countries.Universe)
	GenericLAN32 = 		AddPrinter("Generic LAN 32", Countries.Universe)
	GenericLAN40 = 		AddPrinter("Generic LAN 40", Countries.Universe)
	GenericLAN48 = 		AddPrinter("Generic LAN 48", Countries.Universe)
	GenericBT32 = 		AddPrinter("Generic Bluetooth 32", Countries.Universe)
	GenericBT40 = 		AddPrinter("Generic Bluetooth 40", Countries.Universe)
	GenericBT48 = 		AddPrinter("Generic Bluetooth 48", Countries.Universe)
	GenericSerial32 = 	AddPrinter("Generic Serial 32", Countries.Universe)
	GenericSerial40 = 	AddPrinter("Generic Serial 40", Countries.Universe)
	GenericSerial48 = 	AddPrinter("Generic Serial 48", Countries.Universe)
	DatecsDPP250 = 		AddPrinter("Datecs DPP-250 Bluetooth", Countries.Universe)
	DatecsDPP350 = 		AddPrinter("Datecs DPP-350 Bluetooth", Countries.Universe)
	DatecsDPP450 = 		AddPrinter("Datecs DPP-450 Bluetooth", Countries.Universe)
	DatecsCMP10 = 		AddPrinter("Datecs CMP-10 Bluetooth", Countries.Universe)
	StarWSPi350 = 		AddPrinter("Star WSP-i350 Bluetooth", Countries.Universe)
	BixolonSPPR300 = 	AddPrinter("Bixolon SPP-R300 Bluetooth", Countries.Universe)
	RongtaRPP02 = 		AddPrinter("Rongta RPP-02 Bluetooth", Countries.Universe)
	RongtaRP326LAN = 	AddPrinter("Rongta RP-326 LAN", Countries.Universe)
	RongtaRP326COM = 	AddPrinter("Rongta RP-326 Serial", Countries.Universe)
	PR300 = 			AddPrinter("PR300 LAN", Countries.Universe)
	BrostC230BT = 		AddPrinter("Brost C230H Bluetooth", Countries.Universe)
	BrostC230LAN = 		AddPrinter("Brost C230H WiFi", Countries.Universe)
	PosTechnology80 = 	AddPrinter("POS Technology PT80-UE", Countries.Universe)
	ArabicLAN32 = 		AddPrinter("Arabic ESC/POS LAN 32", Countries.Universe)
	ArabicLAN40 = 		AddPrinter("Arabic ESC/POS LAN 40", Countries.Universe)
	ArabicLAN48 = 		AddPrinter("Arabic ESC/POS LAN 48", Countries.Universe)
	ArabicBT32 = 		AddPrinter("Arabic ESC/POS Bluetooth 32", Countries.Universe)
	ArabicBT40 = 		AddPrinter("Arabic ESC/POS Bluetooth 40", Countries.Universe)
	ArabicBT48 = 		AddPrinter("Arabic ESC/POS Bluetooth 48", Countries.Universe)
	ArabicSerial32 = 	AddPrinter("Arabic ESC/POS Serial 32", Countries.Universe)
	ArabicSerial40 = 	AddPrinter("Arabic ESC/POS Serial 40", Countries.Universe)
	ArabicSerial48 = 	AddPrinter("Arabic ESC/POS Serial 48", Countries.Universe)
End Sub

'Set the parameter correct to work with the give printer.
Public Sub setSelected_Printer(id As Int)
	IDselectedPrinter = id
	
	Select IDselectedPrinter
		
		Case APrinterAP58D
			setDeviceParams(32, 32)
			fiscalMemoryMode = False
			PrinterCodePage = Utilities.SelectCodepage("windows-1251")
			PrinterInitString =  ESC & "t" & Chr(0x06)
			PrinterCutterString = ""
			DeviceSettingsRequirements.Clear
			DeviceSettingsRequirements.Put(Main.PS_BaudRate, "9600")
			DeviceConnection = Conn_COM
			selectedCmdSet = PrinterConstants.ESC_POS_1

		Case APrinterAP80COM
			setDeviceParams(48, 48)
			fiscalMemoryMode = False
			PrinterCodePage = Utilities.SelectCodepage("windows-1251")
			PrinterInitString =  ESC & "t" & Chr(0x06)
			PrinterCutterString = ESC & "i"
			DeviceSettingsRequirements.Clear
			DeviceSettingsRequirements.Put(Main.PS_BaudRate, "9600")
			DeviceConnection = Conn_COM
			selectedCmdSet = PrinterConstants.ESC_POS_1

		Case APrinterAP80LAN
			setDeviceParams(32, 32)
			fiscalMemoryMode = False
			PrinterCodePage = Utilities.SelectCodepage("windows-1251")
			PrinterInitString =  ESC & "t" & Chr(0x06)
			PrinterCutterString = ESC & "i"
			DeviceSettingsRequirements.Clear
			DeviceSettingsRequirements.Put(Main.PS_IPAddress, "192.168.0.1")
			DeviceSettingsRequirements.Put(Main.PS_IPPort, "9100")
			DeviceConnection = Conn_LAN
			selectedCmdSet = PrinterConstants.ESC_POS_1

		Case GenericBT32
			setDeviceParams(32, 32)
			fiscalMemoryMode = False
			PrinterCodePage = Utilities.SelectCodepage("windows-1251")
			PrinterCutterString = ESC & "i"
			DeviceSettingsRequirements.Clear
			DeviceSettingsRequirements.Put(Main.PS_DeviceMAC,"")
			DeviceConnection = Conn_BT
			selectedCmdSet = PrinterConstants.ESC_POS_1
					
		Case GenericBT40
			setDeviceParams(40, 40)
			fiscalMemoryMode = False
			PrinterCodePage = Utilities.SelectCodepage("windows-1251")
			PrinterCutterString = ESC & "i"
			DeviceSettingsRequirements.Clear
			DeviceSettingsRequirements.Put(Main.PS_DeviceMAC,"")
			DeviceConnection = Conn_BT
			selectedCmdSet = PrinterConstants.ESC_POS_1
			
		Case GenericBT48
			setDeviceParams(48, 48)
			fiscalMemoryMode = False
			PrinterCodePage = Utilities.SelectCodepage("windows-1251")
			PrinterCutterString = ESC & "i"
			DeviceSettingsRequirements.Clear
			DeviceSettingsRequirements.Put(Main.PS_DeviceMAC,"")
			DeviceConnection = Conn_BT
			selectedCmdSet = PrinterConstants.ESC_POS_1
			
		Case GenericLAN32
			setDeviceParams(32, 32)
			fiscalMemoryMode = False
			PrinterCodePage = Utilities.SelectCodepage("windows-1251")
			PrinterCutterString = ESC & "i"
			DeviceSettingsRequirements.Clear
			DeviceSettingsRequirements.Put(Main.PS_IPAddress, "192.168.0.1")
			DeviceSettingsRequirements.Put(Main.PS_IPPort, "9100")
			DeviceConnection = Conn_LAN
			selectedCmdSet = PrinterConstants.ESC_POS_1
					
		Case GenericLAN40
			setDeviceParams(40, 40)
			fiscalMemoryMode = False
			PrinterCodePage = Utilities.SelectCodepage("windows-1251")
			PrinterCutterString = ESC & "i"
			DeviceSettingsRequirements.Clear
			DeviceSettingsRequirements.Put(Main.PS_IPAddress, "192.168.0.1")
			DeviceSettingsRequirements.Put(Main.PS_IPPort, "9100")
			DeviceConnection = Conn_LAN
			selectedCmdSet = PrinterConstants.ESC_POS_1
			
		Case GenericLAN48
			setDeviceParams(48, 48)
			fiscalMemoryMode = False
			PrinterCodePage = Utilities.SelectCodepage("windows-1251")
			PrinterCutterString = ESC & "i"
			DeviceSettingsRequirements.Clear
			DeviceSettingsRequirements.Put(Main.PS_IPAddress, "192.168.0.1")
			DeviceSettingsRequirements.Put(Main.PS_IPPort, "9100")
			DeviceConnection = Conn_LAN
			selectedCmdSet = PrinterConstants.ESC_POS_1
			
		Case GenericSerial32
			setDeviceParams(32, 32)
			fiscalMemoryMode = False
			PrinterCodePage = Utilities.SelectCodepage("windows-1251")
			PrinterCutterString = ESC & "i"
			DeviceSettingsRequirements.Clear
			DeviceSettingsRequirements.Put(Main.PS_BaudRate, "115200")
			DeviceConnection = Conn_COM
			selectedCmdSet = PrinterConstants.ESC_POS_1
			
		Case GenericSerial40
			setDeviceParams(40, 40)
			fiscalMemoryMode = False
			PrinterCodePage = Utilities.SelectCodepage("windows-1251")
			PrinterCutterString = ESC & "i"
			DeviceSettingsRequirements.Clear
			DeviceSettingsRequirements.Put(Main.PS_BaudRate, "115200")
			DeviceConnection = Conn_COM
			selectedCmdSet = PrinterConstants.ESC_POS_1
			
		Case GenericSerial48
			setDeviceParams(48, 48)
			fiscalMemoryMode = False
			PrinterCodePage = Utilities.SelectCodepage("windows-1251")
			PrinterCutterString = ESC & "i"
			DeviceSettingsRequirements.Clear
			DeviceSettingsRequirements.Put(Main.PS_BaudRate, "115200")
			DeviceConnection = Conn_COM
			selectedCmdSet = PrinterConstants.ESC_POS_1

		Case ArabicBT32
			setDeviceParams(32, 32)
			fiscalMemoryMode = False
			PrinterCodePage = Utilities.SelectCodepage("windows-1256")
			PrinterInitString =  ESC & "t" & Chr(0x22)
			PrinterCutterString = ESC & "i"
			DeviceSettingsRequirements.Clear
			DeviceSettingsRequirements.Put(Main.PS_DeviceMAC,"")
			DeviceConnection = Conn_BT
			selectedCmdSet = PrinterConstants.ESC_POS_1
					
		Case ArabicBT40
			setDeviceParams(40, 40)
			fiscalMemoryMode = False
			PrinterCodePage = Utilities.SelectCodepage("windows-1256")
			PrinterInitString =  ESC & "t" & Chr(0x22)
			PrinterCutterString = ESC & "i"
			DeviceSettingsRequirements.Clear
			DeviceSettingsRequirements.Put(Main.PS_DeviceMAC,"")
			DeviceConnection = Conn_BT
			selectedCmdSet = PrinterConstants.ESC_POS_1
			
		Case ArabicBT48
			setDeviceParams(48, 48)
			fiscalMemoryMode = False
			PrinterCodePage = Utilities.SelectCodepage("windows-1256")
			PrinterInitString =  ESC & "t" & Chr(0x22)
			PrinterCutterString = ESC & "i"
			DeviceSettingsRequirements.Clear
			DeviceSettingsRequirements.Put(Main.PS_DeviceMAC,"")
			DeviceConnection = Conn_BT
			selectedCmdSet = PrinterConstants.ESC_POS_1
			
		Case ArabicLAN32
			setDeviceParams(32, 32)
			fiscalMemoryMode = False
			PrinterCodePage = Utilities.SelectCodepage("windows-1256")
			PrinterInitString =  ESC & "t" & Chr(0x22)
			PrinterCutterString = ESC & "i"
			DeviceSettingsRequirements.Clear
			DeviceSettingsRequirements.Put(Main.PS_IPAddress, "192.168.0.1")
			DeviceSettingsRequirements.Put(Main.PS_IPPort, "9100")
			DeviceConnection = Conn_LAN
			selectedCmdSet = PrinterConstants.ESC_POS_1
					
		Case ArabicLAN40
			setDeviceParams(40, 40)
			fiscalMemoryMode = False
			PrinterCodePage = Utilities.SelectCodepage("windows-1256")
			PrinterInitString =  ESC & "t" & Chr(0x22)
			PrinterCutterString = ESC & "i"
			DeviceSettingsRequirements.Clear
			DeviceSettingsRequirements.Put(Main.PS_IPAddress, "192.168.0.1")
			DeviceSettingsRequirements.Put(Main.PS_IPPort, "9100")
			DeviceConnection = Conn_LAN
			selectedCmdSet = PrinterConstants.ESC_POS_1
			
		Case ArabicLAN48
			setDeviceParams(48, 48)
			fiscalMemoryMode = False
			PrinterCodePage = Utilities.SelectCodepage("windows-1256")
			PrinterInitString =  ESC & "t" & Chr(0x22)
			PrinterCutterString = ESC & "i"
			DeviceSettingsRequirements.Clear
			DeviceSettingsRequirements.Put(Main.PS_IPAddress, "192.168.0.1")
			DeviceSettingsRequirements.Put(Main.PS_IPPort, "9100")
			DeviceConnection = Conn_LAN
			selectedCmdSet = PrinterConstants.ESC_POS_1
			
		Case ArabicSerial32
			setDeviceParams(32, 32)
			fiscalMemoryMode = False
			PrinterCodePage = Utilities.SelectCodepage("windows-1256")
			PrinterInitString =  ESC & "t" & Chr(0x22)
			PrinterCutterString = ESC & "i"
			DeviceSettingsRequirements.Clear
			DeviceSettingsRequirements.Put(Main.PS_BaudRate, "115200")
			DeviceConnection = Conn_COM
			selectedCmdSet = PrinterConstants.ESC_POS_1
			
		Case ArabicSerial40
			setDeviceParams(40, 40)
			fiscalMemoryMode = False
			PrinterCodePage = Utilities.SelectCodepage("windows-1256")
			PrinterInitString =  ESC & "t" & Chr(0x22)
			PrinterCutterString = ESC & "i"
			DeviceSettingsRequirements.Clear
			DeviceSettingsRequirements.Put(Main.PS_BaudRate, "115200")
			DeviceConnection = Conn_COM
			selectedCmdSet = PrinterConstants.ESC_POS_1
			
		Case ArabicSerial48
			setDeviceParams(48, 48)
			fiscalMemoryMode = False
			PrinterCodePage = Utilities.SelectCodepage("windows-1256")
			PrinterInitString =  ESC & "t" & Chr(0x22)
			PrinterCutterString = ESC & "i"
			DeviceSettingsRequirements.Clear
			DeviceSettingsRequirements.Put(Main.PS_BaudRate, "115200")
			DeviceConnection = Conn_COM
			selectedCmdSet = PrinterConstants.ESC_POS_1

		Case DatecsDPP250
			setDeviceParams(32, 32)
			fiscalMemoryMode = False
			PrinterCodePage = Utilities.SelectCodepage("windows-1251")
			PrinterInitString =  ESC & "u" & Chr(0x11)
			DeviceSettingsRequirements.Clear
			DeviceSettingsRequirements.Put(Main.PS_DeviceMAC,"")
			DeviceConnection = Conn_BT
			selectedCmdSet = PrinterConstants.ESC_POS_1
			
		Case DatecsDPP350
			setDeviceParams(48, 48)
			fiscalMemoryMode = False
			PrinterCodePage = Utilities.SelectCodepage("windows-1251")
			PrinterInitString = ESC & "u" & Chr(0x11)
			DeviceSettingsRequirements.Clear
			DeviceSettingsRequirements.Put(Main.PS_DeviceMAC,"")
			DeviceConnection = Conn_BT
			selectedCmdSet = PrinterConstants.ESC_POS_1
			
		Case DatecsDPP450
			setDeviceParams(64, 64)
			fiscalMemoryMode = False
			PrinterCodePage = Utilities.SelectCodepage("windows-1251")
			PrinterInitString = ESC & "u" & Chr(0x11)
			DeviceSettingsRequirements.Clear
			DeviceSettingsRequirements.Put(Main.PS_DeviceMAC,"")
			DeviceConnection = Conn_BT
			selectedCmdSet = PrinterConstants.ESC_POS_1
			
		Case DatecsCMP10
			setDeviceParams(32, 32)
			fiscalMemoryMode = False
			PrinterCodePage = Utilities.SelectCodepage("windows-1251")
			PrinterInitString = ESC & "u" & Chr(0x11)
			DeviceSettingsRequirements.Clear
			DeviceSettingsRequirements.Put(Main.PS_DeviceMAC,"")
			DeviceConnection = Conn_BT
			selectedCmdSet = PrinterConstants.ESC_POS_1
			
		Case StarWSPi350
			setDeviceParams(48, 48)
			PrinterCodePage = Utilities.SelectCodepage("windows-1251")
			PrinterInitString = ESC & "t" & Chr(0x08)
			DeviceSettingsRequirements.Clear
			DeviceSettingsRequirements.Put(Main.PS_DeviceMAC,"")
			DeviceConnection = Conn_BT
			selectedCmdSet = PrinterConstants.ESC_POS_3
			
		Case BixolonSPPR300
			setDeviceParams(32, 32)
			fiscalMemoryMode = False
			PrinterCodePage = Utilities.SelectCodepage("windows-1251")
			DeviceSettingsRequirements.Clear
			DeviceSettingsRequirements.Put(Main.PS_DeviceMAC,"")
			DeviceConnection = Conn_BT
			selectedCmdSet = PrinterConstants.ESC_POS_2
			
		Case RongtaRPP02
			setDeviceParams(32, 32)
			fiscalMemoryMode = False
			PrinterCodePage = Utilities.SelectCodepage("windows-1251")
			PrinterInitString = ESC & "t" & Chr(0x06)
			DeviceSettingsRequirements.Clear
			DeviceSettingsRequirements.Put(Main.PS_DeviceMAC, "")
			DeviceConnection = Conn_BT
			selectedCmdSet = PrinterConstants.ESC_POS_1
			
		Case RongtaRP326LAN
			setDeviceParams(48, 48)
			fiscalMemoryMode = False
			PrinterCodePage = Utilities.SelectCodepage("windows-1251")
			PrinterInitString = ESC & "t" & Chr(0x06)								'Set Printer page to 6 (1251)
			PrinterInitString = PrinterInitString & GS & Chr(0x61) & Chr(0x0408)	'Enable ASB (Auto Status Back)
			PrinterCutterString = ESC & "i"
			NumberEmptyLines = 3
			DeviceSettingsRequirements.Clear
			DeviceSettingsRequirements.Put(Main.PS_IPAddress, "192.168.63.140")
			DeviceSettingsRequirements.Put(Main.PS_IPPort, "9100")
			DeviceConnection = Conn_LAN
			selectedCmdSet = PrinterConstants.ESC_POS_1
			
		Case RongtaRP326COM
			setDeviceParams(48, 48)
			fiscalMemoryMode = False
			PrinterCodePage = Utilities.SelectCodepage("windows-1251")
			PrinterInitString = ESC & "t" & Chr(0x06)								'Set Printer page to 6 (1251)
			PrinterInitString = PrinterInitString & GS & Chr(0x61) & Chr(0x0408)	'Enable ASB (Auto Status Back)
'			PrinterInitString = PrinterInitString & ESC & "t" & Chr(0x6)
			PrinterCutterString = ESC & "i"
			NumberEmptyLines = 3
			DeviceSettingsRequirements.Clear
			DeviceSettingsRequirements.Put(Main.PS_BaudRate, "19200")
			DeviceConnection = Conn_COM
			selectedCmdSet = PrinterConstants.ESC_POS_1
			
		Case PR300
			setDeviceParams(48, 48)
			fiscalMemoryMode = False
			PrinterCodePage = Utilities.SelectCodepage("IBM866")
			PrinterCutterString = ESC & "i"
			NumberEmptyLines = 3
			DeviceSettingsRequirements.Clear
			DeviceSettingsRequirements.Put(Main.PS_IPAddress, "192.168.63.100")
			DeviceSettingsRequirements.Put(Main.PS_IPPort, "9100")
			DeviceConnection = Conn_LAN
			selectedCmdSet = PrinterConstants.ESC_POS_1
			
		Case BrostC230BT
			setDeviceParams(48, 48)
			fiscalMemoryMode = False
			PrinterCodePage = Utilities.SelectCodepage("IBM866")
			PrinterInitString = ESC & "t" & Chr(0x11)
			PrinterCutterString = ESC & "i"
			NumberEmptyLines = 3
			DeviceSettingsRequirements.Clear
			DeviceSettingsRequirements.Put(Main.PS_DeviceMAC,"")
			DeviceConnection = Conn_BT
			selectedCmdSet = PrinterConstants.ESC_POS_1

		Case BrostC230LAN
			setDeviceParams(48, 48)
			fiscalMemoryMode = False
			PrinterCodePage = Utilities.SelectCodepage("IBM866")
			PrinterInitString = ESC & "t" & Chr(0x11)
			PrinterCutterString = ESC & "i"
			NumberEmptyLines = 3
			DeviceSettingsRequirements.Clear
			DeviceSettingsRequirements.Put(Main.PS_IPAddress, "192.168.192.250")
			DeviceSettingsRequirements.Put(Main.PS_IPPort, "9100")
			DeviceConnection = Conn_LAN
			selectedCmdSet = PrinterConstants.ESC_POS_1

		Case PosTechnology80
			setDeviceParams(48, 48)
			fiscalMemoryMode = False
			PrinterCodePage = Utilities.SelectCodepage("windows-1251")
			PrinterCutterString = ESC & "i"
			NumberEmptyLines = 3
			DeviceSettingsRequirements.Clear
			DeviceSettingsRequirements.Put(Main.PS_IPAddress, "192.168.63.100")
			DeviceSettingsRequirements.Put(Main.PS_IPPort, "9100")
			DeviceConnection = Conn_LAN
			selectedCmdSet = PrinterConstants.ESC_POS_1

	End Select
				
End Sub

#Region Common subs
Public Sub Assign_Scripts(printerScripts As PrinterScripts)
	scripts = printerScripts
End Sub

'Copy current object
Public Sub getPrinter_Instance As PrinterPOS
	Dim objectCopy As PrinterPOS
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
End Sub

Public Sub setStatus_Item(item As PrinterStatusSVItem)
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

'Execute all jobs
#Region Connection
Public Sub doJobs
	statusItem.changeStatus(PrinterConstants.Printing)
	
	Select Case DeviceConnection
		Case Conn_BT
			If Not(BTAdmin.IsInitialized) Then BTAdmin.Initialize("BluetoothAdmin")
			If Not(BTPort.IsInitialized) Then BTPort.Initialize("RemoteDevice")
			If BTPort.IsEnabled Then
				BTPort.Connect(ConnectionParameters.DeviceMAC)
			Else
				ConnectionError
			End If

		Case Conn_LAN
			If Not(MySocket.IsInitialized) Then MySocket.Initialize("RemoteDevice")
			MySocket.Connect(ConnectionParameters.IPAddress, ConnectionParameters.IPPort, 1500)

		Case Conn_COM
			If USBAdmin.GetDevices.Length > 0 Then
				Dim MyDevice As UsbDevice = USBAdmin.GetDevices(0) 					'Assuming that there is exactly one device
							
				If Not(USBAdmin.HasPermission(MyDevice)) Then
					ToastMessageShow(Main.translate.GetString("msgAllowUsbConnection"), True)
					USBAdmin.RequestPermission(MyDevice)
					ConnectionError
				Else
					USBSerial.Initialize("USBSerial", MyDevice, -1)
					USBSerial.BaudRate = ConnectionParameters.BaudRate
					USBSerial.DataBits = USBSerial.DATA_BITS_8
					USBSerial.Parity = USBSerial.PARITY_NONE
					USBSerial.StopBits = USBSerial.STOP_BITS_1
					
					Try
						USBSerial.StartReading
					Catch
						USBSerial.Close
						
						ConnectionError
						Return
					End Try
				
					ExecuteTask
				End If
			Else
				ToastMessageShow(Main.translate.GetString("msgNoDevice"),False)
				ConnectionError
			End If
	End Select
End Sub

Private Sub ConnectionError
	handleUserAction(PrinterConstants.ERR_NoCommunication)
	Wait For UserAction_Click(action As Int)
				
	Select action
		Case PrinterConstants.Action_Retry
			statusItem.changeStatus(PrinterConstants.Printing)
			doJobs
				
		Case PrinterConstants.Action_Abort
			statusItem.changeStatus(PrinterConstants.ERR_NoError)
			Jobs.Clear
	End Select
End Sub

Private Sub RemoteDevice_Connected(Successful As Boolean)
			
	If Successful Then
		
		Select Case DeviceConnection
			Case Conn_BT: 	Sleep(999):	PrinterTX.Initialize(BTPort.InputStream,   BTPort.OutputStream,   "PrinterTX")
			Case Conn_LAN: 	Sleep(100): PrinterTX.Initialize(MySocket.InputStream, MySocket.OutputStream, "PrinterTX")
			Case Conn_COM: 	Sleep(100)
		End Select
		
		TryLoops = 3
		
		ExecuteTask
	Else
		Select Case DeviceConnection
			Case Conn_BT: 	BTPort.Disconnect
			Case Conn_LAN:  MySocket.Close
			Case Conn_COM: 	USBSerial.Close
		End Select

		If TryLoops > 0 Then
			Utilities.FileLog("Connection atempt N:" & TryLoops)
			Sleep(300)
			
			TryLoops = TryLoops - 1
			doJobs
		Else
			TryLoops = 3
			Utilities.FileLog("No connection to the printer")
			
			handleUserAction(PrinterConstants.ERR_NoCommunication)
			Wait For UserAction_Click(action As Int)
			
			Select action
				Case PrinterConstants.Action_Retry: 	doJobs
				Case PrinterConstants.Action_Abort:		Jobs.Clear
			End Select
		End If
	End If
End Sub
#End Region

#Region Job Execution
Private Sub ExecuteTask
	Dim job As Object
	
	Do While Jobs.Size>0
		job = Jobs.Get(0)
		Jobs.RemoveAt(0)
		
		If DeviceConnection = Conn_BT Then BTPort.Listen
		
		Select True
			Case job Is TPrnJobFiscalOpen:			FiscalOpen(job)
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
	Loop
	
	Select Case DeviceConnection
		Case Conn_BT:	PrinterTX.Write(Contents.ToArray): Sleep(500)
		Case Conn_LAN:	PrinterTX.Write(Contents.ToArray): Sleep(300)
		Case Conn_COM:	USBSerial.Write(Contents.ToArray): Sleep(((Contents.ToArray.Length*1000*9)/ConnectionParameters.BaudRate)+500)
	End Select

	Contents.Clear
	
	Select Case DeviceConnection
		Case Conn_BT: 	PrinterTX.SendAllAndClose: Sleep(100): BTPort.Disconnect
		Case Conn_LAN: 	PrinterTX.SendAllAndClose: Sleep(100): MySocket.Close
		Case Conn_COM: 	USBSerial.Close
	End Select
	
	statusItem.changeStatus(PrinterConstants.ERR_NoError)
End Sub

Private Sub EventName_DataAvailable (Buffer() As Byte)
	
End Sub

Private Sub FiscalOpen(job As TPrnJobFiscalOpen)
	priceCalculator.Reset
	
	Send(PrinterInitString)
	
	AddHeader	
End Sub

Private Sub FiscalSellItem(job As TPrnJobFiscalSellItem)
	priceCalculator.addItem(job)
	
	For Each text As String In ScriptMaster.RunDetailScript(scripts.Details,job, DeviceParameters.fiscalChars, selectedCmdSet)
		Send(text)
	Next
End Sub

Private Sub FiscalPrintText(job As TPrnJobFiscalPrintText)
	Send(job.Text)
End Sub

Private Sub FiscalPayment(job As TPrnJobFiscalPayment)
	priceCalculator.AddPayment(job)
	For Each text As String In ScriptMaster.RunTotalScript(scripts.Totals, DeviceParameters.FiscalChars, priceCalculator, selectedCmdSet)
		Send(text)
	Next
End Sub

Private Sub FiscalClose(job As TPrnJobFiscalClose)
	AddFooter
	AddEmptyLines
	CutPaper
End Sub

Private Sub NonFiscalOpen(job As TPrnJobNonFiscalOpen)
	priceCalculator.Reset
	
	Send(PrinterInitString)	
	AddHeader
End Sub

Private Sub NonFiscalPrintText(job As TPrnJobNonFiscalPrintText)
	Send(job.Text)
End Sub

Private Sub NonFiscalClose(job As TPrnJobNonFiscalClose)
	AddFooter
	AddEmptyLines
	CutPaper	
End Sub

Private Sub PrintBarcode(job As TPrnJobPrintBarcode)
	If Regex.IsMatch("^[0-9]*$", job.Barcode) And job.Barcode.Length >= 3 And job.Barcode.Length <= 31 Then
		Send(Chr(0x1D) & Chr(0x68) & Chr(0x3F))
		Select Case job.Barcode.Length
			Case 8: 	Send(Chr(0x1D) & "k" & Chr(0x03) & job.Barcode & Chr(0x00))							'EAN-8
			Case 12: 	Send(Chr(0x1D) & "k" &  Chr(0x00) & job.Barcode.substring2(0, 11) & Chr(0x00))		'UPC-A
			Case 13: 	Send(Chr(0x1D) & "k" &  Chr(0x02) & job.Barcode & Chr(0x00))						'EAN-13
			Case Else: 	Send(Chr(0x1D) & "k" & Chr(0x04) & job.Barcode & Chr(0x00))							'Code 39
		End Select
	Else
		PrintQRCode(job.Barcode)
	End If
End Sub

Private Sub Reports(job As TPrnJobReport)
End Sub

Private Sub PayInOut(job As TPrnJobPayInOut)
	If job.PayType = 1 Then Log("PayIn")
	If job.PayType = 2 Then Log("PayOut")
End Sub

Private Sub CashDrawerOpen(job As TPrnJobCashDrawerOpen)
End Sub

'Отговор от устройството
Private Sub PrinterTX_NewData (Buffer() As Byte)
	If Buffer.Length = 0 Then Return
End Sub

'Грешка в комуникацията
Private Sub PrinterTX_Error
	ToastMessageShow(LastException.Message, True)
End Sub

'Получаване по USB/COM порт
Private Sub USBSerial_DataAvailable (Buffer() As Byte)
	PrinterTX_NewData(Buffer)
End Sub
#End Region

'Процедура за подаване на съобщението и обработка на резултата от действието на потребителя (Retry, Ignore, Abort)
Private Sub handleUserAction(error As Int)
	If statusItem.IsInitialized Then
		userAction = statusItem.getUserAction(error)
		Wait For (userAction) Complete (Result As Int)
		CallSubDelayed2(Me,"UserAction_Click",Result)
	End If
End Sub

'Акумулиране на данни за печат в буфера
Private Sub Send(s As String)
	s = s & Chr(10) & Chr(13)
	Contents.Append(s.GetBytes(PrinterCodePage))
End Sub

Private Sub AddHeader
	For Each text As String In ScriptMaster.RunPostProcessing(scripts.Headers, DeviceParameters.FiscalChars, selectedCmdSet)
		Send(text)
	Next
End Sub

Private Sub AddFooter
	For Each text As String In ScriptMaster.RunPostProcessing(scripts.Footers, DeviceParameters.FiscalChars, selectedCmdSet)
		Send(text)
	Next
End Sub

'Sends a number of empty strings to leave space after conntens (otherwise cutter cuts into footer)
Private Sub AddEmptyLines
	For i = 0 To NumberEmptyLines
		Send(" ")
	Next
End Sub

'Append Cutter string
Private Sub CutPaper
	Send(PrinterCutterString)
End Sub

'Отпечатване на QR код по протокол по няколко известни протокола за печат
Private Sub PrintQRCode(QRCode As String)
Dim Result As String

    If QRCode.Length < 3 Then QRCode = "http://www.microinvest.net"

    Select Case IDselectedPrinter
		Case RongtaRP326COM, RongtaRP326LAN, APrinterAP58D, BixolonSPPR300, BrostC230BT, BrostC230LAN, PosTechnology80, APrinterAP80COM, APrinterAP80LAN
            Result = ""
            Result = Result & Chr(0x1D) & Chr(0x28) & Chr(0x6B) & Chr(0x03) & Chr(0x00) & Chr(0x31) & Chr(0x43) & Chr(0x04) 'Set the Graphic unit module of QR code to be (4 x 4) dots
            Result = Result & Chr(0x1D) & Chr(0x28) & Chr(0x6B) & Chr(0x03) & Chr(0x00) & Chr(0x31) & Chr(0x45) & Chr(0x30) 'Let the check grade of QR code to be L
			Result = Result & Chr(0x1D) & Chr(0x28) & Chr(0x6B) & Chr((QRCode.Length + 3) Mod 256) & Chr((QRCode.Length + 3) / 256) & Chr(0x31) & Chr(0x50) & Chr(0x30) & QRCode
            Result = Result & Chr(0x1B) & Chr(0x61) & Chr(0x01)																'Have the Graphic in the Center
            Result = Result & Chr(0x1D) & Chr(0x28) & Chr(0x6B) & Chr(0x03) & Chr(0x00) & Chr(0x31) & Chr(0x52) & Chr(0x30)	'Check if the QR data is right
            Result = Result & Chr(0x1D) & Chr(0x28) & Chr(0x6B) & Chr(0x03) & Chr(0x00) & Chr(0x31) & Chr(0x51) & Chr(0x30) 'Print!
            Result = Result & Chr(0x1B) & Chr(0x61) & Chr(0x00)                                                             'Have the Graphic in the Left
			
		Case RongtaRPP02, APrinterAP58D																						'Rongta Old Technology
            Result = Chr(0x1D) & "Z" & Chr(0x01) & Chr(0x1B) & "Z" & Chr(0x00) & Chr(0x03) & Chr(0x04)
            Result = Result & Chr(QRCode.Length Mod 256) & Chr(QRCode.Length / 256) & QRCode
        
		Case StarWSPi350
            Result = ""
            Result = Result & Chr(0x1B) & Chr(0x1D) & Chr(0x61) & Chr(0x01)													'Have the Graphic in the Center
            Result = Result & Chr(0x1B) & Chr(0x1D) & "y" & "S" & "0" & Chr(0x02)											'Set Graphic model 2
            Result = Result & Chr(0x1B) & Chr(0x1D) & "y" & "S" & "1" & Chr(0x01)											'Set corrections level M
            Result = Result & Chr(0x1B) & Chr(0x1D) & "y" & "S" & "2" & Chr(0x05)											'Set cell size (5 x 5)
            Result = Result & Chr(0x1B) & Chr(0x1D) & "y" & "D" & Chr(0x31) & Chr(0x00) & Chr(QRCode.Length Mod 256) & Chr((QRCode.Length + 3) / 256) & QRCode
            Result = Result & Chr(0x1B) & Chr(0x1D) & "y" & "P"                                                             'Print!
            Result = Result & Chr(0x1B) & Chr(0x1D) & Chr(0x61) & Chr(0x00)													'Have the Graphic in the Left
                    
		Case GenericBT32, GenericBT40, GenericBT48, GenericLAN32, GenericLAN40, GenericLAN48, GenericSerial32, GenericSerial40, GenericSerial48 & _
			ArabicBT32, ArabicBT40, ArabicBT48, ArabicLAN32, ArabicLAN40, ArabicLAN48, ArabicSerial32, ArabicSerial40, ArabicSerial48
            Result = ""
            Result = Result & Chr(0x1D) & Chr(0x28) & Chr(0x6B) & Chr(0x03) & Chr(0x00) & Chr(0x31) & Chr(0x41) & Chr(0x32) & Chr(0x00)   'Set Graphic model 2
            Result = Result & Chr(0x1D) & Chr(0x28) & Chr(0x6B) & Chr(0x03) & Chr(0x00) & Chr(0x31) & Chr(0x43) & Chr(0x05) 'Set the Graphic unit module of QR code to be (5 x 5) dots
            Result = Result & Chr(0x1D) & Chr(0x28) & Chr(0x6B) & Chr(0x03) & Chr(0x00) & Chr(0x31) & Chr(0x45) & Chr(0x31) 'Let the check grade of QR code to be M
            Result = Result & Chr(0x1D) & Chr(0x28) & Chr(0x6B) & Chr((QRCode.Length + 3) Mod 256) & Chr((QRCode.Length + 3) / 256) & Chr(0x31) & Chr(0x50) & Chr(0x30) & QRCode
            Result = Result & Chr(0x1B) & Chr(0x61) & Chr(0x01)																'Have the Graphic in the Center
            Result = Result & Chr(0x1D) & Chr(0x28) & Chr(0x6B) & Chr(0x3) & Chr(0x0) & Chr(0x31) & Chr(0x52) & Chr(0x30)   'Check if the QR data is right
            Result = Result & Chr(0x1D) & Chr(0x28) & Chr(0x6B) & Chr(0x3) & Chr(0x0) & Chr(0x31) & Chr(0x51) & Chr(0x30)   'Print!
            Result = Result & Chr(0x1B) & Chr(0x61) & Chr(0x00)																'Have the Graphic in the Left
                    
        Case Else: Result = QRCode
    End Select

    Send(Result)
   
End Sub
#End Region