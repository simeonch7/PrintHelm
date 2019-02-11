B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=7.3
@EndOfDesignText@
Private Sub Class_Globals
	Private driverReference As Object
	Private Fiscal As Boolean = False
	
	Private basePanel, head, content,warningContnet, foot As Panel
	Private footNormal,footFiscal As Panel
	Private icon As ImageView
	Private name As Label

	Private Height_Head As Int
	Private Height_Foot As Int
	Private Height_Content As Int
	Private lblHeight As Int 
	
	Private padding As Int = 2dip
	Private CallBackParent As Object 'Ignore 'PrinterStatusScreen
	
	Private headColor As Int = ProgramData.COLOR_HEADER
	Private contentColor As Int = Colors.LightGray
	
	Private Expanded As Boolean = False
	Private printOK As Boolean
	
	Private btnRetry, btnAbort, btnZReport, btnXReport As Button
	Private btnMenu As Button
	
	Private lblStatus As Label
	Private Status As Int
	Private StatusIcon As ImageView
		
	'MesageBox and ListBox
	Private cadAlertDialog As CustomAlertDialog
	Private additionalOptions As List
	
	Private isTest As Boolean
	
	Private internalStatus As Int 
	Private internalSTATUS_ERR As Int = 0
	Private internalSTATUS_NOERR As Int = 1	
End Sub

Public Sub Initialize (pCallBack As Object, printer As TActivePrinter, isFiscal As Boolean, Test As Boolean )
	CallBackParent = pCallBack
	
	Status = PrinterConstants.ERR_NoError
	
	isTest = Test
	Fiscal = isFiscal

	driverReference = printer.driver
	CallSub2(driverReference,"setStatus_Item",Me)
	
	StatusIcon.Initialize("")
	StatusIcon.Gravity = Gravity.FILL
	StatusIcon.Bitmap = ImageResources.BMP_PrintItemIconError
	StatusIcon.Visible = False
	
	basePanel.Initialize("")
	head.Initialize("head")
	content.Initialize("")
	foot.Initialize("")
	warningContnet.Initialize("")
	
	footNormal.Initialize("")
	footFiscal.Initialize("")
	
	icon.Initialize("")
	icon.Bitmap = ImageResources.BMP_PrintItemIconError
	icon.Gravity = Gravity.FILL
	
	name.Initialize("")
	name.TextColor = Colors.White
	name.Gravity = Gravity.CENTER_VERTICAL
	name.Text = printer.name
	
	lblStatus.Initialize("")
	btnXReport.Initialize("ReportAction")
	btnZReport.Initialize("ReportAction")
	btnMenu.Initialize("AditionalActions")
	btnAbort.Initialize("Action")
	btnRetry.Initialize("Action")
	
	fillAdditionalOptions
	
	internalStatus = internalSTATUS_NOERR
End Sub

Private Sub fillAdditionalOptions
	additionalOptions.Initialize
	additionalOptions.Add(Main.translate.GetString("strPayin"))
	additionalOptions.Add(Main.translate.GetString("strPayout"))
End Sub

Public Sub Build(parent As MiScrollView,ParentWidth As Int, ParentHeight As Int)
	
	Height_Head = ParentHeight*0.2
	Height_Foot = ParentHeight*0.15
	lblHeight = ParentHeight*0.08
	Height_Content = Height_Foot + lblHeight
	
	content.Visible = False
	
	head.Color = headColor
	content.Color = contentColor
	
	parent.addView(head,ParentWidth,Height_Head,0,1,0,0)
	parent.addView(content,ParentWidth,Height_Content,0,0,0,0)
	
	content.AddView(foot, 0,lblHeight, content.Width, Height_Foot)
	
	content.AddView(warningContnet,0,lblHeight,content.Width,0)
	
	lblStatus.Text = PrinterConstants.getPrinterStatusMessage(Status)
	lblStatus.TextColor = Colors.Black
	lblStatus.TextSize = ProgramData.TextSize_Small
	lblStatus.Gravity = Gravity.CENTER_VERTICAL
	content.AddView(lblStatus,0,0,content.Width,lblHeight)
	
	Dim iconPadding As Int = padding*3
	Dim iconSize As Int = head.Height -2*iconPadding
	head.AddView(icon, iconPadding, iconPadding,iconSize, iconSize)
	head.AddView(name, (icon.Left + icon.Width) + iconPadding, 0, head.Width - head.Height, head.Height)
	head.AddView(StatusIcon,head.Width-iconSize,iconPadding,iconSize,iconSize)
	
	btnRetry.Text = Main.translate.GetString("strRetry")
	btnRetry.Tag = PrinterConstants.Action_Retry
	HelperFunctions.setButtonStyle(btnRetry)
	HelperFunctions.Remove_Padding(btnRetry)
			
	btnAbort.Text = Main.translate.GetString("strAbort")
	btnAbort.Tag = PrinterConstants.Action_Abort
	HelperFunctions.setButtonStyle(btnAbort)
	HelperFunctions.Remove_Padding(btnAbort)

	btnXReport.Text = Main.translate.GetString("strXReport")
	btnXReport.Tag = Constants.rpt_XReport
	HelperFunctions.setButtonStyle(btnXReport)
	HelperFunctions.Remove_Padding(btnXReport)

	btnZReport.Text = Main.translate.GetString("strZReport")
	btnZReport.Tag = Constants.rpt_ZReport
	HelperFunctions.setButtonStyle(btnZReport)
	HelperFunctions.Remove_Padding(btnZReport)
	
	btnMenu.Text = "..."
	HelperFunctions.setButtonStyle(btnMenu)
	HelperFunctions.Remove_Padding(btnMenu)
	
	HelperFunctions.Remove_Padding(foot)
	
	Dim btnMenuWidth As Int = foot.Width * 0.2
	Dim btnFiscalWidth As Int = (foot.Width - padding - btnMenuWidth)/2
	
	foot.AddView(footNormal,0,0,foot.Width,foot.Height)
	foot.AddView(footFiscal,0,0,foot.Width,foot.Height)	

	footNormal.AddView(btnRetry,0,0,footNormal.Width * 0.6,foot.Height)
	footNormal.AddView(btnAbort,btnRetry.Width+padding,0,footNormal.Width * 0.4, foot.Height)
	
	footFiscal.Visible = False
	footFiscal.AddView(btnZReport,0,0,btnFiscalWidth,footFiscal.Height)
	footFiscal.AddView(btnXReport,btnFiscalWidth+padding,0,btnFiscalWidth,footFiscal.Height)
	footFiscal.AddView(btnMenu,btnXReport.Left + btnXReport.Width + padding,0,btnMenuWidth,footFiscal.Height)
	
	changeStatus(PrinterConstants.ERR_NoError)
	FoldView
End Sub

Public Sub AddWarning(warning As Int)
	Dim lblWarning As Label
	lblWarning.Initialize("")
	lblWarning.TextSize = ProgramData.TextSize_Small
	lblWarning.Text = PrinterConstants.getPrinterStatusMessage(warning)
	lblWarning.TextColor = Colors.Black
	lblWarning.Gravity = Gravity.CENTER_VERTICAL
	
	Dim top As Int = warningContnet.NumberOfViews * (lblHeight + padding)
	warningContnet.AddView(lblWarning,0,top,warningContnet.Width,lblHeight)
	warningContnet.Height = warningContnet.Height + lblHeight
	
	calculateItemHeight 	 	
End Sub

Public Sub getUserAction(error As Int) As ResumableSub
	If isTest Then
		ToastMessageShow(PrinterConstants.getPrinterStatusMessage(error),False)
		Return PrinterConstants.Action_Abort
	End If
	changeStatus(error)

	Wait For Action_Click
	Dim btn As Button = Sender
	
	Select btn.Tag
		Case PrinterConstants.Action_Retry 	: changeStatus(PrinterConstants.Printing)
		Case Else 							: changeStatus(PrinterConstants.ERR_NoError)
	End Select
	
	Return btn.Tag
End Sub

Private Sub ReportAction_Click
	Dim btn As Button = Sender
	changeStatus(PrinterConstants.Printing)
	
	Dim jobReport As TPrnJobReport
	jobReport.Initialize
	jobReport.ReportType = btn.tag
	jobReport.ParamFrom = ""
	jobReport.ParamTo = ""
	CallSub2(driverReference, "AddJob", jobReport)
	CallSubDelayed(driverReference, "doJobs")
End Sub

Private Sub AditionalActions_Click
	cadAlertDialog.display_InputList(additionalOptions, True, -1, Main.translate.GetString("strAdditionalPrinterOptions"))
End Sub

Private Sub InputList_Checked(option As String, optionId As Int)
'	CallSub2(Main,"show_KeyboardForPrinterOption",Array As Object(name.Text,option,Me))
	wait For KeyboardAcceptClick_Printer(input As String)

	If input = 0 Then Return
	Dim job As TPrnJobPayInOut
	job.PaySum = input
	
	Select optionId 
		Case 0 
			job.PayType = 1	'Внасяне
		Case 1
			job.PayType = 2	'Изплащане
	End Select
	
	CallSub2(driverReference,"AddJob",job)
	CallSubDelayed(driverReference,"doJobs")
End Sub

' Метод променящ иконата на принтера в Принтерното меню.
Private Sub CheckStatus(SuccessfulPri As Boolean)
	If SuccessfulPri Then
		icon.Bitmap = ImageResources.BMP_PrintItemIconSuccess
	Else
		icon.Bitmap = ImageResources.BMP_PrintItemIconError
	End If
End Sub


Private Sub head_Click
	calculateItemHeight
	If Expanded Then
		FoldView
		Expanded = False
		'Използва се метод за задаване на иконата, за да бъде статусът и динамично обновяван
		CheckStatus(printOK)
	Else
		ExpandView
		Expanded = True
		icon.Bitmap = ImageResources.BMP_PrinterIcon1
		Sleep(80)
		icon.Bitmap = ImageResources.BMP_PrinterIcon2
		Sleep(120)
		icon.Bitmap = ImageResources.BMP_PrinterIcon3		
		Sleep(50)
		CheckStatus(printOK)
	End If
	Sleep(0)
End Sub

Private Sub FoldView
	content.Height = 0
	content.Visible = False
End Sub

Private Sub ExpandView
	content.Visible = True
	content.Height = Height_Content
End Sub

Public Sub changeStatus(PrinterStatus As Int)	
	If isTest Then
		 ToastMessageShow(PrinterConstants.getPrinterStatusMessage(Status),False) 
		 Return
	End If	
	
	If PrinterStatus = PrinterConstants.Printing Then
		If internalStatus = internalSTATUS_ERR Then
			decrementError
			internalStatus = internalSTATUS_NOERR
		End If
		StatusIcon.Visible = False
		printOK = True
	End If
		
	If PrinterStatus = PrinterConstants.ERR_NoError Then 'No Error
		If internalStatus = internalSTATUS_ERR Then
			decrementError
			internalStatus = internalSTATUS_NOERR			
		End If
		icon.Bitmap = ImageResources.BMP_PrintItemIconSuccess
		StatusIcon.Bitmap = ImageResources.BMP_PrintItemIconSuccess
		StatusIcon.Visible = False
		printOK = True
		
	End If
		
	If PrinterStatus >= PrinterConstants.ERR_FirstError And PrinterStatus < PrinterConstants.ERR_FirstResumableError  Then	'Error
		If internalStatus = internalSTATUS_NOERR Then
			incrementError
			
			internalStatus = internalSTATUS_ERR
		End If
		icon.Bitmap = ImageResources.BMP_PrintItemIconError
		StatusIcon.Visible = False
		printOK = False
	End If
		
	If PrinterStatus >= PrinterConstants.ERR_FirstResumableError And PrinterStatus < PrinterConstants.WRN_FirstWarning Then	'Resumable Error
		If internalStatus = internalSTATUS_NOERR Then
			incrementError
			internalStatus = internalSTATUS_ERR
		End If
		icon.Bitmap = ImageResources.BMP_PrintItemIconError
		StatusIcon.Visible = False
		printOK = False
	End If
	
	If PrinterStatus >= PrinterConstants.WRN_FirstWarning Then	'Warnings
		printOK = True
	End If
	
	Status = PrinterStatus
	swapFoot(printOK)
	lblStatus.Text = PrinterConstants.getPrinterStatusMessage(Status)
	calculateItemHeight
	content.Height = Height_Content
End Sub

Private Sub swapFoot(printSuccess As Boolean)
	
	If printSuccess Then 
		If Fiscal And Status = PrinterConstants.ERR_NoError Then 
			foot.Visible = True
			footFiscal.Visible = True
			footNormal.Visible = False
		Else
			foot.Visible = False
		End If
		
	Else
		foot.Visible = True
		footFiscal.Visible = False
		footNormal.Visible = True
	End If
End Sub

private Sub incrementError
	If SubExists(CallBackParent,"increment_Error") Then _
			CallSub(CallBackParent,"increment_Error")
End Sub

private Sub decrementError
	If SubExists(CallBackParent,"decrement_Error") Then _
			CallSub(CallBackParent,"decrement_Error")
End Sub

Private Sub calculateItemHeight
	Height_Content = lblHeight + warningContnet.Height
	If foot.Visible Then Height_Content = Height_Content + Height_Foot
	warningContnet.Top = lblHeight
	foot.Top = warningContnet.Top+warningContnet.Height
End Sub

Public Sub removeView
	head.RemoveAllViews
	head.RemoveView
	content.RemoveAllViews
	content.RemoveView
End Sub