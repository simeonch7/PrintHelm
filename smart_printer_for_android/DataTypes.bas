B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=7.3
@EndOfDesignText@
'Code module
Sub Process_Globals
	Type CartItem(ID As Int, itemName As String, measureName As String, itemCode As String, qtty As Double, row As Int, vatPercent As Double, vatIndex As Int, itemDiscount As Double, ratio As Int, itemPrice As Double)
	Type StoreObject(ID As Int, storeName As String, storeCode As Int, PriceGroup As Int, storeAddress As String, CompanyID As Int)
	Type Partner(ID As Int, partnerCode As Int, companyName As String, PriceGroup As Int, CardNumber As String, discount As Double, mol As String,City As String,Address As String, phone As String,email As String,taxNo As String,Bulstat As String, PartnerType As Int, Photo As String, CompanyID As Int)
	Type CurrentUser(ID As Int, Name As String, GroupName As String, email As String,phone As String, CompanyId As Int)
	Type Company (ID As Int,CompanyName As String,City As String,CountryId As Int,Address As String,ContactPerson As String,Inn As String,TaxNo As String,eMail As String,phone As String,PaymentToDate As String,ValidUsers As Int,CurrentUsers As Int,IsVatRegistred As Int,PricePercision As Int,QntPercision As Int,PricesWithVat As Int,AutoProduction As Int,AllowNegativeQnt As Int,CurrencyCode As String)
	Type UserConfig(language As String, country As Int)
End Sub