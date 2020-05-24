#NoEnv
#Warn
#SingleInstance Force
SendMode Input
SetWorkingDir %A_ScriptDir%
SetBatchLines -1

FileRead, serverUrl, .env
whr := ComObjCreate("WinHttp.WinHttpRequest.5.1") ; https://www.autohotkey.com/boards/viewtopic.php?t=72287=

colorGreen = 7CFC00
colorRed = F08080

Gui, Color, %colorGreen%
Gui Add, Edit, vTicker x0 y0 w50 h23, TICKER
Gui Add, Radio, gBkgGreen vSide x46 y32 w24 h22 Checked, L
Gui Add, Radio, gBkgRed x70 y31 w23 h23, S
Gui Add, Button, x56 y0 w49 h23, SEND
; Gui Add, Button, x104 y0 w25 h23, + ; intended for adding instances
Gui Add, ComboBox, vRisk x0 y32 w42, 10||11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|20|30|31|32|33|34|35|36|37|38|39|40
Gui Add, CheckBox, vPriorBar x95 y32 w31 h23, P

Gui, +ToolWindow +AlwaysOnTop +Owner
Gui Show, NoActivate w128 h59, Send Order
return

BkgGreen:
Gui, Color, %colorGreen%
return

BkgRed:
Gui, Color, %colorRed%
return

ButtonSEND:
Gui, Submit, NoHide
sideString := Side = 1 ? "LONG" : "SHORT"
priorBarString := PriorBar = 1 ? "TRUE" : "FALSE"
url := serverUrl . "?ticker=" . Ticker . "&side=" . sideString . "&risk=" . Risk . "&priorbar=" . priorBarString
whr.Open("GET", url, true)
whr.Send()
whr.WaitForResponse()
MsgBox % whr.ResponseText
return

GuiEscape:
GuiClose:
    ExitApp