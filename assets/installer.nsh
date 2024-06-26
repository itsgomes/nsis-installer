; ;Settings
!define MUI_ABORTWARNING

;Customization
!define MUI_BGCOLOR 152640
!define MUI_TEXTCOLOR A8BBD9
!define MUI_LICENSEPAGE_BGCOLOR 152640
!define MUI_DIRECTORYPAGE_BGCOLOR 152640
!define MUI_STARTMENUPAGE_BGCOLOR 152640

;Use modern user interface
!include MUI2.nsh

;Pages
!insertmacro MUI_PAGE_LICENSE "${PROJECT_DIR}/assets/license.txt"