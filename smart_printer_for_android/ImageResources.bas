B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=7.3
@EndOfDesignText@
'Code module
Sub Process_Globals
	Public Const BMP_Warning, BMP_SpinnerBack, BMP_InternetConnected, BMP_InternetDisconnected, _
	BMP_Options, BMP_UserCard, BMP_LoginBack, BMP_ExitIcon, BMP_InitialOptions, BMP_ExitProgramX, _
	BMP_LoginUsername, BMP_LoginPassword, BMP_PrinterIcon1, BMP_PrinterIcon2, BMP_PrinterIcon3, _
	BMP_ChekboxBorderBlack, BMP_ChekboxBorderBlack, BMP_ChekboxBorderWhite, BMP_CheckMark, _
	BMP_PrintItemIconError, BMP_PrintItemIconSuccess, BMP_Notes, BMP_Check, BMP_ArrowDelete, _
	BMP_ExitKeyboard, BMP_Coin, BMP_InfoSite, BMP_PartnerPhone , BMP_Notes_Inactive, _
	BMP_Coin_Inactive, BMP_StepLeft, BMP_StepRight, BMP_StepRightShort, BMP_StepLeftShort, _
	BMP_Down, BMP_Up, BMP_Click, BMP_ExtraFunctions, BMP_ResExtraFunc, BMP_RestOrder, _
	BMP_No_Change, BMP_No_ChangePres As Bitmap
End Sub

'Loads images
Public Sub LoadImages
'	BMP_Warning.Initialize(File.DirAssets, "warn_icon.png")
'	BMP_SpinnerBack.Initialize(File.DirAssets, "spinner_background.png")
'	BMP_InternetConnected.Initialize(File.DirAssets, "internet_connected_icon.png")
'	BMP_InternetDisconnected.Initialize(File.DirAssets, "internet_disconnected_icon.png")
'	BMP_Options.Initialize(File.DirAssets, "options_icon.png")
'	BMP_UserCard.Initialize(File.DirAssets, "user_card_icon.png")
'	BMP_LoginBack.Initialize(File.DirAssets, "login_background.jpg")
'	BMP_ExitIcon.Initialize(File.DirAssets, "exit_icon.png")
'	BMP_InitialOptions.Initialize(File.DirAssets, "initial_options_icon.png")
'	BMP_ExitProgramX.Initialize(File.DirAssets, "exit_program_x.png")
'	BMP_LoginUsername.Initialize(File.DirAssets, "login_username_icon.png")
'	BMP_LoginPassword.Initialize(File.DirAssets, "login_password_icon.png")
'	BMP_PrinterIcon1.Initialize(File.DirAssets, "printer_1_icon.png")
'	BMP_PrinterIcon2.Initialize(File.DirAssets, "printer_2_icon.png")
'	BMP_PrinterIcon3.Initialize(File.DirAssets, "printer_3_icon.png")
'	BMP_ChekboxBorderBlack.Initialize(File.DirAssets, "check_border_black.png")
'	BMP_ChekboxBorderWhite.Initialize(File.DirAssets, "check_border_white.png")
'	BMP_CheckMark.Initialize(File.DirAssets, "check_mark_blue.png")
'	BMP_PrintItemIconError.Initialize(File.DirAssets, "print_item_failed_icon.png")
'	BMP_PrintItemIconSuccess.Initialize(File.DirAssets, "print_item_success_icon.png")
'	BMP_Coin.Initialize(File.DirAssets, "coins_icon.png")
'	BMP_Notes.Initialize(File.DirAssets, "papermoney_icon.png")
'	BMP_Check.Initialize(File.DirAssets, "check_icon.png")
'	BMP_ArrowDelete.Initialize(File.DirAssets, "arrow_delete_icon.png")
'	BMP_ExitKeyboard.Initialize(File.DirAssets, "exit_keyboard_icon.png")
'	BMP_Notes_Inactive.Initialize(File.DirAssets, "papermoney_inactive_icon.png")
'	BMP_Coin_Inactive.Initialize(File.DirAssets, "coins_inactive_icon.png")
'	BMP_InfoSite.Initialize(File.DirAssets, "info_site_icon.png")
'	BMP_PartnerPhone.Initialize(File.DirAssets, "partner_phone.png")
'	BMP_StepLeft.Initialize(File.DirAssets, "step1Arrow_icon.png")
'	BMP_StepRight.Initialize(File.DirAssets, "step2Arrow_icon.png")
'	BMP_StepRightShort.Initialize(File.DirAssets, "step3_icon.png")
'	BMP_StepLeftShort.Initialize(File.DirAssets,"step4_icon.png")
'	BMP_Down.Initialize(File.DirAssets, "step5_icon.png")
'	BMP_Up.Initialize(File.DirAssets, "step6_icon.png")
'	BMP_Click.Initialize(File.DirAssets, "click_icon.png")
'	BMP_ExtraFunctions.Initialize(File.DirAssets, "extra_functions.png")
'	BMP_ResExtraFunc.Initialize(File.DirAssets, "RestaurantExtraMenu.png")	
'	BMP_RestOrder.Initialize(File.DirAssets, "rest_order.png")
'	BMP_No_Change.Initialize(File.DirAssets, "icon_noChange.png")
'	BMP_No_ChangePres.Initialize(File.DirAssets, "icon_NoChangePressed.png")
End Sub

'Recycle single bitmap
Public Sub RecycleBitmap(bitmap As Bitmap)
	Dim r As Reflector
	r.Target = bitmap
	r.RunMethod("recycle")
End Sub