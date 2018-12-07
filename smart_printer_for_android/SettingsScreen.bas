B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=8.3
@EndOfDesignText@
Sub Class_Globals
	Dim settingsPanel As Panel
	Dim country, language, printer, serialPort, speed, codeTable  As Spinner
	Dim IPport, IPaddress, operator, password As EditText
	Dim LabelCountry, LabelLanguage, LabelPrinter, LabelPortorIPaddress, LabelSpeedorIPport, LabelCodeTable, LabelOperator, LabelPassword As Label
'	Dim prMain As PrinterMain
	Dim printersAdd As List
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
	
	LabelCountry.Initialize("countryLabel")
	LabelLanguage.Initialize("languageLabel")
	LabelPrinter.Initialize("deviceLabel")
	LabelPortorIPaddress.Initialize("serialPortLabel")
	LabelSpeedorIPport.Initialize("speedLabel")
	LabelCodeTable.Initialize("codeTableLabel")
	LabelOperator.Initialize("opertorLabel")
	LabelPassword.Initialize("passwordLabel")
	
	Countries.Initialize
	
	ColorPickerAndLabelTexts
	
	SettingsUI
	
	addData
	
	settingsPanel.Enabled = False
	settingsPanel.Visible = False
'	printerSpinnferFill
End Sub

'Sub printerSpinnferFill
'	
'	printersAdd = CallSub("getPrintersList", prMain)
'End Sub

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

Private Sub addData 
	For Each m As String In Countries.getCountries
		printersAdd.Add(m)
	Next
	
	
	country.AddAll(printersAdd)
End Sub

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
