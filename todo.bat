@echo off
setlocal enabledelayedexpansion
goto :main

:blank
setlocal

    echo.

    :: checking todo.txt exists
    if NOT EXIST todo.txt (
        echo Please use the /a option to add a task
        goto :eof
    )

    :: displaying the list of tasks
    type todo.txt

endlocal
goto :eof

:delete
setlocal

    :: checking todo.txt exists
    if NOT EXIST todo.txt (
        echo.
        echo Please use the /a option to add a task
        goto :eof
    )

    :: getting the id which is wanted to delete
    echo.
    echo Please enter the id which you want to delete:
    echo.
    set /p id=

    :: checking the input is a valid number
    echo %id%| findstr /r "^[1-9][0-9]*$">nul
    if NOT %errorlevel% equ 0 (
        echo.
        echo Please enter a valid number
        goto :eof
    )

    :: trying to delete from the list
    for /f %%i in ( todo.txt ) do (
        if %%i equ !id! (
            type todo.txt > temp.txt
            type temp.txt | findstr /v !id! > todo.txt
            del temp.txt
            call :deleteFile todo.txt
            echo.
            echo Successfully deleted
            goto :eof
        )
    )

    echo.
    echo No such id 

endlocal
goto :eof

:deleteFile
setlocal
    if "%~z1"=="0" del %~1
endlocal
goto :eof

:deleteAll
setlocal

    echo.
    choice /m "Are you sure you want to delete all the tasks?"
    if %errorlevel% equ 1 del todo.txt

endlocal
goto :eof

:add 
setlocal

    :: initially the id is 1 and the count is 0
    set /a "id=1"
    set /a "count=0"

    :: increment id depending on tasks in todo.txt
    :: where a task is just a line of that file
    if EXIST todo.txt (
        for /f %%i in ( todo.txt ) do (
            if %%i gtr !count! set /a "count=%%i"
            set /a "id=!count!+1"
        )
    )

    :: register new tasks
    echo.
    echo Please enter a task:
    echo.
    set /p task= 
    :: the id comes before the task
    echo !id! %task% >> todo.txt

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

    if "%~1"=="" goto blank
    if "%~1"=="/a" if "%~2"=="" goto add
    if "%~1"=="/A" if "%~2"=="" goto add
    if "%~1"=="/d" if "%~2"=="" goto delete
    if "%~1"=="/D" if "%~2"=="" goto deleteAll
    if "%~1"=="/?" if "%~2"=="" goto help
    echo Invalid argument

endlocal
goto :eof