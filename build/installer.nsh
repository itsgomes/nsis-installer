;Use modern user interface
!include MUI2.nsh

;Settings
!define MUI_ABORTWARNING

;Customization
!define MUI_BGCOLOR 152640
!define MUI_TEXTCOLOR A8BBD9
!define MUI_LICENSEPAGE_BGCOLOR 152640
!define MUI_DIRECTORYPAGE_BGCOLOR 152640
!define MUI_STARTMENUPAGE_BGCOLOR 152640
!define MUI_ICON "${PROJECT_DIR}\assets\son-goku.ico"
!define MUI_UNICON "${PROJECT_DIR}\assets\son-goku.ico"
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_RIGHT
!define MUI_HEADERIMAGE_BITMAP "${PROJECT_DIR}\assets\son-goku.bmp"
!define MUI_HEADERIMAGE_UNBITMAP "${PROJECT_DIR}\assets\son-goku.bmp"

;Pages
!insertmacro MUI_PAGE_LICENSE "${PROJECT_DIR}/license/license.txt"