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
	Private saveSettings, btnTest As Button
	Private tempList As List
	Private background, settingsOpen, settingsClose As BitmapDrawable
	Private saveSettings, advancedSettingsOpen, advancedSettingsClose As Button
	
	Private headersPanel As Panel
		
	Private Const COLOR_NormalTop As Int 	  =	0xff4ac2ff	'Light blue
	Private Const COLOR_NormalBottom As Int   =	0xff149be0	'Darker blue
	Private Const COLOR_PressedTop As Int 	  =	0xff2cb7ff	'Same light blue
	Private Const COLOR_PressedBottom As Int  =	0xff2cb7ff	'Same light blue
	Private Const COLOR_DisabledTop As Int    =	0x66040509	'Semi-transperant black
	Private Const COLOR_DisabledBottom As Int =	0x66040509	'Semi-transperant black
	Private Const ButtonRounding As Int = 60	'How much rounding is done on the buttons & edit text corners
'	Private Const COLOR_Dropdown As Int = 		0xFF012136

	Private background As BitmapDrawable
	
	
	Private intLanguageIndex As Int
	
	
	Private itCart As CartItem
	Private partner As Partner
	Private workingUser As CurrentUser	
	Private workingobject As StoreObject
	Private tagUP As Int = 0
	Private cHeadersList, cFootersList, cDetailesList, cTotalsList As List

End Sub

Public Sub Initialize
	settingsPanel.Initialize("settingsPanel")
	advancedSettingsOpen.Initialize("advancedSettingsOpen")
	advancedSettingsClose.Initialize("advancedSettingsClose")
	headersPanel.Initialize("headersPanel")
	cFootersList.Initialize
	cDetailesList.Initialize
	cHeadersList.Initialize
	cTotalsList.Initialize
	
	background.Initialize(LoadBitmap(File.DirAssets, "6082.jpg"))
	settingsOpen.Initialize(LoadBitmap(File.DirAssets, "Glossy_3d_blue_arrow_right.png"))
	settingsClose.Initialize(LoadBitmap(File.DirAssets, "Glossy_3d_blue_arrow_left.png"))
	
	settingsPanel.Background = background
	
	advancedSettingsOpen.Background = settingsOpen
	advancedSettingsClose.Background = settingsClose
	advancedSettingsClose.Enabled = False
	advancedSettingsClose.Visible= False
	
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
'	btnTest.Initialize("Test")

	
	Countries.Initialize
	
	BoudRatesList.Initialize
	
	controlsMap.Initialize
	raf.Initialize(File.DirInternal, "initialSetting.config", False)
	readinfo.Initialize
	tempList.Initialize
	language.SelectedIndex = language.IndexOf(Main.SelectedLanguage)
	

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
'	HelperFunctions.Apply_ViewStyle(btnTest, Colors.White, COLOR_NormalTop, COLOR_NormalBottom, COLOR_PressedTop, COLOR_PressedBottom, COLOR_DisabledTop, COLOR_DisabledBottom, ButtonRounding)
	HelperFunctions.Apply_ViewStyle(country, Colors.White, COLOR_NormalTop, COLOR_NormalBottom, COLOR_PressedTop, COLOR_PressedBottom, COLOR_DisabledTop, COLOR_DisabledBottom, ButtonRounding)
	HelperFunctions.Apply_ViewStyle(language, Colors.White, COLOR_NormalTop, COLOR_NormalBottom, COLOR_PressedTop, COLOR_PressedBottom, COLOR_DisabledTop, COLOR_DisabledBottom, ButtonRounding)
	HelperFunctions.Apply_ViewStyle(printer, Colors.White, COLOR_NormalTop, COLOR_NormalBottom, COLOR_PressedTop, COLOR_PressedBottom, COLOR_DisabledTop, COLOR_DisabledBottom, ButtonRounding)
	HelperFunctions.Apply_ViewStyle(Boud, Colors.White, COLOR_NormalTop, COLOR_NormalBottom, COLOR_PressedTop, COLOR_PressedBottom, COLOR_DisabledTop, COLOR_DisabledBottom, ButtonRounding)
	HelperFunctions.Apply_ViewStyle(IPport, Colors.White, COLOR_NormalTop, COLOR_NormalBottom, COLOR_PressedTop, COLOR_PressedBottom, COLOR_DisabledTop, COLOR_DisabledBottom, ButtonRounding)
	HelperFunctions.Apply_ViewStyle(IPaddress, Colors.White, COLOR_NormalTop, COLOR_NormalBottom, COLOR_PressedTop, COLOR_PressedBottom, COLOR_DisabledTop, COLOR_DisabledBottom, ButtonRounding)
	HelperFunctions.Apply_ViewStyle(operator, Colors.White, COLOR_NormalTop, COLOR_NormalBottom, COLOR_PressedTop, COLOR_PressedBottom, COLOR_DisabledTop, COLOR_DisabledBottom, ButtonRounding)
	HelperFunctions.Apply_ViewStyle(password, Colors.White, COLOR_NormalTop, COLOR_NormalBottom, COLOR_PressedTop, COLOR_PressedBottom, COLOR_DisabledTop, COLOR_DisabledBottom, ButtonRounding)
	
	
	
End Sub

Sub advancedSettingsOpen_Click
	advancedSettingsClose.Enabled = True
	advancedSettingsClose.visible = True
	advancedSettingsOpen.enabled = False
	advancedSettingsOpen.visible = False
End Sub

Sub advancedSettingsClose_Click
	advancedSettingsClose.Enabled = False
	advancedSettingsClose.visible = False
	advancedSettingsOpen.enabled = True
	advancedSettingsOpen.visible = True
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
	intLanguageIndex = 0							'Български език / Language is Bulgarian

	
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
'	settingsPanel.AddView(btnTest, 25%x, 90%y, 25%x, 5%y)
'	settingsPanel.AddView(saveSettings, btnTest.Left + btnTest.Width + 2%x, 90%y, 25%x, 5%y)
	settingsPanel.AddView(saveSettings, 33.33%x, 85%y, 33.33%x, 10%y)

	advancedSettingsOpen.Height = 70dip
	advancedSettingsOpen.width = 70dip
	settingsPanel.AddView(advancedSettingsOpen, LabelCountry.Left, saveSettings.Top+saveSettings.Height-advancedSettingsOpen.Height, 70dip, 70dip)
	settingsPanel.AddView(advancedSettingsClose, 98%x - advancedSettingsOpen.Width, saveSettings.Top+saveSettings.Height-advancedSettingsOpen.Height, 70dip, 70dip)
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
	inn.InitializeFromBytesArray(SPAservice.urlResponse.GetBytes("UTF8"),0,SPAservice.urlResponse.GetBytes("UTF8").Length)
	Log(inn.BytesAvailable)
	Try
		templates.Parse(inn, "xml")
		
		
		For Each itemCart As CartItem In ProgramData.GroupItemsMat.Values
			Private PJobItem As TPrnJobFiscalSellItem
			PJobItem.Initialize
			PJobItem.PLU = itemCart.itemCode
			PJobItem.ItemName = itemCart.ItemName
			PJobItem.Quantity = itemCart.qtty
			PJobItem.Price = itemCart.itemPrice
			PJobItem.ItemMeasure = itemCart.measureName
			PJobItem.VatPercent = itemCart.VatPercent
			PJobItem.VatIndex = itemCart.VatIndex
			masterP.AddJob(PJobItem)
		Next
		
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
	If Name.EqualsIgnoreCase("Item") Then 
		itCart.Initialize
		tagUP = 1
	End If
	If Name.EqualsIgnoreCase("Partner") Then	'обект
		partner.Initialize
		tagUP = 2
	End If
	If Name.EqualsIgnoreCase("Owner") Then   'партньор
		workingUser.Initialize
		tagUP = 3
	End If
End Sub

'Построява се обкет номенклатура (Item) или групите във зависимост от инициализацията./ Items or groups are 
'created depending on the initialization
Private Sub xml_EndElement (Uri As String, Name As String, Text As StringBuilder)
	Private paymentMethod As String
	
	Select tagUP
		Case 1
			If Name.EqualsIgnoreCase("Code") 		Then itCart.itemCode = Text
			If Name.EqualsIgnoreCase("Name") 		Then itCart.ItemName = Text
			If Name.EqualsIgnoreCase("Price") 		Then itCart.itemPrice = Text
			If Name.EqualsIgnoreCase("Quantity") 	Then itCart.qtty = Text
			If Name.EqualsIgnoreCase("TaxGroup") 	Then itCart.VATIndex = Text
			If Name.EqualsIgnoreCase("TaxPercent")  Then itCart.VATPercent = Text
			If Name.EqualsIgnoreCase("Discount") 	Then itCart.VATPercent = Text		
			
			If Name.EqualsIgnoreCase("Item") 	Then 
				ProgramData.CurrentCompany.PricePercision = 2
				Private itemCart As CartItem
				
				itemCart = CopyWorkingToLocalItem
'				ProgramData.selectedObjectID = objectStorer.storeCode
'				tempList.Add(itemCart)
				ProgramData.GroupItemsMat.Put(itemCart.itemCode, itemCart)
				
			End If
			
		Case 2
			If Name.EqualsIgnoreCase("Code") Then workingobject.storeCode = Text
			If Name.EqualsIgnoreCase("Name") Then 
				workingobject.storeName = Text
				operator.Text = Text
			End If
			If Name.EqualsIgnoreCase("Address") Then workingobject.storeAddress = Text
			If Name.EqualsIgnoreCase("PriceGroup") Then workingobject.PriceGroup = Text - 1
			If Name.EqualsIgnoreCase("City") Then partner.City = Text
			If Name.EqualsIgnoreCase("Discount") Then partner.discount = Text
			If Name.EqualsIgnoreCase("eMail") Then partner.email = Text
			If Name.EqualsIgnoreCase("MOL") Then partner.mol = Text
			If Name.EqualsIgnoreCase("Type") Then partner.PartnerType = Text
			If Name.EqualsIgnoreCase("Phone") Then partner.phone = Text
			If Name.EqualsIgnoreCase("CardNumber") Then partner.CardNumber = Text
			
			If Name.EqualsIgnoreCase("TaxNo") Then
				If Text.ToString = "" Then  Text.Append("0")
				partner.taxNo = Text
			End If
			
			If Name.EqualsIgnoreCase("Partner") Then
					Private partner As Partner
					Private objectStorer As StoreObject

					objectStorer = CopyWorkingToLocalObject

					partner.Initialize
					partner = Copy_WorkingToLocalObject
					ProgramData.selectedPartnerID = partner.partnerCode
					ProgramData.PartnersMap.Put(partner.partnerCode,partner)
					If partner.Bulstat <> "" Then ProgramData.PartnersBulstatMap.Put(partner.Bulstat,partner.id)
					If partner.CardNumber <> "" Then ProgramData.PartnersCardNumberMap.Put(partner.CardNumber,partner.id)
					If partner.phone <> "" Then ProgramData.PartnersPhoneNumberMap.Put(partner.phone,partner.id)
					
					ProgramData.selectedObjectID = objectStorer.storeCode

					ProgramData.ObjectsMap.Put(objectStorer.storeCode,objectStorer)

			End If
			
		Case 3
			If Name.EqualsIgnoreCase("Code") Then  ProgramData.selectedPartnerID = Text
			If Name.EqualsIgnoreCase("Name") Then  workingUser.Name = Text
			If Name.EqualsIgnoreCase("Group") Then  workingUser.GroupName = Text
			If Name.EqualsIgnoreCase("Phone") Then  workingUser.phone = Text
			If Name.EqualsIgnoreCase("eMail") Then  workingUser.email = Text
			If Name.EqualsIgnoreCase("Address") Then  ProgramData.CurrentCompany.Address = Text
			If Name.EqualsIgnoreCase("MOL") Then  ProgramData.CurrentCompany.ContactPerson = Text
			If Name.EqualsIgnoreCase("VATID") Then  ProgramData.CurrentCompany.TaxNo = Text
			If Name.EqualsIgnoreCase("TAXID") Then  ProgramData.CurrentCompany.INN = Text
			If Name.EqualsIgnoreCase("City") Then  ProgramData.CurrentCompany.City = Text

			If Name.EqualsIgnoreCase("Owner") Then
			ProgramData.CurrentUser = UserCopyWorkingToLocalUser
			End If			

			
	End Select
	
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

	

End Sub
#End Region


Private Sub CopyWorkingToLocalItem As CartItem
	Private localitem As CartItem
	localitem.Initialize

	localitem.itemCode = itCart.itemCode
	localitem.ItemName = itCart.ItemName
	localitem.itemPrice = itCart.itemPrice
	localitem.qtty = itCart.qtty
	localitem.VATIndex = itCart.VATIndex
	localitem.VATPercent = itCart.VATPercent
	localitem.VATPercent = itCart.VATPercent

	Return localitem
End Sub

Private Sub CopyWorkingToLocalObject As StoreObject
	Private localitem As StoreObject
	localitem.Initialize
	localitem.storeCode = workingobject.storeCode
	localitem.storeName = workingobject.storeName
	localitem.storeAddress = workingobject.storeAddress
	Return localitem
End Sub

Private Sub Copy_WorkingToLocalObject As Partner
	Private localitem As Partner
	localitem.Initialize
'	localitem.CompanyID = partner.CompanyID
'	localitem.ID = partner.ID
	localitem.partnerCode = partner.partnerCode
	localitem.CompanyName = partner.CompanyName
	localitem.Address = partner.Address
	localitem.PriceGroup = partner.PriceGroup
	localitem.Bulstat = partner.Bulstat
	localitem.CardNumber = partner.CardNumber
	localitem.City = partner.City
	localitem.discount = partner.discount
	localitem.email = partner.email
	localitem.mol = partner.mol
	localitem.PartnerType = partner.PartnerType
	localitem.phone=partner.phone
	localitem.taxNo = partner.taxNo
	Return localitem
End Sub

Private Sub UserCopyWorkingToLocalUser As CurrentUser
	Private localitem As CurrentUser
'	localitem.CompanyId = workingUser.CompanyId
	localitem.Name = workingUser.Name
	localitem.email = workingUser.email
	localitem.phone = workingUser.phone
	localitem.GroupName = workingUser.GroupName
	Return localitem
End Sub

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
	
	LabelCountry.Text = Main.translate.GetString("lblCountry")
	LabelLanguage.Text = Main.translate.GetString("lblLanguage")
	LabelPrinter.Text = Main.translate.GetString("lblDevice")
	LabelIPport.Text = Main.translate.GetString("lblPort")
	LabelBoudOrIp.Text = Main.translate.GetString("lblBoud")
	LabelOperator.Text = Main.translate.GetString("lblOpertor")
	LabelPassword.Text = Main.translate.GetString("lblPassword")
		
	saveSettings.Text = Main.translate.GetString("lblSave")
	saveSettings.Color= Colors.DarkGray
	saveSettings.TextColor = Colors.LightGray
'	
'	btnTest.Text = Main.translate.GetString("lblTest")
'	btnTest.Color= Colors.DarkGray
'	btnTest.TextColor = Colors.LightGray
End Sub

'Private Sub Test_Click
'	'Функцията за тест я има направена в POS модула и е кръстена PrinterTest
'	Dim ConnectionParams As TConnectionParameters = getConnectionParams
'	
'	Dim pScripts As PrinterScripts = getScripts
'	
'	If Not(checkConnectionParams) Then Return
'	
'	Dim printerInfo As Printer = masterP.getInitialPrinterByName(selectedPrinterName)
'	
'	Dim testPrinter As TActivePrinter
'	testPrinter.Initialize
'	testPrinter.name = selectedPrinterName
'	testPrinter.connectionParams = ConnectionParams
'	testPrinter.ScriptsTemplate = pScripts
'	testPrinter.id = printerInfo.id
'	testPrinter.driver = CallSub(printerInfo.ref, "getPrinter_Instance")
'	
'	CallSub2(testPrinter.driver ,"setSelected_Printer", testPrinter.id)
'	CallSub2(testPrinter.driver ,"SetConnection_Parameters", testPrinter.connectionParams)
'	Dim fiscal As Boolean = CallSub(testPrinter.driver ,"getFiscal_MemoryMode")
'	
''	'set the driver scripts
''	CallSub2(testPrinter.driver,"Assign_Scripts", testPrinter.ScriptsTemplate)
''	
''	Dim DummySVItem As PrinterStatusSVItem
''	DummySVItem.Initialize(Null,testPrinter,fiscal,True)
'	
'	masterP.SendPrinterTestJobs(1,testPrinter)
'End Sub

Sub Save_click
	
	readinfo.IPaddress = IPaddress.Text
	readinfo.port = IPport.Text
	readinfo.operator = operator.Text
	readinfo.password = password.Text
	raf.WriteEncryptedObject(readinfo, ProgramData.rafEncPass,0)
	ToastMessageShow(Main.translate.GetString("ToastSave"), False)

End Sub

Private Sub getScripts As PrinterScripts
	Dim scripts As PrinterScripts
	scripts.Initialize
	scripts.Footers = getScriptFooters
	scripts.Headers = getScriptHeaders
	scripts.Details = getScriptDetails
	scripts.Totals  = getScriptTotals
	Return scripts
End Sub

Private Sub getScriptHeaders As List
	Dim dummy As List
	dummy.Initialize
	
	For Each edt As EditText In cHeadersList
		If edt.Text <> "" Then dummy.Add(edt.Text)
	Next
	
	Return dummy
End Sub

Private Sub getScriptDetails As List
	Dim dummy As List
	dummy.Initialize
	
	For Each edt As EditText In cDetailesList
		If edt.Text <> "" Then dummy.Add(edt.Text)
	Next
	
	Return dummy
End Sub

Private Sub getScriptTotals As List
	Dim dummy As List
	dummy.Initialize
	
	For Each edt As EditText In cTotalsList
		If edt.Text <> "" Then dummy.Add(edt.Text)
	Next
	
	Return dummy
End Sub

Private Sub getScriptFooters As List
	Dim dummy As List
	dummy.Initialize
	
	For Each edt As EditText In cFootersList
		If edt.Text <> "" Then dummy.Add(edt.Text)
	Next
	
	Return dummy
End Sub


Private Sub setSettings
	Try
		Dim ActivePrinter As TActivePrinter
		ActivePrinter.Initialize
		ActivePrinter.connectionParams = getConnectionParams
		ActivePrinter.name = selectedPrinterName
		ActivePrinter.ScriptsTemplate = getScripts

		If Not(checkConnectionParams) Then Return
		
		masterP.addToActivePrinter(ActivePrinter)
		refillSpPrinters
	Catch
		Log(LastException)
		Msgbox(Main.translate.GetString("msgPrinterFailedToAdd"),Main.translate.GetString("lblWarning"))
	End Try
End Sub

Sub countrySpinner_ItemClick (Position As Int, Value As Object)
	readinfo.country = Value
End Sub

Sub BoudSpinner_ItemClick (Position As Int, Value As Object)
	readinfo.speed = Value
End Sub

Sub languageSpinner_ItemClick (Position As Int, Value As Object)
	intLanguageIndex = Position
	Main.SelectedLanguage = Value
	Main.translate.SetLanguage(Main.SelectedLanguage)
	InitialSetSignsRefresh
	readinfo.language = Value
End Sub

'Опресняване на надписите в първоначалните настройки / Refreshes signs in Initial settings
Public Sub InitialSetSignsRefresh
	LabelCountry.Text = Main.translate.GetString("lblCountry")
	LabelLanguage.Text = Main.translate.GetString("lblLanguage")
	LabelPrinter.Text = Main.translate.GetString("lblDevice")
	LabelIPport.Text = Main.translate.GetString("lblPort")
	LabelBoudOrIp.Text = Main.translate.GetString("lblBoud")
	LabelOperator.Text = Main.translate.GetString("lblOpertor")
	LabelPassword.Text = Main.translate.GetString("lblPassword")
	saveSettings.Text = Main.translate.GetString("lblSave")
'	btnTest.Text = Main.translate.GetString("lblTest")
	CallSub(Main,"Login_SignsRefresh")	' Когато опресним надписите тук, ще се опресняват и надписите в другите модули
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
			LabelBoudOrIp.Text = Main.translate.GetString("lblBoud")
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
'			
			'Put Control in map
			controlsMap.Put(setting,Boud)
				
		Case Main.PS_IPAddress
			'Build EditText
			LabelBoudOrIp.Text = Main.translate.GetString("lblIPadd")
			IPport.Enabled = True
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