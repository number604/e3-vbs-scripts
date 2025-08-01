'*******************************************************************************
' �������� �������: E3_ReplaceAllOOOWithSubcircuit
' �����: E3.series VBScript Assistant
' ����: 08.07.2025
' ��������: ������ ������������ ��� �������������� ������ ��������,
'           ����� ������� ���������� � "OOO" �� ��������������� �� ��������� �����.
'           ����� ��������� ������������ ��������� �������� "�� D_Proizv3".
'           ����� ������� ��������� ������ ��������������� ����� ����������,
'           ��������� �� ���������, ��������� �������� ������ �� ����� ���������
'           "OOO" �������. ��������� �������� -tUZ � -tV ��� ��������������.
'*******************************************************************************
Option Explicit

Sub ReplaceAllOOOWithSubcircuit()
    ' ���������� ��������������� ����
    Dim result
    result = MsgBox("��������� �� �����������?", vbOKCancel + vbQuestion, "�������������")
    
    ' ���� ������������ ����� "������", ������� �� �������
    If result = vbCancel Then
        Exit Sub
    End If
    
    Dim e3App, job, symbol, sheet, device
    Dim allSymbolIds(), allSymbolCount
    Dim currentSymbolId, symbolName, symbolIndex
    Dim s
    Dim subcircuitPath, subcircuitVersion
    Dim insertedDeviceIds(), deviceCount, d, devName, newName
    Dim prefixList, p, prefix
    Dim attrValue

    Set e3App = CreateObject("CT.Application")
    Set job = e3App.CreateJobObject()
    Set symbol = job.CreateSymbolObject()
    Set sheet = job.CreateSheetObject()
    Set device = job.CreateDeviceObject()

    e3App.PutInfo 0, "=== ����� ������� ==="

    allSymbolCount = job.GetSymbolIds(allSymbolIds)

    If allSymbolCount > 0 Then
        For s = 1 To allSymbolCount
            currentSymbolId = allSymbolIds(s)
            symbol.SetId(currentSymbolId)
            symbolName = symbol.GetName()

            If UCase(Left(symbolName, 3)) = "OOO" Then
                symbolIndex = Mid(symbolName, 4)
                attrValue = Trim(symbol.GetAttributeValue("�� D_Proizv3"))

                ' ����������� �������� ��������, ��� ��������� ������
                If attrValue <> "" And (attrValue >= "1" And attrValue <= "9") Or attrValue = "10" Then ' �������� ������� ��� "10"
                    
                    subcircuitPath = "" ' ��������������, ����� �����, ��� �� ���� ��������
                    
                    ' ����� ���� � ��������� �� �������� ��������
                    Select Case attrValue
                        Case "1": subcircuitPath = "W:\����������� E3\���\�������\���������\����\1_tQF3P.e3p"
                        Case "2": subcircuitPath = "W:\����������� E3\���\�������\���������\����\2_tQF3PtKM.e3p"
                        Case "3": subcircuitPath = "W:\����������� E3\���\�������\���������\����\3_t���3PtKM.e3p"
                        Case "4": subcircuitPath = "W:\����������� E3\���\�������\���������\����\4_t���2PtKM.e3p"
                        Case "5": subcircuitPath = "W:\����������� E3\���\�������\���������\����\5_tQFd2PtKL.e3p"
                        Case "6": subcircuitPath = "W:\����������� E3\���\�������\���������\����\6_tQF1P.e3p"
                        Case "7": subcircuitPath = "W:\����������� E3\���\�������\���������\����\7_tQF3PtKM.e3p"
                        Case "8": subcircuitPath = "W:\����������� E3\���\�������\���������\����\8_t���2PtKL.e3p"
                        Case "9": subcircuitPath = "W:\����������� E3\���\�������\���������\����\9_tQFd2.e3p"
                        Case "10": subcircuitPath = "W:\����������� E3\���\�������\���������\����\10_tQF3PtKM.e3p"
                        Case Else: 
                            ' ���� Case Else, subcircuitPath ��������� ������, � �� ������� ���������
                            e3App.PutInfo 1, "������� " & symbolName & ": ����������� �������� �������� '�� D_Proizv3' = '" & attrValue & "'"
                    End Select

                    ' ���������� ���������� ������ ���� subcircuitPath ��� ������� ���������
                    If subcircuitPath <> "" Then
                        subcircuitVersion = "1"

                        Dim oooX, oooY, oooSheetId, gridDesc, colVal, rowVal
                        oooSheetId = symbol.GetSchemaLocation(oooX, oooY, gridDesc, colVal, rowVal)

                        If oooSheetId > 0 Then
                            sheet.SetId oooSheetId
                            e3App.PutInfo 0, "��������� " & symbolName & " (������� = " & attrValue & ") > �������: " & subcircuitPath

                            Dim insertResult : insertResult = sheet.PlacePart(subcircuitPath, subcircuitVersion, oooX, oooY, 0.0)

                            If insertResult = 0 Or insertResult = -3 Then ' 0: �����, -3: ��������, ����� ����� � ��������� �������
                                e3App.PutInfo 0, "�������� ������� ����������"

                                ' �������������� �������� ����� �������
                                ' ��������: job.GetDeviceIds(insertedDeviceIds) �������� ��� ������� � �������.
                                ' ��� ����� �������� � �������������� ��� ������������ ��������.
                                ' ��� ����� ��������� ������� ��������� ��������� ������ �������� �� � ����� �������.
                                deviceCount = job.GetDeviceIds(insertedDeviceIds)
                                For d = 1 To deviceCount
                                    device.SetId insertedDeviceIds(d)
                                    devName = device.GetName()

                                    ' ����������� ������ ��������� ��� �������������� (������ 105 � �������� �������)
                                    prefixList = Array("-tQF", "-tKM", "-tKL", "-tUZ", "-tV") 
                                    For p = 0 To UBound(prefixList)
                                        prefix = prefixList(p)
                                        If LCase(Left(devName, Len(prefix))) = LCase(prefix) Then
                                            newName = Replace(prefix, "-t", "-") & symbolIndex
                                            e3App.PutInfo 0, "��������������: " & devName & " > " & newName
                                            device.SetName newName
                                            Exit For ' ������� �� ����������� ����� �� ���������, ��� ��� ����� ����������
                                        End If
                                    Next
                                Next
                            Else
                                e3App.PutInfo 0, "������ ������� ��������� (���: " & insertResult & ")"
                            End If
                        Else
                            e3App.PutInfo 0, symbolName & " �� �������� �� �����. ��������."
                        End If
                    End If ' End If ��� �������� subcircuitPath
                Else
                    e3App.PutInfo 1, "������� " & symbolName & ": ������������ ��� ������������� �������� �������� '�� D_Proizv3' = '" & attrValue & "'"
                End If
            End If
        Next
    Else
        e3App.PutInfo 0, "� ������� ��� �������� ��� ���������."
    End If

    e3App.PutInfo 0, "=== ������ �������� ==="

    ' �������
    Set device = Nothing
    Set symbol = Nothing
    Set sheet = Nothing
    Set job = Nothing
    Set e3App = Nothing
End Sub

Call ReplaceAllOOOWithSubcircuit()