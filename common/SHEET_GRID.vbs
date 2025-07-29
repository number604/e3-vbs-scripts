Set App = CreateObject("CT.Application")
Set Job = App.CreateJobObject
Set Cab = Job.CreateDeviceObject
Set Cor = Job.CreatePinObject
Set Sig = Job.CreateSignalObject

If Job.GetId = 0 Then
    App.PutInfo 1, "No project opened, exiting..."
    WScript.Quit
End If


JobName = Job.GetName
App.PutInfo 0, "---- ������ ������ ----"



'===============================================================
' 1-� ����: �������������� �����, ������������ � #, � ������ #<.SHEET><.GRID>
'===============================================================
App.PutInfo 0, "1-� ����: �������������� ����� � ������ #<.SHEET><.GRID>"

' �������� ��� ���� � �������
sigcnt = Job.GetSignalIds(sigids)
If sigcnt = 0 Then
    App.PutInfo 1, "No signals found, exiting..."
    WScript.Quit
End If

' ������ ��� ��������������
Const FORMAT = "#<.SHEET><.GRID>"

' ��������������� ����, ������������ � #
For i = 1 To sigcnt
    Sig.SetId sigids(i)
    SignalName = Sig.GetName
    If Left(SignalName, 1) = "#" Then
        result = Sig.SetNameFormat(FORMAT)
        If result = 0 Then
            App.PutInfo 1, "������ �������������� ���� " & SignalName
        Else
            App.PutInfo 0, "���� " & SignalName & " ������������� � ������ " & FORMAT
        End If
    End If
Next


App.PutInfo 0, "---- ����� ������ ----"