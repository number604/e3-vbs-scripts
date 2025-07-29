'*******************************************************************************
' �������� �������: E3_SynchronizeOooPooAttributes
' �����: E3.series VBScript Assistant
' ����: 08.07.2025
' ��������: ������ ��� ������������� ������������ ��������� ����� ��������� "OOO" � "POO" � ������� E3.series.
'           �� ���� ���� �������� �� ��������� ������� � �� ����� � �������� �������� ��������� �� "OOO" � "POO" �������,
'           ���� �������� �� �����. ��������� ����������� ��������� "�� E_Iras" � "�� E_Inom".
'*******************************************************************************
Option Explicit

Sub SynchronizeOooPooAttributes()
    ' ���������� ��������������� ����
    Dim result
    result = MsgBox("������ ������������� ��������� ����� OOO � POO ��������� � �������?", vbOKCancel + vbQuestion, "�������������")
    
    ' ���� ������������ ����� "������", ������� �� �������
    If result = vbCancel Then
        Exit Sub
    End If

    Dim e3App, job, oooSymbol, pooSymbol ' ���������� ������� ��� OOO � POO ��������
    Dim allSymbolIds ' ������ ���� ID �������� � �������
    Dim allSymbolCount
    Dim s_ooo, s_poo ' �������� ������
    Dim oooSymbolId, oooSymbolName, oooSymbolIndex
    Dim pooSymbolId, pooSymbolName
    Dim pooSymbolFound

    Dim attrNamesToCopy ' ������ � ���������� ��������� ��� �����������
    Dim currentAttrName ' ������� �������� ��������
    Dim oooAttrValue ' �������� �������� �� OOO �������
    Dim p ' ������� ��� ����� �� ���������

    Set e3App = CreateObject("CT.Application")
    Set job = e3App.CreateJobObject()
    Set oooSymbol = job.CreateSymbolObject()
    Set pooSymbol = job.CreateSymbolObject() ' ��������� ������ ��� POO ��������

    e3App.PutInfo 0, "=== ����� �������: ������������� ��������� OOO � POO ==="

    ' ����������� ������ ��������� ��� �����������, ������� "�� D_Proizv2", "�� E_Iras", "�� E_Inom"
    attrNamesToCopy = Array("�� E_TAG", "�� E_TYPE", "�� E_Pnom", "�� V_Type", "�� D_Proizv2", "�� E_Iras", "�� E_Inom")

    allSymbolCount = job.GetSymbolIds(allSymbolIds)

    If allSymbolCount > 0 Then
        For s_ooo = 1 To allSymbolCount ' ���� �� ���� �������� ��� ������ OOO
            oooSymbolId = allSymbolIds(s_ooo)
            oooSymbol.SetId(oooSymbolId)
            oooSymbolName = oooSymbol.GetName()

            ' ���������, ���������� �� ��� ������� � "OOO"
            If UCase(Left(oooSymbolName, 3)) = "OOO" Then
                oooSymbolIndex = Mid(oooSymbolName, 4) ' ��������� ������
                pooSymbolName = "POO" & oooSymbolIndex ' ��������� ��� ���������������� POO �������
                
                pooSymbolId = 0 ' ����� ID POO �������
                pooSymbolFound = False

                ' ���� ��������������� POO ������ ����� ���� �������� � �������
                For s_poo = 1 To allSymbolCount
                    If allSymbolIds(s_poo) <> oooSymbolId Then ' �������� ��������� � ����� OOO ��������
                        pooSymbol.SetId(allSymbolIds(s_poo))
                        If UCase(pooSymbol.GetName()) = UCase(pooSymbolName) Then
                            pooSymbolId = allSymbolIds(s_poo)
                            pooSymbolFound = True
                            e3App.PutInfo 0, "������ ��������������� POO ������: " & pooSymbolName & " (��� OOO: " & oooSymbolName & ")"
                            Exit For ' POO ������ ������, ����� ����� �� ����� ����������� �����
                        End If
                    End If
                Next

                If pooSymbolFound Then
                    ' �������� ��������
                    For p = 0 To UBound(attrNamesToCopy)
                        currentAttrName = attrNamesToCopy(p)
                        oooAttrValue = oooSymbol.GetAttributeValue(currentAttrName)
                        
                        If oooAttrValue <> "" Then ' �������� ������ �������� ��������
                            pooSymbol.SetAttributeValue currentAttrName, oooAttrValue
                            e3App.PutInfo 0, "  -> ���������� ������� '" & currentAttrName & "': '" & oooAttrValue & "'"
                        Else
                            e3App.PutInfo 1, "  -> ������� '" & currentAttrName & "' ��� ������� " & oooSymbolName & " ������. ��������."
                        End If
                    Next
                Else
                    e3App.PutInfo 1, "��������: ��������������� POO ������ '" & pooSymbolName & "' ��� OOO ������� '" & oooSymbolName & "' �� ������. �������� �� �����������."
                End If
            End If ' End If ��� OOO �������
        Next
    Else
        e3App.PutInfo 0, "� ������� ��� �������� ��� ���������."
    End If

    e3App.PutInfo 0, "=== ������ �������� ==="

    ' ������� ��������
    Set oooSymbol = Nothing
    Set pooSymbol = Nothing
    Set job = Nothing
    Set e3App = Nothing
End Sub

Call SynchronizeOooPooAttributes()