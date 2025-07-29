'*******************************************************************************
' �������� �������: E3_UZ_CheckUnplacedSymbolsConcise
' �����: E3.series VBScript Assistant
' ����: 22.07.2025
' ��������: ������ ��� ���� ���������� � ������ ������� ������� �� �������
'           � ������� ���������� ������ � ��� ��������, ������� �� ���������
'           �� �����, � ������������ �������� � ������� �� ������.
'           ������� ��� ������������� ��������� � ��������/������.
'           ��������: ����������� �������� �� �������� �������� ��������.
'*******************************************************************************

Option Explicit

' ���������� ����������
Dim e3App
Dim job
Dim device
Dim symbol

Dim deviceIds
Dim deviceCount
Dim deviceId
Dim deviceName

Dim symbolIds
Dim symbolCount
Dim symbolId
Dim symbolName

Dim xMin, yMin, xMax, yMax
Dim result

' ���������� ���� ��� ��������� (�������, ����� ���� �������)
Const COLOR_RED = &HFF& ' ������� ���� (RGB)

On Error Resume Next ' �������� ��������� ������, ����� �������� ������� ����� ��� ���������� ��������

' ������� ������� E3.series
Set e3App = CreateObject("CT.Application")
Set job = e3App.CreateJobObject()
Set device = job.CreateDeviceObject()
Set symbol = job.CreateSymbolObject()

e3App.PutInfo 0, "�������� ����� ������������� ��������. ��� �������� � ������� ������� �� ��������������� ������."

' �������� ��� ���������� ������� � ������ �������
deviceCount = job.GetTreeSelectedAllDeviceIds(deviceIds)

If deviceCount > 0 Then
    For Each deviceId In deviceIds
        result = device.SetId(deviceId)
        If result <> 0 Then ' ���������, ��� ��������� ID ������� �������
            deviceName = device.GetName()
            
            ' �������� ��� ������� ��� �������� �������
            symbolCount = device.GetSymbolIds(symbolIds)
            
            If symbolCount > 0 Then
                For Each symbolId In symbolIds
                    result = symbol.SetId(symbolId)
                    If result <> 0 Then ' ���������, ��� ��������� ID ������� �������
                        symbolName = symbol.GetName()
                        
                        ' ���������, �������� �� ������ �� �����
                        result = symbol.GetPlacedArea(xMin, yMin, xMax, yMax)
                        
                        If result = 0 Then ' ���� GetPlacedArea ������ 0, ������ �� ��������
                            ' ������� ��������� � ID ������� � �������� LinkID, ����� ������� ��� ������������
                            e3App.PutMessageEx 0, "�� ��������: ������ '" & symbolName & "' (�������: " & deviceName & ")", symbolId, COLOR_RED, 0, 0
                        End If
                    End If ' ��������� If ��� symbol.SetId
                Next
            End If ' ��������� If ��� symbolCount > 0
        End If ' ��������� If ��� device.SetId
    Next
Else
    e3App.PutInfo 0, "� ������ ������� �� �������� �� ������ �������."
End If

e3App.PutInfo 0, "����� ������������� �������� ��������."

' ����������� �������
Set symbol = Nothing
Set device = Nothing
Set job = Nothing
Set e3App = Nothing

On Error GoTo 0