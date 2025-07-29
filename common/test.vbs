' ������������� ������ ��� ���������� ���� ����� �������� ���� - ������ 2
' ������������ ��� ���� � �������, ������� ����� ����� connections

Set app = CreateObject("CT.Application") 
Set job = app.CreateJobObject()
Set symbol = job.CreateSymbolObject()
Set pin = job.CreatePinObject()
Set device = job.CreateDeviceObject()
Set connection = job.CreateConnectionObject()

' ������� ��� �������� ��������� �����
Set dictPinIds = CreateObject("Scripting.Dictionary")

' ��������� ���������� �� ������������
wiregroupName = InputBox("��� �������", "", "������(�)-LS")
If wiregroupName = "" Then
    app.PutInfo 0, "�������� �������������."
    WScript.Quit
End If

databaseWireName = InputBox("������� � ����", "", "1�0.75(�����)")
If databaseWireName = "" Then
    app.PutInfo 0, "�������� �������������."
    WScript.Quit
End If

wireName = InputBox("��� �������", "", "N")
If wireName = "" Then
    app.PutInfo 0, "�������� �������������."
    WScript.Quit
End If

signalName = InputBox("��� ���� ��� ������", "", "N")
If signalName = "" Then
    app.PutInfo 0, "�������� �������������."
    WScript.Quit
End If

app.PutInfo 0, "�������� ����� ����� ����: " & signalName

' �������� ������� ������ ���� ����� ���� � �������
Call FIND_ALL_PINS_BY_SIGNAL()

' ����� ����� ����� connections
Call FIND_PINS_BY_CONNECTIONS()

' �������� ���������� ����� ���������� ������
Call CREATE_CONNECTIONS()

app.PutInfo 0, "��������� ���������."

'==========================================
' ������� ������ ���� ����� �� ����� ����
'==========================================
Sub FIND_ALL_PINS_BY_SIGNAL()
    app.PutInfo 0, "����� ���� ����� � ������� �� signal name..."
    
    ' �������� ��� ���������� � �������
    deviceCount = job.GetDeviceIds(deviceIds)
    app.PutInfo 0, "������� ��������� � �������: " & deviceCount
    
    ' ���������� Collection ��� ������������� �������� ������ �����
    Set pinCollection = CreateObject("Scripting.Dictionary")
    Dim pinCounter
    pinCounter = 0
    
    ' �������� �� ���� �����������
    For deviceIndex = 1 To deviceCount
        deviceId = device.SetId(deviceIds(deviceIndex))
        deviceName = device.GetName()
        
        ' �������� ��� ���� ����������
        pinCount = device.GetPinIds(pinIds)
        
        If pinCount > 0 Then
            For pinIndex = 1 To pinCount
                pinId = pin.SetId(pinIds(pinIndex))
                pinName = pin.GetName()
                pinSignalName = pin.GetSignalName()
                
                ' ���������, ������������� �� ��� ����� ����
                If pinSignalName = signalName Then
                    ' ���������, �� �������� �� ��� ���� ���
                    If Not dictPinIds.Exists(pinId) Then
                        dictPinIds.Add pinId, deviceName & "." & pinName
                        app.PutInfo 0, "������ ��� (signal): " & deviceName & "." & pinName & " (ID: " & pinId & ") ����: " & pinSignalName
                    End If
                End If
            Next
        End If
    Next
    
    app.PutInfo 0, "������� ����� �� signal name: " & dictPinIds.Count
End Sub

'==========================================
' ������� ������ ����� ����� connections
'==========================================
Sub FIND_PINS_BY_CONNECTIONS()
    app.PutInfo 0, "����� ����� ����� connections..."
    
    ' �������� ��� connections � �������
    connectionCount = job.GetConnectionIds(connectionIds)
    app.PutInfo 0, "������� connections � �������: " & connectionCount
    
    ' ��������� ��� �������� ID �����, ��������� � ����� �����
    Set connectedPinIds = CreateObject("Scripting.Dictionary")
    
    ' ������� ������� connections � ������ �����
    For connectionIndex = 1 To connectionCount
        connectionId = connection.SetId(connectionIds(connectionIndex))
        connectionSignalName = connection.GetSignalName()
        
        If connectionSignalName = signalName Then
            ' �������� ���� ����� connection
            pinCount = connection.GetPinIds(pinIds)
            
            For pinIndex = 1 To pinCount
                pinId = pinIds(pinIndex)
                connectedPinIds(pinId) = True
            Next
            
            app.PutInfo 0, "Connection ID: " & connectionId & " �������� " & pinCount & " ����� ���� " & signalName
        End If
    Next
    
    app.PutInfo 0, "������� ����� � connections: " & connectedPinIds.Count
    
    ' ������ �������� ���������� �� ���� �����
    connectedPinKeys = connectedPinIds.Keys()
    For Each pinId In connectedPinKeys
        If Not dictPinIds.Exists(pinId) Then
            ' �������� ���������� � ����
            pin.SetId pinId
            pinName = pin.GetName()
            
            ' �������� ����������, � �������� ����������� ���
            deviceId = device.SetId(pinId)
            deviceName = device.GetName()
            
            dictPinIds.Add pinId, deviceName & "." & pinName
            app.PutInfo 0, "������ ��� (connection): " & deviceName & "." & pinName & " (ID: " & pinId & ")"
        End If
    Next
    
    app.PutInfo 0, "����� ������� ���������� �����: " & dictPinIds.Count
End Sub

'==========================================
' ������� �������� ����������
'==========================================
Sub CREATE_CONNECTIONS()
    If dictPinIds.Count < 2 Then
        app.PutInfo 0, "������������ ����� ��� �������� ���������� (�������: " & dictPinIds.Count & ")"
        Exit Sub
    End If
    
    app.PutInfo 0, "�������� ���������� ����� ������..."
    
    ' ��������� ���� ����� ��������� ����������
    Call SORT_FOUND_PINS()
    
    ' �������� ������ ������ (ID �����)
    pinKeys = dictPinIds.Keys()
    
    ' ������� ���������� ����� ��������� ������
    For i = 0 To dictPinIds.Count - 2
        firstPinId = pinKeys(i)
        secondPinId = pinKeys(i + 1)
        
        firstPinName = dictPinIds(firstPinId)
        secondPinName = dictPinIds(secondPinId)
        
        app.PutInfo 0, "���������: " & firstPinName & " -> " & secondPinName
        
        ' ������� ������
        If CREATE_WIRE(firstPinId, secondPinId) Then
            app.PutInfo 0, "���������� ������� �������"
        Else
            app.PutError 0, "������ �������� ����������"
        End If
    Next
    
    app.PutInfo 0, "������� ����������: " & (dictPinIds.Count - 1)
End Sub

'==========================================
' ������� ���������� ��������� �����
'==========================================
Sub SORT_FOUND_PINS()
    If dictPinIds.Count <= 1 Then Exit Sub

    app.PutInfo 0, "���������� ��������� �����..."

    Dim pinKeys, pinCount, sortArray()
    pinKeys = dictPinIds.Keys()
    pinCount = dictPinIds.Count
    ReDim sortArray(pinCount - 1)

    Dim i
    For i = 0 To pinCount - 1
        Dim fullName, deviceName, pinName, dotPos, pinId
        pinId = pinKeys(i)
        fullName = CStr(dictPinIds(pinId))
        dotPos = InStr(fullName, ".")

        If dotPos > 0 Then
            deviceName = Left(fullName, dotPos - 1)
            pinName = Mid(fullName, dotPos + 1)
        Else
            deviceName = fullName
            pinName = ""
        End If

        ' ������ ������ � ��� ������ �� 3 ���������: [device, pin, pinId]
        sortArray(i) = Array(deviceName, pinName, pinId)
    Next

    ' ��������� ����������
    ReDim options(1, 1)
    options(0, 0) = 0 ' ������ � sortArray(i)(0) � deviceName
    options(0, 1) = 2 ' ���������� ����������
    options(1, 0) = 1 ' ������ sortArray(i)(1) � pinName
    options(1, 1) = 2 ' ���������� ����������

    ' ����������
    app.SortArrayByIndexEx sortArray, options

    ' ������� ������� � ������������
    dictPinIds.RemoveAll

    app.PutInfo 0, "��������� ����������:"
    For i = 0 To pinCount - 1
        deviceName = sortArray(i)(0)
        pinName = sortArray(i)(1)
        pinId = sortArray(i)(2)
        dictPinIds.Add pinId, deviceName & "." & pinName
        app.PutInfo 0, (i + 1) & ". " & deviceName & "." & pinName & " (ID: " & pinId & ")"
    Next
End Sub


'==========================================
' ������� �������� ������� ����� ����� ������
'==========================================
Function CREATE_WIRE(firstPinId, secondPinId)
    CREATE_WIRE = False
    
    If firstPinId <= 0 Or secondPinId <= 0 Then
        app.PutError 0, "�������� ID �����: " & firstPinId & ", " & secondPinId
        Exit Function
    End If
    
    ' ������� ������ (wire group) ��� �������� �������
    cableCount = job.GetCableIds(cableIds)
    
    If cableCount = 0 Then
        app.PutError 0, "�� ������� ������ � �������"
        Exit Function
    End If
    
    ' ���� ���������� wire group
    For cableIndex = 1 To cableCount
        cableId = device.SetId(cableIds(cableIndex))
        cableName = device.GetName()
        isWireGroup = device.isWireGroup()
        
        If isWireGroup = 1 Then
            ' ������� ������
            result = pin.CreateWire(wireName, wiregroupName, databaseWireName, cableId, 0, 0)
            
            If result > 0 Then
                ' ���������� ����� ������� � �����
                pin.SetEndPinId 1, firstPinId
                pin.SetEndPinId 2, secondPinId
                
                actualWireName = pin.GetName()
                app.PutInfo 0, "������ ������: " & actualWireName & " (" & wiregroupName & ", " & databaseWireName & ")"
                
                CREATE_WIRE = True
                Exit Function
            Else
                app.PutError 0, "������ �������� ������� � ������: " & cableName
            End If
        End If
    Next
    
    app.PutError 0, "�� ������ ���������� wire group ��� �������� �������"
End Function

' ������������ ��������
Set dictPinIds = Nothing
Set connection = Nothing
Set device = Nothing
Set pin = Nothing
Set symbol = Nothing
Set job = Nothing 
Set app = Nothing