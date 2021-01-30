@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION

IF "%VisualStudioVersion%" == "14.0" ( IF NOT DEFINED Platform SET "Platform=X86" )
FOR /F %%i IN ('powershell -c "\"%Platform%\".toLower()"') DO SET PLATFORM=%%i
powershell -c "if ('%PLATFORM%' -notin ('x86', 'x64')) {Exit 1}"
IF !ERRORLEVEL! NEQ 0 (
    ECHO Unknown platform: %PLATFORM%
    EXIT /B 1
)

SET "PATH=%CD%;%PATH%"
SET "R2DIST=r2_dist"

ECHO Downloading radare2 (%PLATFORM%)
CD radare2 
rem powershell -command "Invoke-WebRequest 'https://github.com/radareorg/radare2/releases/download/5.1.0/radare2-5.1.0_windows.zip' -OutFile 'radare2-5.1.0_windows.zip'"
pip install wget
python -m wget -o radare2-5.1.0_windows.zip https://github.com/radareorg/radare2/releases/download/5.1.0/radare2-5.1.0_windows.zip
unzip radare2-5.1.0_windows.zip
RMDIR /S /Q ..\%R2DIST%
MOVE radare2-5.1.0_windows %CD%\..\%R2DIST%

rem ECHO Building radare2 (%PLATFORM%)
rem CD radare2
rem git clean -xfd
rem RMDIR /S /Q ..\%R2DIST%
rem rem python sys\meson.py --release --shared --install --prefix=%CD%\..\%R2DIST% --options "r2_datdir=radare2/share" "r2_libdir=radare2/lib" #"c_args=-D_UNICODE -DUNICODE"
rem meson.exe r2_builddir --buildtype=release --prefix=%CD%\..\%R2DIST% || EXIT /B 1
rem ninja -C r2_builddir install || EXIT /B 1
rem IF !ERRORLEVEL! NEQ 0 EXIT /B 1
