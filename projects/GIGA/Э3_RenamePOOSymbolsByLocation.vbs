'*******************************************************************************
' �������� �������: E3_UZ_RenamePOOSymbolsByLocation_SortedSheets
' �����: E3.series VBScript Assistant
' ����: 01.07.2025
' ��������: ������ ��� ��������������� �������������� �������� POO
'          �� ������ �� ������������ �� ������, � ���������� ����������� ������
'          �� ��������� ��������.
'*******************************************************************************
Option Explicit

' === ���������� ���������� ===
' ��������� ���������� ���������, ����� ��� ���� �������� ���� ����������
Dim e3App, job, symbol, sheet

' === ������� ��������� === �������������� �������� POO �� �������
Sub RenamePOOSymbolsByLocation()
    Dim allSymbolIds(), allSymbolCount
    Dim currentSymbolId, symbolName
    Dim s, i, j
    Dim pooCounter : pooCounter = 0 ' ������� ��� ����������������� ����������

    ' ���������� ��� �������� ������ POO �������� ��� ����������
    ' ������ ������� ����� ��������:
    ' (SymbolID, SheetID, SheetName, Column, Row, X, Y, OriginalName)
    Dim pooSymbolsToRename()
    ReDim pooSymbolsToRename(0) ' �������������

    Dim pooCountPlaced : pooCountPlaced = 0 ' ������� ������ ��� ����������� POO ��������

    Set e3App = CreateObject("CT.Application")
    Set job = e3App.CreateJobObject()
    Set symbol = job.CreateSymbolObject()
    Set sheet = job.CreateSheetObject()

    e3App.PutInfo 0, "=== ����� �������: �������������� POO �������� �� ������� ==="

    allSymbolCount = job.GetSymbolIds(allSymbolIds)

    If allSymbolCount = 0 Then
        e3App.PutInfo 0, "� ������� ��� �������� ��� �������. ������ ��������."
        Cleanup
        Exit Sub
    End If

    e3App.PutInfo 0, "������� " & allSymbolCount & " ��������. �������� ������ � �������� ��������������� POO �������..."

    ' === ���� ������ � ��������� �������������� ===
    For s = 1 To allSymbolCount
        currentSymbolId = allSymbolIds(s)
        symbol.SetId(currentSymbolId)
        symbolName = symbol.GetName()

        If LCase(Left(symbolName, 3)) = "poo" Then
            Dim xPos, yPos, gridDesc, columnValue, rowValue
            Dim sheetId : sheetId = symbol.GetSchemaLocation(xPos, yPos, gridDesc, columnValue, rowValue)

            If sheetId > 0 Then
                pooCountPlaced = pooCountPlaced + 1
                ReDim Preserve pooSymbolsToRename(pooCountPlaced)

                sheet.SetId sheetId
                Dim sheetName : sheetName = sheet.GetName()

                pooSymbolsToRename(pooCountPlaced) = Array(currentSymbolId, sheetId, sheetName, columnValue, rowValue, xPos, yPos, symbolName)
                symbol.SetName "POOTMP" & Right(CStr(currentSymbolId), 6)
            End If
        End If
    Next

    If pooCountPlaced = 0 Then
        e3App.PutInfo 0, "����������� ������� POO �� �������. ������ ��������."
        Cleanup
        Exit Sub
    End If

    e3App.PutInfo 0, "������� " & pooCountPlaced & " ����������� POO ��������. ����������..."

    ' === ���������� �� SheetNumber (��������), Column, Row, X, Y ===
    For i = 1 To pooCountPlaced - 1
        For j = i + 1 To pooCountPlaced
            Dim a1, a2
            a1 = pooSymbolsToRename(i)
            a2 = pooSymbolsToRename(j)

            ' ��������� �������� ����� �������� ������ ��� ���������� ����������
            Dim sheetNum1 : sheetNum1 = ExtractSheetNumber(a1(2))
            Dim sheetNum2 : sheetNum2 = ExtractSheetNumber(a2(2))

            If sheetNum1 > sheetNum2 Then
                SwapArrayElements pooSymbolsToRename, i, j
            ElseIf sheetNum1 = sheetNum2 Then
                If StrComp(a1(3), a2(3), vbTextCompare) > 0 Then ' ��������� �������� (Column)
                    SwapArrayElements pooSymbolsToRename, i, j
                ElseIf StrComp(a1(3), a2(3), vbTextCompare) = 0 Then
                    If StrComp(a1(4), a2(4), vbTextCompare) > 0 Then ' ��������� ����� (Row)
                        SwapArrayElements pooSymbolsToRename, i, j
                    ElseIf StrComp(a1(4), a2(4), vbTextCompare) = 0 Then
                        If a1(5) > a2(5) Then ' ��������� X-���������
                            SwapArrayElements pooSymbolsToRename, i, j
                        ElseIf a1(5) = a2(5) And a1(6) > a2(6) Then ' ��������� Y-���������
                            SwapArrayElements pooSymbolsToRename, i, j
                        End If
                    End If
                End If
            End If
        Next
    Next

    e3App.PutInfo 0, "���������� ���������. �������� ��������������..."

    ' === �������������� �� ������� ===
    For s = 1 To pooCountPlaced
        pooCounter = pooCounter + 1
        currentSymbolId = pooSymbolsToRename(s)(0)
        Dim newName : newName = "POO" & pooCounter

        symbol.SetId currentSymbolId
        symbol.SetName newName
    Next

    e3App.PutInfo 0, "=== ����������: ������������� " & pooCounter & " �������� POO ==="
    Cleanup
End Sub

' === ������� ===
Sub Cleanup
    ' ������ ��� ���������� ��������, ��� ��� ��� ��������� ���������
    Set symbol = Nothing
    Set sheet = Nothing
    Set job = Nothing
    Set e3App = Nothing
End Sub

' ��������������� ��������� ������ ��������� �������
Sub SwapArrayElements(arr, index1, index2)
    Dim tmp
    tmp = arr(index1)
    arr(index1) = arr(index2)
    arr(index2) = tmp
End Sub

' === ����� ��������������� ������� ��� ���������� ������ ����� ===
Function ExtractSheetNumber(sheetName)
    Dim re, matches
    Set re = New RegExp
    re.Pattern = "\d+" ' ���� ���� ��� ����� ����
    re.Global = False ' ������� ������ ������ ����������
    
    Set matches = re.Execute(sheetName)
    
    If matches.Count > 0 Then
        ExtractSheetNumber = CInt(matches(0).Value) ' ����������� ��������� ������ � ����� �����
    Else
        ExtractSheetNumber = 0 ' ���������� 0, ���� ����� �� ������� (��� ������ ������ �� ���������)
    End If
End Function

' === ������ ===
Call RenamePOOSymbolsByLocation()