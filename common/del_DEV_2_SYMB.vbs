Set e3Application = CreateObject("CT.Application")
Set job = e3Application.CreateJobObject()

Set device = job.CreateDeviceObject()
Set symbol = job.CreateSymbolObject()

Dim deletedDevices
Set deletedDevices = CreateObject("Scripting.Dictionary")

' �������� ID ���� ���������� ��������
selectedCount = job.GetSelectedSymbolIds(selectedSymbolIds)
If selectedCount = 0 Then
    e3Application.PutInfo 0, "��� ���������� �������� �� �����"
    WScript.Quit
End If

e3Application.PutInfo 0, "�������� ��������: " & selectedCount

' �������� ��� ���������� � �������
deviceCount = job.GetAllDeviceIds(deviceIds)
If deviceCount = 0 Then
    e3Application.PutInfo 0, "� ������� ��� ���������"
    WScript.Quit
End If

' ��� ������� ����������� �������
For selectedIndex = 1 To selectedCount
    selectedSymbolId = selectedSymbolIds(selectedIndex)
    symbol.SetId(selectedSymbolId)
    selectedRealId = symbol.GetId()
    
    found = False

    ' �������� �� ���� ��������
    For i = 1 To deviceCount
        deviceId = deviceIds(i)

        If Not deletedDevices.Exists(CStr(deviceId)) Then
            device.SetId(deviceId)
            
            result = device.GetSymbolIds(symbolIds, 3) ' 3 � ��� �������, ������� ����������
            
            If result > 0 Then
                For j = 1 To result
                    symbol.SetId(symbolIds(j))
                    currentSymbolId = symbol.GetId()
                    
                    If currentSymbolId = selectedRealId Then
                        found = True
                        deviceName = device.GetName()
                        
                        delResult = device.DeleteForced()
                        
                        If delResult = 1 Then
                            deletedDevices.Add CStr(deviceId), True
                            e3Application.PutInfo 0, "������� ����������: " & deviceName & " (" & deviceId & ")"
                        Else
                            e3Application.PutInfo 0, "������ ��� ��������: " & deviceName & " (" & deviceId & ")"
                        End If
                        Exit For
                    End If
                Next
            End If

            If found Then Exit For
        End If
    Next

    If Not found Then
        e3Application.PutInfo 0, "���������� ��� ������� " & selectedRealId & " �� �������"
    End If
Next

' �������
Set deletedDevices = Nothing
Set symbol = Nothing
Set device = Nothing
Set job = Nothing
Set e3Application = Nothing
