B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=8.3
@EndOfDesignText@

Sub Class_Globals
	Private settingsPanel As Panel
	Private country, language, printer, codeTable, spnPrinter, speed As Spinner
	Private IPport, IPaddress, operator, password, serialPort As EditText
	Private LabelCountry, LabelLanguage, LabelPrinter, LabelPortorIPaddress, LabelSpeedorIPport, LabelCodeTable, LabelOperator, LabelPassword As Label
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


End Sub

Public Sub Initialize
	settingsPanel.Initialize("settingsPanel")
'	printersAdd.Initialize
	country.Initialize("countrySpinner")	
	language.Initialize("languageSpinner")
	
	printer.Initialize("deviceSpinner")
		
	serialPort.Initialize("serialPortSpinner")	
	speed.Initialize("speedSpinner")

	IPport.Initialize("IPport")
	IPaddress.Initialize("IPaddress")

	codeTable.Initialize("codeTableSpinner")
	
	operator.Initialize("opertorEditText")
	password.Initialize("passwordEditText")
	spnPrinter.Initialize("")
	LabelCountry.Initialize("countryLabel")
	LabelLanguage.Initialize("languageLabel")
	LabelPrinter.Initialize("deviceLabel")
	LabelPortorIPaddress.Initialize("serialPortLabel")
	LabelSpeedorIPport.Initialize("speedLabel")
	LabelCodeTable.Initialize("codeTableLabel")
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
'	speedprinterFill
	deviceprinterFill
End Sub

Sub printerSpinnerFill
Log(Countries.getCountries)

For Each m As String In Countries.getCountries.Keys
		Log("Country:" & m)
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

Sub SettingsUI
	settingsPanel.AddView(LabelCountry, 2%x, 5%y, 30%x, 5%y)
	settingsPanel.AddView(country, 2%x, LabelCountry.Top + LabelCountry.Height, 40%x, 8%y)
	settingsPanel.AddView(LabelLanguage, 2%x, country.Top + country.Height + 15dip, 40%x, 5%y)
	settingsPanel.AddView(language, 2%x, LabelLanguage.Top + LabelLanguage.Height , 40%x, 8%y)
	settingsPanel.AddView(LabelPrinter, 2%x, language.Top + language.Height + 15dip, 35%x, 5%y)
	settingsPanel.AddView(printer, 2%x, LabelPrinter.Top + LabelPrinter.Height, 40%x, 8%y)
	settingsPanel.AddView(LabelCodeTable, 2%x, printer.Top + printer.Height + 15dip, 40%x, 5%y)
	settingsPanel.AddView(codeTable, 2%x, LabelCodeTable.Top + LabelCodeTable.Height, 40%x, 8%y)
	
	
	settingsPanel.AddView(LabelPortorIPaddress, LabelCountry.Left + LabelCountry.Width + 30%x, LabelCountry.Top, 35%x, 5%y)
	settingsPanel.AddView(serialPort, LabelPortorIPaddress.Left, LabelPortorIPaddress.Top + LabelPortorIPaddress.Height, 35%x, 8%y)
	If GetDeviceLayoutValues.Width < GetDeviceLayoutValues.Height Then
'		settingsPanel.AddView(IPaddress, LabelPortorIPaddress.Left, LabelPortorIPaddress.Top + LabelPortorIPaddress.Height, 35%x, 7%y)
'	Else
'		settingsPanel.AddView(IPaddress, LabelPortorIPaddress.Left, LabelPortorIPaddress.Top + LabelPortorIPaddress.Height, 35%x, 16%y)
	End If
	settingsPanel.AddView(LabelSpeedorIPport, LabelPortorIPaddress.Left, serialPort.Top + serialPort.Height + 7%y, 55%x, 5%y)
	
	If GetDeviceLayoutValues.Width < GetDeviceLayoutValues.Height Then
	
'		settingsPanel.AddView(IPport, LabelPortorIPaddress.Left, LabelSpeedorIPport.Top + LabelSpeedorIPport.Height, 35%x, 7%y)
	Else
'		settingsPanel.AddView(IPport, LabelPortorIPaddress.Left, LabelSpeedorIPport.Top + LabelSpeedorIPport.Height, 35%x, 15%y)
	End If

	settingsPanel.AddView(speed, LabelPortorIPaddress.Left, LabelSpeedorIPport.Top + LabelSpeedorIPport.Height, 35%x, 8%y)
	If GetDeviceLayoutValues.Width < GetDeviceLayoutValues.Height Then
		settingsPanel.AddView(LabelOperator, LabelPortorIPaddress.Left, speed.Top + speed.Height + 5%y, 35%x, 5%y)
		settingsPanel.AddView(operator, LabelPortorIPaddress.Left, LabelOperator.Top+LabelOperator.Height, LabelOperator.Width, 7%y)
		settingsPanel.AddView(LabelPassword,LabelPortorIPaddress.Left, operator.Top+operator.Height, LabelOperator.Width, 5%y)
		settingsPanel.AddView(password, LabelPortorIPaddress.Left, LabelPassword.Top+LabelPassword.Height, LabelOperator.Width, 7%y)
	Else
		settingsPanel.AddView(LabelOperator, LabelPortorIPaddress.Left, speed.Top + speed.Height + 5%y, 35%x, 5%y)
		settingsPanel.AddView(operator, LabelPortorIPaddress.Left, LabelOperator.Top+LabelOperator.Height, LabelOperator.Width, 15%y)
		settingsPanel.AddView(LabelPassword,LabelPortorIPaddress.Left, operator.Top+operator.Height, LabelOperator.Width, 5%y)
		settingsPanel.AddView(password, LabelPortorIPaddress.Left, LabelPassword.Top+LabelPassword.Height, LabelOperator.Width, 15%y)
	End If
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
	ProgramData.req = ProgramData.req.SubString2(1,ProgramData.req.Length - 1)
	Private buffer() As Byte = ProgramData.req.GetBytes("UTF-8")
	ProgramData.req = ProgramData.req.Replace("%3C", "<")
	ProgramData.req = ProgramData.req.Replace("%3E", ">")
	ProgramData.req = ProgramData.req.Replace("%20", " ")
	Log(ProgramData.req)	
	inn.InitializeFromBytesArray(buffer, 0, buffer.Length)
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
		Log("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
	End Try
End Sub

Private Sub xml_StartElement (Uri As String, Name As String, Attributes As Attributes)
	
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
	
	
	If Name.EqualsIgnoreCase("Items") Then
'		If Name.EqualsIgnoreCase("Item") Then
	End If
End Sub
#End Region


Sub asView As Panel
	Return settingsPanel
End Sub

Sub ColorPickerAndLabelTexts
	LabelCountry.TextColor = Colors.Black
	LabelLanguage.TextColor = Colors.Black
	LabelPrinter.TextColor = Colors.Black
	LabelPortorIPaddress.TextColor = Colors.Black
	LabelSpeedorIPport.TextColor = Colors.Black
	LabelCodeTable.TextColor = Colors.Black
	LabelOperator.TextColor = Colors.Black
	LabelPassword.TextColor = Colors.Black
	
	LabelCountry.Text = "Country"
	LabelLanguage.Text = "Language"
	LabelPrinter.Text = "Device"
	LabelPortorIPaddress.Text = "Port"
	LabelSpeedorIPport.Text = "Speed"
	LabelCodeTable.Text = "Code table"
	LabelOperator.Text = "Operator"
	LabelPassword.Text = "Password"
	
	settingsPanel.Color = Colors.ARGB(255, 99, 159, 255)
End Sub

Sub Save_click
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

Sub languageSpinner_ItemClick (Position As Int, Value As Object)
	readinfo.language = Value
End Sub

Sub codeTableSpinner_ItemClick (Position As Int, Value As Object)
	readinfo.codeTable = Value
	
End Sub

Sub deviceSpinner_ItemClick (Position As Int, Value As Object)
	selectedPrinterName = Value
	fillSettings
End Sub

Private Sub fillSettings	
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
	
	Save_click

End Sub


private Sub clearSettingSV
	controlsMap.Clear
End Sub

Public Sub refillSpPrinters
	spnPrinter.Clear
	
	For Each printerAc As TActivePrinter In masterP.ActivePrinters
		spnPrinter.Add(printerAc.name)
	Next
End Sub

Private Sub getConnectionParams As TConnectionParameters
	Dim connectionParams As TConnectionParameters
	connectionParams.Initialize
	For Each key As Int In controlsMap.Keys
		Dim control As Object = controlsMap.Get(key)
'		 = controlsMap.Get(key)
		Select key
			Case Main.PS_BaudRate
				Dim cSpinner As Spinner = control
'				Dim cSpinner As Spinner = control
				If cSpinner.SelectedIndex = -1 Then : getConnectionParamsFailed = True
				Else : connectionParams.BaudRate = cSpinner.SelectedItem
				End If
				
			Case Main.PS_IPAddress
				Dim cEditText As EditText = control
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
				Else : connectionParams.IPPort = cEditText.Text
				End If
				
			Case Main.PS_Password
				Dim cEditText As EditText = control
				If cEditText.Text.Length = 0 Then : getConnectionParamsFailed = True
				Else : connectionParams.Password = cEditText.Text
				End If
				
			Case Main.PS_SerialPort
				Dim cEditText As EditText = control
				If cEditText.Text.Length = 0 Then : getConnectionParamsFailed = True
				Else : connectionParams.SerialPort = cEditText.Text
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

Private Sub genereteSettingView(setting As Int, value As String)
'	If controlsMap.ContainsKey(setting) Then Return top
			
	Select setting
		Case Main.PS_BaudRate	
			'Build Spinner
			printer.Initialize("printerSetting")
			printer.Tag = setting
			printer.AddAll(BoudRatesList)
			printer.DropdownTextColor = Colors.White
			printer.DropdownBackgroundColor = Colors.DarkGray
			
			'Set spinner selected index
			Dim valueIndex As Int = BoudRatesList.IndexOf(value)
			If valueIndex = - 1 Then valueIndex = 3
			printer.SelectedIndex = valueIndex
			
			'Put Control in map
			controlsMap.Put(setting,printer)
				
		Case Main.PS_IPAddress	
			'Build EditText
			IPaddress.Initialize("edtSetting")
			IPaddress.Text = value
			IPaddress.TextColor = Colors.Black
			IPaddress.Tag = setting
			IPaddress.SingleLine = True
			
			controlsMap.Put(setting,IPaddress.Text)
			
		Case Main.PS_IPPort			
			'Build EditText
			IPport.Initialize("edtSetting")
			IPport.Text = value
			IPport.TextColor = Colors.White
			IPport.Tag = setting
			IPport.SingleLine = True
			IPport.InputType = IPport.INPUT_TYPE_NUMBERS
			
			controlsMap.Put(setting,IPport)
			
		Case Main.PS_Password			
			password.Initialize("edtSetting")
			password.Text = value
			password.SingleLine = True
			password.TextColor = Colors.White
			
			controlsMap.Put(setting,password)
			
		Case Main.PS_UserID
			operator.Initialize("edtSetting")
			operator.Text = value
			operator.SingleLine = True
			operator.TextColor = Colors.White
			
			controlsMap.Put(setting, operator)
			
		Case Main.PS_SerialPort
			serialPort.Initialize("edtSetting")
			serialPort.Text = value
			serialPort.TextColor = Colors.White
			serialPort.SingleLine = True
			serialPort.Tag = setting
			serialPort.InputType = serialPort.INPUT_TYPE_NUMBERS
			
			controlsMap.Put(setting,serialPort)
	End Select

End Sub