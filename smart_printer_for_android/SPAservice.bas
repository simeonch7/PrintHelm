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
	Public activityIsStarted As Boolean
End Sub

Sub Service_Create
	server.Initialize("Server")
	server.Start(port)
	Private n As Notification
	n.Initialize
	n.Icon = "icon"
	n.SetInfo("Http Server is running", "", Main)
	Service.StartForeground(1, n)
End Sub

Sub Service_Start (StartingIntent As Intent)
	
End Sub

Sub Server_HandleRequest (Request As ServletRequest, response As ServletResponse)
	Try
		
		urlResponse = su.DecodeUrl(Request.RequestURI, "UTF8")
		urlResponse = urlResponse.Replace("/postMessage", "")
		
		Log("<<<<<<<>>>>>>>")
		Log("Client: " & Request.RemoteAddress)
		Log("--->"&urlResponse)
		Log("<<<<<<<>>>>>>>")
		
		If urlResponse.StartsWith("<") Then
			
			ProgramData.req = urlResponse	
			
			If IsPaused(Main) Then
				CallSubDelayed(Main, "readytoprint")
		
				StartActivity(Main)	
			Else
			
				CallSub(Main, "readytoprint")
				
			End If
				
		End If
		
	Catch
		response.Status = 500
		Log("Error serving request: " & LastException)
		response.SendString("Error serving request: " & LastException)
	End Try
End Sub

