B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=7.3
@EndOfDesignText@
'Code module Program Data
Private Sub Process_Globals
	Public strUser As String = ""
	Public strPass As String = ""
	Public rafEncPass As Int = 6380						'Парола за RAF файл
	Public sameUser As Boolean


	'Размер на текст
	Public DefaultFont As Int = 14
	
	Public finalScore As Double
	
	Public HeaderHeight, FooterHeight, LeftPart,GroupScroller, ButtonLeft, settingsWidth, initSettingsWidth, _
	keyboardWidth, GroupButtonHeight, DefaultFont, HeaderLabelHeight, FooterLabelHeight, DefaultPadding, _
	PressedTextColor As Int	
	Public GroupColor_Normal, GroupColor_Pressed As String
	
	Public strPrinterIP As String
	Public strPrinterPort As String
	
	Public samePrinterIP As Boolean
	Public samePrinterPort As Boolean
	
	'Дефиниране на 4те вида плащания
	Public Const PAYMENT_CASH As Int = 1
	Public Const PAYMENT_BANK As Int = 2
	Public Const PAYMENT_CARD As Int = 3
	Public Const PAYMENT_TALN As Int = 4
	
	'Цветове
	Public COLOR_UIHOLDER_LEFT As Int = 0xFFF4F4F4
	Public COLOR_UIHOLDER_RIGHT As Int = 0xFFFFFFFF
	Public COLOR_UIGROUP_SCROLLER As Int = 0xFFEAEAEA
	Public COLOR_HEADER As Int = 0xFF0068A0
	Public COLOR_FOOTOR As Int = 0xFFFFFFFF'0xFF19ABFF
	Public COLOR_BUTTON_NORMAL As Int = 0xFF0580C7
	Public COLOR_BUTTON_PRESSED As Int = 0xFF38B6FF
	Public COLOR_BUTTON_DISABLED As Int = 0xFF38B6FF
	Public COLOR_BUTTON_TEXTCOLOR As Int = 0xFFFFFFFF 'White
	Public COLOR_BUTTON_Gray As Int = 0xFFEDF0F2 'Gray
	Public BUTTON_ROUNDING As Int = 0
	
	'Размер на текст
	Public DefaultFont As Int = 14
	Public Tile_Small As Int
	Public Tile_Large As Int
	Public TextSize_ExtraLarge As Int
	Public TextSize_Large As Int
	Public TextSize_Small As Int
	Public TextSize_Huge As Int

	Public CurrentCompany As Company
	Public CurrentUser As CurrentUser
	

	Public LastOperations As Operation
	
	Public PartnersMap As Map
	Public ObjectsMap As Map

	Public partnerPhone As String
	Public strLastOperation As String

	Public selectedPartnerID As Int = 0
	Public selectedObjectID As Int

	Public req As String
'	Public devicePort As Int
End Sub

'Инициализиране на обекта / Initializes the object
Public Sub Initialize
	DefaultFont = 16
	initSettingsWidth = 70%x
	keyboardWidth = 100%x
	HeaderHeight = 8%y
	FooterHeight = 5%y
	GroupScroller = 15%x
	DefaultPadding = 1%x
	LeftPart = 100%x
	settingsWidth = 80%x
	GroupButtonHeight = 64dip
	GroupColor_Normal = 0xFF19ABFF
	GroupColor_Pressed = Colors.White
'	GroupColor_Pressed = HelperFunctions.Clr("0D5E89")
	PressedTextColor = Colors.Black
	ButtonLeft = 5%x
End Sub



