B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=7.3
@EndOfDesignText@
Private Sub Class_Globals
	Private Callback,PrinterMainRef As Object 'Ignore
	Private basePanel As Panel
	Private miScroll As MiScrollView
	Private SVItems As List
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize (CallbackObject As Object,PMainRef As Object)
	PrinterMainRef = PMainRef
	Callback = CallbackObject
	basePanel.Initialize("basePanel")
	SVItems.Initialize
End Sub

Public Sub BuildScreen(parent As Panel)
	parent.AddView(basePanel,0,0,parent.Width,parent.Height)
	miScroll.Initialize
	basePanel.AddView(miScroll.ScrollView,0,0,basePanel.Width,basePanel.Height)
End Sub

Public Sub Reset
	SVItems.Clear
	miScroll.removeAllViews
End Sub

public Sub addPrinter(printer As TActivePrinter)
	Dim fiscal As Boolean = CallSub(printer.driver,"getFiscal_MemoryMode")
	
	Dim SVItem As PrinterStatusSVItem
	SVItem.Initialize(Callback,printer,fiscal,False)
	
	SVItem.Build(miScroll,basePanel.Width,basePanel.Height)
	
	SVItems.Add(SVItem)
End Sub

Public Sub removePrinter(index As Int)
	If SVItems.Size = 0 Then Return
	Dim tempSVItem As PrinterStatusSVItem = SVItems.Get(index)
	
	tempSVItem.removeView
	SVItems.RemoveAt(index)
End Sub