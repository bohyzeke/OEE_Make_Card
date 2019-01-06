#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Version=beta
#AutoIt3Wrapper_icon=Source\ZF.ico
#AutoIt3Wrapper_outfile=Bin\Make_Card.exe
#AutoIt3Wrapper_Res_Comment=ZF Slovakia Automation Pluss  Make_Card
#AutoIt3Wrapper_Res_Description=ZF Slovakia Automation Pluss  Make_Card
#AutoIt3Wrapper_Res_Fileversion=0.1.0.4
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_LegalCopyright=ZF Slovakia
#AutoIt3Wrapper_Res_Field=Company|ZFSlovakia
#AutoIt3Wrapper_Res_Field=Creator| Eduard Bohacek
#AutoIt3Wrapper_Res_Field=PerNo |2226
#AutoIt3Wrapper_Res_Field=Tel.no|9760
#AutoIt3Wrapper_Add_Constants=n
#Tidy_Parameters=/tc 3 /gd
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
; *** Start added by AutoIt3Wrapper ***
#include <AutoItConstants.au3>
#include <ButtonConstants.au3>
#include <FileConstants.au3>
; *** End added by AutoIt3Wrapper ***


#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.1
 Author:		Eduard Bohacek
 Script Name : 	Make Card
 Version : 		0.1.0.4
 Date : 		2018 10 06

 Script Function:
	Vytvorenie Karty pre ILC Phoenix.
	Editovanie Konfigu ILC cez FTP Protokol
	Spustanie podpornych funkcii pre ILC

#ce ----------------------------------------------------------------------------

Opt("MustDeclareVars", 1)

#include <File.au3>
#include <MsgBoxConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiListView.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <FTPEx.au3>
#include <WinAPI.au3>
#include <GuiButton.au3>


Global $Dir = @ScriptDir
Global $INI = $dir &"\seting.ini"
Global $Dest = IniRead($INI, "SETING","Destination","E:")
Global $SerIP = IniRead ( $INI,"configserver","ip","10.26.48.23")
Global $ILCName = IniRead( $INI,"ILC","Name","TRNF56001")
Global $ILCSerial = IniRead($INI,"ILC","Serial","001234567890")
Global $data=""
Global $fIlcType, $EditNo ,$ILCIP
global $test= 1
Global $Eror = False



Global $MainWin = GUICreate("ILC Konfig", 300, 300)

; menu items
Global $idSetting 	= GUICtrlCreateMenu("&Setting")
Global $idSetPath 	= GUICtrlCreateMenuItem("&Destination",$idSetting)
Global $idHel 		= GUICtrlCreateMenu("&Help")

;Zakladne menu
GUICtrlCreateLabel("DNS Name",5,10)
Global $idILCName = GUICtrlCreateInput($ILCName,80,5,100)

;~ Global $Test = GUICtrlCreateButton("Test", 250,5)

; Vytvorenie tabov pre funkcie
Local $idTab = GUICtrlCreateTab(5,35,290,240)

; Tab Vytvor kartu
GUICtrlCreateTabItem("Make Card")
GUICtrlCreateLabel("Serial no.",10, 75)
Global $idHWSerial = GUICtrlCreateInput($ILCSerial,80,70,100)

Global $idILC170 = GUICtrlCreateRadio("ILC 170",50,100)
Global $idILC191 = GUICtrlCreateRadio("ILC 191",50,120)
Global $idILC191MS = GUICtrlCreateRadio("ILC 191MS",170,100)
Global $idILC191MY = GUICtrlCreateRadio("ILC 191MY",170,120)
Global $idCartWrite = GUICtrlCreateButton("Write Card",75,150,130,80)

; Tab Podpornych programov
GUICtrlCreateTabItem("Utility")

Global $idUtilCMD = GUICtrlCreateButton("CMD",20,90,120,30)
Global $idUtilWeb = GUICtrlCreateButton("WEB",150,90,120,30)
Global $idUtilIpAsign = GUICtrlCreateButton("IpAsign",20, 130,120,30)
Global $idUtilConnect = GUICtrlCreateButton("Connect Plus",150,130,120,30)

;~ Tab "Ftp update"
GUICtrlCreateTabItem("FTP Update")
GUICtrlCreateLabel ("Server IP :", 10,75)
Local $idFSerIP = GuiCtrlcreateinput ($SerIP, 80, 70,80)
GUICtrlSetState($idFSerIP ,$GUI_DISABLE)
GUICtrlCreateLabel ("ILC IP :", 10,97)
Local $idFILCIP = GUICtrlCreateinput ("",80,95,80)
GUICtrlSetState($idFILCIP ,$GUI_DISABLE)
GUICtrlCreateLabel ("ILC Name :",10,122)
Local $idFilcName = GUICtrlCreateInput ("",80,120,80)
GUICtrlSetState($idFilcName,$GUI_DISABLE)
GUICtrlCreateLabel ("Serial no. :",10,147)
Local $idFSerNo = GUICtrlCreateInput ("",80,145,80)
GUICtrlSetState($idFSerNo,$GUI_DISABLE)
Local $idFeSerIP = GUICtrlCreateButton ("Change",160,70,50,20)
Local $idFeILCIP = GUICtrlCreateButton ("Change",160,95,50,20)
Local $idFeilcName = GUICtrlCreateButton ("Change",160,120,50,20)
Local $idFeSerNo = GUICtrlCreateButton ("Change",160,145,50,20)

Local $idEditServer = GUICtrlCreateInput($SerIP ,170,70,80)
GUICtrlSetState($idEditServer , $GUI_HIDE)
Local $idEditILCIP = GUICtrlCreateInput("" ,170,95,80)
GUICtrlSetState($idEditILCIP , $GUI_HIDE)
Local $idEditilcName = GUICtrlCreateInput("" ,170,120,80)
GUICtrlSetState($idEditilcName , $GUI_HIDE)
Local $idEditSerNo = GUICtrlCreateInput("" ,170,145,80)
GUICtrlSetState($idEditSerNo , $GUI_HIDE)

Local $idFGet = GUICtrlCreateButton("Stiahni",70,200,50)
Local $idFWrite = GUICtrlCreateButton("Zapis", 150,200, 50)




GUISetState()

; Main loop
; Status: Uvolnena
; Start : 0.0.0.0
; Zmena : 0.1.0.5
; Popis : Hlavny program
Local $idMsg
	; Loop until the user exits.
	While 1
	   $idMsg = GUIGetMsg()
	   If $idMsg = $idUtilConnect Then	; Spustenie Connect+
		  If not WinExists("Connect+ V1.1.2") Then
			Run ("C:\Program Files (x86)\Phoenix Contact\Connect Plus\ConnectPlus.exe")
		  EndIf
		  WinWait("Connect+ V1.1.2")
		  WinMove("Connect+ V1.1.2","",720,0,670,900)
		  WinActivate("Connect+ V1.1.2")
		  WinWaitActive("Connect+ V1.1.2")
;~ 		  Send("{TAB}{TAB}^A10")
		  WinActivate("ILC Konfig")
	   EndIf
	   If $idMsg = $idUtilIpAsign Then	; Spustenie IPasign
		  Run($Dir &"\Source\IPAssign.exe")
		  WinWait("Phoenix Contact - IP Assignment Tool")
		  WinMove("Phoenix Contact - IP Assignment Tool","",10,325)
	   EndIf
	   If $idMsg = $idUtilCMD Then		; Spustenie CMD
		  GETIP()
		  CMD()
	   EndIf
	   If $idMsg = $idCartWrite Then 	; Zapisanie konfigu na kartu
		  If GUICtrlRead ($idILC170) = $GUI_CHECKED then Card170()
		  If GUICtrlRead ($idILC191) = $GUI_CHECKED then CARD191()
		  If GUICtrlRead ($idILC191MS) = $GUI_CHECKED then CARD191MS()
		  If GUICtrlRead ($idILC191MY) = $GUI_CHECKED then CARD191MY()
		  If GUICtrlRead ($idILC170) = $GUI_UNCHECKED And GUICtrlRead ($idILC191) = $GUI_UNCHECKED And GUICtrlRead ($idILC191MY)= $GUI_UNCHECKED And GUICtrlRead ($idILC191MY)= $GUI_UNCHECKED  Then
			 MsgBox( $MB_ICONWARNING, "Chyba","Oznac typ ILC")
		  EndIf
		  If $eror == False then
			 GUICtrlSetState($idILC170,$GUI_UNCHECKED )
			 GUICtrlSetState($idILC191,$GUI_UNCHECKED )
			 GUICtrlSetState($idILC191MS,$GUI_UNCHECKED )
			 GUICtrlSetState($idILC191MY,$GUI_UNCHECKED )
;~ 			 GUICtrlSetData($idHWSerial,"00")
			 GUICtrlSetData($idHWSerial,"001234567890")
		  EndIf
	   EndIf
	   If $idMsg = $idFGet Then 		; FTP Nacitanie ILC konfigu cez ftp
		  ;FileDelete ( $Dir&"\temp\CONFIG.XML" )
		  GETIP()
		  FtpGetFile()
		  CheckFileVersion()
		  GetFileData()
	   EndIf
	   If $idMsg = $idTab Then TabSel() ; Zmena Tabu
	   If $idMsg = $idFeSerIP Then		; FTP Povolenie zmeny servra
		  GUICtrlSetState($idFeSerIP , $GUI_HIDE)
		  GUICtrlSetState($idEditServer, $GUI_SHOW)
		  $EditNO = $EditNo + 1
	   EndIf
	   If $idMsg = $idFeILCIP Then		; FTP Povolenie zmeny ILCIP
		  GUICtrlSetState($idFeILCIP , $GUI_HIDE)
		  GUICtrlSetState($idEditILCIP, $GUI_SHOW)
		  $EditNO = $EditNo + 2
	   EndIf
	   If $idMsg = $idFeilcName Then	; FTP Povolenie zmeny ILC mena
		  GUICtrlSetState($idFeilcName , $GUI_HIDE)
		  GUICtrlSetState($idEditilcName, $GUI_SHOW)
		  $EditNO = $EditNo + 4
	   EndIf
	   If $idMsg = $idFeSerNo Then	    ; FTP Povolenie zmeny Serioveho cisla
		  GUICtrlSetState($idFeSerNo , $GUI_HIDE)
		  GUICtrlSetState($idEditSerNo, $GUI_SHOW)
		  GUICtrlSetData($idEditSerNo,Guictrlread($idFSerNo))
		  $EditNO = $EditNo + 8
	   EndIf
	   If $idMsg = $idFWrite Then		; FTP Zapisanie suboru na ILC
		  PutFileData()
		  FtpPutFile()
	   EndIf
	   If $idMsg = $IdSetPath Then		; Nastavenie Cielovej Karty
			SetDest()
	   EndIf
	   If $idMsg = $GUI_EVENT_CLOSE Then; Ukoncenie programu
		  If WinExists("C:\Windows\System32\cmd.exe") Then WinClose("C:\Windows\System32\cmd.exe")
		  If WinExists("Phoenix Contact - IP Assignment Tool") Then WinClose("Phoenix Contact - IP Assignment Tool")
		  If WinExists("Connect+ V1.1.2") Then WinClose("Connect+ V1.1.2")
		  If WinExists("Phoenix Contact") Then WinClose("Phoenix Contact - IP Assignment Tool")
			 Sleep(200)
		  IniWrite($INI,"ILC","Name",GUICtrlRead($idILCName))

		  ExitLoop
	   EndIf
   WEnd


; CMD()
; Status: Uvolnena
; Start : 0.0.0.0
; Zmena : 0.1.0.4
; Popis : Spustenie prikazoveho riadka a Ping
Func CMD()
    Local $IP =$ILCIP
    If WinExists("C:\Windows\System32\cmd.exe") Then WinClose("C:\Windows\System32\cmd.exe")
    Local $ltemp = $ILCIP
	Local $iPID = ShellExecute("cmd.exe")
    WinWait("C:\Windows\System32\cmd.exe")
    WinMove ("C:\Windows\System32\cmd.exe","",0,0,515,300)
    Send("ping "&$IP&" -t{Enter}")
EndFunc

; PutFileData()
; Status: Uvolnena
; Start : 0.0.0.0
; Zmena : 0.1.0.5
; Popis : Zapisanie udajov Do CONFIG.XML
Func PutFileData()
MsgBox(0,"",$EditNo)
    If BitAND($EditNo,1) Then
	   $data = '		<v t="ip">' & GUICtrlRead($idEditServer) & '</v>'
	   _FileWriteToLine($Dir & "\temp\CONFIG.XML", 4,$data, True)
    EndIf
	If BitAND($EditNo,2) Then
	   $data = '		<v t="ip">' & GUICtrlRead($idEditILCIP) & '</v>'
	   _FileWriteToLine($Dir & "\temp\CONFIG.XML", 11,$data, True)
    EndIf
	If BitAND ($EditNo,8) And $fIlcType == 170 Then
	   $data = '		<v t="serialnr">' & GUICtrlRead($idEditSerNo)& '</v>'
	   _FileWriteToLine($Dir & "\temp\CONFIG.XML", 19,$data, True)
    EndIf
	If BitAND ($EditNo,4) And $fIlcType == 190 Then
	   $data = '		<v t="HostName">' & GUICtrlRead($idEditilcName) & '</v>'
	   _FileWriteToLine($Dir & "\temp\CONFIG.XML", 13,$data, True)
    EndIf
	If BitAND ($EditNo,8) And $fIlcType == 190 Then
	   $data = '		<v t="serialnr">' & GUICtrlRead($idEditSerNo)& '</v>'
	   _FileWriteToLine($Dir & "\temp\CONFIG.XML", 22,$data, True)
    EndIf

	  GUICtrlSetState($idFeSerIP , $GUI_SHOW)
	  GUICtrlSetState($idFeILCIP , $GUI_SHOW)
	  GUICtrlSetState($idFeilcName , $GUI_SHOW)
	  GUICtrlSetState($idFeSerNo , $GUI_SHOW)
	  GUICtrlSetState($idEditServer, $GUI_HIDE)
	  GUICtrlSetState($idEditSerNo, $GUI_HIDE)
	  GUICtrlSetState($idEditILCIP, $GUI_HIDE)
	  GUICtrlSetState($idEditilcName, $GUI_HIDE)
	  $EditNo =0
EndFunc

; FTPPutFile()
; Status: Uvolnena
; Start : 0.0.0.0
; Zmena : 0.1.0.4
; Popis : Funkcia pre zapis na config.xml na Ftp
Func FTPPutFile()
    Local $IP = $ILCIP
	Local $Edo , $Result
    Local $iPing = Ping($IP, 250)
    If $iPing Then ; If a value greater than 0 was returned then display the following message.

	   Local $FtpOpen = _FTP_Open("FTP ILC")
	   Local $FtpConn = _FTP_Connect($FtpOpen,$IP,"anonymous","anonymous")
	   If @error Then
		  MsgBox ($MB_ICONERROR, '_FTP_Pripojenie', 'Chyba=' & @error)
	   Else

		  $Edo = _FTP_FileDelete($FtpConn,"/config.xml")
;~ 		  Msgbox("","","Delete "& $Edo)

		  $Result = _FTP_FilePut ( $FtpConn,$dir&"\temp\config.xml", "/config.xml" )
		  If $Result == 1 then Msgbox($MB_SYSTEMMODAL + $MB_ICONINFORMATION,"Transfer","Zapis ukonceny ",5)
;~ 		  Msgbox("","","PUT "& $Edo)
	   EndIf
	   _FTP_Close($FtpConn)
	   _FTP_Close($FtpOpen)

    Else
	   MsgBox($MB_ICONERROR, "", "Zariaddenie "&$IP&" nie je dostupne" )
    EndIf

EndFunc

; TabSel()
; Status: Uvolnena
; Start : 0.0.0.0
; Zmena : 0.1.0.4
; Popis : Funkcia pre vyber Tabu
Func TabSel()
    Local $sTab = GUICtrlRead($idTab)
;~     MsgBox("","",$idTab)
	If $sTab == 2 Then
	   GETIP()
	   FtpGetFile()
	   CheckFileVersion()
	   GetFileData()
    EndIf
	If $sTab <> 2 Then
	   If WinExists("C:\Windows\System32\cmd.exe") Then WinClose("C:\Windows\System32\cmd.exe")
    EndIf
EndFunc

; GetFileData()
; Status: Uvolnena
; Start : 0.0.0.0
; Zmena : 0.1.0.4
; Popis : Ziskanie dat zo suboru Config
Func GetFileData()

    Local $hFileOpen = FileOpen($Dir&"\temp\CONFIG.XML", $FO_READ)
    If $hFileOpen = -1 Then
        MsgBox($MB_ICONERROR, "", "An error occurred when reading the file.")
        Return False
    EndIf
    Local $data = fReadLine($hFileOpen,4,12,4)
	GUICtrlSetData($idfSerIP,$data)
    $data = fReadLine($hFileOpen,11,12,4)
	GUICtrlSetData($idfILCIP,$data)
	If $fIlcType = 170 Then
	   $data = fReadLine($hFileOpen,19,18,4)
	   GUICtrlSetData($idfSerNo,$data)
    EndIf
	If $fIlcType = 190 Then
	   $data = fReadLine($hFileOpen,13,18,4)
	   GUICtrlSetData($idFilcName,$data)
	   $data = fReadLine($hFileOpen,22,18,4)
	   GUICtrlSetData($idfSerNo,$data)
    EndIf
    ; Close the handle returned by FileOpen.
    FileClose($hFileOpen)

EndFunc

; fReadLine($file,$line,$start,$end)
; Status: Uvolnena
; Start : 0.0.0.0
; Zmena : 0.1.0.4
; Popis : Citanie riadku a jeho orezanie
Func fReadLine($file,$line,$start,$end)
    Local $lFileRead = FileReadLine($file, $line)
    Local $data = StringTrimLeft($lFileRead,$start)
	$data = StringTrimRight($data,$end)
	Return $data
EndFunc

; CheckFileVersion()
; Status: Uvolnena
; Start : 0.0.0.0
; Zmena : 0.1.0.4
; Popis : Preverenie verzie Config suboru
Func CheckFileVersion()
    Local $Flines = _FileCountLines($Dir&"\temp\CONFIG.XML")
;~     MsgBox ("","Countlines",$Flines)
	If $Flines == 21 Then $fIlcType = 170
    If $Flines == 24 Then $fIlcType = 190
EndFunc

; FtpGetFile()
; Status: Uvolnena
; Start : 0.0.0.0
; Zmena : 0.1.0.4
; Popis : ziskanie Config.XML z FTP
Func FtpGetFile()
    Local $IP =$ILCIP
    ;CMD()
    Local $iPing = Ping($IP, 250)

    If $iPing Then ; If a value greater than 0 was returned then display the following message.
	   Local $FtpOpen = _FTP_Open("FTP ILC")
	   Local $FtpConn = _FTP_Connect($FtpOpen,$IP,"anonymous","anonymous")
	   If @error Then
		  MsgBox ($MB_ICONERROR, '_FTP_Pripojenie', 'Chyba=' & @error)
	   Else
		  _FTP_FileGet($FtpConn,"CONFIG.XML",$dir&"\temp\CONFIG.XML")
		  ;_FTP_FileGet($FtpConn,"Project.INI",$dir&"\temp\Project.INI")
	   EndIf
	   Local $iFtpc = _FTP_Close($FtpConn)
	   Local $iFtpo = _FTP_Close($FtpOpen)

    Else
	   MsgBox($MB_ICONERROR, "Chyba pripojenia", "Zariaddenie "&$IP&" nie je dostupne" )
    EndIf

EndFunc

; CARD170()
; Status: Uvolnena
; Start : 0.0.0.0
; Zmena : 0.1.0.4
; Popis : Zapis na kartu ILC170 java a MySQL
Func CARD170()
    $Eror = False

	GETIP()
    If Not $Eror Then SerialCheck()
    If Not $Eror Then CheckCard()
	If Not $Eror Then
	   DirCopy($dir & "\Source\ILC170",$Dest & "\cfroot",$fc_overwrite)
	   $data = '		<v t="ip">' & $SerIP & '</v>'
	   _FileWriteToLine($Dest & "\cfroot\config.xml", 4,$data, True)
	   $data = '		<v t="ip">' & $ILCIP & '</v>'
	   _FileWriteToLine($Dest & "\cfroot\config.xml", 11,$data, True)
	   $data = '		<v t="serialnr">' & GUICtrlRead($idHWSerial)& '</v>'
	   _FileWriteToLine($Dest & "\cfroot\config.xml", 19,$data, True)

	   IniWrite($INI,"ILC","Name",GUICtrlRead($idILCName))
	   IniWrite($INI,"ILC","Serial",GUICtrlRead($idHWSerial))
	   MsgBox("","Kopirovanie","Kopirovanie bolo uspesne",5)
	EndIf

;~    DirCopy($Dir&"\Source\ILC170",$dest&"ROOT",$FC_OVERWRITE )
;~    _FileWriteToLine($Dir & "\Source\ILC170\CONFIG.XML", 4,$data, True)

EndFunc

; CARD191()
; Status: Uvolnena
; Start : 0.0.0.0
; Zmena : 0.1.0.4
; Popis : Zapis nakartu ILC191 java a MySQL
Func CARD191()
    $Eror = False

    GETIP()
    If Not $Eror Then SerialCheck()
    If Not $Eror Then CheckCard()

	If Not $Eror Then
	   DirCopy($dir & "\Source\ILC191\cfroot",$Dest & "\cfroot",$fc_overwrite)
	   $data = '		<v t="ip">' & $SerIP & '</v>'
	   _FileWriteToLine($Dest & "\cfroot\config.xml", 4,$data, True)
	   $data = '		<v t="ip">' & $ILCIP & '</v>'
	   _FileWriteToLine($Dest & "\cfroot\config.xml", 11,$data, True)
	   $data = '		<v t="HostName">' & GUICtrlRead($idILCName) & '</v>'
	   _FileWriteToLine($Dest & "\cfroot\config.xml", 13,$data, True)
	   $data = '		<v t="serialnr">' & GUICtrlRead($idHWSerial)& '</v>'
	   _FileWriteToLine($Dest & "\cfroot\config.xml", 22,$data, True)

	   IniWrite($INI,"ILC","Name",GUICtrlRead($idILCName))
	   IniWrite($INI,"","",GUICtrlRead($idHWSerial))
	   MsgBox($MB_ICONINFORMATION,"Kopirovanie","Kopirovanie bolo uspesne",5)
	EndIf
;~    DirCopy($Dir&"\Source\ILC191",$dest&"ROOT",$FC_OVERWRITE )
;~    _FileWriteToLine($Dir & "\Source\ILC170\CONFIG.XML", 4,$data, True)
EndFunc

; CARD191MS()
; Status: Test
; Start : 0.1.0.5
; Zmena : 0.1.0.5
; Popis : Zapis nakartu ILC191 HTML5 a MSSQL
Func CARD191MS()
    $Eror = False

    GETIP()
    If Not $Eror Then SerialCheck()
    If Not $Eror Then CheckCard()

	If Not $Eror Then
	   DirCopy($dir & "\Source\ilc191mysql\cfroot",$Dest & "\cfroot",$fc_overwrite)
	   $data = '		<v t="ip">' & $SerIP & '</v>'
	   _FileWriteToLine($Dest & "\cfroot\config.xml", 4,$data, True)
	   $data = '		<v t="ip">' & $ILCIP & '</v>'
	   _FileWriteToLine($Dest & "\cfroot\config.xml", 11,$data, True)
	   $data = '		<v t="HostName">' & GUICtrlRead($idILCName) & '</v>'
	   _FileWriteToLine($Dest & "\cfroot\config.xml", 13,$data, True)
	   $data = '		<v t="serialnr">' & GUICtrlRead($idHWSerial)& '</v>'
	   _FileWriteToLine($Dest & "\cfroot\config.xml", 22,$data, True)

	   IniWrite($INI,"ILC","Name",GUICtrlRead($idILCName))
	   IniWrite($INI,"","",GUICtrlRead($idHWSerial))
	   MsgBox($MB_ICONINFORMATION,"Kopirovanie","Kopirovanie bolo uspesne",5)
	EndIf
;~    DirCopy($Dir&"\Source\ILC191",$dest&"ROOT",$FC_OVERWRITE )
;~    _FileWriteToLine($Dir & "\Source\ILC170\CONFIG.XML", 4,$data, True)
EndFunc

; CARD191MY()
; Status: Test
; Start : 0.1.0.5
; Zmena : 0.1.0.5
; Popis : Zapis nakartu ILC191HTML5 a MySQL
Func CARD191MY()
    $Eror = False

    GETIP()
    If Not $Eror Then SerialCheck()
    If Not $Eror Then CheckCard()

	If Not $Eror Then
	   DirCopy($dir & "\Source\\ilc191mssql",$Dest & "\cfroot",$fc_overwrite)
	   $data = '		<v t="ip">' & $SerIP & '</v>'
	   _FileWriteToLine($Dest & "\cfroot\config.xml", 4,$data, True)
	   $data = '		<v t="ip">' & $ILCIP & '</v>'
	   _FileWriteToLine($Dest & "\cfroot\config.xml", 11,$data, True)
	   $data = '		<v t="HostName">' & GUICtrlRead($idILCName) & '</v>'
	   _FileWriteToLine($Dest & "\cfroot\config.xml", 13,$data, True)
	   $data = '		<v t="serialnr">' & GUICtrlRead($idHWSerial)& '</v>'
	   _FileWriteToLine($Dest & "\cfroot\config.xml", 22,$data, True)

	   IniWrite($INI,"ILC","Name",GUICtrlRead($idILCName))
	   IniWrite($INI,"","",GUICtrlRead($idHWSerial))
	   MsgBox($MB_ICONINFORMATION,"Kopirovanie","Kopirovanie bolo uspesne",5)
	EndIf
;~    DirCopy($Dir&"\Source\ILC191",$dest&"ROOT",$FC_OVERWRITE )
;~    _FileWriteToLine($Dir & "\Source\ILC170\CONFIG.XML", 4,$data, True)
EndFunc




; CheckCard ()
; Status: Uvolnena
; Start : 0.0.0.0
; Zmena : 0.1.0.4
; Popis : Funkcia pre kontrolu SD karty
Func CheckCard ()
    $Eror = False
    local $ltemp

    Local $sStatus = DriveStatus($Dest & "\")
    If $sStatus <> "Ready" Then
	   MsgBox($MB_ICONERROR,"Drive Eror", "Disk '" & $Dest&"' nie je Redy!")
	   $Eror = True
	   Return
    EndIf
	Local $Temp = Round ( DriveSpaceTotal($Dest),1)
	If $Temp > 2300 Then
	   Local $button = MsgBox($MB_ICONWARNING + $MB_YESNO,"Card WARNING", "Disk '" & $Dest&"' Nie je vhodny pre zvolený typ ILC." & @CRLF & " Pokracovat v zapise?")
	   If $button = $IDCANCEL or $button = $IDNO Then
		  ConsoleWrite("Prerusene uzivatelom")
		  $Eror = True
		  Return
	   EndIf
    EndIf

	If $Temp <550 And GUICtrlRead ($idILC170) = $GUI_CHECKED Then
	   Local $button = MsgBox($MB_ICONWARNING,"Card WARNING", "Disk '" & $Dest&"' Nie je vhodny pre zvolený typ ILC")
	   If $button = $IDCANCEL or $button = $IDNO Then
		  ConsoleWrite("Prerusene uzivatelom")
		  $Eror = True
		  Return
	   EndIf
    EndIf

	Global $licence = $Dest & "\licence"
	If Not FileExists($licence) then
	    MsgBox($MB_ICONERROR,"Licence Eror", "Licencny subor '" & $licence&"' sa nenasiel na karte!")
		$Eror =True
		Return
    EndIf

EndFunc

; SerialCheck()
; Status: Uvolnena
; Start : 0.0.0.0
; Zmena : 0.1.0.4
; Popis : Funkcia pre kontrolu Serioveho cisla z Vstupneho pola
Func SerialCheck()

    Local $ltemp = GUICtrlRead($idHWSerial)
    If StringLen($ltemp) <> 12 Then
	   MsgBox ($MB_ICONERROR,"Eror Serial No.","Nespravny pocet znakov v poli 'Serial no.'")
	   $Eror = True
	   Return
	EndIf
    If Number($ltemp) > 1599999999 or Number($ltemp) <1000000000 Then
	   MsgBox($MB_ICONERROR,"Eror Serial No.","Nespravne seriove cislo" )
	   $Eror = True
	   Return
    EndIf

EndFunc

; GETIP()
; Status: Uvolnena
; Start : 0.0.0.0
; Zmena : 0.1.0.4
; Popis : Funkcia pre kontrolu DNS Mena a ziskanie IP adresy
Func GETIP()
    Local $ltemp = GUICtrlRead($idILCName)

    If StringLen($ltemp) <> 9 Then
	   MsgBox($MB_ICONERROR, "Eror DNS Name","Nespravny pocet znakov"& StringLen($ltemp))
	   $Eror = True
	   Return
    EndIf
    Local $ltemp1 = StringUpper(StringMid($ltemp,1,4))
    If $ltemp1 <> "TRNF" Then
	   MsgBox ($MB_ICONERROR,"Eror DNS Name","Nespravny format TRNCxxxxx")
	   $Eror = True
	   Return
    EndIf
	$ltemp1 = Number(StringMid($ltemp,5,5))
	if $Test = 0 Then
		If $ltemp1 < 50000 Then
		   MsgBox ($MB_ICONERROR,"Eror DNS Name","Nespravny format cisla TRNC5xxxx " & $ltemp1)
		   $Eror = True
		   Return
		EndIf
		$ILCIP = "10.26." & StringMid($ltemp,5,2)& "." & Number(StringMid($ltemp,7,3))
	Else
		$ILCIP = "192.168.0."& Number(StringMid($ltemp,7,3))
	EndIf
 EndFunc

; SetDest()
; Status: Uvolnena
; Start : 0.0.0.0
; Zmena : 0.1.0.5
; Popis : Funkcia pre nastavenie cielovej karty
Func SetDest()
    ; Create GUI and Buttons =========================================================================================
	; ===========================
	; = Set Destinations Window =
	; ===========================
   	GUISetState(@SW_DISABLE,$MainWin)
	Local $GOOEY3 = GUICreate("Nastavenie Destination", 320, 250, -1,-1,BitOR($WS_MINIMIZEBOX,$WS_CAPTION,$WS_POPUP,$WS_GROUP,$WS_BORDER,$WS_CLIPSIBLINGS,$DS_MODALFRAME), BitOR($WS_EX_TOPMOST,$WS_EX_WINDOWEDGE))
	GUISetState (@SW_SHOW + @SW_LOCK)

    ; = Buttons =
	; ===========
	Local $DVyber = GUICtrlCreateButton("Nastav",50,200,80,25,$BS_DEFPUSHBUTTON)
	Local $DClose = GUICtrlCreateButton("Zavri",150,200,80,25,$BS_DEFPUSHBUTTON)

    ; = Label And Coments =
	; =====================
    Local $Status1 = GUICtrlCreateLabel ("Aktualny vyber ' "& $Dest & " '" ,20,10,200,30)
	Local $Status = GUICtrlCreateLabel ("Aktualny vyber ' "& $Dest & " '" ,20,180,200,30)
	Local $DestSel = GuiCtrlCreateListView("Disk|velkost|jednotka", 20, 30, 280, 140 )
;~ 	_GUICtrlListView_SetExtendedListViewStyle($DestSel, BitOR($LVS_EX_FULLROWSELECT, $LVS_EX_CHECKBOXES))

    Local $LDrives = DriveGetDrive($DT_ALL)
	Local $FDrives[1][3]
    If @error Then
	   ; An error occurred when retrieving the drives.
	   MsgBox($MB_SYSTEMMODAL, "", "It appears an error occurred.")
    Else
	   For $i = 1 To $LDrives[0]

		  Local $TDrive =StringUpper($LDrives[$i])
		  Local $TSize = Round ( DriveSpaceTotal($LDrives[$i]),1)
		  Local $TExt = "MB"

		  If $TSize < 1000 Then $TExt = "MB"
		  If $TSize > 1000 And $TSize < 1000000 Then
			 $TSize = Round ( $TSize/1000,1)
			 $TExt = "GB"
		  EndIf

		  If $TSize > 1000000 Then
			 $TSize = Round ( $TSize/1000000,2)
			 $TExt = "TB"
		  EndIf
		  Local $sFill =  $TDrive&"|"&$TSize &"|"&$TExt
		  GUICtrlCreateListViewItem($sFill, $DestSel )
		   _ArrayAdd($FDrives, $sFill)

	   Next

    EndIf

;~ 	GuiCtrlCreateProgress(10, 173, 300, 5)
	GUISetState()


	Do
	Local $msg1 = GUIGetMsg(1)
	Select
	   Case $msg1[0] = $DVyber

;~ 		  MsgBox($MB_SYSTEMMODAL, "listview item",GUICtrlRead(GUICtrlRead($DestSel)), 2)
		  Local $Tempu =  StringSplit(GUICtrlRead(GUICtrlRead($DestSel)),  "|")
;~ 		  MsgBox($MB_SYSTEMMODAL, "listview item",$Tempu[1], 2)
		  $Dest= $Tempu[1]
		  IniWrite($INI, "SETING","Destination",$Dest)

		  GUICtrlSetData($Status, "Prestavene na ' "& $Dest & " '")

	   EndSelect

	Until $msg1[0] = $GUI_EVENT_CLOSE Or $msg1[0] = $DClose
	GUIDelete($GOOEY3)
	GUISetState(@SW_ENABLE,$MainWin)
	WinActivate($MainWin)
EndFunc


;~  Koniec
