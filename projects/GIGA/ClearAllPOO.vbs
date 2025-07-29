Option Explicit

' === ������� === ���������� ������ �� ����� �������
Function ExtractNumber(ByVal itemName)
    Dim re, matches
    Set re = New RegExp
    ' ���� ����� � ����� ������ ����� �������� (��������, POO1)
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

' === ��������� === ����� ���� �������� POO � �������
Sub FindAllPOOSymbols(ByRef POOSymbols)
    Dim e3App, job, symbol
    Dim symbolIds(), symbolCount
    Dim i, symbolName, symbolNumber
    
    Set e3App = CreateObject("CT.Application")
    Set job = e3App.CreateJobObject()
    Set symbol = job.CreateSymbolObject()
    
    e3App.PutInfo 0, "=== ����� ���� �������� POO � ������� ==="
    
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
        
        If LCase(Left(symbolName, 3)) = "POO" Then
            symbolNumber = ExtractNumber(symbolName)
            If symbolNumber > 0 Then
                POOSymbols.Add symbolNumber, symbolIds(i)
                e3App.PutInfo 0, "������ ������ POO: " & symbolName & " (�����: " & symbolNumber & ", ID: " & symbolIds(i) & ")"
            Else
                e3App.PutInfo 0, "������ POO ������, �� ����� �� ���������: " & symbolName
            End If
        End If
    Next
    
    e3App.PutInfo 0, "����� ������� �������� POO � ��������: " & POOSymbols.Count
    
    Set symbol = Nothing
    Set job = Nothing
    Set e3App = Nothing
End Sub

' === ��������� === ������� ��������� ������� POO
Sub ClearPOOSymbolAttributes(ByVal POOSymbolId, ByVal number)
    Dim e3App, job, symbol
    
    Set e3App = CreateObject("CT.Application")
    Set job = e3App.CreateJobObject()
    Set symbol = job.CreateSymbolObject()
    
    symbol.SetId(POOSymbolId)
    
    e3App.PutInfo 0, "=== ������� ��������� ������� POO" & number & " ==="
    
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

' === �������� ��������� === ������� ��������� ���� �������� POO
Sub ClearAllPOOSymbolsAttributes()
    ' ���������� ��������������� ����
    Dim msgResult
    msgResult = MsgBox("�������� ������ ���������?", vbOKCancel + vbQuestion, "�������������")
    
    ' ���� ������������ ����� "������", ������� �� �������
    If msgResult = vbCancel Then
        Exit Sub
    End If
    
    Dim e3App
    Dim POOSymbols
    Dim POONumber, POOSymbolId
    
    Set e3App = CreateObject("CT.Application")
    Set POOSymbols = CreateObject("Scripting.Dictionary")
    
    e3App.PutInfo 0, "=== ����� ������� ��������� ���� POO �������� ==="
    
    ' ������� ��� ������� POO
    Call FindAllPOOSymbols(POOSymbols)
    
    If POOSymbols.Count = 0 Then
        e3App.PutInfo 0, "������� POO �� �������. ������� �� ���������."
        Set POOSymbols = Nothing
        Set e3App = Nothing
        Exit Sub
    End If
    
    ' ������� �������� ������� ������� POO
    For Each POONumber In POOSymbols.Keys
        POOSymbolId = POOSymbols.Item(POONumber)
        
        e3App.PutInfo 0, "--- ������� POO" & POONumber & " ---"
        
        Call ClearPOOSymbolAttributes(POOSymbolId, POONumber)
    Next
    
    e3App.PutInfo 0, "=== ���������� ������� ���� POO �������� ==="
    e3App.PutInfo 0, "���������� ��������: " & POOSymbols.Count
    
    Set POOSymbols = Nothing
    Set e3App = Nothing
End Sub

' === �������� ������ ===
Dim e3App
Set e3App = CreateObject("CT.Application")

e3App.PutInfo 0, "=== ����� ������� ������� ��������� POO �������� ==="
Call ClearAllPOOSymbolsAttributes()
e3App.PutInfo 0, "=== ����� ������� ==="

Set e3App = Nothing