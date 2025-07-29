Option Explicit

' === ������� ��������� === ������������ ��������� �������� OOO
Sub SumOOOSymbolAttributes()
    Dim e3App, job, symbol
    Dim allSymbolIds(), allSymbolCount ' ���������� ��� ���� �������� � �������
    Dim currentSymbolId, symbolName
    Dim s

    ' ���������� ��� �������� ���� ���������
    Dim totalEInom : totalEInom = 0.0
    Dim totalEIras : totalEIras = 0.0
    Dim totalEPnom : totalEPnom = 0.0
    Dim totalEPras : totalEPras = 0.0

    Dim attrValue ' ��� ���������� �������� �������� ��������

    Set e3App = CreateObject("CT.Application")
    Set job = e3App.CreateJobObject()
    Set symbol = job.CreateSymbolObject()

    e3App.PutInfo 0, "=== ����� �������: ������������ ��������� OOO �������� ==="

    ' NEW: �������� ��� ID �������� � ������� ��������
    allSymbolCount = job.GetSymbolIds(allSymbolIds)

    If allSymbolCount = 0 Then
        e3App.PutInfo 0, "� ������� ��� �������� ��� �������."
        Set symbol = Nothing
        Set job = Nothing
        Set e3App = Nothing
        Exit Sub
    End If

    e3App.PutInfo 0, "��������� " & allSymbolCount & " �������� �� ������� OOO..."
    Dim oooFoundCount : oooFoundCount = 0

    ' ��������� �� ���� ��������, ���������� �� job.GetSymbolIds
    For s = 1 To allSymbolCount
        currentSymbolId = allSymbolIds(s)
        symbol.SetId(currentSymbolId)
        symbolName = symbol.GetName()

        ' ���������, �������� �� ������ OOO
        If LCase(Left(symbolName, 3)) = "ooo" Then
            e3App.PutInfo 0, "  ������ OOO ������: " & symbolName & " (ID: " & currentSymbolId & ")"
            oooFoundCount = oooFoundCount + 1

            ' --- ������ � ������������ ��������� ---

            ' ������� �� E_Inom
            attrValue = symbol.GetAttributeValue("�� E_Inom")
            If IsNumeric(attrValue) And Len(Trim(attrValue)) > 0 Then
                totalEInom = totalEInom + CDbl(attrValue)
                e3App.PutInfo 0, "    ��������� �� E_Inom: " & attrValue
            Else
                e3App.PutInfo 0, "    �� E_Inom: <�����> ��� �� �����."
            End If

            ' ������� �� E_Iras
            attrValue = symbol.GetAttributeValue("�� E_Iras")
            If IsNumeric(attrValue) And Len(Trim(attrValue)) > 0 Then
                totalEIras = totalEIras + CDbl(attrValue)
                e3App.PutInfo 0, "    ��������� �� E_Iras: " & attrValue
            Else
                e3App.PutInfo 0, "    �� E_Iras: <�����> ��� �� �����."
            End If

            ' ������� �� E_Pnom
            attrValue = symbol.GetAttributeValue("�� E_Pnom")
            If IsNumeric(attrValue) And Len(Trim(attrValue)) > 0 Then
                totalEPnom = totalEPnom + CDbl(attrValue)
                e3App.PutInfo 0, "    ��������� �� E_Pnom: " & attrValue
            Else
                e3App.PutInfo 0, "    �� E_Pnom: <�����> ��� �� �����."
            End If

            ' ������� �� E_Pras
            attrValue = symbol.GetAttributeValue("�� E_Pras")
            If IsNumeric(attrValue) And Len(Trim(attrValue)) > 0 Then
                totalEPras = totalEPras + CDbl(attrValue)
                e3App.PutInfo 0, "    ��������� �� E_Pras: " & attrValue
            Else
                e3App.PutInfo 0, "    �� E_Pras: <�����> ��� �� �����."
            End If
        End If ' End If LCase(Left(symbolName, 3)) = "ooo"
    Next ' End For s = 1 To allSymbolCount

    e3App.PutInfo 0, "=== ��������� �������� ��������� OOO �������� ==="
    e3App.PutInfo 0, "����� ���������� OOO ��������: " & oooFoundCount
    e3App.PutInfo 0, "����� �� E_Inom: " & totalEInom
    e3App.PutInfo 0, "����� �� E_Iras: " & totalEIras
    e3App.PutInfo 0, "����� �� E_Pnom: " & totalEPnom
    e3App.PutInfo 0, "����� �� E_Pras: " & totalEPras
    e3App.PutInfo 0, "=== ����� ������� ==="

    Set symbol = Nothing
    Set job = Nothing
    Set e3App = Nothing
End Sub

' === �������� ������ ===
Call SumOOOSymbolAttributes()
