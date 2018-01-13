﻿;【概要】選択されたUriを開く（エクスプローラかブラウザかは文字列で判断）
;【引数】なし
;【戻値】なし
openUri() {
	Clipboard =        ;ClipWaitで確実にコピーするため？
    Send ^c
    Sleep 200
    word := RegExReplace(Clipboard, "\r\n", "")        ;URLに改行が含まれる場合は削除する

    SplitPath, word, name, dir, ext, noext, drive
    IfInString, drive, http://
    {
        Run, %word%
	}
    else if(drive != "") {
        Run, %word%
    }
    else if(Clipboard != "") {
        Run, http://www.google.com/search?q=%word%
    }
}


;【概要】ウィンドウサイズの最大化⇔元のサイズ
;【引数】なし
;【戻値】なし
changeWindowSizeMaxOrRestore() {
    fullX1 := getSettingsValue("ScreenSize", "fullX1")
    fullY1 := getSettingsValue("ScreenSize", "fullY1")
    fullX2 := getSettingsValue("ScreenSize", "fullX2")
    fullY2 := getSettingsValue("ScreenSize", "fullY2")
    fullX3 := getSettingsValue("ScreenSize", "fullX3")
    fullY3 := getSettingsValue("ScreenSize", "fullY3")

	WinGetPos, ,, aeroX, aeroY, A
	if (fullX1 = aeroX && fullY1 = aeroY)
	{
		WinRestore, A
		return
	} else if (fullX2 = aeroX && fullY2 = aeroY)
	{
		WinRestore, A
		return
	}  else if (fullX3 = aeroX && fullY3 = aeroY)
	{
		WinRestore, A
		return
	}

	WinMaximize, A
}


;【概要】ウィンドウサイズをデュアルサイズで最大化します
;        ただし、縦幅は短い方に合わせます
;【引数】なし
;【戻値】なし
changeWindowSizeDualMax() {
    fullX := getSettingsValue("DualFullScreenSize", "X")
    fullY := getSettingsValue("DualFullScreenSize", "Y")

    WinRestore, A  ;ウィンドウサイズを変更するため最大化を元に戻す
	WinMove A, , 0, 0, %fullX%, %fullY%
}


;【概要】マウスカーソルを画面９分割の場所に移動する
;【引数】xとyの座標番号
;【戻値】なし
moveMousePointer(indexX, indexY) {
	CoordMode, Mouse, Screen
	MouseGetPos, mX, mY
    monitorLoc := getMonitorLocationInPointer()

    locX := getSettingsValue("QuickMoveWindow", monitorLoc . "LocX")
    locY := getSettingsValue("QuickMoveWindow", monitorLoc . "LocY")
    winX := getSettingsValue("QuickMoveWindow", monitorLoc . "WinX")
    winY := getSettingsValue("QuickMoveWindow", monitorLoc . "WinY")

	dstX := locX + winX / 6 * (1 + (indexX - 1) * 2 )
	dstY := locY + winY / 6 * (1 + (indexY - 1) * 2 )

	moveMouse(dstX - mX, dstY - mY)
	CoordMode, Mouse, Relative
}


;【概要】マウスカーソルを画面９方向の端に表示する
;【引数】xとyの座標番号
;【戻値】なし
moveMousePointerEdge(indexX, indexY) {
    CoordMode, Mouse, Screen
    MouseGetPos, mX, mY
    monitorLoc := getMonitorLocationInPointer()

    locX := getSettingsValue("QuickMoveWindow", monitorLoc . "LocX")
    locY := getSettingsValue("QuickMoveWindow", monitorLoc . "LocY")
    winX := getSettingsValue("QuickMoveWindow", monitorLoc . "WinX")
    winY := getSettingsValue("QuickMoveWindow", monitorLoc . "WinY")
    padding := 10
    deltaX := winX / 2 - padding
    deltaY := winY / 2 - padding

    dstX := locX + padding + (deltaX * (indexX - 1))
    dstY := locY + padding + (deltaY * (indexY - 1))

    moveMouse(dstX - mX, dstY - mY)
    CoordMode, Mouse, Relative
}

;【概要】マウスカーソルを各モニタの中央に移動する
;【引数】場所 (LeftUp / LeftDown / RightUp / RightDown )
;【戻値】なし
moveMousePointerScreen(location) {
    CoordMode, Mouse, Screen
    MouseGetPos, mX, mY

    locX := getSettingsValue("QuickMoveWindow", location . "LocX")
    locY := getSettingsValue("QuickMoveWindow", location . "LocY")
    winX := getSettingsValue("QuickMoveWindow", location . "WinX")
    winY := getSettingsValue("QuickMoveWindow", location . "WinY")

    padding := 10
    deltaX := winX / 2 - padding
    deltaY := winY / 2 - padding

    dstX := locX + padding + deltaX
    dstY := locY + padding + deltaY

    moveMouse(dstX - mX, dstY - mY)
    CoordMode, Mouse, Relative
}

;【概要】ポインタが存在するモニタ位置を取得する
;【引数】なし
;【戻値】LeftUp / LeftDown / RightUp / RightDown 
getMonitorLocationInPointer() {
    CoordMode, Mouse, Screen
    MouseGetPos, mX, mY
    CoordMode, Mouse, 

    leftUpLocX := getSettingsValue("QuickMoveWindow", "LeftUpLocX")
    leftUpLocY := getSettingsValue("QuickMoveWindow", "LeftUpLocY")
    leftDownLocX := getSettingsValue("QuickMoveWindow", "LeftDownLocX")
    leftDownLocY := getSettingsValue("QuickMoveWindow", "LeftDownLocY")
    rightUpLocX := getSettingsValue("QuickMoveWindow", "RightUpLocX")
    rightUpLocY := getSettingsValue("QuickMoveWindow", "RightUpLocY")
    rightDownLocX := getSettingsValue("QuickMoveWindow", "RightDownLocX")
    rightDownLocY := getSettingsValue("QuickMoveWindow", "RightDownLocY")

    ; 左の上下液晶widthが異なる場合があるため、統一されている右液晶の起点を基準に判定
    if (mX < rightUpLocX) {
        if (mY < leftDownLocY) {
            return "LeftUp"
        } else {
            return "LeftDown"
        }
    } else {
        if (mY < rightDownLocY) {
            return "RightUp"
        } else {
            return "RightDown"
        }
    }
}


;【概要】ウィンドウを最適な大きさで、任意の場所に移動する
;【引数】場所 (LeftUp / LeftDown / RightUp / RightDown )
;【戻値】なし
MoveWindow(location) {
    locX := getSettingsValue("QuickMoveWindow", location . "LocX")
    locY := getSettingsValue("QuickMoveWindow", location . "LocY")
    winX := getSettingsValue("QuickMoveWindow", location . "WinX")
    winY := getSettingsValue("QuickMoveWindow", location . "WinY")
    isFull := getSettingsValue("QuickMoveWindow", location . "IsFull")

    ; WinMaximizeの後にWinMoveすると、最小化から復帰したときウィンドウ位置が不正になる
    WinRestore, A
	WinMove A, , %locX%, %locY%, %winX%, %winY%
    if (isFull) {
        WinMaximize, A
    }
}


;【概要】ウィンドウをスクリーン単位で移動します
;【引数】なし
;【戻値】なし
moveScreen() {
	Send #+{right}
}


;【概要】現在押下されているキーが2連続目に押されているかを返します
;【引数】なし
;【戻値】true: 2連続目に押されている
isDoubleKey() {
    return (A_PriorHotKey = A_ThisHotKey and A_TimeSincePriorHotkey < 200)
}


;【概要】現在押下されているキーが特定のキーが押されてから特定の時間内に押されているかを返します。
;        ただし、日本語入力がONになっている場合は必ずFalseを返します。
;【引数】特定のキー
;【戻値】true: 押されている
isConbinationKeyAndIMEOn(key) {
    if (IME_GET()) {
        return false
    }
    return (A_PriorHotKey = key and A_TimeSincePriorHotkey < 200)
}


;【概要】現在押下されているキーが特定のキーが押されてから特定の時間内に押されているかを返します。
;【引数】特定のキー
;【戻値】true: 押されている
isConbinationKey(key) {
    return (A_PriorHotKey = key and A_TimeSincePriorHotkey < 200)
}

;【概要】現在押下されているキーが;の後に押されたものかを返します。
;【引数】なし
;【戻値】true: 押されている
isSecondKey() {
    return (A_PriorHotKey = "$;")
}

;【概要】マルチバイト文字列をsendします。
;        日本語入力のON/OFFに関わらず決定された状態で出力します。
;        複数指定することもできます。
;【引数】キー
;【戻値】なし
sendMultiByte(keys) {
    sendInput %keys%
    sleep 50
}


;【概要】日本語入力をON/OFFを指定して切り替える
;【引数】true: 日本語入力ON / false: 日本語入力OFF
;【戻値】なし
setIME(imeOn) {
    if (isActive("ubuntu")) {
        if (imeOn) {
            send {sc046}
        } else {
            send ^{sc046}
        }
    } else {
        IME_SET(imeOn)
    }
}

getIME() {
    return IME_GET()
}
