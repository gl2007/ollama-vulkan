@echo off
setlocal enabledelayedexpansion

rem Check if the GGUF file path is provided as an argument
if "%~1"=="" (
    echo Usage: import_single_gguf.bat gguf_file_path
    exit /b 1
)

rem Resolve the full path to the file
for %%f in ("%~1") do (
    set "GGUF_FILE=%%~dpf%%~nxf"
    set "GGUF_FOLDER=%%~dpf"
    set "GGUF_NAME=%%~nxf"
    set "MODEL_NAME=%%~nf"
)

rem Check if the file exists
if not exist "%GGUF_FILE%" (
    echo Error: File not found - "%GGUF_FILE%"
    exit /b 1
)

rem Change directory to the GGUF folder
cd /d "%GGUF_FOLDER%" || (
    echo Error: Could not navigate to folder - "%GGUF_FOLDER%"
    exit /b 1
)

rem Create a .model file with the FROM command
echo FROM %GGUF_NAME% > "%MODEL_NAME%.model"
echo # set the temperature to 1 [higher is more creative, lower is more coherent]
echo #PARAMETER temperature 1 >> "%MODEL_NAME%.model"
echo # set the system message >> "%MODEL_NAME%.model"
echo #SYSTEM """ >> "%MODEL_NAME%.model"
echo #You are Mario from Super Mario Bros. Answer as Mario, the assistant, only. >> "%MODEL_NAME%.model"
echo #""" >> "%MODEL_NAME%.model"

rem Run the Ollama create command
echo Importing %GGUF_NAME% as model %MODEL_NAME%
ollama create "%MODEL_NAME%" -f "%MODEL_NAME%.model"
if errorlevel 1 (
    echo Failed to import %GGUF_NAME%
    exit /b 1
)

rem Print success message
echo =================================
echo Import completed successfully for %GGUF_NAME%
echo =================================
pause
