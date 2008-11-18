if (A_IsCompiled) {
; Revisionsinformation bereits verf�gbar
} else {
; Revisionsinformation nicht verf�gbar oder nicht zuverl�ssig, neu generieren
  if (FileExist(".svn")<>False) {
    ; .svn existiert, scheint also ausgecheckt worden zu sein
    RegRead,TSVNPath,HKLM,SOFTWARE\TortoiseSVN,Directory
    RegRead,SVNPath,HKLM,SOFTWARE\CollabNet\Subversion\1.5.4\Client,Install Location
    if (TSVNPath<>"") {
      ; fein, TSVN ist installiert!
      RunWait, "%TSVNPath%bin\SubWCRev.exe" "." "Source\_subwcrev1.tmpl.ahk" "Source\_subwcrev1.generated.ahk",,Hide
      FileRead,TSVNRevFull,Source\_subwcrev1.generated.ahk
      RegExMatch(TSVNRevFull,"""(.*)""",SubPat)
      Revision := SubPat1
    } else if (SVNPath<>"") {
      ; fein, CollabNet-SVN-Client ist installiert!
      RunWait, %comspec% /c ""%SVNPath%\svnversion.exe" "." >"Source\_svnversion.generated.txt"",,Hide
      FileRead,SVNRevFull,Source\_svnversion.generated.txt
      RegExMatch(SVNRevFull,"(.*)$",SubPat)
      Revision := SubPat1
    } else {
      ; nichts installiert. Was jetzt?
      Revision := "<unknown>"
    }
  } else {
    ; kein .svn-Verzeichnis. Was jetzt?
    Revision := "<unknown>"
  }
}

name=Neo 2.0 r%Revision%-r%CompRevision% (%A_ScriptName%)
enable=Aktiviere %name%
disable=Deaktiviere %name%
#LTrim ; Quelltext kann einger�ckt werden

SetCapsLockState Off
SetNumLockState Off
SetScrollLockState Off

EnvGet, WindowsEnvAppDataFolder, APPDATA
ApplicationFolder = %WindowsEnvAppDataFolder%\NEO2
FileCreateDir, %ApplicationFolder%
ini = %ApplicationFolder%\NEO2.ini

bildschirmTastaturEinbinden := 1
IniRead,einHandNeo,%ini%,Global,einHandNeo,0
IniRead,lernModus,%ini%,Global,lernModus,0
IniRead,zeigeLockBox,%ini%,Global,zeigeLockBox,1
IniRead,zeigeModusBox,%ini%,Global,zeigeModusBox,1
IniRead,UseMod4Light,%ini%,Global,UseMod4Light,1
IniRead,LangSTastatur,%ini%,Global,LangSTastatur,0
If LangSTastatur
  CharProc("LnS1")
else
  KeyboardLED(2,"off") ; deaktivieren, falls sie doch brennt
IniRead,isVM,%ini%,Global,isVM,0
if (isVM)
  CharProc("_VM1")
IniRead,striktesMod2Lock,%ini%,Global,striktesMod2Lock,0

regread,inputlocale,HKEY_CURRENT_USER,Keyboard Layout\Preload,1
regread,inputlocalealias,HKEY_CURRENT_USER,Keyboard Layout\Substitutes,%inputlocale%
if (inputlocalealias<>inputlocale=%inputlocalealias% and inputlocale<>00000407) {
  suspend   
  regread,inputlocale,HKEY_LOCAL_MACHINE,SYSTEM\CurrentControlSet\Control\Keyboard Layouts\%inputlocale%,Layout Text
  msgbox, 48, Warnung!,
    (
    Nicht kompatibles Tastaturlayout:   
    `t%inputlocale%   
    `nDas deutsche QWERTZ muss als Standardlayout eingestellt  
    sein, damit %name% wie erwartet funktioniert.   
    `n�ndern Sie die Tastatureinstellung unter 
    `tSystemsteuerung   
    `t-> Regions- und Sprachoptionen   
    `t-> Sprachen 
    `t-> Details...   `n
    )
  exitapp
}
guiErstellt := 0
alwaysOnTop := 1
wasNonShiftKeyPressed := 0
isShiftRPressed := 0
isShiftLPressed := 0
isShiftPressed := 0
isMod2Locked := 0
IsMod3RPressed := 0
IsMod3LPressed := 0
IsMod3Pressed := 0
IsMod4RPressed := 0
IsMod4LPressed := 0
IsMod4Pressed := 0
IsMod4Locked := 0
EbeneAktualisieren()
; die Nachfolgenden sind n�tzlich um sich die Qwertz-Tasten abzugew�hnen, da alle auf der 4. Ebene vorhanden.
lernModus_std_Return := 0
lernModus_std_Backspace := 0
lernModus_std_PgUp := 0
lernModus_std_PgDn := 0
lernModus_std_Einf := 0
lernModus_std_Entf := 0
lernModus_std_Pos0 := 0
lernModus_std_Ende := 0
lernModus_std_Hoch := 0
lernModus_std_Runter := 0
lernModus_std_Links := 0
lernModus_std_Rechts := 0
lernModus_std_ZahlenReihe := 0
lernModus_neo_Backspace := 0
lernModus_neo_Entf := 1
