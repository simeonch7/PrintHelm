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
	Public urlResponse As String
	Dim su As StringUtils
	Dim PrintHandler As HandlePrint
	
End Sub

Sub Service_Create
	server.Initialize("Server")
	server.Start(port)
	PrintHandler.Initialize("")
	
	Private n As Notification
	n.Initialize
	n.Icon = "icon"
	n.SetInfo("Http Server is running", "", Main)
	Service.StartForeground(1, n)
'	port = ProgramData.devicePort
End Sub

Sub Service_Start (StartingIntent As Intent)
	
End Sub

Sub Server_HandleRequest (Request As ServletRequest, response As ServletResponse)
	Try
		Log("Client: " & Request.RemoteAddress)
'		Log("-----"&Request.RequestURI) 'handle the request based on the URL
		
		urlResponse = su.DecodeUrl(Request.RequestURI, "UTF8").SubString(12)
		Log("--->"&urlResponse)

		ProgramData.req = urlResponse
		If Not (PrintHandler.IsInitialized) Then PrintHandler.Initialize("")
		PrintHandler.POS_Print(urlResponse)
'		CallSub(Main, "readytoPrint")
	Catch
		response.Status = 500
		Log("Error serving request: " & LastException)
		response.SendString("Error serving request: " & LastException)
	End Try
End Sub

Sub Service_TaskRemoved
	'This event will be raised when the user removes the app from the recent apps list.
End Sub

'Return true to allow the OS default exceptions handler to handle the uncaught exception.
Sub Application_Error (Error As Exception, StackTrace As String) As Boolean
	Return True
End Sub

Sub Service_Destroy

End Sub

'Sub HandleMainPage (response As ServletResponse)
'
'	Log("---------------------------"&response)
'	
'	response.SetContentType("text/xml")
'End Sub

