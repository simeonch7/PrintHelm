B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=7.3
@EndOfDesignText@
Sub Process_Globals
	Private Alignment As Int
	Private CONST ALIGN_LEFT As Int = 0
	Private CONST ALIGN_RIGHT As Int = 1
	Private CONST ALIGN_CENTER As Int = 2
	Private CONST ALIGN_STRETCH As Int = 3
	
	Private const JOB_EAN13 As Int = 1
	Private const JOB_BARCODE As Int = 2
	Private const JOB_BARCODE39 As Int = 3
	Private const JOB_DOCINFO As Int = 4
	Private const JOB_DELAY As Int = 5
End Sub

#Region Pre Processing
'Return map that contains
'index 0 - key = "script", value = List<String> ScriptLines
'index 1 - key = "jobs", value = List<Objects> Jobs
Public Sub RunPreProcessing(Script As List, lineChars As Int) As Map
	Dim result As Map
	result.Initialize
	
	Dim scripts As List
	scripts.Initialize
	
	Dim jobs As List
	jobs.Initialize
	
	'Go through every script tag and make it lower case
	Dim matcher1 As Matcher
	For i = 0 To Script.Size - 1
		
		Dim isJob As Boolean = False
		Dim line As String= Script.Get(i)
		
		'Use matcher to go through every tag
		matcher1 = Regex.Matcher("<\w+>", Script.Get(i))
		Do While matcher1.Find = True
			Dim current As String = matcher1.Match
			line = line.Replace(current, current.ToLowerCase)
			
			'First check if tag is Job
			Dim obj As Object = ReplacePreProcJobs(line)
			If Not(obj Is Boolean) Then
				isJob = True
				jobs.Add(obj)
			Else
				line = ReplacePreProcScript(line, lineChars) 	'if tag is not Job replace all tags
			End If
		Loop
		
		If Not(isJob) Then scripts.Add(line)
	Next
	
	result.Put("script", scripts)
	result.Put("jobs", jobs)
	
	Return result
End Sub

Private Sub ReplacePreProcScript(line As String, lineChars As Int) As String
	Dim tempObj As StoreObject = ProgramData.ObjectsMap.get(ProgramData.selectedObjectID)
	Dim tempPartner As Partner = ProgramData.PartnersMap.Get(ProgramData.selectedPartnerID)

	Select True
		'CurrentUser / Operator
		Case line.Contains( "<operator>") 			: line = line.Replace("<operator>", ProgramData.CurrentUser.Name)
		Case line.Contains( "<operatorcode>") 		: line = line.Replace("<operatorcode>", "OperatorCode")
		Case line.Contains( "<operatorgroup>") 		: line = line.Replace("<operatorgroup>", ProgramData.CurrentUser.GroupName)
			
			'CurrentCompany
		Case line.Contains( "<phone>") 	 			: line = line.Replace("<phone>", ProgramData.CurrentUser.phone)
		Case line.Contains( "<address>")  			: line = line.Replace("<address>", ProgramData.CurrentCompany.Address)
		Case line.Contains( "<company>") 			: line = line.Replace("<company>", ProgramData.CurrentCompany.CompanyName)
		Case line.Contains( "<inn>") 	 			: line = line.Replace("<inn>", ProgramData.CurrentCompany.Inn)
		Case line.Contains( "<taxno>") 	 			: line = line.Replace("<taxno>", ProgramData.CurrentCompany.Taxno)
			
			'CurrentObject
		Case line.Contains( "<objectname>") 		: line = line.Replace("<objectname>", "")
		Case line.Contains( "<objectaddress>") 		: line = line.Replace("<objectaddress>", tempObj.storeAddress)
		Case line.Contains( "<object>") 			: line = line.Replace("<object>", tempObj.storeName)
		Case line.Contains( "<objectcode>") 		: line = line.Replace("<objectcode>", tempObj.storeCode)
		Case line.Contains( "<objectgroup>") 		: line = line.Replace("<objectgroup>", "")
			
			'Partner
		Case line.Contains( "<partner>") 			: line = line.Replace("<partner>", tempPartner.companyName)
		Case line.Contains( "<partnermol>") 		: line = line.Replace("<partnermol>", tempPartner.mol)
		Case line.Contains( "<partnervatid>") 		: line = line.Replace("<partnervatid>", "")
		Case line.Contains( "<partnertaxid>") 		: line = line.Replace("<partnertaxid>", "")
		Case line.Contains( "<partneraddress>") 	: line = line.Replace("<partneraddress>", tempPartner.Address)
		Case line.Contains( "<partnerphone>") 		: line = line.Replace("<partnerphone>", tempPartner.phone)
		Case line.Contains( "<partnerbalance>") 	: line = line.Replace("<partnerbalance>", "")
		Case line.Contains( "<partnercardnumber>") 	: line = line.Replace("<partnercardnumber>", tempPartner.cardNumber)
		Case line.Contains( "<partnercode>") 		: line = line.Replace("<partnercode>", tempPartner.partnerCode)
		Case line.Contains( "<partnerpaymentdays>") : line = line.Replace("<partnerpaymentdays>", " ")
		Case line.Contains( "<partnerdiscount>") 	: line = line.Replace("<partnerdiscount>", tempPartner.discount)
		Case line.Contains( "<partnergroup>") 		: line = line.Replace("<partnergroup>", " ")
		Case line.Contains( "<partnerduty>") 		: line = line.Replace("<partnerduty>", " ")
		Case line.Contains( "<partnernote1>") 		: line = line.Replace("<partnernote1>", " ")
		Case line.Contains( "<partnernote2>") 		: line = line.Replace("<partnernote2>", " ")
			
			'DateTime
		Case line.Contains( "<date>") 				: line = line.Replace("<date>", GetCurrentDate)
		Case line.Contains( "<time>") 				: line = line.Replace("<time>", GetCurrentTime)
		Case line.Contains( "<datetime>") 			: line = line.Replace("<datetime>", GetCurrentDate & " " & GetCurrentTime)
			
			'Tables TO-DO
		Case line.Contains( "<table>") 				: line = line.Replace("<table>", "Number of table")
		Case line.Contains( "<tablecode>") 			: line = line.Replace("<tablecode>", "Code of table")
		Case line.Contains( "<tablegroup>") 		: line = line.Replace("<tablegroup>", "Table group")
			
			'CurrentCompanyInfo
		Case line.Contains( "<owner>") 				: line = line.Replace("<owner>", ProgramData.CurrentUser.Name)
		Case line.Contains( "<ownermol>") 			: line = line.Replace("<ownermol>", ProgramData.CurrentCompany.ContactPerson)
		Case line.Contains( "<ownervatid>") 		: line = line.Replace("<ownervatid>", ProgramData.CurrentCompany.TaxNo)
		Case line.Contains( "<ownertaxid>") 		: line = line.Replace("<ownertaxid>", ProgramData.CurrentCompany.INN)
		Case line.Contains( "<owneraddress>") 		: line = line.Replace("<owneraddress>", ProgramData.CurrentCompany.Address)
		Case line.Contains( "<ownerphone>") 		: line = line.Replace("<ownerphone>", ProgramData.CurrentCompany.Phone)
		Case line.Contains( "<ownercode>") 			: line = line.Replace("<ownercode>", " ")
		Case line.Contains( "<ownernote1>") 		: line = line.Replace("<ownernote1>", " ")
		Case line.Contains( "<ownernote2>") 		: line = line.Replace("<ownernote2>", " ")
			
		Case line.Contains( "<usercode>") 			: line = line.Replace("<usercode>", " ")
		Case line.Contains( "<usergroup>") 			: line = line.Replace("<usergroup>", " ")
		Case line.Contains( "<invoicecaption>") 	: line = line.Replace("<invoicecaption>", " ")
		Case line.Contains( "<invoiceoriginal>") 	: line = line.Replace("<invoiceoriginal>", " ")
		Case line.Contains( "<invoicedate>") 		: line = line.Replace("<invoicedate>", " ")
		Case line.Contains( "<invoicenumber>") 		: line = line.Replace("<invoicenumber>", " ")
		Case line.Contains( "<invoicecomposer>") 	: line = line.Replace("<invoicecomposer>", " ")
		Case line.Contains( "<invoicerecipient>") 	: line = line.Replace("<invoicerecipient>", " ")
		Case line.Contains( "<invoicerecipientegn>") : line = line.Replace("<invoicerecipientegn>", " ")
		Case line.Contains( "<discount>") 			: line = line.Replace("<discount>", " ")
		Case line.Contains( "<invoicedealplace>") 	: line = line.Replace("<invoicedealplace>", " ")
		Case line.Contains( "<discountpercent>") 	: line = line.Replace("<discountpercent>", " ")
			
		Case line.Contains( "<totalqtty>") 			: line = line.Replace("<totalqtty>", " ")
		Case line.Contains( "<document>") 			: line = line.Replace("<document>", ProgramData.LastOperations.ID)
	
		Case line.Contains( "<guests>") 			: line = line.Replace("<guests>", " ")
		Case line.Contains( "<empty>") 				: line = EmptyLine(line, lineChars)	'"Empty line")
		Case line.Contains( "<esc>") 				: line = line.Replace("<esc>", Chr(27))
		Case line.Contains( "<gs>") 				: line = line.Replace("<gs>",  Chr(29))
		Case line.Contains( "<beep>") 				: line = line.Replace("<beep>", Chr(7))
		Case line.Contains( "<File>MyFile.txt") 	: line = line.Replace("<File>MyFile.txt", "Send file to printer")
		Case line.Contains( "<Random>MyFile.txt") 	: line = line.Replace("<Random>MyFile.txt", "Send 1 row from file to printer")
		Case line.Contains( "<backspace>") 			: line = line.Replace("<backspace>", Chr(8))
		Case line.Contains( "<tab>") 				: line = line.Replace("<tab>", Chr(9))
			
		Case line.Contains( "<limitl20>") 			: line = line.Replace("<limitl20>", "Left limit 20 symbols")
		Case line.Contains( "<limitr30>") 			: line = line.Replace("<limitr30>", "Right limit 30 symbols")
		Case line.Contains( "<limitc40>") 			: line = line.Replace("<limitc40>", "Center limit 40 symbols")
		Case line.Contains( "<chr00>") 				: line = line.Replace("<chr00>", Chr(0))
		Case line.Contains( "<chr01>") 				: line = line.Replace("<chr01>", Chr(1))
		Case line.Contains( "<chrfe>") 				: line = line.Replace("<chrfe>", Chr(254))
		Case line.Contains( "<chrff>") 				: line = line.Replace("<chrff>", Chr(255))
		Case line.Contains( "<farewell>") 			: line = line.Replace("<farewell>", "msgFareWell")
			
			'Tag based calculations and actions
		Case line.Contains( "<calc>") 				: line = CalculateSimple(line) 		'"Simple math operations INT")
		Case line.Contains( "<calcqtty>") 			: line = CalculateQuantity(line)	'"Round to 0.000")
		Case line.Contains( "<format0>") 			: line = FormatExpression(line, 0) 	'"Round to int")
		Case line.Contains( "<format0.0>")			: line = FormatExpression(line, 1) 	'"Round to 0.0")
		Case line.Contains( "<format0.00>") 		: line = FormatExpression(line, 2) 	'"Round to 0.00")
		Case line.Contains( "<format0.000>") 		: line = FormatExpression(line, 3) 	'"Round to 0.000")
		Case line.Contains( "<format0.0000>") 		: line = FormatExpression(line, 4) 	'"Round to 0.0000")
		Case line.Contains( "<format0.00000>") 		: line = FormatExpression(line, 5) 	'"Round to 0.00000")
		Case line.Contains( "<format0.000000>") 	: line = FormatExpression(line, 6) 	'"Round to 0.000000")
			
		Case line.Contains( "<symbol>") 			: line = RepeatSymbolToEnd(line, lineChars) 	'"Repeat symbol for the row")
		Case line.Contains( "<note>") 				: line = line.Replace("<note>", "Note")
		Case line.Contains( "<freetext>") 			: line = line.Replace("<freetextfreetext>", "Free Text")
		Case line.Contains( "<exec>") 				: line = line.Replace("<exec>", "Execute/Start external file or app")
		Case line.Contains( "<null>") 				: line = line.Replace("<null>", "Place string end")
		Case line.Contains( "<ordercount") 			: line = line.Replace("<ordercount>", "Uniquie counter of mid(междинна) order")
		Case line.Contains( "<sdcddate>") 			: line = line.Replace("<sdcddate>", "Date of print from SDC device")
		Case line.Contains( "<sdctime>") 			: line = line.Replace("<sdctime>", "SDCTime")
		Case line.Contains( "<sdcinternaldate>") 	: line = line.Replace("<sdcinternaldate>", "SDCInternalDate")
		Case line.Contains( "<sdcreceiptnumber>") 	: line = line.Replace("<sdcreceiptnumber>", "SDCReceiptNumber")
		Case line.Contains( "<sdcreceiptsignature>") : line = line.Replace("<sdcreceiptsignature>", "SDCReceiptSignature")
		Case line.Contains( "<sdcid>") 				: line = line.Replace("<sdcid>", "Serial number of device")
		Case line.Contains( "<sdcmrc>") 			: line = line.Replace("<sdcmrc>", "Machine registration code")
		Case line.Contains( "<sdctin>") 			: line = line.Replace("<sdctin>", "Tax indentification number")
		Case line.Contains( "<towords>") 			: line = line.Replace("<towords>", "Prints numbers to words")
	End Select
	Return line

End Sub

Private Sub ReplacePreProcJobs(line As String) As Object
	Select True
		Case line.Contains( "<delay>") 				
			 line = line.Replace("<delay>", "")
			 
			If Regex.IsMatch("(\d+)",line) Then
				Return ReturnJob(line,JOB_DELAY)
			End If
			 
		Case line.Contains( "<ean13>") 				
			 line = line.Replace("<ean13>", "")
				
		   	 Return ReturnJob(line,JOB_EAN13)
			 
		Case line.Contains( "<barcode>") 				
			 line = line.Replace("<barcode>", "")
			 
			Return ReturnJob(line,JOB_BARCODE)
			 
		Case line.Contains( "<barcode39>") 			
			 line = line.Replace("<barcode39>", "")
			
			Return ReturnJob(line,JOB_BARCODE39)
			
		Case line.Contains( "<docinfo>")
			 line = line.Replace("<docinfo>", "")
			
			Return ReturnJob(line,JOB_DOCINFO)
	End Select
	
	Return False
End Sub

'Returns numbers for barcodes / Връща цифрите за баркодове.
Private Sub ReturnJob (line As String, jobType As Int) As Object
	Select jobType
		Case JOB_EAN13 
			Dim jobEAN As TPrnJobPrintBarcode
			jobEAN.Initialize
			jobEAN.Barcode = line'ReturnBarcodeValue(line,JOB_EAN13)
			
			Return jobEAN
			
		Case JOB_BARCODE
			Dim jobBARCODE As TPrnJobPrintBarcode
			jobBARCODE.Initialize
			jobBARCODE.Barcode = line'ReturnBarcodeValue(line,JOB_BARCODE)
			
			Return jobBARCODE
			
		Case JOB_BARCODE39
			Dim jobBARCODE39 As TPrnJobPrintBarcode
			jobBARCODE39.Initialize
			jobBARCODE39.Barcode = line'ReturnBarcodeValue(line,JOB_BARCODE39)
			
			Return jobBARCODE39
			
		Case JOB_DOCINFO
			Dim jobDOCINFO As TPrnJobPrintBarcode
			jobDOCINFO.Initialize
			jobDOCINFO.Barcode = line'ReturnBarcodeValue(line,JOB_DOCINFO)
			
			Return jobDOCINFO
			
		Case JOB_DELAY
			Dim jobDelay As TPrnJobDelay
			jobDelay.Initialize
			jobDelay.time = line
				
			Return jobDelay
	End Select
	
	Return Null
End Sub
	
#End Region

#region Post Processing
Public Sub RunPostProcessing(Script As List, lineChars As Int,commandSet As Int) As List
	Dim cmdSet As CommandSet = getCmdSet(commandSet)
	
	Dim scripts As List
	scripts.Initialize
	
'	Go through every line
	For i = 0 To Script.Size - 1
		Dim line As String= Script.Get(i)						'Get the line
		line = PostProcessingSingleLine(line, cmdSet, lineChars)	'Process the line
		scripts.Add(line)										'Add new line in list
	Next

	Return scripts												'Return list with lines
End Sub

'Process single line
private Sub PostProcessingSingleLine(line As String, cmdSet As CommandSet, lineChars As Int) As String
	Dim commands As List
	commands.Initialize
	
	Dim matcher1 As Matcher
	matcher1 = Regex.Matcher("<\w+>", line)
		
	'For each tag found, make it to lower case and replace
	Do While matcher1.Find = True
		Dim current As String = matcher1.Match
		line = line.Replace(current, current.ToLowerCase)
		
		'Get the command if exists and save it in temp list
		Dim cmd As String=  getCommandFromScript(current, cmdSet)
		If cmd <> -1 Then
			line = line.Replace(current,"")
			commands.Add(cmd)
		End If
	Loop
		
	line = setSingleLineAlignment(line,lineChars)	'Set the alignment
		
	'Put back commands to the line
	'Cons: max 2 command per line
	'if there is 1 command 	 : command + line
	'if there are 2 commands : firstCommand + line + secondCommand
	If commands.Size > 1 Then
		Dim cmdBegin As String = commands.Get(0)
		Dim cmdEnd As String = commands.Get(1)
		line = cmdBegin & line & cmdEnd
		
	Else if commands.Size = 1 Then
		Dim cmdBegin As String = commands.Get(0)
		line = cmdBegin & line
	End If
	
	Return line
End Sub

'Replace tags with commands
Private Sub getCommandFromScript(tag As String, cmdSet As CommandSet) As String
	Dim cmd As String = "-1"
	Select True
		'Font Size
		Case tag.Contains("<fontsizeinc>") 	 : cmd = cmdSet.FontSizeINC
		Case tag.Contains("<fontsizedec>") 	 : cmd = cmdSet.FontSizeDEC

		'Font Bold
		Case tag.Contains("<fontboldon>") 	 : cmd = cmdSet.FontBoldON
		Case tag.Contains("<fontboldoff>") 	 : cmd = cmdSet.FontBoldOFF

		'Font Italic
		Case tag.Contains("<Fontitalicon>")  : cmd = cmdSet.FontItalicON
		Case tag.Contains("<Fontitalicoff>") : cmd = cmdSet.FontItalicOFF

		'General
		Case tag.Contains("<cutter>") 		 : cmd = cmdSet.Cutter
		Case tag.Contains("<kickdrawer>") 	 : cmd = cmdSet.KickDrawer
		Case tag.Contains("<counter>") 		 : cmd = cmdSet.Counter
	End Select
	
	Return cmd
End Sub
#End Region

#Region Total Scripts
Public Sub RunTotalScript(Details As List, lineChars As Int, priceCalc As PrinterPriceCalculator, commandSet As Int) As List
	'Get current CommandSet. Used for PreProcessing scripts
	Dim cmdSet As CommandSet = getCmdSet(commandSet)
	
	Dim scripts As List
	scripts.Initialize

	'Go through every script tag and make it lower case
	Dim matcher1 As Matcher
	For i = 0 To Details.Size - 1
		Dim line As String= Details.Get(i)
		matcher1 = Regex.Matcher("<\w+>", Details.Get(i))
	
		'For each tag found, make it to lower case and replace
		Do While matcher1.Find = True
			Dim current As String = matcher1.Match
			line = line.Replace(current, current.ToLowerCase)	'To lower case
			line = ReplacePreProcScript(line, lineChars)		'Pre Processing
			line = ReplaceTotalScripts(line, priceCalc)			'Total Scripts Processing
		Loop
		
		'Tag <payments> is a special case, becouse there can be more the one payment
		If line.Contains("<payments>") Or line.Contains("<paymentscaption>") Then 
			For Each payJob As TPrnJobFiscalPayment In priceCalc.payments.Values
				Dim tempLine As String = line
				
				If tempLine.Contains("<payments>") Then tempLine = tempLine.Replace("<payments>",NumberFormat2(payJob.PaySum,1,2,2,False))
				If tempLine.Contains("<paymentscaption>") Then 
					Select payJob.PayType
						Case ProgramData.PAYMENT_CASH : tempLine = tempLine.Replace("<paymentscaption>",Main.translate.getString("PaymentCash"))
						Case ProgramData.PAYMENT_BANK : tempLine = tempLine.Replace("<paymentscaption>",Main.translate.getString("PaymentBank"))
						Case ProgramData.PAYMENT_CARD : tempLine = tempLine.Replace("<paymentscaption>",Main.translate.getString("PaymentCard"))
						Case ProgramData.PAYMENT_TALN : tempLine = tempLine.Replace("<paymentscaption>",Main.translate.getString("PaymentVoucher"))
					End Select
				End If
				tempLine = PostProcessingSingleLine(tempLine, cmdSet, lineChars)			'Post Processing
				
				scripts.Add(tempLine)
			Next
		Else
			
			line = PostProcessingSingleLine(line, cmdSet, lineChars)			'Post Processing
			
			'Add the script line to final list
			scripts.Add(line)
		End If
	Next
	
	'Run alignment replacement and return list with final values
	Return scripts
End Sub

Private Sub ReplaceTotalScripts(line As String, priceCalc As PrinterPriceCalculator) As String
	Select True
		Case line.Contains( "<total>") 				: line = line.Replace("<total>", NumberFormat2(priceCalc.getTotal,1,2,2,False))
		Case line.Contains( "<totalcaption>") 		: line = line.Replace("<totalcaption>", Main.translate.GetString("msgTotal"))
		Case line.Contains( "<totalnet>") 			: line = line.Replace("<totalnet>", " ")
		Case line.Contains( "<totalcaptionnet>") 	: line = line.Replace("<totalcaptionnet>", " ")
		Case line.Contains( "<totalfull>") 			: line = line.Replace("<totalfull>", " ")
		Case line.Contains( "<totalnetfull>") 		: line = line.Replace("<totalnetfull>", " ")
		Case line.Contains( "<totaldiscount>") 		: line = line.Replace("<totaldiscount>", " ")
		Case line.Contains( "<totalnetdiscount>") 	: line = line.Replace("<totalnetdiscount>", " ")
		Case line.Contains( "<totaldiscountpercent>")	: line = line.Replace("<totaldiscountpercent>", " ")
		Case line.Contains( "<change>") 			: line = line.Replace("<change>", NumberFormat2(priceCalc.getChange,1,2,2,False))
		Case line.Contains( "<changecaption>") 		: line = line.Replace("<changecaption>", Main.translate.GetString("msgChange"))
		Case line.Contains( "<vatcaption>") 		: line = line.Replace("<vatcaption>", " ")
		Case line.Contains( "<vatcode>") 			: line = line.Replace("<vatcode>", " ")
		Case line.Contains( "<vatpercent>") 		: line = line.Replace("<vatpercent>", " ")
		Case line.Contains( "<vatbase>") 			: line = line.Replace("<vatbase>", " ")
		Case line.Contains( "<vatvalue>") 			: line = line.Replace("<vatvalue>", " ")
		Case line.Contains( "<vattotal>") 			: line = line.Replace("<vattotal>", " ")
		Case line.Contains( "<totaloverall>") 		: line = line.Replace("<totaloverall>", " ")
		Case line.Contains( "<kitchenreceiptcaption>")	: line = line.Replace("<kitchenreceiptcaption>", " ")
		Case line.Contains( "<totalprevbalance>") 	: line = line.Replace("<totalprevbalance>", " ")
		Case line.Contains( "<vatvaluenet>") 		: line = line.Replace("<vatvaluenet>", " ")
	End Select
	Return line
End Sub

#End Region

#Region Details Scripts
Public Sub RunDetailScript(Details As List, job As TPrnJobFiscalSellItem, lineChars As Int, commandSet As Int) As List
	'Get current CommandSet. Used for PreProcessing scripts
	Dim cmdSet As CommandSet = getCmdSet(commandSet)

	Dim scripts As List
	scripts.Initialize

	'Go through every script tag and make it lower case
	Dim matcher1 As Matcher
	For i = 0 To Details.Size - 1
		Dim line As String= Details.Get(i)
		matcher1 = Regex.Matcher("<\w+>", Details.Get(i))
	
		'For each tag found, make it to lower case and replace
		Do While matcher1.Find = True
			Dim current As String = matcher1.Match
			line = line.Replace(current, current.ToLowerCase)	'To lowercase
			line = ReplacePreProcScript(line, lineChars)		'Pre processing
			line = ReplaceDetailScripts(line, job)				'Details scripts processing
		Loop
		
		line = PostProcessingSingleLine(line, cmdSet, lineChars)'Post processing
		'Add the script line to final list
		scripts.Add(line)
	Next
	
	'Run alignment replacement and return list with final values
	Return scripts
End Sub

Private Sub ReplaceDetailScripts(line As String, job As TPrnJobFiscalSellItem) As String
	Select True
		Case line.Contains( "<itemname>") 			: line = line.Replace("<itemname>", job.ItemName)
		Case line.Contains( "<itemcode>") 			: line = line.Replace("<itemcode>", " ")
		Case line.Contains( "<itemgroup>") 			: line = line.Replace("<itemgroup>", " ")
		Case line.Contains( "<itemprice>") 			: line = line.Replace("<itemprice>", NumberFormat2(job.Price, 1, 2, 2, False))
		Case line.Contains( "<itempricenet>") 		: line = line.Replace("<itempricenet>", " ")
		Case line.Contains( "<itempricefull>") 		: line = line.Replace("<itempricefull>", " ")
		Case line.Contains( "<itempricenetfull>") 	: line = line.Replace("<itempricenetfull>", " ")
		Case line.Contains( "<itemqtty>") 			: line = line.Replace("<itemqtty>", job.Quantity)
		Case line.Contains( "<itemtotal>") 			: line = line.Replace("<itemtotal>", NumberFormat2(Round2(job.Price * job.Quantity, ProgramData.CurrentCompany.PricePercision), 1, ProgramData.CurrentCompany.PricePercision, ProgramData.CurrentCompany.PricePercision, False))
		Case line.Contains( "<itemtotalnet>") 		: line = line.Replace("<itemtotalnet>", " ")
		Case line.Contains( "<itemtotalfull>") 		: line = line.Replace("<itemtotalfull>", " ")
		Case line.Contains( "<itemtotalnetfull>") 	: line = line.Replace("<itemtotalnetfull>", " ")
		Case line.Contains( "<itemvatcode>") 			: line = line.Replace("<itemvatcode>", " ")
		Case line.Contains( "<itemvatpercent>") 		: line = line.Replace("<itemvatpercent>", job.VatPercent)
		Case line.Contains( "<itemdiscounttotal>") 	: line = line.Replace("<itemdiscounttotal>", " ")
		Case line.Contains( "<itemdiscountpercent>") 	: line = line.Replace("<itemdiscountpercent>", " ")
		Case line.Contains( "<itemdiscounttotalnet>")	: line = line.Replace("<itemdiscounttotalnet>", " ")
		Case line.Contains( "<itemdescription>") 		: line = line.Replace("<itemdescription>", " ")
	End Select
	Return line	
End Sub

#End Region

#Region Methods
Public Sub setSingleLineAlignment(line As String, linechars As Int) As String
'	Dim line As String = workingList.Get(i)
	Dim matcher1 As Matcher = Regex.Matcher("<\w+>", line)
	Alignment = -1
		
	Do While matcher1.Find = True
		Dim tag As String = matcher1.Match
		tag = tag.Replace(tag, tag.ToLowerCase)
	Loop
		
	Select tag.ToLowerCase
		Case "<left>" 		: Alignment = ALIGN_LEFT 		: line = line.replace (tag.tolowercase, "")
		Case "<right>" 		: Alignment = ALIGN_RIGHT 		: line = line.replace (tag.tolowercase, "")
		Case "<center>" 	: Alignment = ALIGN_CENTER 		: line = line.replace (tag.tolowercase, "")
		Case "<stretch>" 	: Alignment = ALIGN_STRETCH 	: line = line.replace (tag.tolowercase, "")
	End Select
	
	If Alignment <> -1 Then  line = setAlignment(Alignment, line, linechars)
	Return line
End Sub

Private Sub setAlignment(Allign As Int,line As String, chars As Int) As String

	Select Allign
		Case ALIGN_LEFT:
			line = line
		
		Case ALIGN_RIGHT:
			line = Utilities.FillLeft(line, chars)
		
		Case ALIGN_CENTER:
			line = Utilities.FillLeft(line, (chars + line.Length ) / 2)
			line = Utilities.Fill(line, chars)
			
		Case ALIGN_STRETCH:
			For i = 0 To 50
				For j = 0 To 4
					line = Utilities.ReplaceEx(line, " ", " " & Chr(0), j)
					If line.Length >= chars Then Exit
				Next
				If line.Length >= chars Then Exit
			Next
			
			line = line.Replace(Chr(0), " ")
			
	End Select
	
	Return line
End Sub

'Returns the current date
'Връща текуща дата
'Format 01.01.2018	
private Sub GetCurrentDate As String
	Dim now As Long = DateTime.Now
	Dim dt As String
	DateTime.DateFormat = "dd.MM.yyyy"
	dt = DateTime.Date(now)
	Return dt
End Sub

'Returns the current time
'Връща времето в момента
'Format 10:30	
private Sub GetCurrentTime As String
	Dim now As Long = DateTime.Now
	Dim dt As String
	DateTime.DateFormat = "hh:mm"
	dt = dt & " " & DateTime.Time(now)
	Return dt
End Sub

'Simple calculation and rounds to integer
'Прости изчисления и закръгля резултата до цяло число
Private Sub CalculateSimple(expression As String) As String
	Dim match As Matcher = Regex.Matcher2("<calc>(.*?)</calc>", Regex.CASE_INSENSITIVE, expression)
	If match.Find Then
		expression = expression.Replace(match.Match, Round(CalculateExpression(RemoveTags(match.Match))))
	End If
	Return expression
End Sub

'Quantity calculation / Изчисляване на количество
'Format 0.000
Private Sub CalculateQuantity (expression As String) As String
	Dim match As Matcher = Regex.Matcher2("<calcqtty>(.*?)</calcqtty>", Regex.CASE_INSENSITIVE, expression)
	If match.Find Then
		expression = expression.Replace(match.Match, NumberFormat2(CalculateExpression(RemoveTags(match.Match)), 1, 3, 3, False))
	End If
	Return expression
End Sub

'Repeats symbol to the end of the line / Повтаря символ до края на реда
Private Sub RepeatSymbolToEnd (s As String, chars As Int) As String
	Dim match As Matcher = Regex.Matcher2("<symbol>.", Regex.CASE_INSENSITIVE, s)
	Dim targetSymbol As String
	If match.Find Then
		targetSymbol = RemoveSingleTag(match.Match)
		s = s.Replace(match.Match,"")
	End If
	Do While s.Length < chars Then
		s = s & targetSymbol
	Loop
	Return s
End Sub

'Formats the given number/string to show N number of fractions / Форматира дадения номер/стринг да показва N на брой дробни. 
'Example: FormatExpression ("1.200000", 3) = "1.200"
Private Sub FormatExpression (expression As String, N As Int) As String
	Dim match As Matcher = Regex.Matcher2("<format\d+.*>(.*?)</format\d+.*>", Regex.CASE_INSENSITIVE, expression)
	If match.Find Then
		expression = expression.Replace(match.Match, NumberFormat2((RemoveTags(match.Match)), 1, N, N, False))
	End If
	Return expression
End Sub

'Calculates string expression and returns result as double / Изчислява стринг уравнение и връща резултат като double.
Private Sub CalculateExpression (expression As String) As Double
	Dim Result As Double = 0
	
	Try
		Result = Main.Math.Eval(expression)
	Catch		
		Log(Main.translate.GetString("msgErrorExpression")&": " & LastException.Message)
		ToastMessageShow(Main.translate.GetString("msgErrorExpression")&"!", False)		
	End Try
	Return Result
End Sub

'Removes the tags from the string/script and returns only the value in-between
'Премахва таговете от стринг/скрипт и връща само стойността посредата
Public Sub RemoveTags (line As String) As String
	Dim position As Int
	For i = 0 To line.Length - 1
		Dim letter As String
		letter = line.CharAt(i)
		If letter = ">" Then
			position = position + 1 'Get +1 for substring begining location
			line = line.SubString2(position, line.Length - (position + 1)) '+1 for the "/" in the closing tag
			Exit
		Else
			position = position + 1
		End If
	Next
	Return line
End Sub


'Replaces the contents of the line with spaces / Замества съдържанието на линията с интервал
Public Sub EmptyLine(line As String, lineChars As Int) As String
	line = ""
	Do While line.Length < lineChars
		line = line & " "
	Loop
	Return line
End Sub

'Removes the a single(opening tag) and retrns everything after that / Премахва един таг (отварящ) и връща всичко след това
Private Sub RemoveSingleTag (line As String) As String
	Dim position As Int
	For i = 0 To line.Length - 1
		Dim letter As String
		letter = line.CharAt(i)
		If letter = ">" Then
			position = position + 1 'Get +1 for substring begining location
			line = line.SubString2(position, line.Length)
			Exit
		Else
			position = position + 1
		End If
	Next
	Return line
End Sub

Private Sub getCmdSet(cmdSet As Int ) As CommandSet
	Select cmdSet
		Case PrinterConstants.ESC_POS_0  :	Return PrinterConstants.cmdSet_ESC_POS_0
		Case PrinterConstants.ESC_POS_1  :	Return PrinterConstants.cmdSet_ESC_POS_1
		Case PrinterConstants.ESC_POS_2  :	Return PrinterConstants.cmdSet_ESC_POS_2
		Case PrinterConstants.ESC_POS_3  :	Return PrinterConstants.cmdSet_ESC_POS_3
		Case Else
			Dim cmd As CommandSet
			cmd.Initialize
			cmd.Counter = ""
			cmd.Cutter = "" 
			cmd.ServiceChargePercent = "" 
			cmd.FontSizeINC = ""
			cmd.FontSizeDEC = ""
			cmd.FontBoldON = ""
			cmd.FontBoldOFF = ""
			cmd.FontItalicON = "" 
			cmd.FontItalicOFF = "" 
			cmd.KickDrawer = "" 
			Return cmd
	End Select
End Sub

#End Region