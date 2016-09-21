@echo off
set JOB_NAME="GetGCC"
set TDM_URL="http://downloads.sourceforge.net/project/tdm-gcc/TDM-GCC%%20Installer/tdm64-gcc-5.1.0-2.exe?r=https%%3A%%2F%%2Fsourceforge.net%%2Fprojects%%2Ftdm-gcc%%2Ffiles%%2FTDM-GCC%%2520Installer%%2F&ts=1474472811&use_mirror=jaist"
set TDM_PATH=%TEMP%\tdm_installer.exe
set BCC_BIN="C:\borland\bcc55\Bin\bcc32.exe"

if not exist %TDM_PATH% (
    bitsadmin /setproxysettings %JOB_NAME% PRECONFIG
    bitsadmin /transfer %JOB_NAME% %TDM_URL% %TDM_PATH%
)
if not exist "C:\TDM-GCC-64\" (
    %TDM_PATH%
)
if not exist %BCC_BIN% (
    set ERROR_MSG="bcc32.exeÇ™å©Ç¬Ç©ÇËÇ‹ÇπÇÒÇ≈ÇµÇΩ"
    goto ERROR
)
if not exist %BCC_BIN%.orig (
    move %BCC_BIN% %BCC_BIN%.orig
    > %BCC_BIN% (
        @echo.@echo off
        @echo.C:\TDM-GCC-64\bin\g++.exe %%1 -o %%~n1.exe -std=c++11
    )
)
echo.èIóπÇµÇ‹ÇµÇΩ.
pause
exit /B 0
:ERROR
echo %ERROR_MSG%
pause
exit /B 1