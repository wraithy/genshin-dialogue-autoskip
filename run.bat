<# : GenshinDialogueSkip -- https://github.com/wraithy/genshin-dialogue-autoskip
@echo off & setlocal
title Overlay
mode 40,9

rem // Relaunch self in PowerShell to run this window Always On Top
powershell -noprofile "iex (${%~f0} | out-string)"

pushd "%~dp0"
py ./autoskip_dialogue.py
@pause

goto :EOF
rem // end batch / begin PowerShell hybrid code #>

# // Solution based on http://stackoverflow.com/a/34703664/1683264
add-type user32_dll @'
    [DllImport("user32.dll")]
    public static extern bool SetWindowPos(IntPtr hWnd, IntPtr hWndInsertAfter,
        int x, int y, int cx, int cy, uint uFlags);
'@ -namespace System

# // Walk up the process tree until we find a window handle
$id = $PID
do {
    $id = (gwmi win32_process -filter "ProcessID='$id'").ParentProcessID
    $hwnd = (ps -id $id).MainWindowHandle
} while (-not $hwnd)

$rootWin = [IntPtr](-1)
$topmostFlags = 0x0003
[void][user32_dll]::SetWindowPos($hwnd, $rootWin, 0, 0, 0, 0, $topmostFlags)