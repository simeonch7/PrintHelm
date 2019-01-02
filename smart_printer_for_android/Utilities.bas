B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=7.3
@EndOfDesignText@
Private Sub Process_Globals
End Sub

Public Sub mesureTextWidth2(text As String, TextSize As Float) As Float
	Dim Canvas As Canvas
	Dim Dummy As Bitmap
	
	Dummy.InitializeMutable(1dip, 1dip) 	'Dummy bmp
	Canvas.Initialize2(Dummy) 				'For string width measure
	Dim width As Float = Canvas.MeasureStringWidth(text, Typeface.DEFAULT, TextSize)
	Return width
End Sub

Public Sub mesureTextHeight(text As String, TextSize As Float) As Float
	Dim Canvas As Canvas
	Dim Dummy As Bitmap
	
	Dummy.InitializeMutable(1dip, 1dip) 	'Dummy bmp
	Canvas.Initialize2(Dummy) 				'For string width measure
	Dim HEIGHT As Float = Canvas.MeasureStringHeight(text, Typeface.MONOSPACE, TextSize)
	Return HEIGHT
End Sub

#Region Копиране на обекти
'Копиране на един обект в друг, предаване на параметрите ByVal вместо по Reference
Public Sub CopyObject(Obj As Object) As Object
	Dim Raf As RandomAccessFile
	Dim n As Int = 256
	Dim NotDone As Boolean = True

	Do While NotDone
		NotDone=False
		Dim Buffer(n) As Byte
		
		Try
			Raf.Initialize3(Buffer, False)
			Raf.WriteObject(Obj, True, 0)
		Catch
			n = n*10
			NotDone = True
		End Try
		
		If NotDone = False Then
			Dim newObj As Object
			newObj = Raf.ReadObject(0)
		End If
		
		Raf.Close
		
	Loop
	
	Return newObj
	
End Sub
#End Region

#Region Стрингови функции
' Форматирование в десятичный формат представления с разделителем - '.'
Public Sub DecimalFormat(FormatStr As String, Value As Object) As String
	Dim DecimalFormatSymbols As JavaObject
	DecimalFormatSymbols.InitializeNewInstance("java.text.DecimalFormatSymbols", Array As Object())
	DecimalFormatSymbols.RunMethod("setDecimalSeparator", Array As Object(Chr(0x2E)))
	
	Dim DecimalFormatter As JavaObject
	DecimalFormatter.InitializeNewInstance("java.text.DecimalFormat", Array As Object(FormatStr, DecimalFormatSymbols))
	
	Return DecimalFormatter.RunMethod("format", Array As Object( Value ))
End Sub

' Форматирование произвольных данных в стиле java.lang.String.format
Public Sub Format(FormatStr As String, Params() As Object) As String
	'Create a Stringbuilder (it's much faster for appending strings)
	Dim SB As StringBuilder
	SB.Initialize

	'Create the Formatter Object
	Dim Formatter As JavaObject
	Formatter.InitializeStatic("java.lang.String")

	SB.Append(Formatter.RunMethod("format", Array As Object( FormatStr, Params )))

	Return SB.ToString
End Sub

'Запълва стринг до зададената дължина
Public Sub Fill(MyString As String, MySize As Int) As String
	Dim s As String

	If MyString = Null Then
		s = ""
	Else
		s = MyString
	End If
	
	Do While s.Length < MySize
		s = s & "         "
	Loop
	
	s = s.SubString2(0, MySize)

	Return s
	
End Sub

'Запълва стринг до зададената дължина
 Public Sub FillLeft(MyString As String, MySize As Int) As String
	Dim s As String

	If MyString = Null Then
		s = ""
	Else
		s = MyString
	End If

	Do While s.Length < MySize
		s = "         " & s
	Loop
	
	s = s.SubString(s.Length - MySize)

	Return s
	
End Sub

'Запълва число с нули от ляво до зададената дължина
Public Sub FillNumber(MyString As String, MySize As Int) As String
	Dim s As String

	If MyString = Null Then
		s = ""
	Else
		s = MyString
	End If

	Do While s.Length < MySize
		s = "000000000" & s
	Loop
	
	s = s.SubString(s.Length - MySize)

	Return s
	
End Sub

'Заменя една част от стринг с друга
Public Sub ReplaceEx(Source As String, Old As String, New As String, Index As Int) As String
	Dim I As Int = -1
	For o = 0 To Index
		I = Source.IndexOf2(Old, I + 1)
		If I = -1 Then Return Source
	Next
	Return Source.SubString2(0, I) & New & Source.SubString(I + Old.Length)
End Sub

'Филтрира стринга и оставя само цифровите стойности
Public Sub GetDigitsOnly(s As String) As String
	Dim Result As String
	Dim i As Int

	Result = ""
	
	For i = 0 To s.Length - 1
		If (s.SubString2(i, i + 1).CompareTo("0") >= 0) And (s.SubString2(i, i + 1).CompareTo("9") <= 0 ) Then Result = Result & s.SubString2(i, i + 1)
	Next
	
	Return Result
End Sub

'Филтрира стринга като оставя само букви, цифри и точка (за IP адреси)
Public Sub GetAlphaNumericOnly(s As String) As String
	Dim Result As String
	Dim i As Int

	Result = ""
	
	For i = 0 To s.Length - 1
		If (s.SubString2(i, i + 1).CompareTo("0") >= 0) And (s.SubString2(i, i + 1).CompareTo("9") <= 0 ) Then Result = Result & s.SubString2(i, i + 1)
		If (s.SubString2(i, i + 1).CompareTo("a") >= 0) And (s.SubString2(i, i + 1).CompareTo("z") <= 0 ) Then Result = Result & s.SubString2(i, i + 1)
		If (s.SubString2(i, i + 1).CompareTo("A") >= 0) And (s.SubString2(i, i + 1).CompareTo("Z") <= 0 ) Then Result = Result & s.SubString2(i, i + 1)
		If (s.SubString2(i, i + 1).CompareTo("а") >= 0) And (s.SubString2(i, i + 1).CompareTo("я") <= 0 ) Then Result = Result & s.SubString2(i, i + 1)
		If (s.SubString2(i, i + 1).CompareTo("А") >= 0) And (s.SubString2(i, i + 1).CompareTo("Я") <= 0 ) Then Result = Result & s.SubString2(i, i + 1)
		If (s.SubString2(i, i + 1).CompareTo(".") = 0) Then Result = Result & s.SubString2(i, i + 1)
		If (s.SubString2(i, i + 1).CompareTo(",") = 0) Then Result = Result & s.SubString2(i, i + 1)
		If (s.SubString2(i, i + 1).CompareTo(":") = 0) Then Result = Result & s.SubString2(i, i + 1)
		If (s.SubString2(i, i + 1).CompareTo("/") = 0) Then Result = Result & s.SubString2(i, i + 1)
		If (s.SubString2(i, i + 1).CompareTo("\") = 0) Then Result = Result & s.SubString2(i, i + 1)
		If (s.SubString2(i, i + 1).CompareTo("@") = 0) Then Result = Result & s.SubString2(i, i + 1)
		If (s.SubString2(i, i + 1).CompareTo("_") = 0) Then Result = Result & s.SubString2(i, i + 1)
	Next
	
	Return Result
End Sub

'Преобразува всички десетични запетаи към точки (съвместимост с 1С и други системи)
Public Sub ForceDecimalPoint(s As String) As String
	
	s = s.Replace(" ", "")					'Интервал
	s = s.Replace(Chr(160), "")				'Непреносим интервал
	s = s.Replace(",", ".")					'Десетична запетая
	
	Return s
End Sub

'Дели шестнайсетичните числа по двойки за лесно четене
Public Sub HexSplit(s As String) As String
	Dim Result As String

	Result = ""
	
	For i = 0 To (s.Length - 1) / 2
		Result = Result & s.SubString2(i*2, (i*2 + 2)) & " "
	Next
	
	Return Result.Trim
End Sub
#End Region

#Region Функции за дата
'Форматира дата и време до SQL формат (и други възможни)
Public Sub FormatDate(InputDate As Long, DateFormat As String) As String
	Dim Result As String

	Result	= ""
 
	Select DateFormat
		Case "DDMMYYHHMM"
			Result	  = NumberFormat2(DateTime.GetDayOfMonth(InputDate),2,0,0,False) & _
						NumberFormat2(DateTime.GetMonth(InputDate),2,0,0,False) & _
						NumberFormat2(DateTime.GetYear(InputDate) - 2000,2,0,0,False) & _
						NumberFormat2(DateTime.GetHour(InputDate),2,0,0,False) & _
						NumberFormat2(DateTime.GetMinute(InputDate),2,0,0,False)						
		Case "YYYYMMDD"
			Result	  = NumberFormat2(DateTime.GetYear(InputDate),4,0,0,False) & _
						NumberFormat2(DateTime.GetMonth(InputDate),2,0,0,False) & _
						NumberFormat2(DateTime.GetDayOfMonth(InputDate),2,0,0,False)
						
		Case "YYYYMMDD HHMMSS"
			Result	  = NumberFormat2(DateTime.GetYear(InputDate),4,0,0,False) & _
						NumberFormat2(DateTime.GetMonth(InputDate),2,0,0,False) & _
						NumberFormat2(DateTime.GetDayOfMonth(InputDate),2,0,0,False) & " " & _
						NumberFormat2(DateTime.GetHour(InputDate),2,0,0,False) & _
						NumberFormat2(DateTime.GetMinute(InputDate),2,0,0,False) & _
						NumberFormat2(DateTime.GetSecond(InputDate),2,0,0,False)
						
		Case "YYYY-MM-DD HH:MM:SS"
			Result	  = NumberFormat2(DateTime.GetYear(InputDate),4,0,0,False) & "-" & _
						NumberFormat2(DateTime.GetMonth(InputDate),2,0,0,False) & "-" & _
						NumberFormat2(DateTime.GetDayOfMonth(InputDate),2,0,0,False) & " " & _
						NumberFormat2(DateTime.GetHour(InputDate),2,0,0,False) & ":" & _
						NumberFormat2(DateTime.GetMinute(InputDate),2,0,0,False) & ":" & _
						NumberFormat2(DateTime.GetSecond(InputDate),2,0,0,False)
						
		Case "SQL"
			Result	  = NumberFormat2(DateTime.GetYear(InputDate),4,0,0,False) & "-" & _
						NumberFormat2(DateTime.GetMonth(InputDate),2,0,0,False) & "-" & _
						NumberFormat2(DateTime.GetDayOfMonth(InputDate),2,0,0,False) & " " & _
						NumberFormat2(DateTime.GetHour(InputDate),2,0,0,False) & ":" & _
						NumberFormat2(DateTime.GetMinute(InputDate),2,0,0,False) & ":" & _
						NumberFormat2(DateTime.GetSecond(InputDate),2,0,0,False)
			Result = "'" & Result & "'"
						
		Case "SQLMini"
			Result	  = NumberFormat2(DateTime.GetYear(InputDate),4,0,0,False) & "-" & _
						NumberFormat2(DateTime.GetMonth(InputDate),2,0,0,False) & "-" & _
						NumberFormat2(DateTime.GetDayOfMonth(InputDate),2,0,0,False)
			Result = "'" & Result & "'"
						
		Case "DD-MM-YYYY"
			Result	  = NumberFormat2(DateTime.GetDayOfMonth(InputDate),2,0,0,False) & "-" & _
						NumberFormat2(DateTime.GetMonth(InputDate),2,0,0,False) & "-" & _
						NumberFormat2(DateTime.GetYear(InputDate),4,0,0,False)
						
		Case "DD-MM-YYYY HH:MM:SS"
			Result	  = NumberFormat2(DateTime.GetDayOfMonth(InputDate),2,0,0,False) & "-" & _
						NumberFormat2(DateTime.GetMonth(InputDate),2,0,0,False) & "-" & _
						NumberFormat2(DateTime.GetYear(InputDate),4,0,0,False) & " " & _
						NumberFormat2(DateTime.GetHour(InputDate),2,0,0,False) & ":" & _
						NumberFormat2(DateTime.GetMinute(InputDate),2,0,0,False) & ":" & _
						NumberFormat2(DateTime.GetSecond(InputDate),2,0,0,False)
							
		Case "DD-MM-YYYY HH:MM"
			Result	  = NumberFormat2(DateTime.GetDayOfMonth(InputDate),2,0,0,False) & "-" & _
						NumberFormat2(DateTime.GetMonth(InputDate),2,0,0,False) & "-" & _
						NumberFormat2(DateTime.GetYear(InputDate),4,0,0,False) & " " & _
						NumberFormat2(DateTime.GetHour(InputDate),2,0,0,False) & ":" & _
						NumberFormat2(DateTime.GetMinute(InputDate),2,0,0,False)
						
		Case "DD.MM.YYYY HH:MM"
			Result	  = NumberFormat2(DateTime.GetDayOfMonth(InputDate),2,0,0,False) & "." & _
						NumberFormat2(DateTime.GetMonth(InputDate),2,0,0,False) & "." & _
						NumberFormat2(DateTime.GetYear(InputDate),4,0,0,False) & " " & _
						NumberFormat2(DateTime.GetHour(InputDate),2,0,0,False) & ":" & _
						NumberFormat2(DateTime.GetMinute(InputDate),2,0,0,False)
						
		Case "DD.MM.YYYY HH"
			Result	  = NumberFormat2(DateTime.GetDayOfMonth(InputDate),2,0,0,False) & "." & _
						NumberFormat2(DateTime.GetMonth(InputDate),2,0,0,False) & "." & _
						NumberFormat2(DateTime.GetYear(InputDate),4,0,0,False) & " " & _
						NumberFormat2(DateTime.GetHour(InputDate),2,0,0,False) 
						
		Case "DD.MM.YYYY HH:MM:SS"
			Result	  = NumberFormat2(DateTime.GetDayOfMonth(InputDate),2,0,0,False) & "." & _
						NumberFormat2(DateTime.GetMonth(InputDate),2,0,0,False) & "." & _
						NumberFormat2(DateTime.GetYear(InputDate),4,0,0,False) & " " & _
						NumberFormat2(DateTime.GetHour(InputDate),2,0,0,False) & ":" & _
						NumberFormat2(DateTime.GetMinute(InputDate),2,0,0,False) & ":" & _
						NumberFormat2(DateTime.GetSecond(InputDate),2,0,0,False)
						
		Case "DD.MM.YYYY"
			Result	  = NumberFormat2(DateTime.GetDayOfMonth(InputDate),2,0,0,False) & "." & _
						NumberFormat2(DateTime.GetMonth(InputDate),2,0,0,False) & "." & _
						NumberFormat2(DateTime.GetYear(InputDate),4,0,0,False)
						
		Case "HH:MM:SS"
			Result	  = NumberFormat2(DateTime.GetHour(InputDate),2,0,0,False) & ":" & _
						NumberFormat2(DateTime.GetMinute(InputDate),2,0,0,False) & ":" & _
						NumberFormat2(DateTime.GetSecond(InputDate),2,0,0,False)
							
		Case Else
			Result = ""

	End Select

	Return Result
	
End Sub

'Превръща датата от SQL формат в стандартен формат
Public Sub SQL2HumanDate(SQLDate As String) As String
	Return SQLDate.SubString2(8, 10) & "." & SQLDate.SubString2(5, 7) & "." & SQLDate.SubString2(0, 4)
End Sub

'Дава стандартното отклонение във времето сперид часовата зона
Public Sub GetTimeZoneOffset As Int
	Dim s As String
	Dim d As String
	Dim l As Long
	Dim Result As Int

	s = DateTime.DateFormat
	DateTime.DateFormat = "MM/dd/yyyy HH:mm:ss"
	
	l = DateTime.Now
	d = DateTime.Date(l) & " GMT"
	DateTime.DateFormat = "MM/dd/yyyy HH:mm:ss z"
	
	Result = -Round((l - DateTime.DateParse(d))/3600000)
	DateTime.DateFormat = s
	
	Return Result
End Sub
#End Region

#Region Криптография
'Криптира стринг по MD5
Public Sub MD5String(s As String) As String
	Dim Data(0) As Byte
	Dim Bconv As ByteConverter
	Dim md As MessageDigest
	
	Data = Bconv.StringToBytes(s, "UTF8")
	Data = md.GetMessageDigest(Data, "MD5")
	Return Bconv.HexFromBytes(Data)
End Sub

'Криптира стринг по SHA-1
Public Sub SHAString(s As String) As String
	Dim Data(0) As Byte
	Dim Bconv As ByteConverter
	Dim md As MessageDigest
	
	Data = Bconv.StringToBytes(s, "UTF8")
	Data = md.GetMessageDigest(Data, "SHA-1")
	Return Bconv.HexFromBytes(Data)
End Sub


'Декриптира паролата
Public Sub PasswordDecrypt(Password As String, sDecrKey As String) As String
	Dim Key(0) As Byte
	Dim IV(0) As Byte
	Dim Data(0) As Byte
	Dim Bytes(0) As Byte
	Dim B64 As Base64
	Dim bConv As ByteConverter
	
	If Password = "" Then Return ""						'Ако паролата е празна (обикновено при експорт от 1С)
	
	IV = Array As Byte(18, 52, 86, 120, 144, 171, 205, 239)
	
	Key = bConv.StringToBytes(sDecrKey.SubString2(0, 8), "UTF8")
	
	'ik: при длине пароля меньше 4-х символов возикает ошибка конвертации из Base-64
	Try
		Data = B64.DecodeStoB(Password)
	Catch
		Return "Invalid decryption!"
	End Try

	Dim Kg As KeyGenerator
	Dim c As Cipher
	
	c.Initialize("DES/CBC/PKCS5Padding")
	c.InitialisationVector = IV
	
	Kg.Initialize("DES")
	Kg.KeyFromBytes(Key)
	
	Try
		Bytes = c.DeCrypt(Data, Kg.Key, True)
	Catch
		Return "Invalid decryption!"
	End Try
	
	Return bConv.stringFromBytes(Bytes, "UTF8")

End Sub

'Универсална парола за вход
Public Sub ServicePassword(HourShift As Int) As String
	Dim s As String
	Dim ss As String
	Dim I As Int

	s = FormatDate(DateTime.Now + (HourShift * 3600000) , "DD.MM.YYYY HH")
	ss = ""
	
	For I = 0 To s.Length - 1
		ss = ss & s.SubString2(I, I + 1) & Chr(0)
	Next

#If FASTPOS or NYRCASSA
	s = MD5String(ss)
#End If
#If FASTMSPOS or IIKOEXPRESS
	s = SHAString(ss)
#End If

	ss = ""
	For I = 0 To s.Length - 1
		If IsNumber(s.SubString2(I, I + 1)) Then
			ss = ss & s.SubString2(I, I + 1)
		End If
		
		If ss.Length = 8 Then
			Exit
		End If
	Next

	Return ss

End Sub
#End Region

#Region Мрежови функции
'Получаване на IP на устройството
Public Sub GetMyIP As String
	Dim DeviceIP As String
	Dim MyIP As ServerSocket		'Ignore

	DeviceIP = ""
 
	Try
		DeviceIP = MyIP.GetMyWifiIP
	Catch
		DeviceIP = ""
	End Try

	If (DeviceIP = "127.0.0.1") Or (DeviceIP = "") Then
		Try
			DeviceIP = MyIP.GetMyIP
		Catch
			DeviceIP = ""
		End Try
	End If
 
	If DeviceIP = "127.0.0.1" Then DeviceIP = ""

	MyIP.Close

	Return DeviceIP
End Sub
#End Region

#Region Имена на продуктите
Public Sub ProductName(FullName As Boolean) As String
	Dim s As String

	Select Case Version.ProductID
		Case 130: s = "Microinvest Restaurant"
		Case 131: s = "Microinvest FastPOS"
		Case 137: s = "Microinvest FastMSPOS"
		Case 138: s = "Microinvest НҰР Касса"
		Case 201: s = "Multisoft MSPOS-K"
	End Select
	
	If FullName Then s = s & CRLF & "For Android"
	
	Return s
End Sub
#End Region

#Region Системни и помощни функции
'Превръща HEX в цвят
Public Sub Clr(MyColor As String) As Int
	Dim R As Int
	Dim G As Int
	Dim B As Int

	R = Bit.ParseInt(MyColor.SubString2(0,2), 16)
	G = Bit.ParseInt(MyColor.SubString2(2,4), 16)
	B = Bit.ParseInt(MyColor.SubString2(4,6), 16)
	
	Return Colors.RGB(R, G, B)
End Sub

'Конвертиране на десетично към двоично число
Public Sub DecToBin(DecVal As Int, NumBit As Int) As String
	Dim Bits As Int
	Dim Dec2Bin As StringBuilder

	Dec2Bin.Initialize

	If NumBit = 0 Then
		Do While DecVal > Power(2 ,Bits)-1
			Bits = Bits + 1
		Loop
	Else
		Bits = NumBit
	End If

	For I = Bits - 1 To 0 Step -1
		Dec2Bin.Append((Bit.And(DecVal , Power(2,I)))/Power(2,I))
	Next
	
	Return Dec2Bin
End Sub

'Конвертиране от двоично към десетично число
Public Sub BinToDec(BinVal As String) As Int
	Dim I As Int
	Dim v As Int
	Dim Dec As Int

	I = BinVal.Length
	v = 1

	For pos = I To 1 Step -1
		If BinVal.SubString2(pos-1, pos) = "1" Then Dec = Dec + v
		v = v * 2
	Next

	Return Dec
End Sub

'Ориентация на устройството
Public Sub IsPortrait As Boolean
	Dim os As OperatingSystem

	os.Initialize("")
	
	If os.widthPixels > os.heightPixels Then
		Return False
	Else
		Return True
	End If
End Sub

'Вграден файлов лог за функционирането на програмата
Public Sub FileLog(MyEvent As String)
	Dim Out As OutputStream
	Dim TW As TextWriter
	
	Log(MyEvent)			'Съхраняваме събитието в стандартния стек на събитията

	Try
		Out = File.OpenOutput(File.DirRootExternal, Version.Path & "/Logger.txt", True)
	Catch
		File.MakeDir(File.DirRootExternal, Version.Path)
	End Try

	If Out.IsInitialized Then
		TW.Initialize(Out)
		TW.Write(FormatDate(DateTime.Now, "DD.MM.YYYY HH:MM:SS") & " " & MyEvent & CRLF)
		TW.Close
	End If
End Sub


#If KIOSK
'Запуск LAUNCHER по-умолчанию
Public Sub LaunchDefLauncher
    Dim intnt As Intent
    Dim packManager As Reflector
    Dim lst As List

    intnt.Initialize(intnt.ACTION_MAIN, "")
    intnt.AddCategory("android.intent.category.HOME")
  
    packManager.Target = getPackageManager
  
    'public abstract List<ResolveInfo> queryIntentActivities(Intent intent, int flags)
    lst = packManager.RunMethod4("queryIntentActivities", Array As Object(intnt, 0), Array As String ("android.content.Intent", "java.lang.int")) 'List<ResolveInfo>

  
    For Each resolveInfo As Object In lst
        Dim ref As Reflector
		ref.Target = resolveInfo
        ref.Target = ref.GetField("activityInfo")
		Dim packageName As String = ref.GetField("packageName")
		Dim name As String = ref.GetField("name")
		If (packageName <> GetPackageName) Then			
			Dim defLauncher As Intent
			defLauncher.Initialize("android.intent.action.MAIN", "")
			defLauncher.AddCategory("android.intent.category.LAUNCHER")
			defLauncher.Flags = Bit.Or(defLauncher.Flags , defLauncher.Flags)
			ref.Target = defLauncher
			ref.RunMethod4("setClassName", Array As Object(packageName, name), Array As String ("java.lang.String", "java.lang.String"))
			StartActivity(defLauncher)
			Exit			
		End If
	Next
  
End Sub

Private Sub GetPackageName As String
   Dim r As Reflector
   Return r.GetStaticField("anywheresoftware.b4a.BA", "packageName")
End Sub

'retrieves android.content.pm.PackageManager
Private Sub getPackageManager As Object
   Dim ctxObj As Reflector
   ctxObj.Target = ctxObj.GetContext
   Return ctxObj.RunMethod("getPackageManager")
End Sub
#End If

'Select the Encoding or find an alternative encoding
Public Sub SelectCodepage(Codepage As String) As String
	Dim i As Int
	Dim j As Int
	Dim k As Int
	Dim s As String
	Dim MyEncodings() As String
	Dim OSEncodings() As String
	Dim bConv As ByteConverter
	
	OSEncodings = bConv.SupportedEncodings
	
	For i = 1 To 7
		Select Case i
			Case 1: s="IBM855,cp855,csIBM855"
			Case 2: s="IBM864,cp864,csIBM864"
			Case 3: s="IBM865,cp865,csIBM865"
			Case 4: s="IBM866,cp866,csIBM866"
			Case 5: s="IBM850,cp850,csPC850Multilingual"
			Case 6: s="windows-1251,cswindows1251,cp-1251,cp1251"
			Case 7: s="windows-1256,cswindows1256,cp-1256,cp1256"
		End Select
		
		If s.Contains(Codepage) Then
			MyEncodings = Regex.Split(",", s)
			
			For j = 0 To MyEncodings.Length - 1
				For k = 0 To OSEncodings.Length - 1
					If MyEncodings(j) = OSEncodings(k) Then
						Return OSEncodings(k)
					End If
				Next
			Next
			
		End If
		
	Next
	
	Return "windows-1251"

End Sub

'List All Encodings
Public Sub ListAllEncodings()
	Dim OSEncodings() As String
	Dim bConv As ByteConverter
	
	OSEncodings = bConv.SupportedEncodings
	For i = 0 To OSEncodings.Length-1
		Log(OSEncodings(i))
	Next
End Sub

'Замяна на стринг Case Insensitive
Public Sub Replace(Source As String, Old As String, New As String) As String
Dim m As Matcher
Dim r As Reflector

	m = Regex.Matcher2(Old, Regex.CASE_INSENSITIVE, Source) 'Case Insensitive
	r.Target = m

	Return r.RunMethod2("replaceAll", New, "java.lang.String")
End Sub

'Функция за изчакване от 100 милисекунди
Public Sub SleepX
Dim ms As Int
Dim Now As Long

	ms = 500
	Now = DateTime.Now
	
	Do Until (DateTime.Now > (Now + ms))
		DoEvents							'Ignore
	Loop
End Sub

Private Sub CITAQID As String
	Dim r As Reflector
	Dim Api As Int
	Dim s As String = ""

	Api = r.GetStaticField("android.os.Build$VERSION", "SDK_INT")
	If Api >=19 Then
		Dim OS As OperatingSystem
		OS.Initialize("")
		If OS.Model.Contains("CITAQ") Then
			s = "MSM8625QSKUD"
		End If
	Else If Api >= 9 Then
		s = r.GetStaticField("android.os.Build", "SERIAL")
	End If
	Return s
End Sub

Public Sub CITAQ As Boolean
	If (CITAQID = "MSM8625QSKUD") Then
		Return True
	Else
		Return False
	End If
End Sub

Public Sub CITAQV8 As Boolean
	Dim OS As OperatingSystem
	OS.Initialize("")
	If (CITAQ And (OS.model == "CITAQ V8")) Then
		Return True
	Else
		Return False
	End If
End Sub

Public Sub CITAQH10 As Boolean
	Dim OS As OperatingSystem
	OS.Initialize("")
	If (CITAQ And (OS.Model == "CITAQ H10")) Then
		Return True
	Else
		Return False
	End If
End Sub
#End Region

'Превръща HEX в цвят със алфа канал
Public Sub ClrA(MyColor As String) As Int
	Dim A As Int
	Dim R As Int
	Dim G As Int
	Dim B As Int
	
	A = Bit.ParseInt(MyColor.SubString2(0,2), 16)
	R = Bit.ParseInt(MyColor.SubString2(2,4), 16)
	G = Bit.ParseInt(MyColor.SubString2(4,6), 16)
	B = Bit.ParseInt(MyColor.SubString2(6,8), 16)

	Return Colors.ARGB(A,R, G, B)
End Sub

'Добавя на padding отлявно и отдясно
Public Sub AddPadding(MyObj As Object, Left As Int, right As Int)
	Dim PaddingTopBottom = 2dip As Int
	Dim r As Reflector
	r.Target = MyObj
	r.RunMethod4("setPadding", Array As Object(Left, PaddingTopBottom, right, PaddingTopBottom), Array As String("java.lang.int", "java.lang.int", "java.lang.int", "java.lang.int"))
End Sub

'Nine Patch картинките трябва да са във \Objects\res\drawable със формат PNG
'Такъв вид картинка може да се направи със Android\tools\draw9patch.bat - drag & drop
'Картинките трябва да са read only - иначе се изтриват при компилация.
'Забележка - след промяна в съдържанието на папката drawable трябва да изчистите проекта със 
'Tools>Clean Project за да се отразят промените и да се добавят новите файлове.
Public Sub SetNinePatchDrawable(Control As View, ImageName As String)
	Dim r As Reflector
	Dim package As String
	Dim id As Int
	package = r.GetStaticField("anywheresoftware.b4a.BA", "packageName")
	id = r.GetStaticField(package & ".R$drawable", ImageName)
	r.Target = r.GetContext
	r.Target = r.RunMethod("getResources")
	Control.Background = r.RunMethod2("getDrawable", id, "java.lang.int")
End Sub

'Като Nine Patch но специално за бутони
Public Sub SetNinePatchButton(Btn As Button, DefaultImage As String, PressedImage As String, DisabledImage As String)
	Dim r As Reflector
	Dim package As String
	Dim idDefault, idPressed, idDisabled As Int
	package = r.GetStaticField("anywheresoftware.b4a.BA", "packageName")
	idDefault = r.GetStaticField(package & ".R$drawable", DefaultImage)
	idPressed = r.GetStaticField(package & ".R$drawable", PressedImage)
	idDisabled = r.GetStaticField(package & ".R$drawable", DisabledImage)
	r.Target = r.GetContext
	r.Target = r.RunMethod("getResources")
	Dim sd As StateListDrawable
	sd.Initialize
	sd.AddState(sd.State_Pressed, r.RunMethod2("getDrawable", idPressed, "java.lang.int"))
	sd.AddState(sd.State_Disabled, r.RunMethod2("getDrawable", idDisabled, "java.lang.int"))
	sd.AddCatchAllState( r.RunMethod2("getDrawable", idDefault, "java.lang.int"))
	Btn.Background = sd
End Sub

'Прилага скин върху бутон - добавен параметър за заобляне
Public Sub ApplyButtonSkin(btn As Button, TextColor As Int, ColorA As Int, ColorB As Int, ColorPressedA As Int, ColorPressedB As Int, ColorDisabledA As Int, ColorDisabledB As Int, CornerRound As Int)
	btn.TextColor = TextColor
	btn.Background = Gradient(ColorA, ColorB, ColorPressedA, ColorPressedB, ColorDisabledA, ColorDisabledB, CornerRound)
	MinimumPadding(btn)
End Sub

'Apply style to control. TextColor is only relevant for views that have it, but you should pass a value for others too.
Public Sub ApplyViewStyle (Control As View, TextColor As Int, ColorA As Int, ColorB As Int, ColorPressedA As Int, ColorPressedB As Int, ColorDisabledA As Int, ColorDisabledB As Int, CornerRound As Int)
	'Handle controls with TextColor
	If Control Is Button Then
		Dim btn As Button = Control
		btn.TextColor = TextColor
	End If

	If Control Is EditText Then
		Dim txt As EditText = Control
		txt.TextColor = TextColor
	End If
	
	If Control Is Spinner Then
		Dim sp As Spinner = Control
		sp.TextColor = TextColor
	End If
	
	'Apply background gradient
	Control.Background = Gradient(ColorA, ColorB, ColorPressedA, ColorPressedB, ColorDisabledA, ColorDisabledB, CornerRound)
	MinimumPadding(Control)
End Sub

'Задава градиент за фон на контролите в приложението - добавено заобляне
Private Sub Gradient(ColorA As Int, ColorB As Int, ColorPressedA As Int, ColorPressedB As Int, ColorDisabledA As Int, ColorDisabledB As Int, CornerRound As Int) As StateListDrawable

	'Дефинира два цвята за стандартния режим на бутона
	Dim colsEnabled(2) As Int
	
	colsEnabled(0) = ColorA
	colsEnabled(1) = ColorB
	'Дефинира градиент за стандартния режим на бутона
	Dim gdwEnabled As GradientDrawable
	gdwEnabled.Initialize("TOP_BOTTOM", colsEnabled)
	gdwEnabled.CornerRadius = CornerRound
	
	'Дефинира два цвята за натиснат бутон
	Dim colsPressed(2) As Int
	colsPressed(0) = ColorPressedA
	colsPressed(1) = ColorPressedB
	
	'Дефинира градиент за натиснат бутон
	Dim gdwPressed As GradientDrawable
	
	gdwPressed.Initialize("TOP_BOTTOM", colsPressed)
	gdwPressed.CornerRadius = CornerRound

	'Дефинира два цвята за неактивния режим на работа
	Dim colsDisabled(2) As Int
	colsDisabled(0) = ColorDisabledA
	colsDisabled(1) = ColorDisabledB
	
	'Дефинира градиент за натиснат бутон
	Dim gdwDisabled As GradientDrawable
	gdwDisabled.Initialize("TOP_BOTTOM", colsDisabled)
	gdwDisabled.CornerRadius = CornerRound

	'Дефинира StateListDrawable като контейнер на градиента
	Dim stdGradient As StateListDrawable
	stdGradient.Initialize
	Dim states(2) As Int
	states(0) = stdGradient.State_Enabled
	states(1) = -stdGradient.State_Pressed
	stdGradient.addState2(states, gdwEnabled)
	Dim states(1) As Int
	states(0) = stdGradient.State_Pressed
	stdGradient.addState2(states, gdwPressed)
	Dim states(1) As Int
	states(0) = stdGradient.State_Disabled
	stdGradient.addState2(states, gdwDisabled)
	' Връща градиента като параметър
	Return stdGradient
End Sub

'Добавя картинка върху бутона
'Картинката се добавя първа ако ще се ползва imagePadding
Public Sub AddImage (act As Panel, control As View, image As String, imagePadding As Boolean, leftOffset As Int)
	Dim imgX,imgY,buttonImageSize As Int
	Dim imageView As ImageView

	buttonImageSize = control.Height/2

	imgX = (control.Left + buttonImageSize/2)+leftOffset
	imgY = control.Top + buttonImageSize
	
	'Add image on top of button
	imageView.Initialize("")
	imageView.Bitmap = LoadBitmap(File.DirAssets,image)
	imageView.Gravity = Gravity.Fill 'Makes image fit in view

	act.AddView(imageView,imgX,imgY,buttonImageSize,buttonImageSize)
	imageView.Top = imageView.Top - imageView.Height/2
	
	'Add size to button
	If imagePadding Then control.Width = control.Width+imageView.Width*2
	imageView.BringToFront
End Sub

'Добавя сянка. За да се добави сянка и картинка: 
'-Картинката да се добави след сянката и без imagePadding(ще се размести)
Public Sub AddShadow(act As Panel,control As View,radius As Int, width As Int,color As Int, size As Int)
	Dim pan As Panel
	Dim col As ColorDrawable

	pan.Initialize("")
	col.Initialize2(color,radius,width,color)
	pan.Background=col
	act.AddView(pan,control.Left,control.Top,control.Width,control.Height+size)
	control.BringToFront
End Sub

'Добавя панел с прозрачен цвят и рамка отгоре на елемента. Рамката да се добавя последна
Public Sub AddBorder(act As Panel, control As View, radius As Int, width As Int, color As Int)
	Dim pan As Panel
	Dim col As ColorDrawable

	pan.Initialize("")
	col.Initialize2(Colors.Transparent, radius, width, color)
	pan.Background = col
	pan.Tag="Border"
	act.AddView(pan,control.Left - 1dip, control.Top - 1dip, control.Width, control.Height + 2dip)
	pan.BringToFront
End Sub

'Намаляване на размера на рамката на контрола
Public Sub MinimumPadding(MyObj As Object)
	Dim PaddingTopBottom = 1dip, PaddingLeftRight = 5dip As Int
	Dim r As Reflector
	r.Target = MyObj
	r.RunMethod4("setPadding", Array As Object(PaddingLeftRight, PaddingTopBottom, PaddingLeftRight, PaddingTopBottom), Array As String("java.lang.int", "java.lang.int", "java.lang.int", "java.lang.int"))
End Sub

Public Sub RemovePadding(MyObj As Object)
	Dim PaddingTopBottom = 0dip, PaddingLeftRight = 0dip As Int
	Dim r As Reflector
	r.Target = MyObj
	r.RunMethod4("setPadding", Array As Object(PaddingLeftRight, PaddingTopBottom, PaddingLeftRight, PaddingTopBottom), Array As String("java.lang.int", "java.lang.int", "java.lang.int", "java.lang.int"))
End Sub