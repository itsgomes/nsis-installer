;----------------
; Import
;----------------
!include LogicLib.nsh
!include nsDialogs.nsh
!include "MUI2.nsh"

Var Dialog
Var isExpress

Var HWND_BUTTON_EXPRESS
Var HWND_BUTTON_CUSTOM

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
!insertmacro MUI_PAGE_LICENSE "${PROJECT_DIR}/license/license.txt"

Page custom dialogPage onDialogClose
Page directory skipPage

;----------------
; Function
;----------------
Function dialogPage
	!insertmacro MUI_HEADER_TEXT "Instalação" "Escolha o tipo de instalação que você deseja executar."

	nsDialogs::Create /NOUNLOAD 1018
	Pop $Dialog

	${If} $Dialog == error
		Abort
	${EndIf}

	${NSD_CreateGroupBox} 0u 10u 100% 40% "Selecione o tipo de instalação que deseja executar."
		Pop $0

	${NSD_CreateRadioButton} 10 50 80% 12u "Expressa"
		Pop $HWND_BUTTON_EXPRESS

	${NSD_CreateRadioButton} 10 70 80% 12u "Customizada"
		Pop $HWND_BUTTON_CUSTOM

	${NSD_AddStyle} $HWND_BUTTON_EXPRESS ${WS_GROUP}
	${NSD_SetState} $HWND_BUTTON_EXPRESS ${BST_CHECKED}
	${NSD_OnBack} denyBack

	nsDialogs::Show
FunctionEnd

Function onDialogClose
	${NSD_GetState} $HWND_BUTTON_EXPRESS $R0
	
	${If} $R0 = 1
		StrCpy $isExpress 1
	${Else}
		StrCpy $isExpress 0
	${EndIf}
FunctionEnd

Function denyBack
	pop $0
	Abort
FunctionEnd

Function skipPage
	${If} $isExpress = 1
		Abort
	${EndIf}
FunctionEnd

!macro customInstallMode
	${If} $isExpress = 1
		StrCpy $isForceCurrentInstall 1
		StrCpy $isForceMachineInstall 0
	${Else}
		StrCpy $isForceCurrentInstall 0
		StrCpy $isForceMachineInstall 1
	${EndIf}
!macroend