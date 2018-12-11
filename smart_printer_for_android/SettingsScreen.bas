B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=8.3
@EndOfDesignText@
Sub Class_Globals
	Private settingsPanel As Panel
	Private country, language, printer, spnPrinter, Boud As Spinner
	Private IPport, IPaddress, operator, password As EditText
	Private LabelCountry, LabelLanguage, LabelPrinter, LabelIPport, LabelBoudOrIp, LabelOperator, LabelPassword As Label
	Private BoudRatesList As List
	Private PrinterList As List
	Private masterP As PrinterMain
	Private templates As SaxParser
	Private cash,card,bank,vaucher As Double
	Private  payMethod As Int
	Private inn As InputStream
	Private getConnectionParamsFailed As Boolean = False	'Show if theres and error in the input of controls in ControlsMap
	Private selectedPrinterName As String = ""				'Hold Name of the selected printer
	Dim raf As RandomAccessFile
	Dim readinfo As information
	Private controlsMap As Map								'Hold all the settings controls
	Private saveSettings As Button
	
	Private Const COLOR_NormalTop As Int 	  =	0xff4ac2ff	'Light blue
	Private Const COLOR_NormalBottom As Int   =	0xff149be0	'Darker blue
	Private Const COLOR_PressedTop As Int 	  =	0xff2cb7ff	'Same light blue
	Private Const COLOR_PressedBottom As Int  =	0xff2cb7ff	'Same light blue
	Private Const COLOR_DisabledTop As Int    =	0x66040509	'Semi-transperant black
	Private Const COLOR_DisabledBottom As Int =	0x66040509	'Semi-transperant black
	Private Const ButtonRounding As Int = 60	'How much rounding is done on the buttons & edit text corners
'	Private Const COLOR_Dropdown As Int = 		0xFF012136

	Private background As BitmapDrawable
	
End Sub

Public Sub Initialize
	settingsPanel.Initialize("settingsPanel")
	
	background.Initialize(LoadBitmap(File.DirAssets, "6082.jpg"))
	settingsPanel.Background = background
	
'	printersAdd.Initialize
	country.Initialize("countrySpinner")
	language.Initialize("languageSpinner")
	
	printer.Initialize("deviceSpinner")
		
	Boud.Initialize("BoudSpinner")

	IPport.Initialize("IPport")
	IPaddress.Initialize("IPaddress")
	
	operator.Initialize("opertorEditText")
	password.Initialize("passwordEditText")
	spnPrinter.Initialize("")
	LabelCountry.Initialize("countryLabel")
	LabelLanguage.Initialize("languageLabel")
	LabelPrinter.Initialize("deviceLabel")
	LabelIPport.Initialize("IPportLabel")
	LabelBoudOrIp.Initialize("BoudLabel")
	LabelOperator.Initialize("opertorLabel")
	LabelPassword.Initialize("passwordLabel")
	saveSettings.Initialize("Save")
	Countries.Initialize
	
	BoudRatesList.Initialize
	
	controlsMap.Initialize
	raf.Initialize(File.DirInternal, "initialSetting.config", False)
	readinfo.Initialize

	
	ColorPickerAndLabelTexts
	
	SettingsUI
	PrinterList.Initialize
'	addData
	templates.Initialize
	masterP.Initialize(Me)
'	"1200", "2400", "4800", "9600", "14400", "19200", "38400", "57600", "115200")
	BoudRatesList.Add(1200)
	BoudRatesList.Add(2400)
	BoudRatesList.Add(4800)
	BoudRatesList.Add(9600)
	BoudRatesList.Add(14400)
	BoudRatesList.Add(19200)
	BoudRatesList.Add(38400)
	BoudRatesList.Add(57600)
	BoudRatesList.Add(115200)
	
	settingsPanel.Enabled = False
	settingsPanel.Visible = False
	printerSpinnerFill
	languageprinterFill
	BoudprinterFill
	deviceprinterFill
	
	HelperFunctions.Apply_ViewStyle(saveSettings, Colors.White, COLOR_NormalTop, COLOR_NormalBottom, COLOR_PressedTop, COLOR_PressedBottom, COLOR_DisabledTop, COLOR_DisabledBottom, ButtonRounding)
	HelperFunctions.Apply_ViewStyle(country, Colors.White, COLOR_NormalTop, COLOR_NormalBottom, COLOR_PressedTop, COLOR_PressedBottom, COLOR_DisabledTop, COLOR_DisabledBottom, ButtonRounding)
	HelperFunctions.Apply_ViewStyle(language, Colors.White, COLOR_NormalTop, COLOR_NormalBottom, COLOR_PressedTop, COLOR_PressedBottom, COLOR_DisabledTop, COLOR_DisabledBottom, ButtonRounding)
	HelperFunctions.Apply_ViewStyle(printer, Colors.White, COLOR_NormalTop, COLOR_NormalBottom, COLOR_PressedTop, COLOR_PressedBottom, COLOR_DisabledTop, COLOR_DisabledBottom, ButtonRounding)
	HelperFunctions.Apply_ViewStyle(Boud, Colors.White, COLOR_NormalTop, COLOR_NormalBottom, COLOR_PressedTop, COLOR_PressedBottom, COLOR_DisabledTop, COLOR_DisabledBottom, ButtonRounding)
	HelperFunctions.Apply_ViewStyle(IPport, Colors.White, COLOR_NormalTop, COLOR_NormalBottom, COLOR_PressedTop, COLOR_PressedBottom, COLOR_DisabledTop, COLOR_DisabledBottom, ButtonRounding)
	HelperFunctions.Apply_ViewStyle(IPaddress, Colors.White, COLOR_NormalTop, COLOR_NormalBottom, COLOR_PressedTop, COLOR_PressedBottom, COLOR_DisabledTop, COLOR_DisabledBottom, ButtonRounding)
	HelperFunctions.Apply_ViewStyle(operator, Colors.White, COLOR_NormalTop, COLOR_NormalBottom, COLOR_PressedTop, COLOR_PressedBottom, COLOR_DisabledTop, COLOR_DisabledBottom, ButtonRounding)
	HelperFunctions.Apply_ViewStyle(password, Colors.White, COLOR_NormalTop, COLOR_NormalBottom, COLOR_PressedTop, COLOR_PressedBottom, COLOR_DisabledTop, COLOR_DisabledBottom, ButtonRounding)
	
End Sub

Sub printerSpinnerFill
	'Log(Countries.getCountries)

	For Each m As String In Countries.getCountries.Keys
'		Log("Country:" & m)
		country.Add(m)
	Next
End Sub

Private Sub languageprinterFill
	language.Clear
	language.AddAll(Main.languageList)
End Sub

Private Sub deviceprinterFill
	PrinterList = masterP.PrintersList

	printer.Clear
	printer.AddAll(PrinterList)
End Sub

Private Sub BoudprinterFill
	Boud.Clear
	Boud.AddAll(BoudRatesList)
End Sub

Sub SettingsUI
	settingsPanel.AddView(LabelCountry, 2%x, 5%y, 30%x, 5%y)
	settingsPanel.AddView(country, 2%x, LabelCountry.Top + LabelCountry.Height, 40%x, 8%y)
	settingsPanel.AddView(LabelLanguage, 2%x, country.Top + country.Height + 15dip, 40%x, 5%y)
	settingsPanel.AddView(language, 2%x, LabelLanguage.Top + LabelLanguage.Height , 40%x, 8%y)
	settingsPanel.AddView(LabelPrinter, 2%x, language.Top + language.Height + 15dip, 35%x, 5%y)
	settingsPanel.AddView(printer, 2%x, LabelPrinter.Top + LabelPrinter.Height, 40%x, 8%y)
	
	settingsPanel.AddView(LabelIPport, LabelCountry.Left + LabelCountry.Width + 30%x, LabelCountry.Top, 35%x, 5%y)
	settingsPanel.AddView(IPport, LabelIPport.Left, LabelIPport.Top + LabelIPport.Height, 35%x, 8%y)

	settingsPanel.AddView(LabelBoudOrIp, LabelIPport.Left, IPport.Top + IPport.Height + 15dip, 35%x, 8%y)
	settingsPanel.AddView(Boud, LabelIPport.Left, LabelBoudOrIp.Top + LabelBoudOrIp.Height, 35%x, 8%y)
	settingsPanel.AddView(IPaddress, LabelIPport.Left, LabelBoudOrIp.Top + LabelBoudOrIp.Height, 35%x, 8%y)
	IPaddress.Visible = False
	IPaddress.Enabled = False
	If GetDeviceLayoutValues.Width < GetDeviceLayoutValues.Height Then
		settingsPanel.AddView(LabelOperator, LabelIPport.Left, Boud.Top + Boud.Height + 5%y, 35%x, 5%y)
		settingsPanel.AddView(operator, LabelIPport.Left, LabelOperator.Top+LabelOperator.Height, LabelOperator.Width, 7%y)
		settingsPanel.AddView(LabelPassword,LabelIPport.Left, operator.Top+operator.Height, LabelOperator.Width, 5%y)
		settingsPanel.AddView(password, LabelIPport.Left, LabelPassword.Top+LabelPassword.Height, LabelOperator.Width, 7%y)
	Else
		settingsPanel.AddView(LabelOperator, LabelIPport.Left, Boud.Top + Boud.Height + 5%y, 35%x, 5%y)
		settingsPanel.AddView(operator, LabelIPport.Left, LabelOperator.Top+LabelOperator.Height, LabelOperator.Width, 15%y)
		settingsPanel.AddView(LabelPassword,LabelIPport.Left, operator.Top+operator.Height, LabelOperator.Width, 5%y)
		settingsPanel.AddView(password, LabelIPport.Left, LabelPassword.Top+LabelPassword.Height, LabelOperator.Width, 15%y)
	End If
	settingsPanel.AddView(saveSettings, 33.33%x, 85%y, 33.33%x, 10%y)
	
End Sub


#Region Printing
Private Sub POS_Print
	Dim phone As String = ProgramData.partnerPhone
	If Countries.SelectedCountry = Countries.Russia Then
		If Regex.IsMatch("((007)9([0-9]){9})", phone) Then
			phone = "+7" & phone.SubString(3)
						
		else if Regex.IsMatch("((7|8)9([0-9]){9})", phone) Then
			phone = "+7" & phone.SubString(1)
					
		else if Regex.IsMatch("(9([0-9]){9})", phone) Then
			phone = "+7" & phone
						
		End If
					
	Else if Countries.SelectedCountry = Countries.Bulgaria Then
		If Regex.IsMatch("((0)8[0-9]{8})",phone) Then
			phone = "+359" & phone.SubString(1)
						
		else if Regex.IsMatch("((359)8[0-9]{8})",phone) Then
			phone = "+" & phone
		End If
		
	Else if Countries.SelectedCountry = Countries.Romania Then
		If phone.Contains("VAT:") Then
'			ToastMessageShow ("Message " & phone, False)
		End If
	End If
	
	
	Private PJobOpen As TPrnJobFiscalOpen
	PJobOpen.Initialize
	PJobOpen.Phone = phone'\ProgramData.partnerPhone
	masterP.AddJob(PJobOpen)
'	ProgramData.req = ProgramData.req.SubString2(1,ProgramData.req.Length - 1)
'	Private buffer() As Byte = ProgramData.req.GetBytes("UTF-8")
	inn.InitializeFromBytesArray(SPAservice.urlResponse.GetBytes("UTF8"),0,SPAservice.urlResponse.GetBytes("UTF8").Length)
'	inn.InitializeFromBytesArray(buffer, 0, buffer.Length)
	Log(inn.BytesAvailable)
	Try
		templates.Parse(inn, "xml")
		
		Private PJobItem As TPrnJobFiscalSellItem
		PJobItem.Initialize
'		PJobItem.PLU = Text
'		PJobItem.ItemName = itCart.ItemName
'		PJobItem.Quantity = itCart.qtty
'		PJobItem.Price = PriceMathFunctions.GetSinglePriceWithVat(itCart)
'		PJobItem.ItemMeasure = itCart.measureName
'		PJobItem.VatPercent = itCart.VatPercent
'		PJobItem.VatIndex = itCart.VatIndex
		masterP.AddJob(PJobItem)
'	Next
	
		Private PJobPayment As TPrnJobFiscalPayment
		PJobPayment.Initialize
		PJobPayment.PayType = payMethod
	
		Select PJobPayment.PayType
			Case 1:	PJobPayment.PaySum = cash
			Case 2:	PJobPayment.PaySum = bank
			Case 3:	PJobPayment.PaySum = card
			Case 4:	PJobPayment.PaySum = vaucher
		End Select
		
		masterP.AddJob(PJobPayment)
		
		Private PJobFiscalPrintText As TPrnJobFiscalPrintText
		PJobFiscalPrintText.Initialize
		PJobFiscalPrintText.Text = Device.WatermarkText
		masterP.AddJob(PJobFiscalPrintText)
		
		Private PJobPrintBarcode As TPrnJobPrintBarcode
		PJobPrintBarcode.Initialize
		PJobPrintBarcode.Barcode = Device.WatermarkURL
		masterP.AddJob(PJobPrintBarcode)
		
		Private PJobFinish As TPrnJobFiscalClose
		PJobFinish.Initialize
		masterP.AddJob(PJobFinish)
		masterP.DoJobs
	Catch
		Log("Failed")
	End Try
End Sub

Private Sub xml_StartElement (Uri As String, Name As String, Attributes As Attributes)
	Log(Name)
End Sub

'Построява се обкет номенклатура (Item) или групите във зависимост от инициализацията./ Items or groups are 
'created depending on the initialization
Private Sub xml_EndElement (Uri As String, Name As String, Text As StringBuilder)
	Private paymentMethod As String
	If Name.EqualsIgnoreCase("Payment") Then
		Select Name.EqualsIgnoreCase(paymentMethod)
			Case paymentMethod.EqualsIgnoreCase("Cash"): payMethod = ProgramData.PAYMENT_CASH
			Case paymentMethod.EqualsIgnoreCase("Account"): payMethod = ProgramData.PAYMENT_BANK
			Case paymentMethod.EqualsIgnoreCase("Card"): payMethod = ProgramData.PAYMENT_CARD
			Case paymentMethod.EqualsIgnoreCase("Voucher"): payMethod = ProgramData.PAYMENT_TALN
		End Select
	End If
	
	
	If Name.EqualsIgnoreCase("Cash") Then cash = Text
	If Name.EqualsIgnoreCase("Account") Then bank = Text
	If Name.EqualsIgnoreCase("Card") Then card = Text
	If Name.EqualsIgnoreCase("Voucher") Then vaucher = Text
	
	
	If Name.EqualsIgnoreCase("Item") Then
		Log("Item here")
	End If
End Sub
#End Region


Sub asView As Panel
	Return settingsPanel
End Sub

Sub ColorPickerAndLabelTexts
	LabelCountry.TextColor = Colors.LightGray
	LabelLanguage.TextColor = Colors.LightGray
	LabelPrinter.TextColor = Colors.LightGray
	LabelIPport.TextColor = Colors.LightGray
	LabelBoudOrIp.TextColor = Colors.LightGray
	LabelOperator.TextColor = Colors.LightGray
	LabelPassword.TextColor = Colors.LightGray
	
	LabelCountry.Text = "Country"
	LabelLanguage.Text = "Language"
	LabelPrinter.Text = "Device"
	LabelIPport.Text = "Port"
	LabelBoudOrIp.Text = "Boud rate"
	LabelOperator.Text = "Operator"
	LabelPassword.Text = "Password"
		
	saveSettings.Text = "Save!"
	saveSettings.Color= Colors.DarkGray
	saveSettings.TextColor = Colors.LightGray
End Sub

Sub Save_click
	
	readinfo.IPaddress = IPaddress.Text
	readinfo.port = IPport.Text
	readinfo.operator = operator.Text
	readinfo.password = password.Text
	raf.WriteEncryptedObject(readinfo, ProgramData.rafEncPass,0)
	ToastMessageShow("Saved!", False)

End Sub

Private Sub setSettings
	Try
		Dim ActivePrinter As TActivePrinter
		ActivePrinter.Initialize
		ActivePrinter.connectionParams = getConnectionParams
		ActivePrinter.name = selectedPrinterName
'				ActivePrinter.ScriptsTemplate = getScripts

		If Not(checkConnectionParams) Then Return
		
		masterP.addToActivePrinter(ActivePrinter)
		refillSpPrinters
	Catch
		Log(LastException)
		Msgbox("Failed", "Failed")
'				Msgbox(Main.translate.GetString("msgPrinterFailedToAdd"),Main.translate.GetString("lblWarning"))
	End Try
End Sub

Sub countrySpinner_ItemClick (Position As Int, Value As Object)
	readinfo.country = Value
End Sub

Sub BoudSpinner_ItemClick (Position As Int, Value As Object)
	readinfo.speed = Value
End Sub

Sub languageSpinner_ItemClick (Position As Int, Value As Object)
	readinfo.language = Value
End Sub

Sub codeTableSpinner_ItemClick (Position As Int, Value As Object)
	readinfo.codeTable = Value
End Sub

Sub deviceSpinner_ItemClick (Position As Int, Value As Object)
	selectedPrinterName = Value
	readinfo.Device = Value
	fillSettings
End Sub

public Sub fillSettings
	Dim printerInfo As Printer = masterP.getInitialPrinterByName(selectedPrinterName)
	CallSub2(printerInfo.ref,"setSelected_Printer", printerInfo.id)
	Dim m As Map = CallSub(printerInfo.ref,"getDevice_SettingsRequirements")
	
	Dim fiscalMode As Boolean = CallSub(printerInfo.ref, "getFiscal_MemoryMode")
	
	runMap(m,fiscalMode)
End Sub

private Sub runMap(m As Map, isFiscal As Boolean)
	clearSettingSV

	For Each setting As Int In m.Keys
		genereteSettingView(setting, m.Get(setting))
	Next
	
	setSettings
End Sub


private Sub clearSettingSV
	controlsMap.Clear
End Sub

Public Sub refillSpPrinters
	spnPrinter.Clear
	
	For Each printerAc As TActivePrinter In masterP.ActivePrinters
		spnPrinter.Add(printerAc.name)
		For i = 0 To Boud.Size-1
			If Boud.GetItem(i) = Boud.IndexOf(printerAc.connectionParams.BaudRate) Then
				Boud.SelectedIndex = i
			End If
		Next
		
		IPaddress.Text = printerAc.connectionParams.IPAddress
		IPport.Text = printerAc.connectionParams.IPPort
		IPport.Text = printerAc.connectionParams.IPport
	Next
End Sub

Private Sub getConnectionParams As TConnectionParameters
	Dim connectionParams As TConnectionParameters
	connectionParams.Initialize
	For Each key As Int In controlsMap.Keys
		Dim control As Object = controlsMap.Get(key)
		Select key
			Case Main.PS_BaudRate
				Dim cSpinner As Spinner = control
				If cSpinner.SelectedIndex = -1 Then : getConnectionParamsFailed = True
				Else
					connectionParams.BaudRate = cSpinner.SelectedItem
				End If
				
			Case Main.PS_IPAddress
				Dim s As String = control
				If s.Length = 0 Then
					getConnectionParamsFailed = True
				else If Not (IsValidIP(s)) Then
					ToastMessageShow(Main.translate.GetString("msgWrongIP"), False)
					getConnectionParamsFailed = True
				Else
					connectionParams.IPAddress = s
				End If
				
			Case Main.PS_IPPort
				Dim cEditText As EditText = control
				If cEditText.Text.Length = 0 Then : getConnectionParamsFailed = True
				Else
					connectionParams.IPPort = cEditText.Text
				End If
				
			Case Main.PS_Password
				Dim cEditText As EditText = control
				If cEditText.Text.Length = 0 Then : getConnectionParamsFailed = True
				Else : connectionParams.Password = cEditText.Text
				End If
				
			Case Main.PS_IPport
				Dim cEditText As EditText = control
				If cEditText.Text.Length = 0 Then : getConnectionParamsFailed = True
				Else : connectionParams.IPport = cEditText.Text
				End If
				
			Case Main.PS_UserID
				Dim cEditText As EditText = control
				If cEditText.Text.Length = 0 Then : getConnectionParamsFailed = True
				Else : connectionParams.UserID = cEditText.Text
				End If
		End Select
	Next
	
	Return connectionParams
End Sub


Private Sub IsValidIP(ip As String) As Boolean
	Dim m As Matcher
	m = Regex.Matcher("^(\d+)\.(\d+)\.(\d+)\.(\d+)$", ip)
	If m.Find = False Then Return False
	For i = 1 To 4
		If m.Group(i) > 255 Or m.Group(i) < 0 Then Return False
	Next
	Return True
End Sub

Private Sub checkConnectionParams As Boolean
	If getConnectionParamsFailed Then
		getConnectionParamsFailed = False
		Msgbox(Main.translate.GetString("msgPleaseFillAllFields"), Main.translate.GetString("msgError"))
		Return False
	Else
		Return True
	End If
End Sub

public Sub genereteSettingView(setting As Int, value As String)
'	If controlsMap.ContainsKey(setting) Then Return top
			
	Select setting
		Case Main.PS_BaudRate
			'Build Spinner
'			printer.Initialize("printerSetting")
			LabelBoudOrIp.Text = "Boud rate"
			IPport.Enabled = False
			IPaddress.Visible = False
			IPaddress.Enabled = False
			Boud.Visible = True
			Boud.Enabled = True
			Boud.Tag = setting
			BoudprinterFill
			'Set spinner selected index
			
			For i = 0 To Boud.Size-1
				If Boud.GetItem(i) = value Then
					Boud.SelectedIndex = i
				End If
			Next
'			Dim valueIndex As Int = Boud.IndexOf(value)
'			If valueIndex = - 1 Then valueIndex = 3
'			Boud.SelectedIndex = valueIndex
'			
			'Put Control in map
			controlsMap.Put(setting,Boud)
				
		Case Main.PS_IPAddress
			'Build EditText
			LabelBoudOrIp.Text = "IP Address"
			
			IPaddress.Visible = True
			IPaddress.Enabled = True
			Boud.Visible = False
			Boud.Enabled = False
			IPaddress.Text = value
			IPaddress.TextColor = Colors.Black
			IPaddress.Tag = setting
			IPaddress.SingleLine = True
			
			controlsMap.Put(setting,IPaddress.Text)
			
		Case Main.PS_IPPort
			'Build EditText
			IPport.Text = value
			IPport.TextColor = Colors.White
			IPport.Tag = setting
			IPport.SingleLine = True
			IPport.InputType = IPport.INPUT_TYPE_NUMBERS
			
			controlsMap.Put(setting,IPport)
			
		Case Main.PS_Password
			password.Text = value
			password.SingleLine = True
			password.TextColor = Colors.White
			
			controlsMap.Put(setting,password)
			
		Case Main.PS_UserID
			operator.Text = value
			operator.SingleLine = True
			operator.TextColor = Colors.White
			
			controlsMap.Put(setting, operator)
	End Select

End Sub

Sub settingsFill
	If File.Exists(File.DirInternal, "initialSetting.config") = True And File.Size(File.DirInternal, "initialSetting.config") > 0 Then
		readinfo = raf.ReadEncryptedObject(ProgramData.rafEncPass,0)
		IPaddress.Text = readinfo.IPaddress
		IPport.Text = readinfo.port
		operator.Text = readinfo.operator
		password.Text = readinfo.password
		For i = 0 To country.Size-1
			If country.GetItem(i) = readinfo.country Then
				country.SelectedIndex = i
			End If
		Next
		For i = 0 To language.Size-1
			If language.GetItem(i) = readinfo.language Then
				language.SelectedIndex = i
			End If
		Next
		For i = 0 To Boud.Size-1
			If Boud.GetItem(i) = readinfo.speed Then
				Boud.SelectedIndex = i
			End If
		Next
		For i = 0 To printer.Size-1
			If printer.GetItem(i) = readinfo.Device Then
				printer.SelectedIndex = i
				selectedPrinterName  = readinfo.Device
				fillSettings
			End If
		Next
				
	Else
		IPaddress.Text = ""
		IPport.Text = ""
		operator.Text = ""
		password.Text = ""
		country.SelectedIndex = 0
		language.SelectedIndex = 0
		Boud.SelectedIndex = 0
		printer.SelectedIndex = 0
	End If
End Sub