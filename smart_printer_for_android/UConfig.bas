B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=8.8
@EndOfDesignText@
'Code module
'Subs in this code module will be accessible from all modules.
Sub Process_Globals
	'These global variables will be declared once when the application starts.
	'These variables can be accessed from all modules.
	Public USConfig As UserConfig
End Sub

Public Sub writeUSConfig
	Try
		Dim RAF As RandomAccessFile
		RAF.Initialize(Main.SHAREDFolder, "LangAndContry.config", False)
		RAF.WriteEncryptedObject(USConfig, ProgramData.rafEncPass, RAF.CurrentPosition)
		RAF.Close
	Catch
		Log(LastException)
		Msgbox(Main.translate.GetString("msgFailedToSavePrinters"), Main.translate.GetString("lblWarning"))
	End Try
End Sub

Public Sub LoadSavedUSConfig
	Try
		If File.Exists(Main.SHAREDFolder, "LangAndContry.config") Then
			Dim RAF As RandomAccessFile
			RAF.Initialize(Main.SHAREDFolder, "LangAndContry.config", True)
			USConfig = RAF.ReadEncryptedObject(ProgramData.rafEncPass, RAF.CurrentPosition)
			RAF.Close
			Main.SelectedLanguage = USConfig.language
			Main.translate.SetLanguage(USConfig.language)
			Countries.setSelectedCountry(USConfig.country)
		Else
			USConfig.Initialize
			USConfig.country = 1		
			USConfig.language = "BG"
			Main.SelectedLanguage = USConfig.language
			Main.translate.SetLanguage(USConfig.language)
			Countries.setSelectedCountry(USConfig.country)
			writeUSConfig
		End If
	Catch
		Msgbox("Fail load USConfig ","Warrning")
		Log(LastException)
	End Try
End Sub