' ������: �������������� ��������� -sXT1 � -XT666 � �� ����������� � 6 / 66
' ������������ ������ ���������� � ������������� ������������

Set app = CreateObject("CT.Application")
Set job = app.CreateJobObject()
Set device = job.CreateDeviceObject()

Dim deviceIds
result = job.GetAllDeviceIds(deviceIds)

Dim foundCount
foundCount = 0

app.PutInfo 0, "=== ����� ��������� -sXT1 ==="

If result > 0 Then
    app.PutInfo 0, "����� ��������� � �������: " & result
    
    ' ������� ������ ��� ���������� -sXT1 � �������� �� ����������
    Dim sxtDevices()
    Dim sxtCount
    sxtCount = 0
    
    For i = 1 To result
        device.SetId deviceIds(i)
        name = device.GetName()
        
        If name = "-sXT1" Then
            ' ���������, ���� �� � ���������� ���������
            currentMasterPin = device.GetMasterPinName()
            
            app.PutInfo 0, "--- ������� ���������� -sXT1 ---"
            app.PutInfo 0, "ID ����������: " & deviceIds(i)
            app.PutInfo 0, "������� ���������: '" & currentMasterPin & "'"
            
            ' ���� ��������� ���������� (�� ������)
            If Len(Trim(currentMasterPin)) > 0 Then
                sxtCount = sxtCount + 1
                ReDim Preserve sxtDevices(sxtCount - 1)
                sxtDevices(sxtCount - 1) = deviceIds(i)
                app.PutInfo 0, "���������� ��������� � ������ ��� ��������� (�" & sxtCount & ")"
            Else
                app.PutInfo 0, "���������� ��������� - ��� ����������"
            End If
        End If
    Next
    
    app.PutInfo 0, "=== ��������� ��������� ��������� ==="
    app.PutInfo 0, "��������� � ������������ ��� ���������: " & sxtCount
    
    ' ������ ������������ ��������� ���������� � ������������
    For j = 0 To sxtCount - 1
        If j >= 2 Then
            app.PutInfo 0, "������� ����� ���� ��������� � ������������. ��������� �� ����������."
            Exit For
        End If
        
        device.SetId sxtDevices(j)
        foundCount = j + 1
        
        app.PutInfo 0, "--- ��������� ���������� #" & foundCount & " ---"
        
        ' �������������� ����������
        newName = "-XT666"
        resultSet = device.SetName(newName)
        
        If resultSet = 0 Then
            app.PutInfo 0, "������ ��� �������������� ���������� #" & foundCount
        Else
            app.PutInfo 0, "���������� #" & foundCount & " ������������� � " & newName
        End If
        
        ' ��������� ����������
        If foundCount = 1 Then
            resultPin = device.SetMasterPinName("6")
            If resultPin = 0 Then
                app.PutInfo 0, "������ ��� ��������� ���������� '6' ��� ���������� #" & foundCount
            Else
                app.PutInfo 0, "��������� ���������� #" & foundCount & " ���������� �: 6"
            End If
        ElseIf foundCount = 2 Then
            resultPin = device.SetMasterPinName("66")
            If resultPin = 0 Then
                app.PutInfo 0, "������ ��� ��������� ���������� '66' ��� ���������� #" & foundCount
            Else
                app.PutInfo 0, "��������� ���������� #" & foundCount & " ���������� �: 66"
            End If
        End If
        
        ' �������� ����������
        finalMasterPin = device.GetMasterPinName()
        app.PutInfo 0, "�������� ���������: '" & finalMasterPin & "'"
    Next
    
    If sxtCount = 0 Then
        app.PutInfo 0, "�� ������� �� ������ ���������� -sXT1 � �����������."
    End If
    
Else
    app.PutInfo 0, "������: ���������� � ������� �� �������."
End If

app.PutInfo 0, "=== ������ �������� ==="

' �������
Set device = Nothing
Set job = Nothing
Set app = Nothing