@echo off
setlocal enabledelayedexpansion

rem Check if the folder path is provided as an argument
if "%~1"=="" (
    echo Usage: import_all_ggufs.bat folder_path
    exit /b 1
)

rem Resolve the folder path
set "GGUF_FOLDER=%~1"

rem Check if the folder exists
if not exist "%GGUF_FOLDER%" (
    echo Error: Folder not found - "%GGUF_FOLDER%"
    exit /b 1
)

rem Change directory to the folder
cd /d "%GGUF_FOLDER%" || (
    echo Error: Could not navigate to folder - "%GGUF_FOLDER%"
    exit /b 1
)

rem Initialize counters
set "success_count=0"
set "failure_count=0"

rem Loop through all GGUF files in the folder
for %%f in (*.gguf) do (
    set "GGUF_NAME=%%~nxf"
    set "MODEL_NAME=%%~nf"

    rem Create a .model file with the FROM command
    echo FROM %%f > "!MODEL_NAME!.model"
    echo # set the temperature to 1 [higher is more creative, lower is more coherent]
    echo #PARAMETER temperature 1 >> "!MODEL_NAME!.model"
    echo # set the system message >> "!MODEL_NAME!.model"
    echo #SYSTEM """ >> "!MODEL_NAME!.model"
    echo #You are Mario from Super Mario Bros. Answer as Mario, the assistant, only. >> "!MODEL_NAME!.model"
    echo #""" >> "!MODEL_NAME!.model"

    rem Run the Ollama create command
    echo Importing %%f as model !MODEL_NAME!
    ollama create "!MODEL_NAME!" -f "!MODEL_NAME!.model"
    if errorlevel 1 (
        echo Failed to import %%f
        set /a failure_count+=1
    ) else (
        echo Successfully imported %%f
        set /a success_count+=1
    )
)

rem Print summary
echo =================================
echo Total GGUF files processed: !success_count! success, !failure_count! failure
echo =================================
pause
