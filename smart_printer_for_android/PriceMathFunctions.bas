B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=7.3
@EndOfDesignText@

Sub Process_Globals
End Sub

'Final item price VAT Amount
Public Sub GetFinalPriceVat(cartItem As CartItem) As Double
	Return  Round2(GetFinalPriceWithVat(cartItem) - GetFinalPriceWithoutVat(cartItem), _
			 ProgramData.CurrentCompany.PricePercision)
End Sub

'Final item price with VAT
Public Sub GetFinalPriceWithVat(cartItem As CartItem) As Double
	Return  Round2(GetSinglePriceWithVat(cartItem)  * cartItem.qtty, _
			 ProgramData.CurrentCompany.PricePercision)
End Sub

'Final item price without VAT
Public Sub GetFinalPriceWithoutVat(cartItem As CartItem) As Double
	Return  Round2(GetSinglePriceWithoutVat(cartItem)  * cartItem.qtty, _
			 ProgramData.CurrentCompany.PricePercision)
End Sub

'Single item price with VAT
Public Sub GetSinglePriceWithVat(cartItem As CartItem) As Double
	Return  Round2(GetSinglePriceWithDiscount(cartItem), _
			 ProgramData.CurrentCompany.PricePercision)
End Sub

'Single item price without VAT
Public Sub GetSinglePriceWithoutVat(cartItem As CartItem) As Double
	Return  Round2((GetSinglePriceWithVat(cartItem) / (1 + cartItem.VatPercent / 100)) * cartItem.ratio, _
			 ProgramData.CurrentCompany.PricePercision)
End Sub

'Single item price with Discount
Public Sub GetSinglePriceWithDiscount(cartItem As CartItem) As Double
	Return  Round2((cartItem.itemPrice * (1 - cartItem.itemDiscount / 100)) * cartItem.ratio, _
			 ProgramData.CurrentCompany.PricePercision)
End Sub
