B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=7.3
@EndOfDesignText@
Sub Process_Globals
End Sub

Public Sub Remove_Padding (obj As Object)		'Премахва отстоянията / Remove padding
	Private pad = 0dip As Int
	Private reflect As Reflector
	reflect.Target = obj
	reflect.RunMethod4("setPadding", Array As Object(pad, pad, pad, pad), Array As String("java.lang.int", "java.lang.int", "java.lang.int", "java.lang.int"))
End Sub

Public Sub Add_Padding (obj As Object, left As Int, top As Int, right As Int, bottom As Int )		'Премахва отстоянията / Remove padding
	Private reflect As Reflector
	reflect.Target = obj
	reflect.RunMethod4("setPadding", Array As Object(left, top, right, bottom), Array As String("java.lang.int", "java.lang.int", "java.lang.int", "java.lang.int"))
End Sub

'Прилага визуалния стил върху контролите / Apply visual style over controls
Public Sub Apply_ViewStyle (Control As View, TextColor As Int, ColorA As Int, ColorB As Int, ColorPressedA As Int, ColorPressedB As Int, ColorDisabledA As Int, ColorDisabledB As Int, CornerRound As Int)
	If Control Is Button Then					'Handle controls with TextColor
		Private btn As Button = Control
		btn.TextColor = TextColor
	End If	
	If Control Is EditText Then
		Private txt As EditText = Control
		txt.TextColor = TextColor
	End If		
	If Control Is Spinner Then
		Private sp As Spinner = Control
		sp.TextColor = TextColor
		sp.DropdownBackgroundColor = Colors.ARGB(255, 13, 17, 135)
		sp.DropdownTextColor = Colors.ARGB(255, 213, 213, 229)
	End If		
	'Apply background gradient
	Control.Background = Helper_Gradient(ColorA, ColorB, ColorPressedA, ColorPressedB, ColorDisabledA, ColorDisabledB, CornerRound)
	Remove_Padding(Control)
End Sub

'Задава градиент за фон на контролите в приложението - добавено заобляне / Defines background gradient for controls and views in the app
Private Sub Helper_Gradient(ColorA As Int, ColorB As Int, ColorPressedA As Int, ColorPressedB As Int, ColorDisabledA As Int, ColorDisabledB As Int, CornerRound As Int) As StateListDrawable
	Private colsEnabled(2) As Int				'Дефинира два цвята за стандартния режим на бутона
	colsEnabled(0) = ColorA
	colsEnabled(1) = ColorB
	Private gdwEnabled As GradientDrawable		'Дефинира градиент за стандартния режим на бутона
	gdwEnabled.Initialize("TOP_BOTTOM", colsEnabled)
	gdwEnabled.CornerRadius = CornerRound	
	Private colsPressed(2) As Int				'Дефинира два цвята за натиснат бутон
	colsPressed(0) = ColorPressedA
	colsPressed(1) = ColorPressedB	
	Private gdwPressed As GradientDrawable		'Дефинира градиент за натиснат бутон
	gdwPressed.Initialize("TOP_BOTTOM", colsPressed)
	gdwPressed.CornerRadius = CornerRound
	Private colsDisabled(2) As Int				'Дефинира два цвята за неактивния режим на работа
	colsDisabled(0) = ColorDisabledA
	colsDisabled(1) = ColorDisabledB	
	Private gdwDisabled As GradientDrawable		'Дефинира градиент за натиснат бутон
	gdwDisabled.Initialize("TOP_BOTTOM", colsDisabled)
	gdwDisabled.CornerRadius = CornerRound
	Private stdGradient As StateListDrawable	'Дефинира StateListDrawable като контейнер на градиента
	stdGradient.Initialize
	Private states(2) As Int
	states(0) = stdGradient.State_Enabled
	states(1) = -stdGradient.State_Pressed
	stdGradient.addState2(states, gdwEnabled)
	Private states(1) As Int
	states(0) = stdGradient.State_Pressed
	stdGradient.addState2(states, gdwPressed)
	Private states(1) As Int
	states(0) = stdGradient.State_Disabled
	stdGradient.addState2(states, gdwDisabled)
	Return stdGradient							'Връща градиента като параметър / Returns Gradient as Parameter
End Sub

'To be changed later, when printer module are synchronised
'Побира контрола (изгледа) в основния скроу панел/Fit views inside Main Scroll panel
Public Sub FitViewsInScroll(targetScroll As ScrollView)
	Private viewLast As View = Find_LastView(targetScroll.Panel)
	If viewLast.IsInitialized Then targetScroll.Panel.Height = (viewLast.Top + viewLast.Height) + UISizes.DefaultPadding	
	targetScroll.ScrollPosition = 0
End Sub

'Намира последния контрол(изглед) / Finds the last view
Private Sub Find_LastView (pan As Panel) As View
	Private LastView As View
	LastView = pan.GetView(pan.NumberOfViews - 1)
	Return LastView
End Sub

Public Sub setButtonStyle(b As Button)
	Apply_ViewStyle(b,Colors.White,ProgramData.COLOR_BUTTON_NORMAL,ProgramData.COLOR_BUTTON_NORMAL,ProgramData.COLOR_BUTTON_PRESSED,ProgramData.COLOR_BUTTON_PRESSED,ProgramData.COLOR_BUTTON_DISABLED,ProgramData.COLOR_BUTTON_DISABLED,0)
End Sub