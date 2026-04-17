'args = WScript.Arguments.Count
 
 
Option Explicit
Dim objNetwork 
Dim strDriveLetter, strRemotePath, strUser, strPassword, strProfile
 
' Values of variables set
strDriveLetter = "I:" 
strRemotePath = "\\10.112.44.35\inventry" 
strUser = "10.112.44.35\Inventry"
strPassword = "Inventry1983"
strProfile = "false"
 
' This section creates a network object. (objNetwork)
' Then apply MapNetworkDrive method. Result H: drive
' Note, this script features 5 arguments on lines 21/22.
 
 
on error resume next
Set objNetwork = WScript.CreateObject("WScript.Network") 
objNetwork.MapNetworkDrive strDriveLetter, strRemotePath, _
strProfile, strUser, strPassword
 
 
'Path to all users startup folder: "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup"
 
 
'if args > 0 then 
'msgbox wscript.arguments(0) & wscript.arguments(1)
'end if