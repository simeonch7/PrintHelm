B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=7.3
@EndOfDesignText@
#Event: EventName_Click
Sub Class_Globals
	Private mEventName As String
	Private mCallBack As Object 
	Private mBase As Panel
	Private fakePanel As Panel
	Private notifyWarnings, notifyError, notifyReady As Label
	Private bitmapPrinting1, bitmapPrinting2, bitmapPrinting3, bitmapPressed As Bitmap
	Private timerPrinting As Timer
	Private counter As Int = 0	
	Private countWarning, countErr, countReady As Int	
	Private Const COLOR_ERR As Int = Colors.RGB(146, 1, 0)
	Private Const COLOR_RDY As Int = Colors.RGB(3, 123, 0)
	Private Const COLOR_WRN As Int = Colors.RGB(255, 255, 0)
End Sub

Public Sub Initialize (Callback As Object, EventName As String)
	mEventName = EventName
	mCallBack = Callback
	mBase.Initialize("Base")
	notifyError.Initialize("fakeLabel")
	notifyWarnings.Initialize("fakeLabel")
	notifyReady.Initialize("fakeLabel")
	fakePanel.Initialize("HolderFakeCounterButton")
	timerPrinting.Initialize("printing",200)
End Sub

Public Sub BuildButtonNotifications(parent As Panel)
	parent.AddView(mBase, 0, 0, parent.Width, parent.Height)
	
	Dim controlSide As Int = mBase.Width * 0.3
	bitmapPressed.Initialize(File.DirAssets, "printer_icon_pressed.png")
	
	mBase.SetBackgroundImage(bitmapPressed)
	
	notifyError.TextSize = ProgramData.TextSize_Small
	notifyError.Gravity = Gravity.CENTER
	HelperFunctions.Apply_ViewStyle(notifyError, Colors.White, COLOR_ERR, COLOR_ERR, COLOR_ERR, COLOR_ERR, COLOR_ERR, COLOR_ERR, 20)
	mBase.AddView(notifyError, mBase.Width - controlSide, 0, controlSide, controlSide)
	
	notifyWarnings.TextSize = ProgramData.TextSize_Small
	notifyWarnings.Gravity = Gravity.CENTER
	HelperFunctions.Apply_ViewStyle(notifyWarnings, Colors.White, COLOR_WRN, COLOR_WRN, COLOR_WRN, COLOR_WRN, COLOR_WRN, COLOR_WRN, 20)
	mBase.AddView(notifyWarnings, 0, 0, controlSide, controlSide)
	
	notifyReady.TextSize = ProgramData.TextSize_Small
	notifyReady.Gravity = Gravity.CENTER
	HelperFunctions.Apply_ViewStyle(notifyReady, Colors.White, COLOR_RDY, COLOR_RDY, COLOR_RDY, COLOR_RDY, COLOR_RDY, COLOR_RDY, 20)
	mBase.AddView(notifyReady, mBase.Width - controlSide, mBase.Height - controlSide, controlSide, controlSide)

	ResetCounterButton
End Sub

Private Sub printing_Tick
	Select counter
		Case 0
			counter = 1
			mBase.SetBackgroundImage(bitmapPrinting1)
		Case 1
			counter = 2
			mBase.SetBackgroundImage(bitmapPrinting2)
		Case 2
			counter = 0
			mBase.SetBackgroundImage(bitmapPrinting3)
	End Select
End Sub

Private Sub UpdateStatusCounterButton
	If countReady = 0 Then
		notifyReady.Visible = False
	Else
		notifyReady.Visible = True
		notifyReady.Text = countReady
	End If	
	If countErr = 0 Then
		notifyError.Visible = False
	Else
		notifyError.Visible = True
		notifyError.Text = countErr
	End If	
	If countWarning = 0 Then
		notifyWarnings.Visible = False
	Else
		notifyWarnings.Visible = True
		notifyWarnings.Text = countWarning
	End If
End Sub

Public Sub ResetCounterButton
	countReady = 0
	countErr = 0
	countWarning = 0
	UpdateStatusCounterButton
End Sub

Public Sub showCounterButton
	fakePanel.BringToFront
	fakePanel.Visible = True
	mBase.SetLayoutAnimated(300, fakePanel.Width * 0.85, mBase.Top, mBase.Width, mBase.Height)
End Sub

Public Sub hideCounterButton
	mBase.SetLayoutAnimated(300, fakePanel.Width, mBase.Top, mBase.Width, mBase.Height)
	Sleep(300)
	fakePanel.Visible = False
	StopPrinting
End Sub

Public Sub StopPrinting
	timerPrinting.Enabled = False
End Sub

'Ready
Public Sub IncrementReady
	countReady = countReady + 1
	UpdateStatusCounterButton
End Sub

Public Sub DecrementReady
	countReady = countReady - 1
	If countReady < 0 Then countReady = 0
	UpdateStatusCounterButton
End Sub

'Error
Public Sub increment_Error
	countErr = countErr + 1
	UpdateStatusCounterButton
End Sub

Public Sub decrement_Error
	countErr = countErr - 1
	If countErr < 0 Then countErr = 0
	UpdateStatusCounterButton
End Sub

Private Sub getError_Counter As Int
	Return countErr
End Sub

'Warning
Public Sub IncrementWarning
	countWarning = countWarning + 1
	UpdateStatusCounterButton
End Sub

Public Sub DecrementWarning
	countWarning = countWarning - 1
	If countWarning < 0 Then countWarning = 0
	UpdateStatusCounterButton
End Sub

Private Sub Base_Click
	CallSub(mCallBack, mEventName & "_Click")
End Sub

Private Sub HolderFakeCounterButton_Click	
End Sub