@echo off
setlocal EnableDelayedExpansion
title glbOBJ2Creality
color 0A

cls
echo.
echo  ============================================================================
echo.
echo                   glbOBJ2Creality v2.0 - 02/07/2026
echo.
echo   Developed by Brett Yandell because for some reason nobody else has done this
echo.              
echo  ============================================================================
echo.
echo   This tool converts textured OBJ and GLB models to vertex-colored OBJ files
echo                    for Creality Slicer multi-color 3D printing.
echo.
echo   NEW: Select material type (PLA, PETG, ABS, TPU) and limit color count!
echo.
echo  ============================================================================
echo.
pause

cls
echo.
echo  ============================================================================
echo                              FILE SETUP
echo  ============================================================================
echo.

:: Ask for folder path
set /p "FOLDER=Enter folder path (e.g., C:\Models\Batman): "

:: Remove trailing backslash if present
if "%FOLDER:~-1%"=="\" set "FOLDER=%FOLDER:~0,-1%"

:: Validate folder exists
if not exist "%FOLDER%" (
    echo.
    echo  [ERROR] Folder not found: %FOLDER%
    pause
    exit /b 1
)

echo.
:: Ask for base file name
set /p "BASENAME=Enter base file name without extension (e.g., batman): "

echo.
echo  ============================================================================
echo                           MATERIAL SELECTION
echo  ============================================================================
echo.
echo   Select the filament material type:
echo.
echo     [1] PLA  - Standard PLA filaments (most colors available)
echo     [2] PETG - PETG filaments (heat resistant)
echo     [3] ABS  - ABS filaments (requires enclosure)
echo     [4] TPU  - Flexible TPU filaments
echo     [5] ALL  - Use all available filament types
echo.
set /p "MATSELECT=Enter choice (1-5) [default: 1]: "

if "%MATSELECT%"=="" set "MATSELECT=1"
if "%MATSELECT%"=="1" set "MATERIAL=PLA"
if "%MATSELECT%"=="2" set "MATERIAL=PETG"
if "%MATSELECT%"=="3" set "MATERIAL=ABS"
if "%MATSELECT%"=="4" set "MATERIAL=TPU"
if "%MATSELECT%"=="5" set "MATERIAL=ALL"
if not defined MATERIAL set "MATERIAL=PLA"

echo.
echo   Selected material: %MATERIAL%

echo.
echo  ============================================================================
echo                           COLOR QUANTIZATION
echo  ============================================================================
echo.
echo   How many colors should the final model use?
echo.
echo   Enter a number to limit colors (e.g., 4, 8, 16)
echo   Or press Enter for unlimited colors (uses all needed colors)
echo.
set /p "MAXCOLORS=Max colors [default: unlimited]: "

if "%MAXCOLORS%"=="" set "MAXCOLORS=0"

echo.
if "%MAXCOLORS%"=="0" (
    echo   Color limit: Unlimited
) else (
    echo   Color limit: %MAXCOLORS% colors
)

echo.
echo  ============================================================================
echo                            SCANNING FOR FILES
echo  ============================================================================
echo.

:: Initialize variables
set "MODELFILE="
set "TEXTUREFILE="

:: Check for GLB first (preferred)
if exist "%FOLDER%\%BASENAME%.glb" (
    set "MODELFILE=%FOLDER%\%BASENAME%.glb"
    echo   [FOUND] %BASENAME%.glb
)

:: Check for OBJ
if exist "%FOLDER%\%BASENAME%.obj" (
    if not defined MODELFILE set "MODELFILE=%FOLDER%\%BASENAME%.obj"
    echo   [FOUND] %BASENAME%.obj
)

:: Check for MTL
if exist "%FOLDER%\%BASENAME%.mtl" echo   [FOUND] %BASENAME%.mtl

:: Check for texture files
if exist "%FOLDER%\%BASENAME%.jpg" (
    set "TEXTUREFILE=%FOLDER%\%BASENAME%.jpg"
    echo   [FOUND] %BASENAME%.jpg
)
if exist "%FOLDER%\%BASENAME%.jpeg" (
    set "TEXTUREFILE=%FOLDER%\%BASENAME%.jpeg"
    echo   [FOUND] %BASENAME%.jpeg
)
if exist "%FOLDER%\%BASENAME%.png" (
    set "TEXTUREFILE=%FOLDER%\%BASENAME%.png"
    echo   [FOUND] %BASENAME%.png
)
if exist "%FOLDER%\%BASENAME%.bmp" (
    set "TEXTUREFILE=%FOLDER%\%BASENAME%.bmp"
    echo   [FOUND] %BASENAME%.bmp
)
if exist "%FOLDER%\%BASENAME%.tga" (
    set "TEXTUREFILE=%FOLDER%\%BASENAME%.tga"
    echo   [FOUND] %BASENAME%.tga
)

:: Check if we found a model file
if not defined MODELFILE (
    echo.
    echo   [ERROR] No model file found!
    echo           Looking for: %BASENAME%.glb or %BASENAME%.obj
    pause
    exit /b 1
)

echo.
echo  ============================================================================
echo                            CONVERSION SETTINGS
echo  ============================================================================
echo.
echo   Model file:   %MODELFILE%
if defined TEXTUREFILE (
    echo   Texture file: %TEXTUREFILE%
) else (
    echo   Texture file: [None - will use embedded or default]
)
echo   Material:     %MATERIAL%
if "%MAXCOLORS%"=="0" (
    echo   Max colors:   Unlimited
) else (
    echo   Max colors:   %MAXCOLORS%
)
echo   Output path:  %FOLDER%
echo.
echo  ============================================================================
echo.
echo   Press any key to start conversion or CTRL+C to cancel...
pause >nul

cls
echo.
echo  ============================================================================
echo                           CONVERTING MODEL
echo  ============================================================================
echo.

:: Build the command
set "CMD=obj2creality.exe "%MODELFILE%""

:: Add texture if found
if defined TEXTUREFILE set "CMD=!CMD! "%TEXTUREFILE%""

:: Add material option
set "CMD=!CMD! -m %MATERIAL%"

:: Add color limit if specified
if not "%MAXCOLORS%"=="0" set "CMD=!CMD! -c %MAXCOLORS%"

:: Add output option
set "CMD=!CMD! -o "%FOLDER%\%BASENAME%""

:: Show and run the command
echo   Running: !CMD!
echo.
echo  ----------------------------------------------------------------------------
echo.

!CMD!

echo.
echo  ----------------------------------------------------------------------------
echo.

:: Check if output files were created
if exist "%FOLDER%\%BASENAME%_vertexcolor.obj" (
    echo   [SUCCESS] Created: %BASENAME%_vertexcolor.obj
) else (
    echo   [ERROR] Failed to create vertex color OBJ file!
)

if exist "%FOLDER%\%BASENAME%_filaments.txt" (
    echo   [SUCCESS] Created: %BASENAME%_filaments.txt
) else (
    echo   [ERROR] Failed to create filament list!
)

echo.
echo  ============================================================================
echo                              COMPLETE!
echo  ============================================================================
echo.
echo   Material: %MATERIAL%
if not "%MAXCOLORS%"=="0" echo   Limited to %MAXCOLORS% colors
echo.
echo   Output files are in: %FOLDER%
echo.
echo  ============================================================================
echo.

set /p "OPENLIST=Open the filament list now? (Y/N): "
if /i "%OPENLIST%"=="Y" start notepad "%FOLDER%\%BASENAME%_filaments.txt"

set /p "OPENFOLDER=Open the output folder? (Y/N): "
if /i "%OPENFOLDER%"=="Y" explorer "%FOLDER%"

echo.
echo   Press any key to exit...
pause >nul
exit /b 0
