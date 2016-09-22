@echo off
set JOB_NAME="GetGCC"
set TDM_URL="http://jaist.dl.sourceforge.net/project/tdm-gcc/TDM-GCC%%20Installer/tdm64-gcc-5.1.0-2.exe"
set TDM_PATH=%TEMP%\tdm_installer.exe
set BCC_BIN="C:\borland\bcc55\Bin\bcc32.exe"
set BCC_BAT="C:\borland\bcc55\Bin\bcc32.bat"
set BCC_DUMMY_SRC=%TEMP%\bcc32.c
set BCC_DUMMY_BIN=%TEMP%\bcc32.exe
set DOWNLOADER_PS=%TEMP%\downloader.ps1

if not exist %BCC_BIN% (
    set ERROR_MSG="bcc32.exeÇ™å©Ç¬Ç©ÇËÇ‹ÇπÇÒÇ≈ÇµÇΩ"
    goto ERROR
)
pushd %TEMP%
if not exist "C:\TDM-GCC-64\" (
    > %DOWNLOADER_PS% (
        @echo.Invoke-WebRequest -Uri %TDM_URL% -Outfile %TDM_PATH%
    )
    if not exist %TDM_PATH% (
        powershell -File %DOWNLOADER_PS%
    )
    %TDM_PATH%
)
if not exist %BCC_BIN%.orig (
    @echo.main^(int a,char**v^)^{char cmd[999];sprintf^(cmd,"bcc32.bat %%s",v[1]^);system^(cmd^);return 0;^} > %BCC_DUMMY_SRC%
    %BCC_BIN% %BCC_DUMMY_SRC%
    move %BCC_BIN% %BCC_BIN%.orig
    move %BCC_DUMMY_BIN% %BCC_BIN%
    > %BCC_BAT% (
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
