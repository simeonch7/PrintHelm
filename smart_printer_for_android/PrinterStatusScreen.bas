B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=7.3
@EndOfDesignText@
Private Sub Class_Globals
	Private darkBG,BG As Panel
	Private outerHolder As Panel
	Private holder As Panel
	Private lblTitle As Label
	Private separator1,separator2 As Panel
	Private btnClose As Button
	Private posScreenRef,callback As Object 'Ignore callback = printermain
	
	Private fiscalDevices As List

	Private aPrinterMap As Map

	Private SVPrinters As PrinterStatusSVItems
	
'	Public floatingButton As ButtonWithNotifications
	
'	Private showLeft, hideLeft As Int
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(CB As Object,PosScreen As Object) 'Ignore
	callback = CB
	posScreenRef = PosScreen
	aPrinterMap.Initialize
	fiscalDevices.Initialize
	
	BG.Initialize("BG")
	darkBG.Initialize("BG")
	holder.Initialize("holderFake")
	lblTitle.Initialize("Title")

	btnClose.Initialize("Close")

	outerHolder.Initialize("holderFake")
	separator1.Initialize("holderFake")
	separator2.Initialize("holderFake")
	
'	floatingButton.Initialize(Me,"FloatingButton")
End Sub

Public Sub BuildScreen(Parent As Panel,buttonHolder As Panel)
'	floatingButton.BuildButtonNotifications(buttonHolder)
	
	BG.Visible = False
	
	Dim padding As Int = 1dip
	Dim oPadding As Int = 6
	
	Parent.AddView(BG,0,0,Parent.Width,Parent.Height)
	
	BG.AddView(darkBG,0,0,BG.Width,BG.Height)
	
	darkBG.Color = Colors.ARGB(190,64,64,64)
	separator1.Color = ProgramData.COLOR_HEADER
	separator2.Color = ProgramData.COLOR_HEADER
	HelperFunctions.Apply_ViewStyle(outerHolder,Colors.White,ProgramData.COLOR_HEADER,ProgramData.COLOR_HEADER,ProgramData.COLOR_HEADER,ProgramData.COLOR_HEADER,ProgramData.COLOR_HEADER,ProgramData.COLOR_HEADER,6)
	HelperFunctions.Apply_ViewStyle(holder,Colors.White,Colors.White,Colors.White,Colors.White,Colors.White,Colors.White,Colors.White,6)

	If Main.ScreenOrientation = Main.orientationPortrait Then 'Portrait
		BG.AddView(outerHolder,0,0,BG.Width,BG.Height*0.5)
	Else								'landscape
		BG.AddView(outerHolder,BG.Width*0.5,0,BG.Width*0.5,BG.Height)
	End If
	
'	showLeft = outerHolder.Left
'	hideLeft = BG.Width
	
	outerHolder.AddView(holder,oPadding*padding,oPadding*padding,outerHolder.Width-2*oPadding*padding,outerHolder.Height-2*oPadding*padding)
	
	lblTitle.Text = Main.translate.GetString("msgPrintingStatusTitle")
	lblTitle.TextColor = Colors.Black
	lblTitle.Gravity = Gravity.CENTER
	holder.AddView(lblTitle,0,0,holder.Width,holder.Height*0.1)
	
	holder.AddView(separator1,0,lblTitle.Top+lblTitle.Height+padding,holder.Width,padding*2)
	Dim svParent As Panel
	svParent.Initialize("")
	holder.AddView(svParent,padding,separator1.Height+separator1.Top+2*padding,holder.Width-2*padding,holder.Height-lblTitle.Height-separator1.Height-holder.Height*0.1)
	SVPrinters.Initialize(Me,callback)
	SVPrinters.BuildScreen(svParent)
	
	holder.AddView(separator2,0,svParent.Top+svParent.Height+padding,holder.Width,padding*2)
	
'	hide_Screen
End Sub

public Sub AddPrinter(printer As TActivePrinter)
	SVPrinters.AddPrinter(printer)
End Sub

public Sub RemovePrinter(index As Int)
	SVPrinters.RemovePrinter(index)
End Sub

'Public Sub decrement_Error
'	floatingButton.decrement_Error
'End Sub
'
'Public Sub increment_Error
'	floatingButton.increment_Error
'End Sub
'
'Private Sub decrement_Warning
'	floatingButton.DecrementWarning
'End Sub
'
'Private Sub decrement_Ready
'	floatingButton.DecrementReady
'End Sub
'
'Private Sub increment_Warning
'	floatingButton.IncrementWarning
'End Sub
'
'Private Sub increment_Ready
'	floatingButton.IncrementReady
'End Sub

'Private Sub show_Screen
'	BG.BringToFront
'	BG.SetVisibleAnimated(Settings.AnimationTime, True)
'	outerHolder.SetLayoutAnimated(Settings.AnimationTime, showLeft,outerHolder.Top, outerHolder.Width, outerHolder.Height)
'	BG.BringToFront
'	CallSub2(Main,"SetPrinterStatus_Reference",Me)	'Set main screen reference to this screen
'End Sub

'Public Sub hide_Screen
'	BG.SetVisibleAnimated(Settings.AnimationTime,False)
'	outerHolder.SetLayoutAnimated(Settings.AnimationTime, hideLeft, outerHolder.Top, outerHolder.Width, outerHolder.Height)
'End Sub

Private Sub holderFake_Click
	
End Sub

'Private Sub Close_click
'	hide_Screen
'End Sub
'
'Private Sub BG_Click
'	hide_Screen
'End Sub

'Public Sub Show
'	floatingButton.showCounterButton
'End Sub

Private Sub FloatingButton_Click
'	CallSubDelayed(Main, "Hide_Keyboard")
'	CallSubDelayed(posScreenRef, "footer_GoToInitialPage")
'	show_Screen
End Sub