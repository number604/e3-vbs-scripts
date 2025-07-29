Option Explicit

' === ������� ��������� === ��������� ��������� ������ ������� OOO1
Sub ReplaceOOO1WithSubcircuit()
    Dim e3App, job, symbol, sheet
    Dim allSymbolIds(), allSymbolCount
    Dim currentSymbolId, symbolName
    Dim s
    Dim ooo1Found : ooo1Found = False
    Dim ooo1SymbolId, ooo1SheetId
    Dim ooo1XPos, ooo1YPos
    Dim subcircuitPath, subcircuitVersion
    
    Set e3App = CreateObject("CT.Application")
    Set job = e3App.CreateJobObject()
    Set symbol = job.CreateSymbolObject()
    Set sheet = job.CreateSheetObject()

    e3App.PutInfo 0, "=== ����� �������: ��������� ��������� ������ ������� OOO1 ==="

    ' ������ ���� � ��������� � ������ ����� � ���� (����� �������� �� �������������)
    subcircuitPath = "C:\Users\SEK\Desktop\DWG_4_E3\SIC-QF666.e3p"  ' �������� �� ������ ���� ��� ��� ���������
    subcircuitVersion = "1"             ' �������� �� ������ ������
    
    e3App.PutInfo 0, "������������ ��������: " & subcircuitPath & " (������: " & subcircuitVersion & ")"

    ' �������� ��� ID �������� � �������
    allSymbolCount = job.GetSymbolIds(allSymbolIds)

    If allSymbolCount > 0 Then
        e3App.PutInfo 0, "������� " & allSymbolCount & " �������� � �������. ����� ������� OOO1..."

        ' === ����� ������� OOO1 ===
        For s = 1 To allSymbolCount
            currentSymbolId = allSymbolIds(s)
            symbol.SetId(currentSymbolId)
            symbolName = symbol.GetName()

            If UCase(symbolName) = "OOO1" Then
                Dim gridDesc, columnValue, rowValue
                ooo1SheetId = symbol.GetSchemaLocation(ooo1XPos, ooo1YPos, gridDesc, columnValue, rowValue)
                
                If ooo1SheetId > 0 Then ' ������ �������� �� �����
                    ooo1SymbolId = currentSymbolId
                    ooo1Found = True
                    
                    sheet.SetId ooo1SheetId
                    Dim sheetName : sheetName = sheet.GetName()
                    
                    e3App.PutInfo 0, "������ OOO1 ������:"
                    e3App.PutInfo 0, "  ID: " & ooo1SymbolId
                    e3App.PutInfo 0, "  ����: " & sheetName & " (ID: " & ooo1SheetId & ")"
                    e3App.PutInfo 0, "  �������: " & columnValue & rowValue & " (X: " & ooo1XPos & ", Y: " & ooo1YPos & ")"
                    Exit For
                Else
                    e3App.PutInfo 0, "������ OOO1 ������, �� �� �������� �� ����� (ID: " & currentSymbolId & ")"
                End If
            End If
        Next

        If ooo1Found Then
            ' === ��������� ��������� ������ OOO1 ===
            e3App.PutInfo 0, "��������� ��������� '" & subcircuitPath & "' ������ ������� OOO1 � ������� (" & ooo1XPos & ", " & ooo1YPos & ")..."
            
            sheet.SetId ooo1SheetId
            Dim placeResult : placeResult = sheet.PlacePart(subcircuitPath, subcircuitVersion, ooo1XPos, ooo1YPos, 0.0)
            
            ' ��������� ���������� ��������� ���������
            Select Case placeResult
                Case 0
                    e3App.PutInfo 0, "�������� '" & subcircuitPath & "' ������� ���������� ������ ������� OOO1 �� ���� " & sheet.GetName() & " � ������� (" & ooo1XPos & ", " & ooo1YPos & ")"
                Case 9
                    e3App.PutInfo 0, "������: ������������� ������ ����� ���������"
                Case 3
                    e3App.PutInfo 0, "������: �������� ��� ��������� ��� ������"
                Case -1
                    e3App.PutInfo 0, "������: �������� ������� �� ���������� ������ � ���������� �������� 'Ignore sheet border'"
                Case -2
                    e3App.PutInfo 0, "������: �������� �������� ����� � �� ���������� �������� 'Ignore sheet border'"
                Case -3
                    e3App.PutInfo 0, "������: �������� ��� �������� ��� �������� �������� � ������� (" & ooo1XPos & ", " & ooo1YPos & ")"
                    e3App.PutInfo 0, "����������: ��� ����� ���� ���������, ���� �������� ��������� ������ ������� OOO1"
                Case -4
                    e3App.PutInfo 0, "������: ���� ������������"
                Case Else
                    e3App.PutInfo 0, "������: ����������� ������ ��� ��������� ���������. ��� ������: " & placeResult
            End Select

            If placeResult = 0 Then
                e3App.PutInfo 0, "=== ���������� �������: �������� ������� ������� ������ ������� OOO1 ==="
            ElseIf placeResult = -3 Then
                e3App.PutInfo 0, "=== ���������� �������: �������� �������� ���������� (��� -3), �� �������� ����� ���� ���������� ==="
            Else
                e3App.PutInfo 0, "=== ���������� �������: ������ ��� ��������� ��������� ������ ������� OOO1 ==="
            End If
        Else
            e3App.PutInfo 0, "������ OOO1 �� ������ � ������� ��� �� �������� �� �����."
            e3App.PutInfo 0, "=== ����� ������� ==="
        End If
    Else
        e3App.PutInfo 0, "� ������� ��� �������� ��� �������. ������ ��������."
        e3App.PutInfo 0, "=== ����� ������� ==="
    End If

    ' ������� ��������
    Set symbol = Nothing
    Set sheet = Nothing
    Set job = Nothing
    Set e3App = Nothing
End Sub

' === �������� ������ ===
Call ReplaceOOO1WithSubcircuit()