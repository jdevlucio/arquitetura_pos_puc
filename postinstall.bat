@echo off
SetLocal EnableDelayedExpansion

set FILE_PATH=node_modules\native-base\src\core\NativeBaseProvider.tsx

REM Check if the file exists
if not exist "%FILE_PATH%" (
    echo Error: File does not exist.
    exit /b 1
)

REM Creating a temporary file
set TEMP_FILE=%FILE_PATH%.temp

REM Process line by line
for /f "tokens=*" %%a in ('type "%FILE_PATH%"') do (
    set "line=%%a"
    
    REM Check and remove the import statement
    echo !line! | findstr /v /c:"import { SSRProvider } from '@react-native-aria/utils';" > nul
    if !errorlevel! equ 0 (
        REM Write the line to temp file if it's not the import statement
        echo !line! >> "%TEMP_FILE%"
    ) else (
        REM Replace '<SSRProvider>{children}</SSRProvider>' with '{children}'
        set "modified=!line:<SSRProvider>{children}</SSRProvider>={children}!"
        echo !modified! >> "%TEMP_FILE%"
    )
)

REM Replace the original file with the modified one
move /Y "%TEMP_FILE%" "%FILE_PATH%" > nul

echo Modifications complete.
EndLocal