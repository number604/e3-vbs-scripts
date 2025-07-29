Option Explicit

' =========================================================================
' ��������������� �������: ���������� ��������� ������� �� �����
' ������: "POO19" -> 19, "-XT19" -> 19, "-tXT1" -> 1, "-QF12" -> 12
' ���������� 0, ���� �������� ������ �� ������ ��� ��� ������/������������
' =========================================================================
Function ExtractNumericIndex(nameString)
    ' �������� ��������� ��������� ������ ��� ���� �������
    On Error Resume Next
    
    Dim i, char, numericPart
    numericPart = ""
    ExtractNumericIndex = 0 ' ������������� �������� �� ���������

    If Len(nameString) = 0 Then
        Exit Function ' �������, ���� ������ ������
    End If

    ' �������� ����� ���� � ����� ������, ��� ��� ��� ������ � ����� �����
    For i = Len(nameString) To 1 Step -1
        char = Mid(nameString, i, 1)
        If IsNumeric(char) Then
            numericPart = char & numericPart ' ��������� ����� � ������ numericPart
        Else
            ' ���� ��������� ���������� ������, � ��� ���� �����, ������, ����� �����������
            If Len(numericPart) > 0 Then Exit For
        End If
    Next

    If Len(numericPart) > 0 Then
        If IsNumeric(numericPart) Then
            ExtractNumericIndex = CInt(numericPart)
        Else
            e3App.PutInfo 2, "���������� ������ � ExtractNumericIndex: �������� ���������� ����� '" & numericPart & "' �� '" & nameString & "'"
        End If
    End If
    
    If Err.Number <> 0 Then
        e3App.PutInfo 2, "������ � ExtractNumericIndex ��� ������ '" & nameString & "': " & Err.Description
        Err.Clear ' ������� ������
    End If
End Function


' =========================================================================
' �������� ���������: ����������� �������� E_TAG �� POOi � ������� -QFi � -KMi
' =========================================================================
Sub CopyETagToFunctionAttribute()
    On Error Resume Next ' �������� ��������� ������ ��� ���� ���������

    ' ������������� �������� E3.series
    Dim e3App, job, device, symbol
    Set e3App = CreateObject("CT.Application")
    Set job = e3App.CreateJobObject()
    Set device = job.CreateDeviceObject()
    Set symbol = job.CreateSymbolObject()

    ' ������� ��� �������� ������������: ������ POO -> �������� E_TAG
    Dim pooIndexToETagMap
    Set pooIndexToETagMap = CreateObject("Scripting.Dictionary")

    Dim i ' ���������� ��� ������
    Dim allSymbolIds, symbolCount, currentSymbolId, currentSymbolName
    Dim attrValue, pooNumericIndex
    Dim processedDevicesCount ' ������� ������� ������������ ���������
    processedDevicesCount = 0

    e3App.PutInfo 0, "=== �����: ����������� �������� E_TAG �� POOi � ������� -QFi � -KMi ==="

    ' =============================================================
    ' ���� 1: ���� �������� �������� "�� E_TAG" �� �������� POOi
    ' =============================================================
    e3App.PutMessageEx 0, "���� 1: ���� ������ E_TAG �� �������� POOi...", 0, 0, 0, 249

    symbolCount = job.GetSymbolIds(allSymbolIds)

    If symbolCount > 0 Then
        For i = 1 To symbolCount
            currentSymbolId = allSymbolIds(i)
            symbol.SetId(currentSymbolId)
            currentSymbolName = symbol.GetName()

            If Left(UCase(currentSymbolName), 3) = "POO" Then ' �������� �� "POO"
                pooNumericIndex = ExtractNumericIndex(currentSymbolName)
                
                If pooNumericIndex > 0 Then ' ������ ���� ������ �������� ���������
                    attrValue = symbol.GetAttributeValue("�� E_TAG")
                    
                    If attrValue <> "" Then
                        If Not pooIndexToETagMap.Exists(pooNumericIndex) Then
                            pooIndexToETagMap.Add pooNumericIndex, attrValue
                            e3App.PutInfo 0, "������ ������ POO" & pooNumericIndex & ". E_TAG: '" & attrValue & "'"
                        Else
                            ' ��� ��������������, ���� ��������� �������� POOi ����� ���� � ��� �� ������,
                            ' �� ������ E_TAG. ����� ������ ��������� ��������.
                            e3App.PutInfo 1, "��������: ������������� ������ POO" & pooNumericIndex & ". ������������ ������ ��������� �������� E_TAG: '" & pooIndexToETagMap(pooNumericIndex) & "'. ������� E_TAG: '" & attrValue & "'"
                        End If
                    Else
                        e3App.PutInfo 1, "��������������: ������ POO" & pooNumericIndex & " ����� ������ ������� '�� E_TAG'. ���������."
                    End If
                Else
                    e3App.PutInfo 1, "��������������: �� ������� ������� �������� ������ �� ����� ������� POO: '" & currentSymbolName & "'. ������ ������������ � ���� 1."
                End If
            End If
        Next
    Else
        e3App.PutInfo 1, "� ������� �� ������� �� ������ ������� POO."
    End If

    ' =============================================================
    ' ���� 2: ����� ��������� -QFi � -KMi � ����������� �������� "�������"
    ' ��� ��������� (������� ��������� � ��������) ������� �� ���� ����.
    ' =============================================================
    Dim allDeviceIds, deviceCount, currentDeviceId, currentDeviceName
    Dim qfNumericIndex, eTagValueToSet, setResult
    Dim deviceNamePrefix ' ���������� ��� �������� �������� ����� ����������

    deviceCount = job.GetAllDeviceIds(allDeviceIds) ' �������� ��� ���������� � �������

    If deviceCount > 0 Then
        For i = 1 To deviceCount
            currentDeviceId = allDeviceIds(i)
            device.SetId(currentDeviceId)
            currentDeviceName = device.GetName()

            deviceNamePrefix = Left(UCase(currentDeviceName), 3)

            ' ���������, ��� ���������� ����� ��������� ������ ����� "-QFi" ��� "-KMi"
            If deviceNamePrefix = "-QF" Or deviceNamePrefix = "-KM" Then
                qfNumericIndex = ExtractNumericIndex(currentDeviceName)

                If qfNumericIndex > 0 Then ' ������ ���� ������ �������� ���������
                    If pooIndexToETagMap.Exists(qfNumericIndex) Then
                        eTagValueToSet = pooIndexToETagMap(qfNumericIndex)
                        
                        ' ������������� �������� �������� "�������"
                        ' ���� �������� ���, E3.series ��� �������
                        setResult = device.SetAttributeValue("�������", eTagValueToSet)
                        
                        If setResult = 0 Then
                            processedDevicesCount = processedDevicesCount + 1
                        End If
                    End If
                End If
            End If
        Next
    Else
        ' ��������� �������
    End If

    e3App.PutInfo 0, "=== ��������� ==="

    ' ������� ��������
    Set pooIndexToETagMap = Nothing
    Set symbol = Nothing
    Set device = Nothing
    Set job = Nothing
    Set e3App = Nothing
End Sub

' ����� �������� ���������
Call CopyETagToFunctionAttribute()