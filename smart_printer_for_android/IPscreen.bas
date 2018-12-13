B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=7.3
@EndOfDesignText@
Private Sub Class_Globals
	Private raf As RandomAccessFile
	Private loginPanel As Panel
	Private appTitle, lblConnection As Label
	Private PrinterIP, PrinterPort As EditText
	Public btnloginPanel As Button
	Public CAD As CustomAlertDialog
	Private usrString, PrinterPortString As String
	Private settingsBG As BitmapDrawable
	Private BMP_Options As Bitmap
End Sub

'Инициализиране на обекта / Initializes the object
Public Sub Initialize
	appTitle.Initialize("")
	lblConnection.Initialize("isConnect")
	loginPanel.Initialize("loginPanelPanelsFake")
	PrinterIP.Initialize("PrinterIPName")
	PrinterPort.Initialize("PrinterPort")
	btnloginPanel.Initialize("ButtonloginPanel")
	BMP_Options.Initialize(File.DirAssets, "options_icon.png")

	settingsBG.Initialize(BMP_Options)
	btnloginPanel.Background = settingsBG
	If checkNet Then
		StartService(SPAservice)
	Else
		ToastMessageShow("Connect to Internet", False)
	End If
	
	
End Sub

' Построяване на екрана / Builds the UI of the screen
Public Sub build_Screen
	loginPanel_Configurations
	Private edtWidth,edtHeight As Int
	Private btnWidth,btnHeight As Int
	Private Padding,left As Int
	

		Padding = ProgramData.DefaultPadding
		edtWidth = loginPanel.Width*0.7
		edtHeight = loginPanel.Height*0.08
		btnHeight = loginPanel.Height*0.08
		btnWidth = edtWidth/2 - Padding
		left = (loginPanel.Width - edtWidth)/2	
		
	loginPanel.AddView(appTitle, left, loginPanel.Height*(0.1), edtWidth, edtHeight + 2)
	
	loginPanel.AddView(PrinterIP,left, loginPanel.Height*(0.3),edtWidth, edtHeight)
	loginPanel.AddView(PrinterPort, left, PrinterIP.Top+PrinterIP.Height*1.5+Padding, edtWidth, edtHeight)
		
	loginPanel.AddView(lblConnection, left + Padding, PrinterPort.Top + edtHeight * 1.5, btnWidth, btnHeight)
	Padding = 7%x
	loginPanel.AddView(btnloginPanel, lblConnection.Left + lblConnection.Width + Padding, lblConnection.Top, btnWidth / 2, btnHeight)


isConnect_Click
	
'	btnloginPanel.Enabled=True
End Sub

'Прилагане на стилове за външния вид на екрана за влизане / Applying visual styles for loginPanel screen
Private Sub loginPanel_Configurations
	loginPanel.SetBackgroundImage(LoadBitmap(File.DirAssets,"login_background.jpg"))
	
	appTitle.Text = Main.translate.GetString("title")
	appTitle.TextSize = 20
	appTitle.Typeface = Typeface.DEFAULT_BOLD
	appTitle.Gravity = Gravity.CENTER
	appTitle.TextColor = Colors.White
		
	HelperFunctions.Apply_ViewStyle(PrinterIP,Colors.Black,Colors.White,Colors.White,Colors.White,Colors.White,Colors.White,Colors.White,60)
	PrinterIP.Padding = Array As Int(15,0,0,0)
	PrinterIP.SingleLine = True

	Dim ssocket As ServerSocket
	Log("Ip address: " & ssocket.GetMyWifiIP)
	If ssocket.GetMyWifiIP = "127.0.0.1" Then
		PrinterIP.Text = Main.translate.GetString("NolocalNet")  '"Device not connected to local network"
	Else
		PrinterIP.Text = ssocket.GetMyWifiIP
		PrinterPort.Text =  SPAservice.port
		PrinterPort.Enabled = False
	End If


	HelperFunctions.Apply_ViewStyle(PrinterPort,Colors.Black,Colors.White,Colors.White,Colors.White,Colors.White,Colors.White,Colors.White,60)
	PrinterPort.Padding = Array As Int(15,0,0,0)
	PrinterPort.SingleLine = True
	PrinterPort.Hint = Main.translate.GetString("hintPort")
	PrinterPort.HintColor = Colors.Gray
	
	btnloginPanel.Gravity = Gravity.CENTER
	btnloginPanel.Background = settingsBG
	
	lblConnection.TextSize = 14
	lblConnection.Gravity = Gravity.CENTER
	checkNet
End Sub

'Метод прехвърлящ фокус между полетата / Changes focus between input fields
Private Sub PrinterPort_FocusChanged (HasFocus As Boolean)
	If HasFocus Then
		PrinterPort.Text=""
	End If
End Sub

'Метода, който вкарва потребителя в системата / Method for log in 
Private Sub ButtonloginPanel_Click
	CallSub(Main, "changePanels")	
End Sub

Public Sub isConnect_Click
	If checkNet Then
		lblConnection.Text = Main.translate.GetString("lblConnection")
		lblConnection.TextColor = Colors.Green
	Else
		lblConnection.Text = Main.translate.GetString("lblNoconnection")
		lblConnection.TextColor = Colors.Red
		ToastMessageShow("No Internet Connection", False)
	End If
End Sub

Public Sub checkNet As Boolean
	Dim p As Phone
	Dim Response, Error As StringBuilder
	Response.Initialize
	Error.Initialize
	'Ping Google DNS - if you can't reach this you are in serious trouble!
	p.Shell("ping -c 1 8.8.8.8",Null,Response,Error)
	Log("======= Response ========")
	Log(Response)
	Log("======= Error ===========")
	Log(Error)
	Log("======================")

	Dim ssocket As ServerSocket
	Log("Ip address: " & ssocket.GetMyWifiIP)
	If ssocket.GetMyWifiIP = "127.0.0.1" Then
		PrinterIP.Text = Main.translate.GetString("NolocalNet")  '"Device not connected to local network"
	Else
		PrinterIP.Text = ssocket.GetMyWifiIP
		PrinterPort.Text =  SPAservice.port
	End If


	If Error.ToString="" Then
		Return True
       
	Else
		Return False
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