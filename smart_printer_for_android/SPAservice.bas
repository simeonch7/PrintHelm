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
	Private templates As SaxParser
'	Private su As StringUtils
	Public port As Int = 8000
End Sub

Sub Service_Create
	server.Initialize("Server")
	server.Start(port)
	templates.Initialize
	Dim n As Notification
	n.Initialize
	n.Icon = "icon"
	n.SetInfo("Http Server is running", "", Main)
	Service.StartForeground(1, n)
	
End Sub

Sub Service_Start (StartingIntent As Intent)
	
End Sub

Sub Server_HandleRequest (Request As ServletRequest, Response As ServletResponse)
	Try
		Log("Client: " & Request.RemoteAddress)
		Log(Request.RequestURI) 'handle the request based on the URL
'		Select True
'			Case Request.RequestURI = "/"
'				HandleMainPage (Response)
'			Case Else
'				'send a file as a response (this section is enough in order to host a site)
'				SetContentType(Request.RequestURI, Response)
'				Response.SendFile(File.DirAssets, DecodePath(Request.RequestURI.SubString(1)))
'		End Select
		Private param As String

		Request.GetParameter(param)
	Catch
		Response.Status = 500
		Log("Error serving request: " & LastException)
		Response.SendString("Error serving request: " & LastException)
	End Try
End Sub

'Sub HandleMainPage (Response As ServletResponse)
'	
'End Sub
'
'Sub HandleUpload (Request As ServletRequest, Response As ServletResponse)
'
'End Sub
'
'Sub HandleList(Request As ServletRequest, Response As ServletResponse)
'
'End Sub
'
'Sub EncodePath(P As String) As String
'	Return su.EncodeUrl(P, "UTF8")
'End Sub
'
'Sub DecodePath(S As String) As String
'	Return su.DecodeUrl(S, "UTF8")
'End Sub
'
'Sub GetTemplate(Name As String) As String
'
'End Sub
'
'Sub SetContentType(FileName As String, Response As ServletResponse)
'	Response.SetContentType("text/xml")
'End Sub
'

'Sub Service_Destroy
'	server.Stop
'	Service.StopForeground(1)
'End Sub
