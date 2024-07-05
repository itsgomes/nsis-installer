;----------------
; Import
;----------------
!include LogicLib.nsh
!include nsDialogs.nsh
!include "MUI2.nsh"

;----------------
; Variables
;----------------
Var Dialog

Var HWND_ML_TEXT
Var HWND_LABEL
Var HWND_IS_EXPRESS

;----------------
; Customization
;----------------
!define MUI_ABORTWARNING

!define MUI_ICON "${PROJECT_DIR}\assets\son-goku.ico"
!define MUI_UNICON "${PROJECT_DIR}\assets\son-goku.ico"

!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_RIGHT
!define MUI_HEADERIMAGE_BITMAP "${PROJECT_DIR}\assets\son-goku.bmp"
!define MUI_HEADERIMAGE_UNBITMAP "${PROJECT_DIR}\assets\son-goku.bmp"

!define MUI_TEXTCOLOR A8BBD9

!define MUI_BGCOLOR 152640
!define MUI_LICENSEPAGE_BGCOLOR 152640
!define MUI_DIRECTORYPAGE_BGCOLOR 152640
!define MUI_STARTMENUPAGE_BGCOLOR 152640

;----------------
; Pages
;----------------
Page custom dialogPage onDialogClose

;----------------
; Function
;----------------
Function dialogPage
	!insertmacro MUI_HEADER_TEXT "Acordo de Licença" "Por favor, leia com atenção os termos da licença antes de instalar o nsis-installer."

	; Setting 'next button' text
	Push $R0
	GetDlgItem $R0 $HWNDPARENT 1
	SendMessage $R0 ${WM_SETTEXT} 0 "STR:Eu concordo"
	Pop $R0

	; Creating page
	nsDialogs::Create /NOUNLOAD 1018
	Pop $Dialog

	${If} $Dialog == error
		Abort
	${EndIf}
	
	; Creating multiline text control
	nsDialogs::CreateControl EDIT \ 
		"${DEFAULT_STYLES}|${WS_VSCROLL}|${ES_MULTILINE}|${ES_READONLY}|${ES_WANTRETURN}" \ 
		"${__NSD_Text_EXSTYLE}" \
		0 0 100% 70% \
		""
		Pop $HWND_ML_TEXT
	
	; Setting colors to multiline text control
	SetCtlColors $HWND_ML_TEXT 000000 FFFFFF
	
	; Reading and importing data to multiline text control
	FileOpen $4 "${PROJECT_DIR}\license\license.txt" r
	loop:
		FileRead $4 $1
		SendMessage $HWND_ML_TEXT ${EM_REPLACESEL} 0 "STR:$1"
		IfErrors +1 loop
	FileClose $4
	
	${NSD_CreateLabel} 0 75% 100% 15% "Se você aceita os termos do acordo, clique em Eu concordo para continuar.$\nVocê deve aceitar o acordo para instalar o nsis-installer."
		Pop $HWND_LABEL
		
	${NSD_CreateCheckbox} 0 90% 100% 10% "Desejo que seja realizado uma instalação expressa"
		Pop $HWND_IS_EXPRESS

	nsDialogs::Show
FunctionEnd

Function onDialogClose
	${NSD_GetState} $HWND_IS_EXPRESS $R0
	
	${If} $R0 = 1
		StrCpy $R9 "3"
		Call RelGoToPage
	${EndIf}
FunctionEnd

Function RelGoToPage
  IntCmp $R9 0 0 Move Move
    StrCmp $R9 "X" 0 Move
      StrCpy $R9 "120"

  Move:
  SendMessage $HWNDPARENT "0x408" "$R9" ""
FunctionEnd

!macro customInit
    ${if} $installMode == "all"
        ${IfNot} ${UAC_IsAdmin}
            ShowWindow $HWNDPARENT ${SW_HIDE}
            !insertmacro UAC_RunElevated
            Quit
        ${endif}
    ${endif}
!macroend