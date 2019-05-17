B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=7.3
@EndOfDesignText@
'Code module
Sub Process_Globals
	Public Const bitmapPressed, settingsBG, edtbtnBG, addbtnBG, removebtnBG, BMP_SpinnerBack,background, BMP_PrinterIcon1, BMP_PrinterIcon2, BMP_PrinterIcon3, BMP_PrintItemIconError, BMP_PrintItemIconSuccess, BMP_PrintItemIconPressed As Bitmap
End Sub

'Loads images
Public Sub LoadImages
	background.Initialize(File.DirAssets, "smartBG.jpg")
	BMP_SpinnerBack.Initialize(File.DirAssets, "spinner_background.png")
	BMP_PrinterIcon1.Initialize(File.DirAssets, "printer_1_icon.png")
	BMP_PrinterIcon2.Initialize(File.DirAssets, "printer_2_icon.png")
	BMP_PrinterIcon3.Initialize(File.DirAssets, "printer_3_icon.png")
	BMP_PrintItemIconSuccess.Initialize(File.DirAssets, "print_item_success_icon.png")
	BMP_PrintItemIconPressed.Initialize(File.DirAssets, "printer_icon_pressed.png")
	BMP_PrintItemIconError.Initialize(File.DirAssets, "print_item_failed_icon.png")
	edtbtnBG.Initialize(File.DirAssets, "edit.png")
	settingsBG.Initialize(File.DirAssets, "settingsIcon.png")
	bitmapPressed.Initialize(File.DirAssets, "printer_icon_pressed.png")
End Sub