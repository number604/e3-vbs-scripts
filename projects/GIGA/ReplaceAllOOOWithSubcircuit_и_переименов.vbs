' === ������� ��������� === ��������� ��������� ������ ���� �������� OOO...
Sub ReplaceAllOOOWithSubcircuit()
    Dim e3App, job, symbol, sheet, device
    Dim allSymbolIds(), allSymbolCount
    Dim currentSymbolId, symbolName, symbolIndex
    Dim s
    Dim subcircuitPath, subcircuitVersion
    Dim insertedDeviceIds(), deviceCount, d, devName, newName

    Set e3App = CreateObject("CT.Application")
    Set job = e3App.CreateJobObject()
    Set symbol = job.CreateSymbolObject()
    Set sheet = job.CreateSheetObject()
    Set device = job.CreateDeviceObject()

    e3App.PutInfo 0, "=== ����� �������: ��������� ���� �������� OOO... ==="

    subcircuitPath = "C:\Users\SEK\Desktop\DWG_4_E3\SIC-tQF.e3p"
    subcircuitVersion = "1"

    e3App.PutInfo 0, "������������ ��������: " & subcircuitPath & " (������: " & subcircuitVersion & ")"

    allSymbolCount = job.GetSymbolIds(allSymbolIds)

    If allSymbolCount > 0 Then
        For s = 1 To allSymbolCount
            currentSymbolId = allSymbolIds(s)
            symbol.SetId(currentSymbolId)
            symbolName = symbol.GetName()

            If UCase(Left(symbolName, 3)) = "OOO" Then
                symbolIndex = Mid(symbolName, 4) ' �������� ������ ����� "OOO"
                
                Dim oooX, oooY, oooSheetId, gridDesc, colVal, rowVal
                oooSheetId = symbol.GetSchemaLocation(oooX, oooY, gridDesc, colVal, rowVal)

                If oooSheetId > 0 Then
                    sheet.SetId oooSheetId
                    e3App.PutInfo 0, "������ ������ " & symbolName & " �� ����� ID: " & oooSheetId & ", ���������� (" & oooX & ", " & oooY & ")"

                    ' ������� ���������
                    Dim result : result = sheet.PlacePart(subcircuitPath, subcircuitVersion, oooX, oooY, 0.0)

                    If result = 0 Or result = -3 Then
                        e3App.PutInfo 0, "�������� ���������� ��� " & symbolName

                        ' ����� ���� ���������, ��������� ����� �������
                        deviceCount = job.GetDeviceIds(insertedDeviceIds)
                        For d = 1 To deviceCount
                            device.SetId insertedDeviceIds(d)
                            devName = device.GetName()
                            If LCase(Left(devName, 4)) = "-tqf" Then
                                newName = "-QF" & symbolIndex
                                e3App.PutInfo 0, "�������������� ������� " & devName & " > " & newName
                                device.SetName newName
                                Exit For ' ������������, ��� ������ ���� ������ ��������
                            End If
                        Next
                    Else
                        e3App.PutInfo 0, "������ ��������� ��������� ��� " & symbolName & ". ���: " & result
                    End If
                Else
                    e3App.PutInfo 0, "������ " & symbolName & " �� �������� �� �����."
                End If
            End If
        Next
    Else
        e3App.PutInfo 0, "������� � ������� �� �������."
    End If

    ' �������
    Set device = Nothing
    Set symbol = Nothing
    Set sheet = Nothing
    Set job = Nothing
    Set e3App = Nothing
End Sub

Call ReplaceAllOOOWithSubcircuit()
