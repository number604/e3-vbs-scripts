' ������ ��� ������ ���������� ���� � ������������ ��������
Set e3App = CreateObject("CT.Application")
Set job = e3App.CreateJobObject()
Set device = job.CreateDeviceObject()
Set symbol = job.CreateSymbolObject()

' ����� ��������� (RGB)
Const COLOR_RED = 225    ' ��� ������
Const COLOR_GREEN = 121 ' ��� �������� ���������
Const COLOR_BLUE = 249 ' ��� ��������������

Dim deviceIds, deviceCount, devName, hasProblems
hasProblems = False

' ������� ���� ���������
e3App.PutMessageEx 0, "����� ���������� ����...", 0, 0, 0, COLOR_BLUE

' �������� ��� ���������� �������
deviceCount = job.GetAllDeviceIds(deviceIds)

If deviceCount > 0 Then
    For i = 1 To deviceCount
        device.SetId(deviceIds(i))
        devName = device.GetName()
        
        ' ��������� ���� (�� "KL" � �����)
        If InStr(1, devName, "KL", vbTextCompare) > 0 Then
            Dim symbolIds, symbolCount, coilConnected, anyContactConnected
            coilConnected = False
            anyContactConnected = False
            
            ' �������� ��� ������� ����������
            symbolCount = device.GetSymbolIds(symbolIds, 0)
            
            If symbolCount > 0 Then
                ' ����������� ��� ������� ����
                For j = 1 To symbolCount
                    symbol.SetId(symbolIds(j))
                    symbolTypeName = LCase(symbol.GetSymbolTypeName())
                    
                    ' ��������� ��� ������� � ��� �����������
                    If InStr(symbolTypeName, "�������") > 0 Then
                        If symbol.IsConnected() = 1 Then
                            coilConnected = True
                        End If
                    ElseIf InStr(symbolTypeName, "�������") > 0 Then
                        If symbol.IsConnected() = 1 Then
                            anyContactConnected = True
                        End If
                    End If
                Next
                
                ' ��������� ��������� � ��������� � ������������ �������
                If Not coilConnected Then
                    e3App.PutMessageEx 0, "���� " & devName & ": ������� �� ����������", deviceIds(i), COLOR_RED, 0, 0
                    hasProblems = True
                ElseIf Not anyContactConnected Then
                    e3App.PutMessageEx 0, "���� " & devName & ": ������� ����������, �� �� ���� ������� �� ���������", deviceIds(i), COLOR_RED, 0, 0
                    hasProblems = True
                End If
            End If
        End If
    Next
    
    ' ������� �������� ���������
    If Not hasProblems Then
        e3App.PutMessageEx 0, "��� ���� ���������� ���������.", 0, 0, COLOR_GREEN, 0
    End If
Else
    e3App.PutMessageEx 0, "� ������� ��� ���������.", 0, COLOR_RED, 0, 0
End If

' ����������� �������
Set symbol = Nothing
Set device = Nothing
Set job = Nothing
Set e3App = Nothing