Local $hWnd
Local $x
Local $y
Local $width
Local $height

Local $timer = TimerInit()
Local $timeout = 60000

_Main()

Func _Main()
	_Init()
	AdlibRegister('_Run', 1000)

	While True
	WEnd
EndFunc

Func _Init()
	HotKeySet('{PAUSE}', '_Exit')
	AutoItSetOption('MouseCoordMode', 2)
	_ProcessAttach()
EndFunc

Func _ProcessAttach()
	$hWnd = WinWait('BlueStacks App Player', '', 5)

	If $hWnd = 0 Then
		MsgBox(0, 'ERROR', 'Could not locate game window', 10)
		_Exit()
	EndIf

	WinActivate($hWnd)

	If WinWaitActive($hWnd, '', 5) = 0 Then
		MsgBox(0, 'ERROR', 'Could not activate game window', 10, $hWnd)
		_Exit()
	EndIf
EndFunc

Func _Run()
	Local $ctrlCoords = ControlGetPos($hWnd, '', '[CLASS:BlueStacksApp]')
	$x = $ctrlCoords[0]
	$y = $ctrlCoords[1]
	$width = $ctrlCoords[2]
	$height = $ctrlCoords[3]

	; _ReloadGame()
	_ItemCollect(0)
	; _ItemCollect(1)
EndFunc

Func _ReloadGame()
	If TimerDiff($timer) >= $timeout Then
		MouseClick('primary', $x, $y, 1, 0)
		$timer = TimerInit()
	EndIf
EndFunc

Func _ItemCollect($itemId)
	Local $itemColors[2]
	Local $item[2] = [$x, $y]

	Switch $itemId
		Case 0
			$itemColors[0] = 0xF4E758
			$itemColors[1] = 0xEBD045

		Case 1
			; $itemColor = 0xEF8EE5
	EndSwitch

	Local $i
	Local $searchX1 = 425 ; $x
	Local $searchX2 = 450 ; $x + $width - 100

	For $i = 0 To $i < UBound($itemColors)
		ConsoleWrite($i & ' Start ' & $searchX1 & ' ' & $item[1] & @CRLF)
		$item = PixelSearch($searchX1, $item[1], $searchX2, $item[1], $itemColors[$i], 100, 1, $hWnd)

		If @error Then
			ConsoleWrite('Failed' & @CRLF)
			ExitLoop
		EndIf

		ConsoleWrite($i & ' End ' & $item[0] & ' ' & $item[1] & @CRLF)

		$searchX1 = $item[0] + 1
		$searchX2 = $item[0] + 1
	Next

	If $i = UBound($itemColors) Then
		MouseClick('primary', $item[0], $item[1], 1, 0)
		Sleep(20)
	EndIf
	ConsoleWrite(@CRLF & @CRLF)
EndFunc

Func _Exit()
	Exit
EndFunc
