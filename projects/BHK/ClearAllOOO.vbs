Option Explicit

' === ������� === ���������� ������ �� ����� �������
Function ExtractNumber(ByVal itemName)
    Dim re, matches
    Set re = New RegExp
    ' ���� ����� � ����� ������ ����� �������� (��������, OOO1)
    re.Pattern = "(\d+)$"
    re.Global = False
    
    Set matches = re.Execute(itemName)
    
    If matches.Count > 0 Then
        ExtractNumber = CInt(matches.Item(0).Value)
    Else
        ExtractNumber = 0 ' ���� ����� �� ������
    End If
    
    Set re = Nothing
End Function

' === ��������� === ����� ���� �������� OOO � �������
Sub FindAllOOOSymbols(ByRef oooSymbols)
    Dim e3App, job, symbol
    Dim symbolIds(), symbolCount
    Dim i, symbolName, symbolNumber
    
    Set e3App = CreateObject("CT.Application")
    Set job = e3App.CreateJobObject()
    Set symbol = job.CreateSymbolObject()
    
    e3App.PutInfo 0, "=== ����� ���� �������� OOO � ������� ==="
    
    symbolCount = job.GetSymbolIds(symbolIds)
    If symbolCount = 0 Then
        e3App.PutInfo 0, "� ������� �� ������� ��������."
        Set symbol = Nothing
        Set job = Nothing
        Set e3App = Nothing
        Exit Sub
    End If
    
    For i = 1 To symbolCount
        symbol.SetId(symbolIds(i))
        symbolName = symbol.GetName()
        
        If LCase(Left(symbolName, 3)) = "ooo" Then
            symbolNumber = ExtractNumber(symbolName)
            If symbolNumber > 0 Then
                oooSymbols.Add symbolNumber, symbolIds(i)
                e3App.PutInfo 0, "������ ������ OOO: " & symbolName & " (�����: " & symbolNumber & ", ID: " & symbolIds(i) & ")"
            Else
                e3App.PutInfo 0, "������ OOO ������, �� ����� �� ���������: " & symbolName
            End If
        End If
    Next
    
    e3App.PutInfo 0, "����� ������� �������� OOO � ��������: " & oooSymbols.Count
    
    Set symbol = Nothing
    Set job = Nothing
    Set e3App = Nothing
End Sub

' === ��������� === ������� ��������� ������� OOO
Sub ClearOOOSymbolAttributes(ByVal oooSymbolId, ByVal number)
    Dim e3App, job, symbol
    
    Set e3App = CreateObject("CT.Application")
    Set job = e3App.CreateJobObject()
    Set symbol = job.CreateSymbolObject()
    
    symbol.SetId(oooSymbolId)
    
    e3App.PutInfo 0, "=== ������� ��������� ������� OOO" & number & " ==="
    
    ' ������� ��������� QF ����������
    symbol.SetAttributeValue "�� V_Inom", "-"
    e3App.PutInfo 0, "������ ������� �� V_Inom"
    
    symbol.SetAttributeValue "�� V_Type", "-"
    e3App.PutInfo 0, "������ ������� �� V_Type"
    
    symbol.SetAttributeValue "�� V_Icu", "-"
    e3App.PutInfo 0, "������ ������� �� V_Icu"
    
    symbol.SetAttributeValue "�� V_Proizv", "-"
    e3App.PutInfo 0, "������ ������� �� V_Proizv"
    
    symbol.SetAttributeValue "�� V_Dop ystr", "-"
    e3App.PutInfo 0, "������ ������� �� V_Dop ystr"
    
    ' ������� ��������� KM ����������
    symbol.SetAttributeValue "�� K_Type", "-"
    e3App.PutInfo 0, "������ ������� �� K_Type"
    
    symbol.SetAttributeValue "�� K_Proizv", "-"
    e3App.PutInfo 0, "������ ������� �� K_Proizv"
    
    symbol.SetAttributeValue "�� K_Inom", "-"
    e3App.PutInfo 0, "������ ������� �� K_Inom"
    
    Set symbol = Nothing
    Set job = Nothing
    Set e3App = Nothing
End Sub

' === �������� ��������� === ������� ��������� ���� �������� OOO
Sub ClearAllOOOSymbolsAttributes()
    ' ���������� ��������������� ����
    Dim msgResult
    msgResult = MsgBox("�������� ������ ���������?", vbOKCancel + vbQuestion, "�������������")
    
    ' ���� ������������ ����� "������", ������� �� �������
    If msgResult = vbCancel Then
        Exit Sub
    End If
    
    Dim e3App
    Dim oooSymbols
    Dim oooNumber, oooSymbolId
    
    Set e3App = CreateObject("CT.Application")
    Set oooSymbols = CreateObject("Scripting.Dictionary")
    
    e3App.PutInfo 0, "=== ����� ������� ��������� ���� OOO �������� ==="
    
    ' ������� ��� ������� OOO
    Call FindAllOOOSymbols(oooSymbols)
    
    If oooSymbols.Count = 0 Then
        e3App.PutInfo 0, "������� OOO �� �������. ������� �� ���������."
        Set oooSymbols = Nothing
        Set e3App = Nothing
        Exit Sub
    End If
    
    ' ������� �������� ������� ������� OOO
    For Each oooNumber In oooSymbols.Keys
        oooSymbolId = oooSymbols.Item(oooNumber)
        
        e3App.PutInfo 0, "--- ������� OOO" & oooNumber & " ---"
        
        Call ClearOOOSymbolAttributes(oooSymbolId, oooNumber)
    Next
    
    e3App.PutInfo 0, "=== ���������� ������� ���� OOO �������� ==="
    e3App.PutInfo 0, "���������� ��������: " & oooSymbols.Count
    
    Set oooSymbols = Nothing
    Set e3App = Nothing
End Sub

' === �������� ������ ===
Dim e3App
Set e3App = CreateObject("CT.Application")

e3App.PutInfo 0, "=== ����� ������� ������� ��������� OOO �������� ==="
Call ClearAllOOOSymbolsAttributes()
e3App.PutInfo 0, "=== ����� ������� ==="

Set e3App = Nothing