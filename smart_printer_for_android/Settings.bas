B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=7.3
@EndOfDesignText@
Private Sub Process_Globals
	Public ShowImages, ShowPrice, ShowCode, ShowBarcodeReader As Boolean
	Public obj, partner As String
	Public size As Int
	Public CONST AnimationTime As Int = 500
	Public settingsFilename As String = "POSSetting.config"
End Sub

'Дефиниране на начални стойности / Set values to default
public Sub SetDefaults
	ShowCode = True
	ShowPrice = True
	ShowImages = True
	ShowBarcodeReader = True
	size = 3
	obj = ""
	partner = ""
End Sub

Public Sub SaveSettings
	Private randomFile As RandomAccessFile
	randomFile.Initialize(File.DirDefaultExternal, settingsFilename, False)
	randomFile.WriteEncryptedObject(ShowCode, ProgramData.rafEncPass, randomFile.CurrentPosition)
	randomFile.WriteEncryptedObject(ShowPrice, ProgramData.rafEncPass, randomFile.CurrentPosition)
	randomFile.WriteEncryptedObject(ShowImages, ProgramData.rafEncPass, randomFile.CurrentPosition)
	randomFile.WriteEncryptedObject(ShowBarcodeReader, ProgramData.rafEncPass, randomFile.CurrentPosition)
	randomFile.WriteEncryptedObject(size, ProgramData.rafEncPass, randomFile.CurrentPosition)
End Sub

public Sub LoadSettings
	Try
		If File.Exists(File.DirDefaultExternal, settingsFilename) = True And File.Size(File.DirDefaultExternal, settingsFilename) > 0 Then
			Private raf As RandomAccessFile
			raf.Initialize(File.DirDefaultExternal, settingsFilename, False)			
			ShowCode = raf.ReadEncryptedObject(ProgramData.rafEncPass, raf.CurrentPosition)
			ShowPrice = raf.ReadEncryptedObject(ProgramData.rafEncPass, raf.CurrentPosition)
			ShowImages = raf.ReadEncryptedObject(ProgramData.rafEncPass, raf.CurrentPosition)
			ShowBarcodeReader = raf.ReadEncryptedObject(ProgramData.rafEncPass, raf.CurrentPosition)
			size = raf.ReadEncryptedObject(ProgramData.rafEncPass, raf.CurrentPosition)
		Else 'No config file exists so check for language
			SetDefaults
			SaveSettings
		End If
	Catch
		Log("LoadPosSettingsStandart Exeption: " & LastException)
		SetDefaults
		SaveSettings
	End Try
End Sub