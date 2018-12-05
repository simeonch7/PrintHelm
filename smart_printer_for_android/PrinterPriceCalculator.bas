B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=7.3
@EndOfDesignText@
Private Sub Class_Globals
	Private Total As Double	'Ignore
	Private Change As Double
	Public Payments As Map
	
End Sub

Public Sub Initialize
	Payments.Initialize
End Sub

Public Sub addItem(jobSellItem As TPrnJobFiscalSellItem)
	Total = Total + Round2(jobSellItem.Price * jobSellItem.Quantity, 2)
End Sub

Public Sub AddPayment(jobPayment As TPrnJobFiscalPayment)
	Payments.Put(jobPayment.PayType, jobPayment)
End Sub

Public Sub getTotal As Double
	Return Round2(Total, 2)
End Sub

Public Sub getChange As Double
	Dim tempPaymentsMap As Map
	tempPaymentsMap.Initialize
	For i = 0 To Payments.Size - 1
		tempPaymentsMap.Put(Payments.GetKeyAt(i), Payments.GetValueAt(i))	
	Next
	
	If Not(tempPaymentsMap.ContainsKey(ProgramData.PAYMENT_CASH)) Then
		Change = 0
	Else
		Dim otherSum As Double = 0
		
		Dim cashJob As TPrnJobFiscalPayment = tempPaymentsMap.Get(ProgramData.PAYMENT_CASH)
		Dim cashSum As Double = cashJob.PaySum
		tempPaymentsMap.Remove(ProgramData.PAYMENT_CASH)
		
		For Each payment As TPrnJobFiscalPayment In tempPaymentsMap.Values
			otherSum = otherSum + payment.PaySum
		Next
		
		If otherSum >= Total Then
			Change = 0
		Else 
			Change = cashSum - (Total - otherSum)
		End If
	End If
	
		
	Return Round2(Change, 2)
End Sub

Public Sub Reset
	Total = 0
	Change = 0 
	Payments.Clear
End Sub