B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=7.3
@EndOfDesignText@
Sub Process_Globals
	Private MyPhone As Phone
		
	Private Const Device_Unchecked	As Int = 0
	Public Const Device_Unknown		As Int = 1
	Public Const Device_SunmiV1s	As Int = 2
	Public Const Device_Evator		As Int = 3
	
	Private DeviceIndex As Int
	
	'Debug режим на принтерите за проследяване на комуникацията в Log
	Public Const PrinterDebugMode As Boolean = True
	
	Public Const WatermarkText As String = "*** Smart Printer for Android ***"
	Public Const WatermarkURL As String = "Simeonch"
End Sub

'Връща устройството като предварително зададена константа, ако не е разпознато устройството, прави проверка от известните до момента устройства
Public Sub Model() As Int
	If DeviceIndex = Device_Unchecked Then
		DeviceIndex = Device_Unknown
		
		If PrinterDebugMode Then
			Log("Manufacturer: " & MyPhone.Manufacturer & " / " & "Model: " & MyPhone.Model & " / " & "Product: " & MyPhone.Product)
		End If
		
		Select Case MyPhone.Model
			Case "V1s-G": 	DeviceIndex = Device_SunmiV1s
			Case "Evator":	DeviceIndex = Device_Evator
			Case Else:		DeviceIndex = Device_Unknown
		End Select
	End If

	Return DeviceIndex
End Sub

'Проверява дали зададеното устройство е това, което сме посочили като параметър
Public Sub ModelIs(DeviceModel As Int) As Boolean
	If DeviceModel = DeviceIndex Then
		Return True
	Else
		Return False
	End If
End Sub