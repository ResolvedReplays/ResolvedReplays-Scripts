@echo off

title Resovled Replays - RReplays Resample

set /A fps = 240
set /A blendFrames = %fps% / 30

for %%i in (*.mkv) do (
	:: Use ffmpeg for resampling
	ffmpeg -i "%%i" -c:v libx264 -preset slow -movflags faststart -crf 12 -vf tmix=frames=%blendFrames%:weights="1 1.7 2.1 4.1 5" -c:a copy -r 60 "%%~ni.mp4"
	
	:: Remove file after finished
	if not errorlevel 1 if exist "%%~dpni.mp4" del /q "%%i"
)
