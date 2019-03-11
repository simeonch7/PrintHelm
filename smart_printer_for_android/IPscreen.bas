B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=7.3
@EndOfDesignText@
Private Sub Class_Globals
	Private loginPanel As Panel
	Private appTitle, lblConnection As Label
	Private PrinterIP, PrinterPort As EditText
	Public btnloginPanel As Button
	Public CAD As CustomAlertDialog
	Private settingsBG As BitmapDrawable
	Private BMP_Options As Bitmap
	
	Private ETColorTP As Int = 0xFF87B0EA
	Public SettingsScr As SettingsScreen
End Sub

'Инициализиране на обекта / Initializes the object
Public Sub Initialize
	loginPanel.Initialize("")
	
	appTitle.Initialize("")
	lblConnection.Initialize("isConnect")

	PrinterIP.Initialize("PrinterIPName")
	PrinterPort.Initialize("PrinterPort")
	btnloginPanel.Initialize("ButtonloginPanel")
	BMP_Options.Initialize(File.DirAssets, "settingsIcon.png")


	settingsBG.Initialize(BMP_Options)
	btnloginPanel.Background = settingsBG
	If localNET Then
		StartService(SPAservice)
	Else
		ToastMessageShow("Connect to Internet", False)
	End If
	
End Sub

' Построяване на екрана / Builds the UI of the screen
Public Sub build_Screen(target As Panel)
	loginPanel_Configurations
	Private edtWidth,edtHeight As Int
	Private btnWidth,btnHeight As Int
	Private Padding,left As Int
	target.AddView(loginPanel, 0, 0, 100%x, 100%y)

		Padding = ProgramData.DefaultPadding
		edtWidth = loginPanel.Width*0.7
		edtHeight = loginPanel.Height*0.08
		btnHeight = loginPanel.Height*0.08
		btnWidth = edtWidth/2 - Padding
		left = (loginPanel.Width - edtWidth)/2	
		
	loginPanel.AddView(appTitle, left, loginPanel.Height*(0.1), edtWidth, edtHeight + 2)
	
	loginPanel.AddView(PrinterIP,left, loginPanel.Height*(0.3),edtWidth, edtHeight)
	loginPanel.AddView(PrinterPort, left, PrinterIP.Top+PrinterIP.Height*1.5+Padding, edtWidth, edtHeight)
		
	HelperFunctions.Apply_ViewStyle(PrinterIP,Colors.Black,Colors.Transparent,ETColorTP,Colors.White,Colors.White,Colors.White,Colors.White,10)
	HelperFunctions.Apply_ViewStyle(PrinterPort,Colors.Black,Colors.Transparent,ETColorTP,Colors.White,Colors.White,Colors.White,Colors.White,10)
	PrinterPort.Padding = Array As Int(30,0,30,0)
	PrinterIP.Padding = Array As Int(30,0,30,0)
		
	loginPanel.AddView(lblConnection, left + Padding, PrinterPort.Top + edtHeight * 1.5, btnWidth, btnHeight)
	
	Padding = 7%x
	loginPanel.AddView(btnloginPanel, lblConnection.Left + lblConnection.Width + Padding * 2, lblConnection.Top, btnHeight, btnHeight)
		
	isConnect_Click
End Sub

public Sub Hide
	loginPanel.Visible = False
End Sub

public Sub Show
	loginPanel.Visible = True
End Sub

private Sub localNET As Boolean
	
	Dim ssocket As ServerSocket
	
	Log("<<<<<<<>>>>>>>")
	Log("Ip address: " & ssocket.GetMyWifiIP)
	Log("<<<<<<<>>>>>>>")	
	
	If ssocket.GetMyWifiIP = "127.0.0.1" Then
		PrinterIP.Text = Main.translate.GetString("NolocalNet")  '"Device not connected to local network"
		Return False
	Else
		PrinterIP.Text = ssocket.GetMyWifiIP
		PrinterPort.Text =  SPAservice.port
		Return True
	End If
End Sub

'Прилагане на стилове за външния вид на екрана за влизане / Applying visual styles for loginPanel screen
Private Sub loginPanel_Configurations
	loginPanel.SetBackgroundImage(LoadBitmap(File.DirAssets,"smartBG.jpg"))
	
	appTitle.Text = Main.translate.GetString("title")
	appTitle.TextSize = 20
	appTitle.Typeface = Typeface.DEFAULT_BOLD
	appTitle.Gravity = Gravity.CENTER
	appTitle.TextColor = 0xFF2A96EA
	
	PrinterIP.SingleLine = True

	PrinterPort.SingleLine = True
	PrinterPort.Hint = Main.translate.GetString("hintPort")
	PrinterPort.HintColor = Colors.Gray
	
	btnloginPanel.Gravity = Gravity.CENTER
	btnloginPanel.Background = settingsBG
	
	lblConnection.TextSize = 14
	lblConnection.Gravity = Gravity.CENTER
End Sub

'Метод прехвърлящ фокус между полетата / Changes focus between input fields
Private Sub PrinterPort_FocusChanged (HasFocus As Boolean)
	If HasFocus Then
		PrinterPort.Text=""
	End If
End Sub

'Метода, който вкарва потребителя в системата / Method for log in 
Private Sub ButtonloginPanel_Click
	SettingsScr.Initialize
'	Hide
	SettingsScr.settingsPanel.setlayoutanimated(500, 0, 0, 100%x, 100%y)
	Main.SCREEN_ID = Main.SCREEN_SETTINGS
	btnloginPanel.Enabled = False
End Sub

public Sub goBackToLoginScreen
	Main.SCREEN_ID = Main.SCREEN_LOGIN

	SettingsScr.settingsPanel.setlayoutanimated(500, 0, 100%y, 100%x, 100%y)

	btnloginPanel.Enabled = True
	isConnect_Click
End Sub

Public Sub isConnect_Click
	If localNET Then
		lblConnection.Text = Main.translate.GetString("lblConnection")
		lblConnection.TextColor = Colors.Green
	Else
		lblConnection.Text = Main.translate.GetString("lblNoconnection")
		lblConnection.TextColor = Colors.Red
	End If
End Sub

Public Sub refreshLogin_Labels
	isConnect_Click
	appTitle.Text = Main.translate.GetString("title")
	PrinterPort.Hint = Main.translate.GetString("hintPort")
End Sub

Public Sub asView As Panel
	Return loginPanel
End Sub