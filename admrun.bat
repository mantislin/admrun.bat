:adminrun       -- Set user environments (not global environments).
::              -- Read environment settings those set in config file, then output the processed settings to reg file them import it.

@echo OFF

if "%~1" == "/?" goto :help
if "%~1" == "" goto :help

:UACPrompt
    SETLOCAL ENABLEDELAYEDEXPANSION

    for /f "tokens=1-2 delims= " %%x in ('echo %date%') do (
        if "%%x" NEQ "" (
            for /f "tokens=1-3 delims=:./- " %%a in ('echo %%x') do (
                if not "%%b" == "" (
                    set "month=%%a"
                    set "day=%%b"
                    set "year=%%c"
                )
            )
        )
        if "%%y" NEQ "" (
            for /f "tokens=1-3 delims=:./- " %%a in ('echo %%y') do (
                if not "%%b" == "" (
                    set "month=%%a"
                    set "day=%%b"
                    set "year=%%c"
                )
            )
        )
    )

    for /f "tokens=1-4 delims=:./- " %%a in ('echo %time%') do (
        set "hour=%%a" & set "min=%%b" & set "sec=%%c" & set "msec=%%d"
    )

    set "vbsname=getadmin_%year%%month%%day%_%hour%%min%%sec%%msec%.vbs"
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\%vbsname%"

    set params=%*
    if "%params%" NEQ "" set params=%params:"=""%

    rem echo UAC.ShellExecute "%comspec%", "/c %params%", "", "runas", 0 >> "%temp%\%vbsname%"
    echo UAC.ShellExecute "cmd.exe", "/c start """" /d ""%~sdp1"" /b %params%", "", "runas", 0 >> "%temp%\%vbsname%"

    "%temp%\%vbsname%"
    set exitCode=%errorlevel%
    del/q/f "%temp%\%vbsname%"
    (ENDLOCAL
        set ERRORLEVEL=%exitCode%
    )
    exit/b

:help
    echo/Append file to run as admin, and append parameters for the file.
    exit/b
