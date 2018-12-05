B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=7.3
@EndOfDesignText@
'Code module
Private Sub Process_Globals
End Sub

'Експортиране на xml фаиловете / Xml files export
Public Sub ExportXML(op As Operation) As String
	Public exportFileName As StringBuilder	
	Public mapPay As Map
	Public mapItems As List
	mapItems.Initialize
	mapItems = op.Items	
	mapPay.Initialize
	mapPay = op.Payments	
	exportFileName.Initialize()
	exportFileName.Append("<?xml version=" & QUOTE & "1.0" & QUOTE & " encoding=" & QUOTE & "utf-8" & QUOTE & "?>").Append(CRLF)
	exportFileName.Append("<Root>").Append(CRLF)
	exportFileName.Append("	<Operation>").Append(CRLF)
	exportFileName.Append("		<id>" & op.id & "</id>").Append(CRLF)
	exportFileName.Append("		<CompanyId>" & op.CompanyID & "</CompanyId>").Append(CRLF)
	exportFileName.Append("		<DateIssued>" & op.DateIssued & "</DateIssued>").Append(CRLF)
	exportFileName.Append("		<OperType>" & op.OperType & "</OperType>").Append(CRLF)
	exportFileName.Append("		<ObjectId>" & op.ObjectID & "</ObjectId>").Append(CRLF)
	exportFileName.Append("		<PartnerId>" & op.PartnerId & "</PartnerId>").Append(CRLF)
	exportFileName.Append("		<UserId>" & op.UserID & "</UserId>").Append(CRLF)
	exportFileName.Append("		<Amount>" & op.Amount & "</Amount>").Append(CRLF)
	exportFileName.Append("		<AmountVat>" & op.AmountVat & "</AmountVat>").Append(CRLF)
	exportFileName.Append("		<PricesWithVat>" & op.PricesWithVat & "</PricesWithVat>").Append(CRLF)
	exportFileName.Append("		<NullVat>" & op.NullVat & "</NullVat>").Append(CRLF)
	exportFileName.Append("		<IsVat>" & op.IsVat & "</IsVat>").Append(CRLF)
	exportFileName.Append("		<PaymentTypeId>" & op.PaymentID & "</PaymentTypeId>").Append(CRLF)
	' Items
	exportFileName.Append("		<Items>").Append(CRLF)
	For a = 0 To mapItems.Size - 1
		Private Goods As CartItem
		Goods = mapItems.Get(a)
		exportFileName.Append("			<Item>").Append(CRLF)
		exportFileName.Append("				<ItemId>" & Goods.ID & "</ItemId>").Append(CRLF)
		exportFileName.Append("				<Qtty>" & Goods.Qtty & "</Qtty>")    
		exportFileName.Append("				<Discount>" & Goods.itemDiscount & "</Discount>").Append(CRLF) ' To be retrived
		exportFileName.Append("				<Price>" & PriceMathFunctions.GetSinglePriceWithVat(Goods) & "</Price>").Append(CRLF)
		exportFileName.Append("				<RowSum>" & PriceMathFunctions.GetFinalPriceWithVat(Goods) & "</RowSum>") 'Will be added later
		exportFileName.Append("				<Note></Note>").Append(CRLF) ' To Do
		exportFileName.Append("			</Item>").Append(CRLF)
	Next
	exportFileName.Append("		</Items>").Append(CRLF)	
	exportFileName.Append("		<Payments>").Append(CRLF)
	For p = 0 To mapPay.Size - 1 'Използва цикъл, когато има повече от 1 плащане
		exportFileName.Append("			<Payment>").Append(CRLF)
		exportFileName.Append("				<PaymentId>" & op.Payments.GetKeyAt(p) & "</PaymentId>").Append(CRLF) ' To DO
		exportFileName.Append("				<Amount>" & op.AmountWithVat & "</Amount>").Append(CRLF)
		exportFileName.Append("			</Payment>").Append(CRLF)
	Next
	exportFileName.Append("		</Payments>").Append(CRLF)	
	exportFileName.Append("		<ECReceipt>").Append(CRLF)
	exportFileName.Append("			<Total>" & op.ECReceipt.Total & "</Total>").Append(CRLF)
	exportFileName.Append("			<ECRID>" & op.ECReceipt.ECRID & "</ECRID>").Append(CRLF)
	exportFileName.Append("			<ReceiptID>" & op.ECReceipt.ReceiptID & "</ReceiptID>").Append(CRLF)
	exportFileName.Append("			<ReceiptType>" & op.ECReceipt.ReceiptType & "</ReceiptType>").Append(CRLF)
	exportFileName.Append("		</ECReceipt>").Append(CRLF)	
	exportFileName.Append("	</Operation>").Append(CRLF)
	exportFileName.Append("</Root>").Append(CRLF)	
	Return exportFileName.ToString
End Sub

'Записва датата и час на операциите / Hold date and time of operations
Public Sub GetDateIssued As String
	Private dateNow As String = DateTime.Now
	Private dateFinal As String
	Private year, month, day, hour, minute, second As String
	year = DateTime.GetYear(dateNow)
	month = DateTime.GetMonth(dateNow)
	day = DateTime.GetDayOfMonth(dateNow)
	hour = DateTime.GetHour(dateNow)
	minute = DateTime.GetMinute(dateNow)
	second = DateTime.GetSecond(dateNow)	
	If (month.Length = 1) Then month = "0" & month
	If (day.Length = 1) Then day = "0" & day	 
	If (hour.Length = 1) Then hour = "0" & hour
	If (minute.Length = 1) Then minute = "0" & minute
	If (second.Length = 1) Then second = "0" & second	
	dateFinal = year & "-" & month & "-" & day & " " & hour & ":" & minute & ":" & second

	Return dateFinal
End Sub