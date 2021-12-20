@echo off
@setlocal enableextensions enabledelayedexpansion
chcp 65001

title Resovled Replays - RReplays VS Rendering

set configFile=config.ini

call :GetConfig
call :RenderReplays

endlocal
pause
exit /b %ERRORLEVEL% 

:GetConfig
set /a i=-2
for /f "usebackq delims=" %%l in (!configFile!) do (
	set line=%%l
	
	if "!line:~0,1!" == "[" (
        set /a i += 1
    ) else (
		for /f "tokens=1,2 delims==" %%b in ("!line!") do (
            set currentKey=%%b
            set currentValue=%%c
			
			:: Parse General section
            if "!currentKey!" == "DanserDirectory " (
				:: Remove leading and trailing whitespace
				call :TrimString trimedString !currentValue!

				:: Append the value to the array
				set danserDirectory=!trimedString!
			)

			if "!currentKey!" == "LeftPlayerSettings " (
				:: Remove leading and trailing whitespace
				call :TrimString trimedString !currentValue!

				:: Append the value to the array
				set settings[0]=!trimedString!
			)
			
			if "!currentKey!" == "RightPlayerSettings " (
				:: Remove leading and trailing whitespace
				call :TrimString trimedString !currentValue!

				:: Append the value to the array
				set settings[1]=!trimedString!
			)

			if "!currentKey!" == "MusicSettings " (
				:: Remove leading and trailing whitespace
				call :TrimString trimedString !currentValue!

				:: Append the value to the array
				set settings[2]=!trimedString!
			)

			if "!currentKey!" == "MusicOuputName " (
				:: Remove leading and trailing whitespace
				call :TrimString trimedString !currentValue!

				:: Append the value to the array
				set musicOutputName=!trimedString!
			)

			:: Parse LeftPlayer and RightPlayer section
			if "!currentKey!" == "PlayerName " (
				:: Remove leading and trailing whitespace
				call :TrimString trimedString !currentValue!

				:: Append the value to the array
				set playerNames[!i!]=!trimedString!
			)
			
			if "!currentKey!" == "ReplayPath " (
				:: Remove leading and trailing whitespace
				call :TrimString trimedString !currentValue!

				:: Append the value to the array
				set replayPaths[!i!]=!trimedString!
			)
			
			if "!currentKey!" == "Skin " (
				:: Remove leading and trailing whitespace
				call :TrimString trimedString !currentValue!

				:: Append the value to the array
				set skins[!i!]=!trimedString!
			)
        )
	)
)

exit /b 0

:RenderReplays
:: Change current working directory to danser directory
pushd !danserDirectory!

:: Render replays with danser
for /l %%n in (0, 1, 1) do (
	.\danser.exe -replay "!replayPaths[%%n]!" -skin "!skins[%%n]!" -settings "!settings[%%n]!" -out "!playerNames[%%n]!"
)

:: Render audio
.\danser.exe -replay "!replayPaths[0]!" -settings "!settings[2]!" -out !musicOutputName!

:: Return to the previous working directory
popd

exit /b 0

:TrimString
set agrs=%*
for /f "tokens=1*" %%a in ("!agrs!") do (
	set %1=%%b
)

exit /b 0
