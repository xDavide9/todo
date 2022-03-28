@echo off
setlocal enabledelayedexpansion
goto :main

:blank
setlocal

    echo.

    :: checking %file% exists
    if NOT EXIST %file% (
        echo Empty list - use the /a option to add a task
        goto :eof
    )

    :: displaying the list of tasks
    type %file%

endlocal
goto :eof

:delete
setlocal

    :: checking %file% exists
    if NOT EXIST %file% (
        echo.
        echo Empty list - use the /a option to add a task
        goto :eof
    )

    :: getting the id which is wanted to delete
    echo.
    echo Enter the id which you want to delete:
    echo.
    set /p id=

    :: checking the input is a valid number
    echo %id%| findstr /r "^[1-9][0-9]*$">nul
    if NOT %errorlevel% equ 0 (
        echo.
        echo Enter a valid number
        goto :eof
    )

    :: trying to delete from the list
    for /f %%i in ( %file% ) do (
        if %%i equ !id! (
            type %file% > %temporary%
            type %temporary% | findstr /v !id! > %file%
            del %temporary%
            call :deleteFile %file%
            echo.
            echo Successfully deleted
            goto :eof
        )
    )

    echo.
    echo Enter a valid id

endlocal
goto :eof

:deleteFile
setlocal
    if "%~z1"=="0" del %~1
endlocal
goto :eof

:deleteAll
setlocal

    :: checking %file% exists
    if NOT EXIST %file% (
        echo.
        echo Empty list - use the /a option to add a task
        goto :eof
    )

    echo.
    choice /m "Are you sure you want to delete all the tasks?"
    if %errorlevel% equ 1 del %file%

endlocal
goto :eof

:add 
setlocal

    :: initially the id is 1 and the count is 0
    set /a "id=1"
    set /a "count=0"

    :: increment id depending on tasks in %file%
    :: where a task is just a line of that file
    if EXIST %file% (
        for /f %%i in ( %file% ) do (
            if %%i gtr !count! set /a "count=%%i"
            set /a "id=!count!+1"
        )
    )

    :: register new tasks
    echo.
    echo Enter a new task:
    echo.
    set /p task= 
    :: the id comes before the task
    echo !id! %task% >> %file%

    echo.
    echo Successfully added

endlocal
goto :eof

:help
setlocal

    echo.
    echo NAME
    echo    todo - create a list of tasks that are numbered with an id
    echo.
    echo SYNOPSIS
    echo    todo [OPTION]
    echo.
    echo OPTIONS 
    echo    /a, /A - add a task
    echo    /d - to delete a task
    echo    /D - delete all the tasks

endlocal
goto :eof

:main
setlocal

    :: creating location to store information in
    set current=%cd%
    cd %APPDATA%
    mkdir todo 2>nul
    set file=%APPDATA%\todo\todo.txt
    set temporary=%temp%\temp.txt
    cd %current%
    
    if "%~1"=="" goto blank
    if "%~1"=="/a" if "%~2"=="" goto add
    if "%~1"=="/A" if "%~2"=="" goto add
    if "%~1"=="/d" if "%~2"=="" goto delete
    if "%~1"=="/D" if "%~2"=="" goto deleteAll
    if "%~1"=="/?" if "%~2"=="" goto help
    echo.
    echo Invalid argument

endlocal
goto :eof