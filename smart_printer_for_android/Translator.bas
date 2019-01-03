B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=7.3
@EndOfDesignText@
'Това е оптимизиран транслатор.
'Премахнат е част от кода който се отнася за Translation Tool и не е нужен за работа
'Махнати са изпълненията на Utilites.CopyObject и са заменени с собствени методи - където е възможно защото това бави устройството
Private Sub Class_Globals
	Type Product(productName As String, languageMap As Map, languageList As List, languagesDisplayNames As Map, dictionaryVersion As Int , dictionary As Map, languagesBeforeUpdate As Map, languageCounter As Int, selectedLanguage As Int)
	Private workingProduct As Product
	Private dictionaryVersion, EN As Int		'Ignore (the variable is actually used, the ide is buggy)
	Private productsVersionsMap As Map 'productName is the key, version for this key is the value
	Private selectedProduct As String 'choosed product to translation
	'contains translations for every key
	Private allDictionaries As Map 'all products and data for them is saved there, for android project there is only the loaded translations for selected product
	Private dictionary As Map 'loaded dictionary for selected product
	Private fileDirPath As String 'path to dictionary.xml
	'xml file name
	Private xmlParser As SaxParser
	'for replenishing the dictionary map
	Private xmlItemValues As List
	'variables used to parse the xml
	Private languageForParsing, displayNameForParsing, keyForParsing, productNameForParsing As String
	Private isImporting As Boolean = False 'Flag raised when is importing a new language
	Private indexOfLanguageToUpdate As Int 'id of language to update
	Private unknownAbbreviature As String 'For importing new language...
	Private langAbbreviature As String 'saves last item language abbreviature when importing or updating new language
End Sub

'Инициализиране на обекта / Initializes the object
Public Sub Initialize()
#If Not(TranslationTool)
	fileDirPath = File.DirRootExternal
#end if
	workingProduct.Initialize
	Try
		If Version.ProductID > 99 Then
			If File.Exists(fileDirPath, Version.Path & "/dictionary.xml") Then
				Open_XML(fileDirPath,  Version.Path & "/dictionary.xml")
			Else
				Open_XML(File.DirAssets, "dictionary.xml")
			End If
		End If
'		isInitialized = True
	Catch
		Log(LastException.Message)
	End Try
	unknownAbbreviature = "UNKNOWN ABBREVIATION"
End Sub

'Първоначална инициализация на речника и езиците, парсира xml фаила по име или пътека /'Initializes 
'dictionary, languageMap and languageList for the first time and parses the xml file by given path and name
'filePath - path to the file
'fileName - name and extension (.xml) of the file
Private Sub Open_XML(filePath As String, fileName As String)
	ResetVariables
	productsVersionsMap.Initialize
	allDictionaries.Initialize
	Parse_XML(filePath, fileName)
	SetProduct(selectedProduct)
	If workingProduct.IsInitialized And workingProduct.languagesBeforeUpdate.Size > 0 Then
		Private currentProduct As Product = allDictionaries.Get(workingProduct.productName)
		currentProduct.languagesBeforeUpdate = workingProduct.languagesBeforeUpdate
	End If
End Sub

'Парсира xml фаила и създава речник и списък с езици / Parses the xml file and generates the dictionary 
'and languageList
Private Sub Parse_XML(filePath As String, fileName As String)
	Private xmlText As InputStream
	xmlText = File.OpenInput(filePath, fileName)
	xmlParser.Initialize
	xmlParser.parse(xmlText, "xmlParser")
	xmlText.Close
End Sub

'Изпълнява се по време на парсирането - стартиране/ Raises during parsing the xml - start
Private Sub xmlParser_StartElement (Uri As String, Name As String, Attributes As Attributes)
	If Not (productsVersionsMap.IsInitialized) Then productsVersionsMap.Initialize
	Private productName As String
	Private productVersion As Int
	For i = 0 To Attributes.Size - 1
		If Attributes.GetName(i) = "Version" Then productVersion = Attributes.GetValue(i)
		If Attributes.GetName(i) = "Product" Then productName = Attributes.GetValue(i)
		If Attributes.GetName(i) = "Lang" Then languageForParsing = Attributes.GetValue(i)
		If Attributes.GetName(i) = "Key" Then keyForParsing = Attributes.GetValue(i)
		If Attributes.GetName(i) = "DisplayName" Then displayNameForParsing = Attributes.GetValue(i)
	Next
	If productName.Length > 0 Then
		productsVersionsMap.Put(productName, productVersion)
		productNameForParsing = productName
		dictionaryVersion = productVersion
	End If
End Sub

'Нулира всички променливи за заредения продукт / Resets all variables for loaded product
Private Sub ResetVariables
	dictionary.Initialize
	workingProduct.Initialize
	workingProduct.languageMap.Initialize
	workingProduct.languagesDisplayNames.Initialize
	workingProduct.languagesBeforeUpdate.Initialize
	workingProduct.languageList.Initialize
	workingProduct.languageCounter = 0
End Sub

'Изпълнява се по време на парсирането - край / Raises during parsing the xml - end
Private Sub xmlParser_EndElement (Uri As String, Name As String, Text As StringBuilder)
	If xmlParser.Parents.IndexOf("TranslationDictionaries") > -1 Then
		If Name = "Dictionary" And dictionary.Size > 0 Then
			If isImporting And workingProduct.productName <> productNameForParsing Then Return
'			UpdateLanguagesForNextImport
			Private currentProduct As Product
			currentProduct.Initialize
			currentProduct.languageList.Initialize
			currentProduct.languageMap = Duplicate_Map (workingProduct.languageMap)
			currentProduct.languageList.AddAll(workingProduct.languageList)
			currentProduct.languagesDisplayNames = Duplicate_Map(workingProduct.languagesDisplayNames)
			currentProduct.dictionaryVersion = dictionaryVersion
			currentProduct.dictionary = Duplicate_Map(dictionary)
			currentProduct.productName = productNameForParsing
			currentProduct.languagesBeforeUpdate = Duplicate_Map(workingProduct.languagesBeforeUpdate)
			currentProduct.languageCounter = workingProduct.languageCounter
			currentProduct.selectedLanguage = workingProduct.selectedLanguage
			allDictionaries.Put(productNameForParsing, currentProduct)
			If productNameForParsing = "TranslationTool" Or productNameForParsing = Version.ProductInDictionary Then
				allDictionaries.Put(productNameForParsing, currentProduct)
				selectedProduct = Version.ProductInDictionary
			End If
			ResetVariables
			Return
		End If
		langAbbreviature = languageForParsing
		If Name = "Language" Then
			Generate_LanguageList(Text)
		End If
		If Name = "Data" Or Name = "Value" Then
			If workingProduct.languagesBeforeUpdate.ContainsKey(languageForParsing) Then
				For Each key As String In workingProduct.languagesBeforeUpdate.Keys
					Private value As Int = workingProduct.languagesBeforeUpdate.Get(key)
					Private languageKey As Int = workingProduct.languageMap.Get(languageForParsing)
					If languageKey = value Then
						indexOfLanguageToUpdate = value
						langAbbreviature = key
						Exit
					End If
				Next
				If isImporting And indexOfLanguageToUpdate = EN Then Return
			Else
				If Not(workingProduct.languagesBeforeUpdate.ContainsKey(langAbbreviature)) Then
					langAbbreviature = unknownAbbreviature
				End If
			End If
			If Name = "Value" Then Name = languageForParsing
			If Name = "Data" Then Name = keyForParsing
			Generate_MapRow(Name, Text, langAbbreviature)
		End If
	End If
End Sub

'Проверка за дублиращи се елементи / Duplicate elements check
Private Sub Duplicate_Map (source As Map) As Map
	Private copyMap As Map
	copyMap.Initialize
	For Each key As String In  source.Keys
		copyMap.Put(key,source.Get(key))
	Next
	Return copyMap
End Sub

'Създава списък с езици както и мап / Generates languageList and map. languageMap is mapping for languages.
'langAbbreviation - the abbreviation of language like EN, BG, RU...
Private Sub Generate_LanguageList(langAbbreviation As String)
	langAbbreviation = langAbbreviation.ToUpperCase
	If Not(workingProduct.languageMap.ContainsKey(langAbbreviation)) Then
		workingProduct.languageMap.Put(langAbbreviation, workingProduct.languageCounter)
		If Not (workingProduct.languagesDisplayNames.IsInitialized) Then workingProduct.languagesDisplayNames.Initialize
		workingProduct.languagesDisplayNames.Put(langAbbreviation, displayNameForParsing)
		workingProduct.languageList.Add(langAbbreviation)
		workingProduct.languageCounter = workingProduct.languageCounter+1
	End If
End Sub

'Запазва индексите и стойностите им за речника / Saves the key and all translations for its value.
'Name - this must be the key
'Text - value for current key
Private Sub Generate_MapRow(Name As String, Text As StringBuilder, Language As String)
	If(Name.Length <> 2) Then
		Private newRecords As List
		newRecords.Initialize
		newRecords.AddAll(xmlItemValues)
		If isImporting Then
			If workingProduct.languagesBeforeUpdate.ContainsKey(Language) And Language <> "EN" And Language <> unknownAbbreviature Then
				Dim keyTranslation As String = xmlItemValues.Get(xmlItemValues.Size-1)
				Update_ExistingLanguage(Name, keyTranslation)
			Else
				Import_NewLanguage(Name, newRecords)
			End If
			Return
		End If
		dictionary.Put(Name, newRecords)
		xmlItemValues.Clear
		Return
	End If
	If Not(xmlItemValues.isInitialized) Then xmlItemValues.Initialize
	xmlItemValues.Add(Text.ToString)
End Sub

'Проверка за успешно опресняване - ако стойността на индексът е нова опресняване не е необходимо 
'/ Return true if the update is successful and false if the key is new and update is not needed.
'newRecords - this must be the row with values to add if the update is needed.
Private Sub Import_NewLanguage(key As String, values As List)
	If(dictionary.ContainsKey(key)) Then
		If productNameForParsing = selectedProduct Then
			Private updateList As List = dictionary.Get(key)
			updateList.Add(values.Get(values.Size-1))
			dictionary.Put(key, updateList)
			xmlItemValues.Clear
		End If
	End If
End Sub

'Заменя превода с по-нов запис / Replaces translation for given key with new records
Private Sub Update_ExistingLanguage(key As String, data As String)
	If(dictionary.ContainsKey(key)) Then
		Private updateList As List = dictionary.Get(key)
		dictionary.Remove(key)
		updateList.Set(indexOfLanguageToUpdate, data)
		dictionary.Put(key, updateList)
		xmlItemValues.Clear
	End If
End Sub

'Връща езиците / Returns the langugages
Public Sub Get_LanguageList() As List
	Return workingProduct.languageList
End Sub

'Избира продукт (като име на програма) / Set product (name of the app)
Private Sub SetProduct(productName As String)
	If allDictionaries.ContainsKey(productName) Then
		workingProduct = allDictionaries.Get(productName) 'Това е Референция TODO - дали е нужно да се "счупи"?
		dictionary.Clear
		dictionary = Duplicate_Map(workingProduct.dictionary)
		selectedProduct = productName
		dictionaryVersion = workingProduct.dictionaryVersion
	End If
End Sub

'Дефинира език /Sets the language lang - language abbreviation like EN, BG, RU ...
Public Sub SetLanguage(lang As String)
	lang = lang.ToUpperCase
	If (workingProduct.languageMap.ContainsKey(lang)) Then workingProduct.selectedLanguage = workingProduct.languageMap.Get(lang)
End Sub

'Взима езикът / Get the language
Private Sub Get_Language() As String
	Return workingProduct.selectedLanguage
End Sub

'Връща преведената стойност на индекса / Returns translated value for given key
'key - searches translated value with this key
Public Sub GetString(key As String) As String
	If (dictionary.ContainsKey(key)) Then
		Return Get_Translation(key)
	Else
		Return Get_Translation("strStringNotFound")
	End If
End Sub

'Връща стойност при търсене през индекс / Private method for getting the translation value by given key
Private Sub Get_Translation(key As String) As String
	Try
		Private translationString As String = Get_TranslatedString(key, workingProduct.selectedLanguage)
		If(translationString <> "") Then
			Return translationString
		Else
			Return Get_TranslatedString(key, EN)
		End If
	Catch
		translationString = "NOT TRANSLATED"
		Log("ERROR IN KEY: " & key)
		Return translationString
	End Try
End Sub

'Връща преведена стойност към ключ за избрания език / Returns translated value with the given key for 
'the current language
Private Sub Get_TranslatedString(key As String, language As Int) As String
	Try
		Private strTranslationList As List = dictionary.Get(key)
		If language < strTranslationList.Size Then
			Private translatedString As String = strTranslationList.Get(language)
		End If
		Return translatedString
	Catch
		translatedString = "NOT TRANSLATED"
		Log("ERROR IN KEY: " & key)
		Return translatedString
	End Try
End Sub