B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=7.3
@EndOfDesignText@
'Code module
'Subs in this code module will be accessible from all modules.
Sub Process_Globals
	'These global variables will be declared once when the application starts.
	'These variables can be accessed from all modules.
	Private CountriesMap As Map
	Private counter As Int = 0
	
	Public SelectedCountry As Int
	
	Public const Universe As Int = 0
	
	Public Belarus As Int
	Public Bulgaria As Int
	Public Cuba As Int
	Public Cyprus As Int
	Public Greece As Int
	Public Kazakhstan As Int
	Public Kenya As Int
	Public Moldova As Int
	Public Romania As Int
	Public Russia As Int
	Public SaudiArabia As Int
	Public Spain As Int
	Public Tanzania As Int
	Public Turkey As Int
	Public Turkmenistan As Int
	Public Ukraine As Int
	Public Uzbekistan As Int
End Sub

Public Sub Initialize
	CountriesMap.Initialize
	counter = -1
	Belarus 		= addCountry("Belarus")
	Bulgaria 		= addCountry("Bulgaria")
	Cuba 			= addCountry("Cuba")
	Cyprus 			= addCountry("Cyprus")
	Greece			= addCountry("Greece")
	Kazakhstan 		= addCountry("Kazakhstan")
	Kenya 			= addCountry("Kenya")
	Moldova 		= addCountry("Moldova")
	Romania			= addCountry("Romania")
	Russia			= addCountry("Russia")
	SaudiArabia		= addCountry("Saudi Arabia")
	Spain 			= addCountry("Spain")
	Tanzania 		= addCountry("Tanzania")
	Turkey 			= addCountry("Turkey")
	Turkmenistan	= addCountry("Turkmenistan")
	Ukraine			= addCountry("Ukraine")
	Uzbekistan 		= addCountry("Uzbekistan")
End Sub

Private Sub addCountry(name As String) As Int
	counter = counter + 1
	CountriesMap.Put(name, counter)
	Return counter
End Sub

Public Sub getCountries As Map
	Return CountriesMap
End Sub

public Sub setSelectedCountry(key As Int)
	SelectedCountry = CountriesMap.GetValueAt(key)
End Sub

Public Sub getSelectedCountryName As String
	For Each country As String In CountriesMap.Keys
		If CountriesMap.Get(country) = SelectedCountry Then 
			Return country
		End If
	Next
	
	Return "Bulgaria"
End Sub