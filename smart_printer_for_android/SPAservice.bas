B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Service
Version=8.3
@EndOfDesignText@
 #Region  Service Attributes 
	#StartAtBoot: False
#End Region

Sub Process_Globals
	Private server As HttpServer
	Public port As Int = 8000
	Public r As String
	Public IDPRef As Int
End Sub

Sub Service_Create
	server.Initialize("Server")
	server.Start(port)
	Private n As Notification
	n.Initialize
	n.Icon = "icon"
	n.SetInfo("Http Server is running", "", Main)
	Service.StartForeground(1, n)
'	port = ProgramData.devicePort
End Sub

Sub Service_Start (StartingIntent As Intent)
	
End Sub

Sub Server_HandleRequest (Request As ServletRequest, Response As ServletResponse)
	Try
		Log("Client: " & Request.RemoteAddress)
		Log("-----"&Request.RequestURI) 'handle the request based on the URL

		ProgramData.req = Request.RequestURI
		
		CallSub(Main, "readytoPrint")
	Catch
		Response.Status = 500
		Log("Error serving request: " & LastException)
		Response.SendString("Error serving request: " & LastException)
	End Try
End Sub

Sub HandleMainPage (Response As ServletResponse)

	Log("---------------------------"&Response)
	
	Response.SetContentType("text/xml")
End Sub
