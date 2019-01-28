B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=7.3
@EndOfDesignText@
Private Sub Process_Globals
End Sub
#Region Стрингови функции

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

Public Sub ReplaceEx(Source As String, Old As String, New As String, Index As Int) As String
	Dim I As Int = -1
	For o = 0 To Index
		I = Source.IndexOf2(Old, I + 1)
		If I = -1 Then Return Source
	Next
	Return Source.SubString2(0, I) & New & Source.SubString(I + Old.Length)
End Sub

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

#Region Системни и помощни функции
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

'Замяна на стринг Case Insensitive
Public Sub Replace(Source As String, Old As String, New As String) As String
Dim m As Matcher
Dim r As Reflector

	m = Regex.Matcher2(Old, Regex.CASE_INSENSITIVE, Source) 'Case Insensitive
	r.Target = m

	Return r.RunMethod2("replaceAll", New, "java.lang.String")
End Sub
#End Region

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


'Намаляване на размера на рамката на контрола
Public Sub MinimumPadding(MyObj As Object)
	Dim PaddingTopBottom = 1dip, PaddingLeftRight = 5dip As Int
	Dim r As Reflector
	r.Target = MyObj
	r.RunMethod4("setPadding", Array As Object(PaddingLeftRight, PaddingTopBottom, PaddingLeftRight, PaddingTopBottom), Array As String("java.lang.int", "java.lang.int", "java.lang.int", "java.lang.int"))
End Sub
