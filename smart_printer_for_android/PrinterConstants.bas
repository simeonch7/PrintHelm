B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=7.3
@EndOfDesignText@
Private Sub Process_Globals
	'User action
	Public Const Action_Retry As Int = 1
	Public Const Action_Abort As Int = 2
	
	Public Const Printing As Int = -1
	Public Const ERR_NoError As Int = 0
	
	'Errors
	Public Const ERR_FirstError As Int = 1
	Public Const ERR_NoCommunication As Int = 2
	Public Const ERR_InvalidCommand As Int = 3
	Public Const ERR_MoneyInsufficiency As Int = 4
	Public Const ERR_NoDisplay As Int = 5
	Public Const ERR_NeedZReport As Int = 6
	Public Const ERR_InvalidPassword As Int = 7
	
	'Resumable Errors
	Public Const ERR_FirstResumableError As Int = 100
	Public Const ERR_TimeOut As Int = 101
	Public Const ERR_NoPaper As Int = 102
	Public Const ERR_CoverOpen As Int = 103
	
	'Warnings
	Public Const WRN_FirstWarning As Int = 200
	Public Const WRN_PaperNearEnd As Int = 201
	Public Const WRN_FiscalMemoryNearLimit As Int = 202
	Public Const WRN_InvalidDateTime As Int = 203
	
	'CommandSet
	Type CommandSet(Counter As String, Cutter As String, ServiceChargePercent As String, FontSizeINC As String, FontSizeDEC As String,	FontBoldON As String, FontBoldOFF As String, FontItalicON As String, FontItalicOFF As String, KickDrawer As String)
	Public cmdSet_ESC_POS_0 As CommandSet
	Public cmdSet_ESC_POS_1 As CommandSet
	Public cmdSet_ESC_POS_2 As CommandSet
	Public cmdSet_ESC_POS_3 As CommandSet
	
	Public Const ESC_POS_0 As Int = 0		'Command Set 3
	Public Const ESC_POS_1 As Int = 1		'Command Set 1
	Public Const ESC_POS_2 As Int = 2		'Command Set 2
	Public Const ESC_POS_3 As Int = 3		'Command Set 3
End Sub

'Получава текст на съобщенията в зависмост от вида на грешката/предупреждението
Public Sub getPrinterStatusMessage(status As Int) As String
	Select status
		Case Printing					: Return Main.translate.GetString("msgPrinting")
		
		Case ERR_NoError				: Return Main.translate.GetString("msgReady")
	
			'Errors
		Case ERR_NoCommunication		: Return Main.translate.GetString("msgConnectionError")
		Case ERR_InvalidCommand 		: Return Main.translate.GetString("msgInvalidCommand")
		Case ERR_MoneyInsufficiency 	: Return Main.translate.GetString("msgMoneyInsufficiency")
		Case ERR_NoDisplay 				: Return Main.translate.GetString("msgNoDisplay")
		Case ERR_NeedZReport 			: Return Main.translate.GetString("msgNeedZReport")
		Case ERR_InvalidPassword		: Return Main.translate.GetString("msgInvalidPassword")
			
			'Resumable Errors
		Case ERR_TimeOut  				: Return Main.translate.GetString("msgTimeout")
		Case ERR_NoPaper  				: Return Main.translate.GetString("msgNoPaper")
		Case ERR_CoverOpen 				: Return Main.translate.GetString("msgCoverOpen")
	
			'Warnings
		Case WRN_PaperNearEnd 			: Return Main.translate.GetString("msgPaperNearEnd")
		Case WRN_FiscalMemoryNearLimit	: Return Main.translate.GetString("msgFiscalMemoryNearLimit")
		Case WRN_InvalidDateTime		: Return Main.translate.GetString("msgInvalidDate")
		Case Else 						: Return Main.translate.GetString("msgErrorNotFound")
	End Select
End Sub

Public Sub initCommandSets
	Dim ESC As String = Chr(0x1B)
'	Dim FS As String = Chr(0x1C)
	Dim GS As String = Chr(0x1D)
		
	'EPSON Style
	cmdSet_ESC_POS_1.Initialize
	cmdSet_ESC_POS_1.Counter = ""
	cmdSet_ESC_POS_1.Cutter = ESC & "i"
	cmdSet_ESC_POS_1.ServiceChargePercent = ""
	cmdSet_ESC_POS_1.FontSizeINC = GS & Chr(0x21) & Chr(0x11)
	cmdSet_ESC_POS_1.FontSizeDEC = GS & Chr(0x21) & Chr(0x00)
	cmdSet_ESC_POS_1.FontBoldON = ESC & "E1"
	cmdSet_ESC_POS_1.FontBoldOFF = ESC & "E0"
	cmdSet_ESC_POS_1.FontItalicON = ESC & "-" & Chr(0x01)
	cmdSet_ESC_POS_1.FontItalicOFF = ESC & "-" & Chr(0x00)
	cmdSet_ESC_POS_1.KickDrawer = ESC & "p" & Chr(0x00) & Chr(0x80) & Chr(0xF0) & ESC & "p" & Chr(0x01) & Chr(0x80) & Chr(0xF0)
	
	'Alternative Stype
	cmdSet_ESC_POS_2.Initialize
	cmdSet_ESC_POS_2.Counter = ""
	cmdSet_ESC_POS_2.Cutter = GS & "V" & Chr(0x00)
	cmdSet_ESC_POS_2.ServiceChargePercent = ""
	cmdSet_ESC_POS_2.FontSizeINC = ESC &  "!" & Chr(0x30)
	cmdSet_ESC_POS_2.FontSizeDEC = ESC &  "!" & Chr(0x00)
	cmdSet_ESC_POS_2.FontBoldON = ESC & "E1" & ESC & "G1"
	cmdSet_ESC_POS_2.FontBoldOFF = ESC & "E0" & ESC & "G0"
	cmdSet_ESC_POS_2.FontItalicON = ESC & "-" & Chr(0x01)
	cmdSet_ESC_POS_2.FontItalicOFF = ESC & "-" & Chr(0x00)
	cmdSet_ESC_POS_2.KickDrawer = ESC & "p" & Chr(0x00) & Chr(0x80) & Chr(0xF0) & ESC & "p" & Chr(0x01) & Chr(0x80) & Chr(0xF0)
	
	'STAR Style
	cmdSet_ESC_POS_3.Initialize
	cmdSet_ESC_POS_3.Counter = ""
	cmdSet_ESC_POS_3.Cutter = ESC & "d" & Chr(0x01)
	cmdSet_ESC_POS_3.ServiceChargePercent = ""
	cmdSet_ESC_POS_3.FontSizeINC = Chr(0x1D) &  Chr(0x21) & Chr(0x11)
	cmdSet_ESC_POS_3.FontSizeDEC = Chr(0x1D) &  Chr(0x21) & Chr(0x00)
	cmdSet_ESC_POS_3.FontBoldON = Chr(0x1B) & "E1"
	cmdSet_ESC_POS_3.FontBoldOFF = Chr(0x1B) & "E0"
	cmdSet_ESC_POS_3.FontItalicON = ESC & "-" & Chr(0x01)
	cmdSet_ESC_POS_3.FontItalicOFF = ESC & "-" & Chr(0x00)
	cmdSet_ESC_POS_3.KickDrawer = ESC & Chr(0x07) & Chr(0x20) & Chr(0x20)
	
	'NO Style
	cmdSet_ESC_POS_0.Initialize
	cmdSet_ESC_POS_0.Counter = "" '"<counter>"
	cmdSet_ESC_POS_0.Cutter = "" '"<cutter>"
	cmdSet_ESC_POS_0.ServiceChargePercent = "" '"<servicechargepercent>"
	cmdSet_ESC_POS_0.FontSizeINC = "" '"<fontsizeinc>"
	cmdSet_ESC_POS_0.FontSizeDEC = "" '"<fontsizedec>"
	cmdSet_ESC_POS_0.FontBoldON = "" '"<fontboldon>"
	cmdSet_ESC_POS_0.FontBoldOFF = "" '"<fontboldoff>"
	cmdSet_ESC_POS_0.FontItalicON = "" '"<Fontitalicon>"
	cmdSet_ESC_POS_0.FontItalicOFF = "" '"<Fontitalicoff>"
	cmdSet_ESC_POS_0.KickDrawer = "" '"<kickdrawer>"
End Sub

'Изпраща се скрипт в човешки вид с команди в него, в зависимост от множеството CommandSet се поставят правилните скриптови команди за намерения скрипт
Public Sub ESCScript(Data As String, CommandSet As Int) As String
Dim Script As String
	
	Script = "<FontBoldOn>"
	Select Case CommandSet
		Case ESC_POS_1: Data = Utilities.Replace(Data, Script, Chr(0x1b) & "E1" & Chr(0x1b) & "G1")
		Case ESC_POS_2:
		Case ESC_POS_3:			
	End Select
	
	Script = "<FontBoldOff>"
	Select Case CommandSet
		Case ESC_POS_1: Data = Utilities.Replace(Data, Script, Chr(0x1b) & "E0" & Chr(0x1b) & "G0")
		Case ESC_POS_2:
		Case ESC_POS_3:
	End Select
	
	Return Data
End Sub