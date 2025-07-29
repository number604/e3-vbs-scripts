' ������ ��� �������� ����������� ����� � ���� (���������� � "KL" � �����)
' ������� ������ ���� � ��������� ��������������� ��������� ��� ����������

Set e3App = CreateObject("CT.Application")
Set job = e3App.CreateJobObject()

Set device = job.CreateDeviceObject()
Set pin = job.CreatePinObject()

Dim relayCoilPins, relayContactPins
relayCoilPins = Array("A1", "A2")
relayContactPins = Array("11", "12", "14", "21", "22", "24", "31", "32", "34", "41", "42", "44")

Dim deviceIds, deviceCount

' �������� ��� ������� �������
deviceCount = job.GetAllDeviceIds(deviceIds)

If deviceCount > 0 Then
    For i = 1 To deviceCount
        device.SetId(deviceIds(i))
        devName = device.GetName()

        ' ���������� ���� �� �����
        If InStr(devName, "KL") > 0 Then
            Dim pinIds, pinCount
            pinCount = device.GetPinIds(pinIds)
            
            Dim pinMap, pinSignalNames
            Set pinMap = CreateObject("Scripting.Dictionary")
            Set pinSignalNames = CreateObject("Scripting.Dictionary")
            
            ' ������������� ����� �������
            For Each p In relayCoilPins
                pinMap.Add p, False
                pinSignalNames.Add p, ""
            Next
            
            ' ������������� ������ ������������ ���������� �����
            If pinCount > 0 Then
                For j = 1 To pinCount
                    pin.SetId(pinIds(j))
                    pinName = pin.GetName()
                    
                    ' ��������� ������ �� ���������� ����, ������� ���� � ����������
                    For Each contactPin In relayContactPins
                        If pinName = contactPin And Not pinMap.Exists(pinName) Then
                            pinMap.Add pinName, False
                            pinSignalNames.Add pinName, ""
                        End If
                    Next
                Next
            End If
            
            ' �������� ����������� ����� ����� GetSignalName()
            If pinCount > 0 Then
                For j = 1 To pinCount
                    pin.SetId(pinIds(j))
                    pinName = pin.GetName()

                    If pinMap.Exists(pinName) Then
                        signalName = pin.GetSignalName()
                        pinMap(pinName) = (Len("" & signalName) > 0)
                        pinSignalNames(pinName) = signalName
                    End If
                Next
            End If

            ' ��������, ��� �� ���������� ��� ���� �������
            Dim bothCoilsDisconnected
            bothCoilsDisconnected = True
            For Each p In relayCoilPins
                If pinMap.Exists(p) And pinMap(p) Then
                    bothCoilsDisconnected = False
                    Exit For
                End If
            Next
            
            ' ��������, ��� �� ���������� ��� ���������� ����
            Dim allContactsDisconnected
            allContactsDisconnected = True
            For Each p In pinMap.Keys()
                ' ���������� ���� �������
                If Not IsInArray(p, relayCoilPins) Then
                    If pinMap(p) Then
                        allContactsDisconnected = False
                        Exit For
                    End If
                End If
            Next

            ' ����� ��������� ������ ��� ���������� ����
            If bothCoilsDisconnected Or allContactsDisconnected Then
                e3App.PutInfo 0, "���� " & devName & " - �������� � ������������:"
                
                If bothCoilsDisconnected Then
                    e3App.PutInfo 0, "  � �� ���������� ��� ���� ������� (A1 � A2)"
                End If
                
                If allContactsDisconnected Then
                    e3App.PutInfo 0, "  � �� ���������� ��� ���������� ����"
                End If
                
                ' �������������� ���������� � �������������� �����
                Dim disconnectedPins
                disconnectedPins = ""
                For Each p In pinMap.Keys()
                    If Not pinMap(p) Then
                        disconnectedPins = disconnectedPins & p & ", "
                    End If
                Next
                If Len(disconnectedPins) > 0 Then
                    e3App.PutInfo 0, "  � �������������� ����: " & Left(disconnectedPins, Len(disconnectedPins)-2)
                End If
            End If
        End If
    Next
Else
    e3App.PutInfo 0, "��� ��������� � �������"
End If

Set pin = Nothing
Set device = Nothing
Set job = Nothing
Set e3App = Nothing

' ��������������� ������� ��� �������� ������� �������� � �������
Function IsInArray(item, arr)
    IsInArray = False
    For Each element In arr
        If element = item Then
            IsInArray = True
            Exit Function
        End If
    Next
End Function