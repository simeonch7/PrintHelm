B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=8.3
@EndOfDesignText@
  Sub Class_Globals
	Private settingsPanel, countourPanel, configPanel, statusBtn As Panel
	Private country, language, printer, spnMac As Spinner
	Private IPport, IPaddress As EditText
	Private LabelCountry, LabelLanguage, LabelPrinter, LabelAcPrinter, lblEditPrinter As Label
	Private BoudRatesList As List
	Private PrinterList As List
	Private masterP As PrinterMain
	Private templates As SaxParser
	Private cash,card,bank,vaucher As Double
	Private  payMethod As Int
	Private inn As InputStream
	Private getConnectionParamsFailed As Boolean = False	'Show if theres and error in the input of controls in ControlsMap
	Private selectedPrinterName As String = ""				'Hold Name of the selected printer				
	Private controlsMap As Map								'Hold all the settings controls
	Private spnActivePrinter As Spinner
	Private btnPrinterRemove, btnPrinterAdd, btnPrinterEdt, pnlEditImg As Button
	Private Const ButtonsRounding As Int = 5
	Private BTmap As Map

	Private BTSettingsSV As ScrollView						'SV for all the settings controls
	Private HFHeight,HFsingleLineHeight As Int
	Private inFooterHolder, outFooterHolder, outHeaderHolder, inHeaderHolder, outDetailesHolder, inDetailesHolder, outTotalsHolder, inTotalsHolder As Panel

	Private tempList As List
	Private saveSettings, exitSettings As Button
			
	Private Const COLOR_NormalTop As Int 	  =	0xff4ac2ff	'Light blue
	Private Const COLOR_NormalBottom As Int   =	0xff149be0	'Darker blue
	Private Const COLOR_PressedTop As Int 	  =	0xff2cb7ff	'Same light blue
	Private Const COLOR_PressedBottom As Int  =	0xff2cb7ff	'Same light blue
	Private Const COLOR_DisabledTop As Int    =	0x66040509	'Semi-transperant black
	Private Const COLOR_DisabledBottom As Int =	0x66040509	'Semi-transperant black
	Private Const ButtonRounding As Int = 60	'How much rounding is done on the buttons & edit text corners
'	Private Const COLOR_Dropdown As Int = 		0xFF012136

	Private background, edtbtnBG As BitmapDrawable
	
	Public mode As Int
	Public const mode_add As Int = 1
	Public const mode_edit As Int = 2
	Private selectedEditPrinterIndex As Int

	
	Private itCart As CartItem
	Private partner As Partner
	Private workingUser As CurrentUser	
	Private workingobject As StoreObject
	Private tagUP As Int = 0
	Private cHeadersList, cFootersList, cDetailesList, cTotalsList As List
	
	
End Sub



Public Sub Initialize
	settingsPanel.Initialize("fakeHolder")
	
	configPanel.Initialize("configPanel")
	countourPanel.Initialize("countourPanel")
	cFootersList.Initialize
	cDetailesList.Initialize
	cHeadersList.Initialize
	cTotalsList.Initialize
	
	background.Initialize(LoadBitmap(File.DirAssets, "smartBG.jpg"))
	edtbtnBG.Initialize(LoadBitmap(File.DirAssets, "edit.png"))
	
	settingsPanel.Background = background
	
	country.Initialize("countrySpinner")
	Countries.Initialize
	CountriesFill
	country.SelectedIndex = UConfig.USConfig.country
	language.Initialize("languageSpinner")
	languageprinterFill
	language.SelectedIndex = language.IndexOf(Main.SelectedLanguage)
	
	printer.Initialize("deviceSpinner")

	IPport.Initialize("IPport")
	IPaddress.Initialize("IPaddress")
	lblEditPrinter.Initialize("")
	
	LabelCountry.Initialize("countryLabel")
	LabelLanguage.Initialize("languageLabel")
	LabelPrinter.Initialize("deviceLabel")
	LabelAcPrinter.Initialize("AcPrnLabel")
	saveSettings.Initialize("Save")
	exitSettings.Initialize("exit")
	statusBtn.Initialize("")
	spnActivePrinter.Initialize("PrinterChoose")
	btnPrinterRemove.Initialize("removePrinter")
	pnlEditImg.Initialize("editPrinter")
	edtbtnBG= pnlEditImg.SetBackgroundImage(LoadBitmap(File.DirAssets,"edit.png"))
	edtbtnBG.Gravity = Gravity.CENTER
	btnPrinterEdt.Initialize("EditPrinter")
	btnPrinterAdd.Initialize("AddbtnPrinter")
	spnMac.Initialize("")
	
	
	BoudRatesList.Initialize
	
	controlsMap.Initialize
	tempList.Initialize

	BTmap.Initialize

	ColorPickerAndLabelTexts
	masterP.Initialize(Me)
	refillSpPrinters
	PrinterList.Initialize
	templates.Initialize
	BoudRatesList.Add("1200")
	BoudRatesList.Add("2400")
	BoudRatesList.Add("4800")
	BoudRatesList.Add("9600")
	BoudRatesList.Add("14400")
	BoudRatesList.Add("19200")
	BoudRatesList.Add("38400")
	BoudRatesList.Add("57600")
	BoudRatesList.Add("115200")
	
	deviceprinterFill
	
	configPanel.Color = Colors.White
	countourPanel.Color = ProgramData.COLOR_BUTTON_NORMAL
	HelperFunctions.Apply_ViewStyle(saveSettings, Colors.White, COLOR_NormalTop, COLOR_NormalBottom, COLOR_PressedTop, COLOR_PressedBottom, COLOR_DisabledTop, COLOR_DisabledBottom, ButtonRounding)
	HelperFunctions.Apply_ViewStyle(country, Colors.White, COLOR_NormalBottom, COLOR_NormalBottom, COLOR_PressedTop, COLOR_PressedBottom, COLOR_DisabledTop, COLOR_DisabledBottom, ButtonRounding)
	HelperFunctions.Apply_ViewStyle(language, Colors.White, COLOR_NormalBottom, COLOR_NormalBottom, COLOR_PressedTop, COLOR_PressedBottom, COLOR_DisabledTop, COLOR_DisabledBottom, ButtonRounding)
	HelperFunctions.Apply_ViewStyle(printer, Colors.White, COLOR_NormalBottom, COLOR_NormalBottom, COLOR_PressedTop, COLOR_PressedBottom, COLOR_DisabledTop, COLOR_DisabledBottom, ButtonRounding)
	HelperFunctions.Apply_ViewStyle(spnActivePrinter, Colors.White, COLOR_NormalBottom, COLOR_NormalBottom, COLOR_PressedTop, COLOR_PressedBottom, COLOR_DisabledTop, COLOR_DisabledBottom, ButtonRounding)
	HelperFunctions.Apply_ViewStyle(exitSettings, Colors.White, COLOR_NormalTop, COLOR_NormalBottom, COLOR_PressedTop, COLOR_PressedBottom, COLOR_DisabledTop, COLOR_DisabledBottom, ButtonRounding)
	HelperFunctions.Apply_ViewStyle(statusBtn, Colors.White, ProgramData.COLOR_BUTTON_NORMAL, ProgramData.COLOR_BUTTON_NORMAL, ProgramData.COLOR_BUTTON_PRESSED, ProgramData.COLOR_BUTTON_PRESSED, ProgramData.COLOR_BUTTON_PRESSED, ProgramData.COLOR_BUTTON_PRESSED, ProgramData.BUTTON_ROUNDING + ButtonRounding)
	HelperFunctions.Apply_ViewStyle(printer, Colors.White, COLOR_NormalTop, COLOR_NormalBottom, COLOR_PressedTop, COLOR_PressedBottom, COLOR_DisabledTop, COLOR_DisabledBottom, ButtonRounding)
	HelperFunctions.Apply_ViewStyle(btnPrinterRemove, Colors.White, ProgramData.COLOR_BUTTON_NORMAL, ProgramData.COLOR_BUTTON_NORMAL, ProgramData.COLOR_BUTTON_PRESSED, ProgramData.COLOR_BUTTON_PRESSED, ProgramData.COLOR_BUTTON_PRESSED, ProgramData.COLOR_BUTTON_PRESSED, ProgramData.BUTTON_ROUNDING + ButtonsRounding)
	HelperFunctions.Apply_ViewStyle(btnPrinterAdd, Colors.White, ProgramData.COLOR_BUTTON_NORMAL, ProgramData.COLOR_BUTTON_NORMAL, ProgramData.COLOR_BUTTON_PRESSED, ProgramData.COLOR_BUTTON_PRESSED, ProgramData.COLOR_BUTTON_PRESSED, ProgramData.COLOR_BUTTON_PRESSED, ProgramData.BUTTON_ROUNDING + ButtonsRounding)
	HelperFunctions.Apply_ViewStyle(btnPrinterEdt, Colors.White, ProgramData.COLOR_BUTTON_NORMAL, ProgramData.COLOR_BUTTON_NORMAL, ProgramData.COLOR_BUTTON_PRESSED, ProgramData.COLOR_BUTTON_PRESSED, ProgramData.COLOR_BUTTON_PRESSED, ProgramData.COLOR_BUTTON_PRESSED, ProgramData.BUTTON_ROUNDING + ButtonsRounding)
	HelperFunctions.Apply_ViewStyle(spnMac, Colors.White, COLOR_NormalTop, COLOR_NormalBottom, COLOR_PressedTop, COLOR_PressedBottom, COLOR_DisabledTop, COLOR_DisabledBottom, ButtonRounding)
	country.SetBackgroundImage(ImageResources.BMP_SpinnerBack)
	language.SetBackgroundImage(ImageResources.BMP_SpinnerBack)
	printer.SetBackgroundImage(ImageResources.BMP_SpinnerBack)
	spnActivePrinter.SetBackgroundImage(ImageResources.BMP_SpinnerBack)



	lblEditPrinter.Visible = False
	lblEditPrinter.TextColor = Colors.Black
	lblEditPrinter.Typeface = Typeface.DEFAULT_BOLD
	lblEditPrinter.Gravity = Gravity.CENTER
	
	
	SettingsUI
	setSettingsScrtoActivity
	refillSpPrinters
	
End Sub

public Sub setSettingsScrtoActivity
	Dim target As Panel
	target =CallSub(Main, "Get_Activity")
	target.RemoveAllViews
	target.AddView(settingsPanel, 0, 0, 100%x, 100%y)
End Sub

'Public Sub buttonsHide
'	If btnPrinterRemove.Enabled = True Then	
'		btnPrinterRemove.Visible = False
'		btnPrinterAdd.Visible = False
'		btnPrinterEdt.Visible = False
'		spnActivePrinter.Visible = False
'	End If
'End Sub
'
'Public Sub buttonsShow
'	If btnPrinterRemove.Visible  = False Then
'		btnPrinterRemove.Visible = True
'		btnPrinterAdd.Visible = True
'		btnPrinterEdt.Visible = True
'		spnActivePrinter.Visible = True
'	End If
'End Sub


Sub CountriesFill
	For Each m As String In Countries.getCountries.Keys
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
	
	settingsPanel.AddView(countourPanel, -100%x, 50%y, 100%x, 50%y)
	countourPanel.AddView(configPanel, 5dip, 5dip, 100%x - 10dip, 50%y - 10dip)
		
	settingsPanel.AddView(LabelCountry, 0%x, 8%y, 100%x, 5%y)
	LabelCountry.Gravity = Gravity.CENTER_HORIZONTAL
	settingsPanel.AddView(country, 30%x, LabelCountry.Top + LabelCountry.Height, 40%x, 5%y)
	
	settingsPanel.AddView(LabelLanguage, 0%x, country.Top + country.Height + 2%y, 100%x, 5%y)
	LabelLanguage.Gravity = Gravity.CENTER_HORIZONTAL
	settingsPanel.AddView(language, 30%x, LabelLanguage.Top + LabelLanguage.Height , 40%x, 5%y)
		
	settingsPanel.AddView(LabelAcPrinter, 0%x, language.Top + language.Height + 5%y, 100%x, 5%y)
	LabelAcPrinter.Gravity = Gravity.CENTER_HORIZONTAL
	
	settingsPanel.AddView(spnActivePrinter, 32.5%x, LabelAcPrinter.Top + LabelAcPrinter.Height + UISizes.DefaultPadding, 35%x, 5%y)
	
	settingsPanel.AddView(statusBtn, 100%x - 12%x, 2%y, 10%x, 6%y)
	
	'PrinterSettingsPanel
	configPanel.AddView(LabelPrinter, 2%x, 2%y, 35%x, 5%y)
	LabelPrinter.Gravity = Gravity.CENTER_VERTICAL
	configPanel.AddView(printer, 2%x, LabelPrinter.Top + LabelPrinter.Height, 40%x, 5%y)

	configPanel.AddView(lblEditPrinter, 2%x, LabelPrinter.Top + LabelPrinter.Height, 40%x, 5%y)
	configPanel.AddView(saveSettings, configPanel.Width -25%x, configPanel.Height - 20%y, 20%x, 5%y)
	configPanel.AddView(exitSettings, saveSettings.Left, saveSettings.top + saveSettings.Height + 3%y, 20%x, 5%y)
	
	masterP.initPrintingScreen(settingsPanel, statusBtn)
	
	settingsPanel.AddView(btnPrinterAdd, spnActivePrinter.Left + spnActivePrinter.Width - (15%x + 6 * UISizes.DefaultPadding)* 1.5, spnActivePrinter.top + spnActivePrinter.Height + UISizes.DefaultPadding, 5%x, 5%y)
	settingsPanel.AddView(btnPrinterRemove, btnPrinterAdd.Left + btnPrinterAdd.Width + UISizes.DefaultPadding, btnPrinterAdd.top, 5%x, 5%y)
	settingsPanel.AddView(btnPrinterEdt, btnPrinterRemove.Left + btnPrinterRemove.Width + UISizes.DefaultPadding, btnPrinterAdd.top, 5%x, 5%y)
	settingsPanel.AddView(pnlEditImg, btnPrinterRemove.Left + btnPrinterRemove.Width + UISizes.DefaultPadding, btnPrinterAdd.top, 5%x, 5%y)

	Dim heightSV As Int
	heightSV = configPanel.Height - LabelPrinter.Height - printer.Height
	BTSettingsSV.Initialize(heightSV)

	configPanel.AddView(BTSettingsSV, 2%x, printer.Top + printer.Height + 1%y, configPanel.Width * 0.7, heightSV)

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
#End Region
'
'Private Sub fakeHolder_Click
'	
'End Sub

Sub ColorPickerAndLabelTexts
	LabelCountry.TextColor = Colors.white
	LabelLanguage.TextColor = Colors.white
	LabelPrinter.TextColor = Colors.white
	LabelAcPrinter.TextColor = Colors.white
	
	LabelCountry.Text = Main.translate.GetString("lblCountry")
	LabelLanguage.Text = Main.translate.GetString("lblLanguage")
	LabelPrinter.Text = Main.translate.GetString("lblDevice")
	LabelAcPrinter.Text = Main.translate.GetString("lblACDevice")
		
	saveSettings.Text = Main.translate.GetString("lblSave")
	saveSettings.Color= Colors.white
	saveSettings.TextColor = Colors.white
	
	exitSettings.Text = Main.translate.GetString("lblExit")
	exitSettings.Color= Colors.white
	exitSettings.TextColor = Colors.white
	
	spnActivePrinter.TextColor = Colors.White
	spnActivePrinter.DropdownTextColor = Colors.White

	btnPrinterRemove.Text = "-"
	btnPrinterAdd.Text = "+"

End Sub

Private Sub removePrinter_Click
	If spnActivePrinter.SelectedIndex <> - 1 Then
		masterP.removeFromActivePrinter(spnActivePrinter.SelectedIndex)
		spnActivePrinter.RemoveAt(spnActivePrinter.SelectedIndex)
	End If
	SavePrinters
End Sub

Sub Save_click
	Select mode
		Case mode_add
			Try
				Dim ActivePrinter As TActivePrinter
				ActivePrinter.Initialize
				ActivePrinter.connectionParams = getConnectionParams
				ActivePrinter.name = selectedPrinterName
				ActivePrinter.ScriptsTemplate = getScripts
		
				If Not(checkConnectionParams) Then Return			
				masterP.addToActivePrinter(ActivePrinter)
				spnActivePrinter.Add(ActivePrinter.name)
				refillSpPrinters
				hideScreen
			Catch
				Log(LastException)
				Msgbox(Main.translate.GetString("msgPrinterFailedToAdd"),Main.translate.GetString("lblWarning"))
			End Try
			
		Case mode_edit
			Dim Acprinter As TActivePrinter = masterP.ActivePrinters.Get(selectedEditPrinterIndex)
			Dim connectionParams As TConnectionParameters = getConnectionParams
			Dim scripts As PrinterScripts = getScripts
			
			If Not(checkConnectionParams) Then Return
					Acprinter.connectionParams = connectionParams
					Acprinter.ScriptsTemplate = scripts
			CallSub2(Acprinter.driver ,"SetConnection_Parameters", Acprinter.connectionParams)
			hideScreen
		End Select
	SavePrinters
End Sub

Private Sub AddbtnPrinter_Click
	If countourPanel.left = 0 Then
		hideScreen
		Return
	End If
	mode = mode_add

	CallSub3(Me, "deviceSpinner_ItemClick", 0, printer.GetItem(0))
	setVisible(True)
	configPanel.Color = Colors.White

	countourPanel.BringToFront	
	country.Enabled = False
	language.Enabled = False
	countourPanel.SetLayoutAnimated(500, 0, 50%y, 100%x, 50%y)
End Sub

Private Sub EditPrinter_Click
	If spnActivePrinter.Size >= 1 Then 
		If countourPanel.left = 0 Then
			hideScreen
			Return
		End If
		mode = mode_edit
		setVisible(True)
		fillEditSettings(selectedEditPrinterIndex)
		countourPanel.BringToFront
		country.Enabled = False
		language.Enabled = False
		countourPanel.SetLayoutAnimated(500, 0, 50%y, 100%x, 50%y)
		configPanel.Color = Colors.White
	Else
		ToastMessageShow("No Active Printers", False)
	End If
	
End Sub

Private Sub exit_Click
	hideScreen
End Sub

Public Sub hideScreen
	printer.SelectedIndex = 0
	controlsMap.Clear
	BTSettingsSV.Panel.RemoveAllViews
	
	country.Enabled = True
	language.Enabled = True

	countourPanel.SetLayoutAnimated(500, -100%x, 50%y, 100%x, 50%y)
'	setVisible(False)
End Sub


Public Sub setVisible(isVisible As Boolean)
	countourPanel.SetVisibleAnimated(500,isVisible)
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


Sub countrySpinner_ItemClick (Position As Int, Value As Object)
	UConfig.USConfig.country = Position
	
End Sub

Sub languageSpinner_ItemClick (Position As Int, Value As Object)
	UConfig.USConfig.language = Value
	Main.SelectedLanguage = Value
	Main.translate.SetLanguage(Value)
	InitialSetSignsRefresh
End Sub

'Опресняване на надписите в първоначалните настройки / Refreshes signs in Initial settings
Public Sub InitialSetSignsRefresh
	LabelCountry.Text = Main.translate.GetString("lblCountry")
	LabelLanguage.Text = Main.translate.GetString("lblLanguage")
	LabelPrinter.Text = Main.translate.GetString("lblDevice")
	LabelAcPrinter.Text = Main.translate.GetString("lblACDevice")
	saveSettings.Text = Main.translate.GetString("lblSave")
	exitSettings.Text = Main.translate.GetString("lblExit")

	CallSub(Main,"Login_SignsRefresh")	' Когато опресним надписите тук, ще се опресняват и надписите в другите модули
End Sub

Sub deviceSpinner_ItemClick (Position As Int, Value As Object)
	selectedPrinterName = Value
'	readinfo.Device = Value
	fillSettings
End Sub

Sub PrinterChoose_ItemClick (Position As Int, Value As Object)
	selectedPrinterName = Value
	selectedEditPrinterIndex = Position
End Sub

public Sub fillSettings
	
	printer.Visible = True
	lblEditPrinter.Visible = False

	Dim printerInfo As Printer = masterP.getInitialPrinterByName(selectedPrinterName)
	CallSub2(printerInfo.ref,"setSelected_Printer", printerInfo.id)	
	Dim m As Map = CallSub(printerInfo.ref,"getDevice_SettingsRequirements")
	
	Dim fiscalMode As Boolean = CallSub(printerInfo.ref, "getFiscal_MemoryMode")
	
	runMap(m,fiscalMode)
End Sub

Private Sub fillEditSettings(APrinterIndex As Int)
	'трябва проверка дали има принтер, който да се едитва
	
	Dim actprinter As TActivePrinter = masterP.ActivePrinters.Get(APrinterIndex)
	Dim m As Map = CallSub(actprinter.driver,"getDevice_SettingsRequirements")
	Dim fiscalMode As Boolean = CallSub(actprinter.driver, "getFiscal_MemoryMode")
	actprinter.connectionParams = CallSub(actprinter.driver, "getConnection_Parameters")


	printer.Visible = False
	lblEditPrinter.Visible = True
	lblEditPrinter.Text = actprinter.name
	selectedPrinterName = actprinter.name

	
	runMap(m,fiscalMode)
	FillControls(actprinter.connectionParams)
	fillScripts(actprinter.ScriptsTemplate, fiscalMode)
End Sub

private Sub fillScripts(Scripts As PrinterScripts, fiscalMode As Boolean)
	If Scripts.Headers.Size > 0 Then
		For Each H As String In Scripts.Headers
			addHeader(H)
		Next
	Else
		addHeader("")
	End If
	
	If Not(fiscalMode) Then
		If Scripts.Details.Size > 0 Then
			For Each H As String In Scripts.Details
				addDetail(H)
			Next
		Else
			addDetail("")
		End If
	End If
	
	If Not(fiscalMode) Then
		If Scripts.Totals.Size > 0 Then
			For Each H As String In Scripts.Totals
				addTotals(H)
			Next
		Else
			addTotals("")
		End If
	End If
	
	If Scripts.Footers.Size > 0 Then
		For Each H As String In Scripts.Footers
			addFooter(H)
		Next
	Else
		addFooter("")
	End If
End Sub


private Sub FillControls(connectionParams As TConnectionParameters)
	For Each key As Int In controlsMap.Keys
		Dim control As Object = controlsMap.Get(key)
		Log(control)
		Select key
			Case Main.PS_BaudRate		
				Dim cSpinner As Spinner = control
				
				cSpinner.SelectedIndex =  cSpinner.IndexOf(connectionParams.BaudRate)
'				
			Case Main.PS_IPAddress
				Dim cEditText As EditText = control
				cEditText.Text = connectionParams.IPAddress
				
			Case Main.PS_IPPort
				Dim cEditText As EditText = control
				cEditText.Text = connectionParams.IPPort
				
			Case Main.PS_Password
				Dim cEditText As EditText = control
				cEditText.Text = connectionParams.Password
				
			Case Main.PS_SerialPort
				Dim cEditText As EditText = control
				cEditText.Text = connectionParams.SerialPort
				
			Case Main.PS_UserID
				Dim cEditText As EditText = control
				cEditText.Text = connectionParams.UserID
				
			Case Main.PS_DeviceMAC
				Dim cTable As Spinner = control
				cTable.SelectedIndex = cTable.IndexOf(connectionParams.DeviceMAC)
		End Select
	Next
	
End Sub

private Sub runMap(m As Map, isFiscal As Boolean)
	clearSettingSV
	Dim last As Int = 0
	For Each setting As Int In m.Keys
		last = generateSettingView(BTSettingsSV, last, setting, m.Get(setting))
	Next
	
	HFHeight = configPanel.Height * 0.25
	HFsingleLineHeight = configPanel.Height * 0.07
	
	last = GenerateHeader(BTSettingsSV,last)
	
	If Not(isFiscal) Then
		last = GenerateDetails(BTSettingsSV, last)
		last = GenerateTotals(BTSettingsSV, last)
	End If
	
	last = GenerateFooter(BTSettingsSV,last)
	
	HelperFunctions.FitViewsInScroll(BTSettingsSV)

		
End Sub

private Sub clearSettingSV
	controlsMap.Clear
	cHeadersList.Clear
	cFootersList.Clear
	cDetailesList.Clear
	cTotalsList.Clear
	
	outHeaderHolder.Initialize("")
	outHeaderHolder.RemoveAllViews
	outHeaderHolder.RemoveView
	inHeaderHolder.Initialize("")
	inHeaderHolder.RemoveAllViews
	inHeaderHolder.RemoveView
	
	outFooterHolder.Initialize("")
	outFooterHolder.RemoveAllViews
	outFooterHolder.RemoveView
	inFooterHolder.Initialize("")
	inFooterHolder.RemoveAllViews
	inFooterHolder.RemoveView
	
	outDetailesHolder.Initialize("")
	outDetailesHolder.RemoveAllViews
	outDetailesHolder.RemoveView
	inDetailesHolder.Initialize("")
	inDetailesHolder.RemoveAllViews
	inDetailesHolder.RemoveView
	
	outTotalsHolder.Initialize("")
	outTotalsHolder.RemoveAllViews
	outTotalsHolder.RemoveView
	inTotalsHolder.Initialize("")
	inTotalsHolder.RemoveAllViews
	inTotalsHolder.RemoveView
	
	BTSettingsSV.Panel.RemoveAllViews
End Sub

Public Sub refillSpPrinters
	spnActivePrinter.Clear
	
	For Each printerAc As TActivePrinter In masterP.ActivePrinters
		spnActivePrinter.Add(printerAc.name)
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
				Else : connectionParams.BaudRate = cSpinner.SelectedItem 
					Log(connectionParams.baudrate)
				End If
				
			Case Main.PS_IPAddress
				Dim cEditText As EditText = control
				If cEditText.Text.Length = 0 Then
					getConnectionParamsFailed = True
				else If Not (IsValidIP(cEditText.Text)) Then
					ToastMessageShow(Main.translate.GetString("msgWrongIP"), False)
					getConnectionParamsFailed = True
				Else
					connectionParams.IPAddress = cEditText.Text
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
				
			Case Main.PS_UserID
				Dim cEditText As EditText = control
				If cEditText.Text.Length = 0 Then : getConnectionParamsFailed = True
				Else : connectionParams.UserID = cEditText.Text
				End If
				
			Case Main.PS_DeviceMAC
				Dim cTable As Spinner = control
				
				If cTable.Size = 0 Then :	getConnectionParamsFailed = True
				Else : connectionParams.DeviceMAC = cTable.GetItem(0)
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

public Sub generateSettingView(Spnl As ScrollView, top As Int,  setting As Int, value As Object) As Int
'	If controlsMap.ContainsKey(setting) Then Return top

	Dim hold As Panel
	Dim cHeight As Int = 40dip

	hold.Initialize("")
	Spnl.Panel.AddView(hold, 0, top, Spnl.Width, cHeight)
	Dim lblWidth As Int = hold.Width / 3

	Select setting
		Case Main.PS_BaudRate
			
			Dim info As Label
			Dim spn As Spinner
			
			'Build Label
			info.Initialize("")
			info.Text = Main.translate.GetString("lblBaud")
			info.Gravity = Gravity.CENTER
			info.TextColor = Colors.Black
			hold.AddView(info, 0, 0, lblWidth, cHeight)
			
			spn.Initialize("spnSetting")
			spn.Tag = setting
			spn.AddAll(BoudRatesList)
			spn.SelectedIndex = value
			spn.DropdownTextColor = Colors.White
			spn.DropdownBackgroundColor = 0xFF3577D5
			spn.SetBackgroundImage(ImageResources.BMP_SpinnerBack)
			HelperFunctions.Remove_Padding(spn)
			hold.AddView(spn, info.Width, cHeight * 0.05, hold.Width - lblWidth, cHeight * 0.6)
			
			'Set spinner selected index
			Dim valueIndex As Int = BoudRatesList.IndexOf(value)
			If valueIndex = - 1 Then valueIndex = 3
			spn.SelectedIndex = valueIndex
			
			'Put Control in map
			controlsMap.Put(setting,spn)
				
		Case Main.PS_IPAddress
			Dim info As Label
			Dim edt As EditText
			
			'Build Label
			info.Initialize("")
			info.Text = Main.translate.GetString("lblIPAddress")
			info.Gravity = Gravity.CENTER
			info.TextColor = Colors.Black
			hold.AddView(info, 0, 0, lblWidth, cHeight)
			
			'Build EditText
			edt.Initialize("edtSetting")
			edt.Text = value
			edt.TextColor = Colors.White
			edt.Tag = setting
			edt.SingleLine = True
			HelperFunctions.Apply_ViewStyle(edt, Colors.White, ProgramData.COLOR_BUTTON_NORMAL, ProgramData.COLOR_BUTTON_NORMAL, ProgramData.COLOR_BUTTON_PRESSED, ProgramData.COLOR_BUTTON_PRESSED, ProgramData.COLOR_BUTTON_PRESSED, ProgramData.COLOR_BUTTON_PRESSED, ProgramData.BUTTON_ROUNDING + 5)
			hold.AddView(edt, info.Width, cHeight * 0.05, hold.Width - lblWidth, cHeight * 0.6)
			
			controlsMap.Put(setting,edt)
			
		Case Main.PS_IPPort
			Dim info As Label
			Dim edt As EditText
			
			'Build Label
			info.Initialize("")
			info.Text = Main.translate.GetString("lblPort")
			info.Gravity = Gravity.CENTER
			info.TextColor = Colors.Black
			hold.AddView(info, 0, 0, lblWidth, cHeight)
			
			'Build EditText
			edt.Initialize("edtSetting")
			edt.Text = value
			edt.TextColor = Colors.White
			edt.Tag = setting
			edt.SingleLine = True
			edt.InputType = edt.INPUT_TYPE_NUMBERS
			HelperFunctions.Apply_ViewStyle(edt, Colors.White, ProgramData.COLOR_BUTTON_NORMAL, ProgramData.COLOR_BUTTON_NORMAL, ProgramData.COLOR_BUTTON_PRESSED, ProgramData.COLOR_BUTTON_PRESSED, ProgramData.COLOR_BUTTON_PRESSED, ProgramData.COLOR_BUTTON_PRESSED, ProgramData.BUTTON_ROUNDING + 5)
			hold.AddView(edt, info.Width, cHeight * 0.05 , hold.Width - lblWidth, cHeight * 0.6)
			
			controlsMap.Put(setting,edt)
			
		Case Main.PS_DeviceMAC
			'Init BTPort
						
			Dim info As Label
			Dim spn As Spinner
			
			'Build Label
			info.Initialize("")
			info.Text = Main.translate.GetString("lblMac")
			info.Gravity = Gravity.CENTER
			info.TextColor = Colors.Black
			hold.AddView(info, 0, 0, lblWidth, cHeight)
			
			spn.Initialize("spnSetting")
			spn.Tag = setting
			HelperFunctions.Apply_ViewStyle(spn, Colors.White, COLOR_NormalBottom, COLOR_NormalBottom, COLOR_PressedTop, COLOR_PressedBottom, COLOR_DisabledTop, COLOR_DisabledBottom, ButtonRounding)
			spn.SetBackgroundImage(ImageResources.BMP_SpinnerBack)
			HelperFunctions.Remove_Padding(spn)
			
			Dim btPort As Serial
			btPort.Initialize("BTPort")
			If btPort.GetPairedDevices.Size > 0 Then 
				For Each name As String In btPort.GetPairedDevices.Keys
					BTmap.Put(name, btPort.GetPairedDevices.Get(name))
					spn.Add( btPort.GetPairedDevices.Get(name))
				Next
			Else
				ToastMessageShow("No paired Devices", False)
			End If
			hold.AddView(spn, info.Width, cHeight * 0.05, hold.Width - lblWidth, cHeight * 0.6)

			controlsMap.Put(setting,spn)
		
	End Select
	'Calculate next top
	top = top + hold.Height + UISizes.DefaultPadding
	
	Return top

End Sub

#Region Scripts

'Header 
private Sub GenerateHeader(SV As ScrollView,top As Int) As Int 'ignore
	Dim btnAdd As Button
	Dim title As Label
	
	Dim cHeight As Int = configPanel.Height*0.07
	
	SV.Panel.AddView(outHeaderHolder,0,top,SV.Width,HFHeight)
	
	'Build title
	title.Initialize("")
	title.Text = Main.translate.GetString("lblHeaders")
	title.TextSize = ProgramData.TextSize_ExtraLarge
	title.TextColor = Colors.Gray
	title.Gravity = Gravity.CENTER_VERTICAL + Gravity.LEFT
	HelperFunctions.Remove_Padding(title)
	outHeaderHolder.AddView(title,0,0,outHeaderHolder.Width - cHeight - UISizes.DefaultPadding,cHeight)
	
	'Build Add Button
	btnAdd.Initialize("addHeader")
	btnAdd.Text = "+"
	HelperFunctions.Apply_ViewStyle(btnAdd, Colors.White, ProgramData.COLOR_BUTTON_NORMAL, ProgramData.COLOR_BUTTON_NORMAL, ProgramData.COLOR_BUTTON_PRESSED, ProgramData.COLOR_BUTTON_PRESSED, ProgramData.COLOR_BUTTON_DISABLED, ProgramData.COLOR_BUTTON_DISABLED, 3)
	HelperFunctions.Remove_Padding(btnAdd)
	outHeaderHolder.AddView(btnAdd,title.Left + title.Width + UISizes.DefaultPadding,0,cHeight,cHeight)
	
	inHeaderHolder.Color = ProgramData.COLOR_BUTTON_NORMAL
	
	outHeaderHolder.AddView(inHeaderHolder,0,title.Top + title.Height + UISizes.DefaultPadding,outHeaderHolder.Width,0)
	
	outHeaderHolder.Height = inHeaderHolder.Top + inHeaderHolder.Height + UISizes.DefaultPadding

	
	Return outHeaderHolder.Top + outHeaderHolder.Height + UISizes.DefaultPadding
End Sub

private Sub addHeader_Click
	addHeader("")
End Sub

Private Sub addHeader(value As String)
	Dim edtHeader As EditText
	Dim padding As Int = 1dip
	Dim id As Int = inHeaderHolder.NumberOfViews
	Dim top As Int = id*HFsingleLineHeight+padding*id

	edtHeader.Initialize("")
	edtHeader.SingleLine = True
	edtHeader.Hint = "header"
	edtHeader.TextColor = Colors.Black
	edtHeader.TextSize = ProgramData.TextSize_Large
	edtHeader.Color = Colors.White
	edtHeader.Text = value
	HelperFunctions.Remove_Padding(edtHeader)
	inHeaderHolder.AddView(edtHeader,padding,top+padding,inHeaderHolder.Width - 2*padding,HFsingleLineHeight)
	
	cHeadersList.Add(edtHeader)
	
	inHeaderHolder.Height = edtHeader.Top + edtHeader.Height + padding
	outHeaderHolder.Height = outHeaderHolder.Height + edtHeader.Height + padding
	
	If outDetailesHolder.IsInitialized Then
		outDetailesHolder.Top = outDetailesHolder.Top + edtHeader.Height + padding
	End If
	
	If outTotalsHolder.IsInitialized Then
		outTotalsHolder.Top = outTotalsHolder.Top + edtHeader.Height + padding
	End If
	
	If outFooterHolder.IsInitialized Then
		outFooterHolder.Top = outFooterHolder.Top + edtHeader.Height + padding
	End If
	
	HelperFunctions.FitViewsInScroll(BTSettingsSV)
	BTSettingsSV.ScrollPosition = outHeaderHolder.Top + outHeaderHolder.Height - UISizes.DefaultPadding

End Sub

'Detailes
private Sub GenerateDetails(SV As ScrollView,top As Int) As Int 'ignore
	Dim btnAdd As Button
	Dim title As Label
	
	Dim cHeight As Int = configPanel.Height*0.07
	
	SV.Panel.AddView(outDetailesHolder,0,top,SV.Width,HFHeight)
	
	'Build title
	title.Initialize("")
	title.Text = Main.translate.GetString("lblDetails")
	title.TextSize = ProgramData.TextSize_ExtraLarge
	title.TextColor = Colors.Gray
	title.Gravity = Gravity.CENTER_VERTICAL + Gravity.LEFT
	HelperFunctions.Remove_Padding(title)
	outDetailesHolder.AddView(title,0,0,outDetailesHolder.Width - cHeight - UISizes.DefaultPadding,cHeight)
	
	'Build Add Button
	btnAdd.Initialize("addDetail")
	btnAdd.Text = "+"
	HelperFunctions.Apply_ViewStyle(btnAdd, Colors.White, ProgramData.COLOR_BUTTON_NORMAL, ProgramData.COLOR_BUTTON_NORMAL, ProgramData.COLOR_BUTTON_PRESSED, ProgramData.COLOR_BUTTON_PRESSED, ProgramData.COLOR_BUTTON_DISABLED, ProgramData.COLOR_BUTTON_DISABLED, 3)
	HelperFunctions.Remove_Padding(btnAdd)
	outDetailesHolder.AddView(btnAdd,title.Left + title.Width + UISizes.DefaultPadding,0,cHeight,cHeight)
	
	inDetailesHolder.Color = ProgramData.COLOR_BUTTON_NORMAL
	
	outDetailesHolder.AddView(inDetailesHolder,0,title.Top + title.Height + UISizes.DefaultPadding,outDetailesHolder.Width,0)
	
	outDetailesHolder.Height = inDetailesHolder.Top + inDetailesHolder.Height + UISizes.DefaultPadding

	
	Return outDetailesHolder.Top + outDetailesHolder.Height + UISizes.DefaultPadding
End Sub

private Sub addDetail_Click
	addDetail("")
End Sub

private Sub addDetail(value As String)
	Dim edtDetail As EditText
	Dim padding As Int = 1dip
	Dim id As Int = inDetailesHolder.NumberOfViews
	Dim top As Int = id*HFsingleLineHeight+padding*id

	edtDetail.Initialize("")
	edtDetail.SingleLine = True
	edtDetail.TextColor = Colors.Black
	edtDetail.TextSize = ProgramData.TextSize_Large
	edtDetail.Color = Colors.White
	edtDetail.Text = value
	edtDetail.Hint = "Detail"
	HelperFunctions.Remove_Padding(edtDetail)
	inDetailesHolder.AddView(edtDetail,padding,top+padding,inDetailesHolder.Width - 2*padding,HFsingleLineHeight)
	
	cDetailesList.Add(edtDetail)
	
	inDetailesHolder.Height = edtDetail.Top + edtDetail.Height + padding
	outDetailesHolder.Height = outDetailesHolder.Height + edtDetail.Height + padding
	
	If outTotalsHolder.IsInitialized Then
		outTotalsHolder.Top = outTotalsHolder.Top + edtDetail.Height + padding
	End If
	
	If outFooterHolder.IsInitialized Then
		outFooterHolder.Top = outFooterHolder.Top + edtDetail.Height + padding
	End If
	
	HelperFunctions.FitViewsInScroll(BTSettingsSV)
	BTSettingsSV.ScrollPosition = outDetailesHolder.Top + outDetailesHolder.Height - UISizes.DefaultPadding
End Sub

'Totals
private Sub GenerateTotals(SV As ScrollView,top As Int) As Int 'ignore
	Dim btnAdd As Button
	Dim title As Label
	
	Dim cHeight As Int = configPanel.Height*0.07
	
	SV.Panel.AddView(outTotalsHolder,0,top,SV.Width,HFHeight)
	
	'Build title
	title.Initialize("")
	title.Text = Main.translate.GetString("lblTotals")
	title.TextSize = ProgramData.TextSize_ExtraLarge
	title.TextColor = Colors.Gray
	title.Gravity = Gravity.CENTER_VERTICAL + Gravity.LEFT
	HelperFunctions.Remove_Padding(title)
	outTotalsHolder.AddView(title,0,0,outTotalsHolder.Width - cHeight - UISizes.DefaultPadding,cHeight)
	
	'Build Add Button
	btnAdd.Initialize("addTotals")
	btnAdd.Text = "+"
	HelperFunctions.Apply_ViewStyle(btnAdd, Colors.White, ProgramData.COLOR_BUTTON_NORMAL, ProgramData.COLOR_BUTTON_NORMAL, ProgramData.COLOR_BUTTON_PRESSED, ProgramData.COLOR_BUTTON_PRESSED, ProgramData.COLOR_BUTTON_DISABLED, ProgramData.COLOR_BUTTON_DISABLED, 3)
	HelperFunctions.Remove_Padding(btnAdd)
	outTotalsHolder.AddView(btnAdd,title.Left + title.Width + UISizes.DefaultPadding,0,cHeight,cHeight)
	
	inTotalsHolder.Color = ProgramData.COLOR_BUTTON_NORMAL
	
	outTotalsHolder.AddView(inTotalsHolder,0,title.Top + title.Height + UISizes.DefaultPadding,outTotalsHolder.Width,0)
	
	outTotalsHolder.Height = inTotalsHolder.Top + inTotalsHolder.Height + UISizes.DefaultPadding

	
	Return outTotalsHolder.Top + outTotalsHolder.Height + UISizes.DefaultPadding
End Sub

private Sub addTotals_Click
	addTotals("")
End Sub

private Sub addTotals(value As String)
	Dim edtTotal As EditText
	Dim padding As Int = 1dip
	Dim id As Int = inTotalsHolder.NumberOfViews
	Dim top As Int = id*HFsingleLineHeight+padding*id

	edtTotal.Initialize("")
	edtTotal.SingleLine = True
	edtTotal.TextColor = Colors.Black
	edtTotal.TextSize = ProgramData.TextSize_Large
	edtTotal.Color = Colors.White
	edtTotal.Text = value
	edtTotal.Hint = "Total"
	HelperFunctions.Remove_Padding(edtTotal)
	inTotalsHolder.AddView(edtTotal,padding,top+padding,inTotalsHolder.Width - 2*padding,HFsingleLineHeight)
	
	cTotalsList.Add(edtTotal)
	
	inTotalsHolder.Height = edtTotal.Top + edtTotal.Height + padding
	outTotalsHolder.Height = outTotalsHolder.Height + edtTotal.Height + padding
	
	If outFooterHolder.IsInitialized Then
		outFooterHolder.Top = outFooterHolder.Top + edtTotal.Height + padding
	End If
	
	HelperFunctions.FitViewsInScroll(BTSettingsSV)
	BTSettingsSV.ScrollPosition = outTotalsHolder.Top + outTotalsHolder.Height - UISizes.DefaultPadding
End Sub

'Footer
private Sub GenerateFooter(SV As ScrollView,top As Int) As Int 'ignore
	Dim btnAdd As Button
	Dim title As Label
	
	Dim cHeight As Int = configPanel.Height*0.07
	
	SV.Panel.AddView(outFooterHolder,0,top,SV.Width,HFHeight)
	
	'Build title
	title.Initialize("")
	title.Text = Main.translate.GetString("lblFooters")
	title.TextSize = ProgramData.TextSize_ExtraLarge
	title.TextColor = Colors.Gray
	title.Gravity = Gravity.CENTER_VERTICAL + Gravity.LEFT
	HelperFunctions.Remove_Padding(title)
	outFooterHolder.AddView(title,0,0,outFooterHolder.Width - cHeight - UISizes.DefaultPadding,cHeight)
	
	'Build Add Button
	btnAdd.Initialize("addFooter")
	btnAdd.Text = "+"
	HelperFunctions.Apply_ViewStyle(btnAdd, Colors.White, ProgramData.COLOR_BUTTON_NORMAL, ProgramData.COLOR_BUTTON_NORMAL, ProgramData.COLOR_BUTTON_PRESSED, ProgramData.COLOR_BUTTON_PRESSED, ProgramData.COLOR_BUTTON_DISABLED, ProgramData.COLOR_BUTTON_DISABLED, 3)
	HelperFunctions.Remove_Padding(btnAdd)
	outFooterHolder.AddView(btnAdd,title.Left + title.Width + UISizes.DefaultPadding,0,cHeight,cHeight)
	
	inFooterHolder.Color = ProgramData.COLOR_BUTTON_NORMAL
	
	outFooterHolder.AddView(inFooterHolder,0,title.Top + title.Height + UISizes.DefaultPadding,outFooterHolder.Width,0)
	
	outFooterHolder.Height = inFooterHolder.Top + inFooterHolder.Height + UISizes.DefaultPadding
	
	Return outFooterHolder.Top+outFooterHolder.Height + UISizes.DefaultPadding
End Sub

private Sub addFooter_Click
	addFooter("")
End Sub

private Sub addFooter(value As String)
	Dim edtFooter As EditText
	Dim padding As Int = 1dip
	Dim id As Int = inFooterHolder.NumberOfViews
	Dim top As Int = id*HFsingleLineHeight+padding*id

	edtFooter.Initialize("")
	edtFooter.SingleLine = True
	edtFooter.Hint = "Footer"
	edtFooter.TextColor = Colors.Black
	edtFooter.TextSize = ProgramData.TextSize_Large
	edtFooter.Color = Colors.White
	edtFooter.Text = value
	HelperFunctions.Remove_Padding(edtFooter)
	inFooterHolder.AddView(edtFooter,padding,top+padding,inFooterHolder.Width - 2*padding,HFsingleLineHeight)
	
	cFootersList.Add(edtFooter)
	
	inFooterHolder.Height = edtFooter.Top + edtFooter.Height + padding
	outFooterHolder.Height = outFooterHolder.Height + edtFooter.Height + padding
	
	HelperFunctions.FitViewsInScroll(BTSettingsSV)
	BTSettingsSV.ScrollPosition = outFooterHolder.Top + outFooterHolder.Height - UISizes.DefaultPadding
End Sub
#End Region

Public Sub SavePrinters
	Try
		Dim RAF As RandomAccessFile
		RAF.Initialize(Main.SHAREDFolder, "Printers.config", False)
		RAF.WriteEncryptedObject(masterP.ActivePrinters, ProgramData.rafEncPass, RAF.CurrentPosition)
		RAF.Close
	Catch
		Log(LastException)
		Msgbox(Main.translate.GetString("msgFailedToSavePrinters"), Main.translate.GetString("lblWarning"))
	End Try
	Dim RAF As RandomAccessFile
	RAF.Initialize(Main.SHAREDFolder, "Printers.config", False)
'	Log(RAF.ReadEncryptedObject(ProgramData.rafEncPass, RAF.CurrentPosition))
	RAF.Close

End Sub

