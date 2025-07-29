Set e3App = CreateObject("CT.Application")
Set job = e3App.CreateJobObject()

Set device = job.CreateDeviceObject()
Set symbol = job.CreateSymbolObject()
Set pin = job.CreatePinObject()

' �������� ID ���� ���������� ��������
selectedCount = job.GetSelectedSymbolIds(selectedSymbolIds)
If selectedCount = 0 Then
    e3App.PutInfo 0, "��� ���������� �������� �� �����"
    WScript.Quit
End If

' ������������ ��������� ����� �������� (������ ����������)
selectedSymbolId = selectedSymbolIds(1)
symbol.SetId(selectedSymbolId)
symbolRealId = symbol.GetId()

e3App.PutInfo 0, "��������� ������� ID: " & symbolRealId

' ���� ����������, �������� ����������� ������
Dim foundDeviceId
foundDeviceId = 0

' �������� ��� ���������� � �������
deviceCount = job.GetAllDeviceIds(deviceIds)
If deviceCount = 0 Then
    e3App.PutInfo 0, "� ������� ��� ���������"
    WScript.Quit
End If

' ����� ���������� �� �������
For i = 1 To deviceCount
    device.SetId(deviceIds(i))
    
    ' �������� ��� ������� ���������� (3 - ��� �������, ������� ����������)
    result = device.GetSymbolIds(symbolIds, 3)
    
    If result > 0 Then
        For j = 1 To result
            symbol.SetId(symbolIds(j))
            currentSymbolId = symbol.GetId()
            
            If currentSymbolId = symbolRealId Then
                foundDeviceId = deviceIds(i)
                Exit For
            End If
        Next
    End If
    
    If foundDeviceId <> 0 Then Exit For
Next

If foundDeviceId = 0 Then
    e3App.PutInfo 0, "���������� ��� ������� " & symbolRealId & " �� �������"
    WScript.Quit
End If

' �������� ��������� ����������
device.SetId(foundDeviceId)
deviceName = device.GetName()
e3App.PutInfo 0, "������� ����������: " & deviceName & " (ID: " & foundDeviceId & ")"
e3App.PutInfo 0, "������� �������� �� �����..."

' �������� ��� ���� ����������
pinCount = device.GetPinIds(pinIds)
If pinCount = 0 Then
    e3App.PutInfo 0, "� ���������� ��� �����"
    WScript.Quit
End If

Dim clearedCount
clearedCount = 0

' ������� ������� �� ���� �����
For i = 1 To pinCount
    pin.SetId(pinIds(i))
    pinName = pin.GetName()
    
    ' ��������� ������� ������
    currentSignal = pin.GetSignalName()
    If Len(currentSignal) > 0 Then
        ' ������� ������
        result = pin.SetSignalName("")
        If result = 1 Then
            clearedCount = clearedCount + 1
            e3App.PutInfo 0, "������ ��� " & pinName & " (��� ������: '" & currentSignal & "')"
        Else
            e3App.PutInfo 1, "������ ������� ���� " & pinName
        End If
    End If
Next

' �������� �����
e3App.PutInfo 0, "������. ������� ��������: " & clearedCount & " �� " & pinCount & " �����"

' ������� ��������
Set pin = Nothing
Set symbol = Nothing
Set device = Nothing
Set job = Nothing
Set e3App = Nothing