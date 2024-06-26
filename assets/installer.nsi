;working examle for "Directory Page" Full Transparent /// DIMM_V2
!include "MUI2.nsh"
; Local bitmap path.
!define BITMAP_FILE "${PRODUCT_DIR}/assets/son-goku.bmp"
; --------------------------------------------------------------------------------------------------
; Installer Settings
; --------------------------------------------------------------------------------------------------
Name "Background Bitmap"
OutFile "bgbitmap.exe"
ShowInstDetails show
; --------------------------------------------------------------------------------------------------
; Modern UI Settings
; --------------------------------------------------------------------------------------------------

; !define MUI_UI ".\dimm_beta_img.exe" ;The interface file with the dialog resources. Change this if you have made your own customized UI.


; !define MUI_HEADERIMAGE #  это отвечает за большое окно  
; !define MUI_UI_HEADERIMAGE ".\dimm_beta_img.exe" # измененный ехе     ; dimm 1018 my bmp image ! 
!define MUI_DIRECTORYPAGE_BGCOLOR CDCDCD  # gray color of Destination Folder
!define BGCOLOR Transparent ; Setting this to "Transparent" only works partially and requires some hacks...
!define MUI_CUSTOMFUNCTION_GUIINIT MyGUIInit
!define MUI_TEXTCOLOR ffffff #  white : ffffff
!define MUI_BGCOLOR Transparent # back upper side must be transparent
DirText "$\r" # псевдо затирание!   /// hide text in directory page 
!define MUI_DIRECTORYPAGE_TEXT_DESTINATION "Install Folder"
; --------------------------------------------------------------------------------------------------
; Definitions
  InstallDir "$temp"
; --------------------------------------------------------------------------------------------------
Var hBitmap
; --------------------------------------------------------------------------------------------------
; Pages
; --------------------------------------------------------------------------------------------------
!define MUI_PAGE_CUSTOMFUNCTION_SHOW DirectoryPageShow
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_LANGUAGE English
 ; --------------------------------------------------------------------------------------------------
; Macros
; --------------------------------------------------------------------------------------------------
; Destroy a window.
!macro DestroyWindow HWND IDC
  GetDlgItem $R0 ${HWND} ${IDC}
  System::Call `user32::DestroyWindow(i R0)`
!macroend

; Give window transparent background.
!macro SetTransparent HWND IDC
    GetDlgItem $R0 ${HWND} ${IDC}
    SetCtlColors $R0 0x444444 transparent
!macroend


!macro setwhite HWND IDC
  GetDlgItem $R0 ${HWND} ${IDC}
  SetCtlColors $R0 ffffff transparent  # set text color here  ==> white -  ffffff   gray ,  transparent
!macroend
 
 
; Refresh window.
!macro RefreshWindow HWND IDC
  GetDlgItem $R0 ${HWND} ${IDC}
  ShowWindow $R0 ${SW_HIDE}
  ShowWindow $R0 ${SW_SHOW}
!macroend
 ; --------------------------------------------------------------------------------------------------
; Macros
; --------------------------------------------------------------------------------------------------
 
; --------------------------------------------------------------------------------------------------
; Functions
; --------------------------------------------------------------------------------------------------
 
Function MyGUIInit
  ; Extract bitmap image.
  InitPluginsDir
  ReserveFile `${BITMAP_FILE}`
  File `/ONAME=$PLUGINSDIR\bg.bmp` `${BITMAP_FILE}`
  System::Call `user32::GetClientRect(i $HWNDPARENT, i R0)`
  System::Free $R0
  ; Create bitmap control.
  System::Call `kernel32::GetModuleHandle(i 0) i.R3`
  System::Call `user32::CreateWindowEx(i 0, t "STATIC", t "", i ${SS_BITMAP}|${WS_CHILD}|${WS_VISIBLE}, i 0, i 0, i R1, i R2, i $HWNDPARENT, i,i R3, i 0) i.R1`
  System::Call `user32::SetWindowPos(i R1, i , i 0, i 0, i 0, i 0, i })`
  ; Set the bitmap.
  System::Call `user32::LoadImage(i 0, t "$PLUGINSDIR\bg.bmp", i ${IMAGE_BITMAP}, i 0, i 0, i ${LR_CREATEDIBSECTION}|${LR_LOADFROMFILE}) i.s`
  Pop $hBitmap
  SendMessage $R1 ${STM_SETIMAGE} ${IMAGE_BITMAP} $hBitmap
FunctionEnd
; Refresh parent window controls.
; Has to be done for some controls if they have a transparent background.
Function RefreshParentControls
  !insertmacro RefreshWindow $HWNDPARENT 1020
  !insertmacro RefreshWindow $HWNDPARENT 1019
  !insertmacro RefreshWindow $HWNDPARENT 1256
  !insertmacro RefreshWindow $HWNDPARENT 1024
  !insertmacro RefreshWindow $HWNDPARENT 1023
FunctionEnd

; from page dir
; DirectoryPage "#32770" "" $HWNDPARENT
; DirectoryPage.Text $mui.DirectoryPage               1006
; DirectoryPage.DirectoryBox $mui.DirectoryPage       1020
; DirectoryPage.Directory $mui.DirectoryPage          1019
; DirectoryPage.BrowseButton $mui.DirectoryPage       1001
; DirectoryPage.SpaceRequired $mui.DirectoryPage      1023
; DirectoryPage.SpaceAvailable $mui.DirectoryPage     1024
  

; For directory page.
Function DirectoryPageShow
SetCtlColors $mui.DirectoryPage.title 0xFFFFFF transparent # Set Transparent page bg
;Set transparent backgrounds.
FindWindow $0 "#32770" "" $HWNDPARENT
!insertmacro setwhite $0 1256 # SpaceRequired 
!insertmacro setwhite $0 1023  # SpaceRequired  
!insertmacro SetTransparent $0 1001 # dimm this is working
!insertmacro SetTransparent $0 1008 # dimm this is working
!insertmacro SetTransparent $0 1001
!insertmacro setwhite $0 1024 # space availbe  
!insertmacro SetTransparent $0 1008
!insertmacro SetTransparent $0 1006  # middle bg 
; !insertmacro SetTransparent $0 1020  # this is label of Dest. Folder
SendMessage $R0 ${WM_SETTEXT} 0 STR: # hide label "Directory Folder"


; Remove unwanted controls.
!insertmacro DestroyWindow $HWNDPARENT 1023 # remove line here  working 
!insertmacro DestroyWindow $HWNDPARENT 1020 # remove line here  working 
!insertmacro DestroyWindow $HWNDPARENT 1256 # remove line here  working 
!insertmacro DestroyWindow $HWNDPARENT 1028 # remove line here  working
!insertmacro DestroyWindow $HWNDPARENT 1039 # remove line here working


 
; Refresh controls.
Call RefreshParentControls
FunctionEnd
 

; Free loaded resources.
Function .onGUIEnd
  ; Destroy the bitmap.
  ; System::Call `gdi32::DeleteObject(i s)` $hBitmap
FunctionEnd
 
; --------------------------------------------------------------------------------------------------
; Dummy section
; --------------------------------------------------------------------------------------------------
 
Section "Dummy Section"
SectionEnd