B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=7.3
@EndOfDesignText@
'Code module Program Data
Private Sub Process_Globals
	Public rafEncPass As Int = 6380						'Парола за RAF файл
	
	Public FooterHeight, DefaultPadding As Int	
	Public GroupColor_Normal, GroupColor_Pressed As String
	
	'Дефиниране на 4те вида плащания
	Public Const PAYMENT_CASH As Int = 1
	Public Const PAYMENT_BANK As Int = 2
	Public Const PAYMENT_CARD As Int = 3
	Public Const PAYMENT_TALN As Int = 4
	
	'Цветове
	Public COLOR_HEADER As Int = 0xFF0068A0
	Public COLOR_BUTTON_NORMAL As Int = 0xFF0580C7
	Public COLOR_BUTTON_PRESSED As Int = 0xFF38B6FF
	Public COLOR_BUTTON_DISABLED As Int = 0xFF38B6FF
	Public BUTTON_ROUNDING As Int = 0
	
	'Размер на текст
	Public TextSize_ExtraLarge As Int = 16
	Public TextSize_Large As Int = 14
	Public TextSize_Small As Int = 12

	Public CurrentCompany As Company
	Public CurrentUser As CurrentUser

	Public PartnersMap As Map
	Public ObjectsMap As Map
	Public GroupItemsMat As Map
	
	Public PartnersBulstatMap As Map
	Public PartnersCardNumberMap, PartnersPhoneNumberMap As Map


	Public partnerPhone As String

	Public selectedPartnerID As Int
	Public selectedObjectID As Int

	Public req As String
'	Public devicePort As Int
End Sub

'Инициализиране на обекта / Initializes the object
Public Sub Initialize
	FooterHeight = 5%y
	DefaultPadding = 1%x
	GroupColor_Normal = 0xFF19ABFF
	GroupColor_Pressed = Colors.White
	
	PartnersMap.Initialize
	ObjectsMap.Initialize
	CurrentCompany.Initialize
	CurrentUser.Initialize

	PartnersBulstatMap.Initialize
	PartnersCardNumberMap.Initialize
	PartnersPhoneNumberMap.Initialize
	GroupItemsMat.Initialize

End Sub



