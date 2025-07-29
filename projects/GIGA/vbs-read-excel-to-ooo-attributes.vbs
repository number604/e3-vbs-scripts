Option Explicit

' === ������� ��������� === ������ ��������� OOO �� Excel
Sub WriteOOOAttributesFromExcel()
    Dim e3App, job, symbol
    Dim excelApp, excelWorkbook, excelSheet
    Dim filePath, i, rowNum, cellValue

    ' ���������� ��� �������� ���������
    Dim oooTag, oooType, oooPras, oooPnom, oooInom
    Dim oooDProizv3
    Dim oooIras
    Dim oooDProizv2 ' ���������� ��� �������� �� D_Proizv2
    Dim oooDProizv1 ' ���������� ��� �������� �� D_Proizv1

    Set e3App = CreateObject("CT.Application")
    Set job = e3App.CreateJobObject()
    Set symbol = job.CreateSymbolObject()

    e3App.PutInfo 0, "=== ����� �������: ������ ��������� OOO �� Excel ==="

    ' 1. ������ ���� � ����� XLSX
    filePath = InputBox("������� ������ ���� � ����� XLSX � �������:", "���� � ����� Excel", "C:\MyData\OooAttributes.xlsx")

    If Trim(filePath) = "" Then
        e3App.PutInfo 0, "���� � ����� �� ��� ������. ������ �������."
        Exit Sub
    End If

    ' �������� ������������� �����
    Dim fso
    Set fso = CreateObject("Scripting.FileSystemObject")
    If Not fso.FileExists(filePath) Then
        e3App.PutInfo 0, "������: ���� '" & filePath & "' �� ������. ��������� ����."
        Set fso = Nothing
        Exit Sub
    End If
    Set fso = Nothing

    ' 2. ������ Excel � �������� �����
    On Error Resume Next ' �������� ��������� ������ ��� �������� � Excel
    Set excelApp = GetObject("Excel.Application")
    If Err.Number <> 0 Then
        Set excelApp = CreateObject("Excel.Application")
    End If
    On Error GoTo 0 ' ��������� ��������� ������

    If excelApp Is Nothing Then
        e3App.PutInfo 0, "������: �� ������� ��������� ��� ������������ � Excel. ���������, ��� Excel ����������."
        Exit Sub
    End If

    excelApp.Visible = False ' �������� Excel ��� ������� ������
    excelApp.DisplayAlerts = False ' ��������� �������������� (��������, � ������ �������������)

    On Error Resume Next
    Set excelWorkbook = excelApp.Workbooks.Open(filePath)
    If Err.Number <> 0 Then
        e3App.PutInfo 0, "������: �� ������� ������� ���� Excel: '" & filePath & "'. ������: " & Err.Description
        excelApp.Quit
        Set excelApp = Nothing
        Exit Sub
    End If
    On Error GoTo 0

    Set excelSheet = excelWorkbook.Sheets(1) ' �������� � ������ ������

    ' 3. ��������� ���� �������� OOO �� ������� � �� ����������
    Dim allSymbolIds()
    Dim allSymbolCount
    ' job.GetSymbolIds ���������� ���������� ��������� � ��������� ������ allSymbolIds
    allSymbolCount = job.GetSymbolIds(allSymbolIds)

    If allSymbolCount = 0 Then
        e3App.PutInfo 0, "� ������� ��� �������� ��� �������. ������ ��������."
        excelWorkbook.Close False ' ������� ��� ����������
        excelApp.Quit
        Set excelSheet = Nothing
        Set excelWorkbook = Nothing
        Set excelApp = Nothing
        Set symbol = Nothing
        Set job = Nothing
        Set e3App = Nothing
        Exit Sub
    End If

    ' ���������� ������� ��� ���������� �������� OOO �������� � �� �������� ��������
    Dim oooSymbolsMap
    Set oooSymbolsMap = CreateObject("Scripting.Dictionary")
    Dim oooNamesArray() ' ��� �������� �������� �������� OOO, ������� ����� �����������
    Dim oooArrayCurrentSize : oooArrayCurrentSize = 0 ' ������� ���������� ��������� � oooNamesArray

    For i = LBound(allSymbolIds) To UBound(allSymbolIds) ' ���������� LBound � UBound ��� ����������
        symbol.SetId(allSymbolIds(i))
        Dim symName : symName = symbol.GetName()
        If LCase(Left(symName, 3)) = "ooo" Then
            ' ��������� �������� ������ �� ����� OOO (��������, �� "OOO12" �������� 12)
            Dim oooNum : oooNum = CLng(Mid(symName, 4))
            If Not oooSymbolsMap.Exists(CStr(oooNum)) Then
                oooSymbolsMap.Add CStr(oooNum), allSymbolIds(i)
                
                ' ����������� ������ ������� � ������������� ���
                oooArrayCurrentSize = oooArrayCurrentSize + 1
                ReDim Preserve oooNamesArray(oooArrayCurrentSize - 1) ' ��� 0-���������������� �������: N ��������� -> ������������ ������ N-1
                
                oooNamesArray(oooArrayCurrentSize - 1) = oooNum ' ����������� �������� ���������� ��������
            Else
                e3App.PutInfo 0, "��������������: ��������� ������������� OOO ������ � ������� '" & oooNum & "'. ����� ��������� ������ ������ ���������."
            End If
        End If
    Next

    If oooSymbolsMap.Count = 0 Then
        e3App.PutInfo 0, "� ������� �� ������� �������� OOO ��� ������ ���������. ������ ��������."
        excelWorkbook.Close False
        excelApp.Quit
        Set excelSheet = Nothing
        Set excelWorkbook = Nothing
        Set excelApp = Nothing
        Set symbol = Nothing
        Set job = Nothing
        Set e3App = Nothing
        Set oooSymbolsMap = Nothing
        Exit Sub
    End If

    ' ��������� �������� ������� OOO �������� �� �����������
    Call SortNumericArrayAsc(oooNamesArray) ' ���������� ��������������� ������� ��� ����������

    e3App.PutInfo 0, "������� " & oooSymbolsMap.Count & " �������� OOO. �������� ������ ���������..."

    ' 4. ���� �� ��������������� OOO �������� � ������ ���������
    For i = LBound(oooNamesArray) To UBound(oooNamesArray) ' ���������� LBound � UBound ��� �������� �� ���������������� �������
        Dim currentOOONum : currentOOONum = oooNamesArray(i)
        Dim currentOOOId : currentOOOId = oooSymbolsMap.Item(CStr(currentOOONum))

        symbol.SetId(currentOOOId)
        Dim currentSymName : currentSymName = symbol.GetName()

        ' ������������� OOO_N -> ������ N+1
        ' ���� Excel ���������� �� ������ 1, � OOO_N � 1, �� ������ N+1 - ��� 2, 3 � �.�.
        ' ���� OOO_N ��� 0, �� ������ 0+1 = 1. ���������, ��� ��� ������������� ����� ��������� Excel.
        rowNum = currentOOONum + 1 

        ' ������ �������� �� Excel
        On Error Resume Next ' �������� ��������� ������ ��� ������ �����
        oooTag = Trim(CStr(excelSheet.Cells(rowNum, 13).Value))    ' ������� M --> �� E_TAG
        oooType = Trim(CStr(excelSheet.Cells(rowNum, 14).Value))  ' ������� N --> �� E_TYPE
        oooPras = Trim(CStr(excelSheet.Cells(rowNum, 6).Value)) ' ������� F --> �� E_Pras
        oooPnom = Trim(CStr(excelSheet.Cells(rowNum, 5).Value))  ' ������� E --> �� E_Pnom
        oooInom = Trim(CStr(excelSheet.Cells(rowNum, 8).Value)) ' ������� H --> �� E_Inom
        oooDProizv3 = Trim(CStr(excelSheet.Cells(rowNum, 16).Value)) ' ������� P --> �� D_Proizv3
        oooIras = Trim(CStr(excelSheet.Cells(rowNum, 9).Value))  ' ������� I --> �� E_Iras
        oooDProizv2 = Trim(CStr(excelSheet.Cells(rowNum, 11).Value)) ' ������� K --> �� D_Proizv2
        
        ' ������ "��������������� �������" �� "��" � ������
        If InStr(1, oooDProizv2, "��������������� �������", vbTextCompare) > 0 Then
            oooDProizv2 = Replace(oooDProizv2, "��������������� �������", "��", 1, -1, vbTextCompare)
        End If
        
        ' ���� ������������ ��, �� � D_Proizv1 ���������� ���� ������������
        If InStr(1, oooDProizv2, "��", vbTextCompare) > 0 Then
            oooDProizv1 = "���� ������������ 24 VDC, 1 CO � �������� ���. RNC1CO024+SNB05-E-AR"
        Else
            oooDProizv1 = "" ' ���� �� ��, �� ��������� ������
        End If
        
        If Err.Number <> 0 Then
            e3App.PutInfo 0, "��������������: ������ ��� ������ ������ ��� OOO ������� '" & currentSymName & "' (ID: " & currentOOOId & ") �� ������ " & rowNum & ". ��������� �������� ����� ���� �������. ������: " & Err.Description
            Err.Clear
        End If
        On Error GoTo 0

        ' ������ ��������� � ������ OOO
        e3App.PutInfo 0, "  ��������� �������: " & currentSymName & " (ID: " & currentOOOId & ") -> ������ Excel: " & rowNum

        If Len(oooTag) > 0 Then
            symbol.SetAttributeValue "�� E_TAG", oooTag
            e3App.PutInfo 0, "    �������� �� E_TAG: " & oooTag
        Else
            e3App.PutInfo 0, "    �� E_TAG: <�����>"
        End If

        If Len(oooType) > 0 Then
            symbol.SetAttributeValue "�� E_TYPE", oooType
            e3App.PutInfo 0, "    �������� �� E_TYPE: " & oooType
        Else
            e3App.PutInfo 0, "    �� E_TYPE: <�����>"
        End If

        If Len(oooPras) > 0 Then
            symbol.SetAttributeValue "�� E_Pras", oooPras
            e3App.PutInfo 0, "    �������� �� E_Pras: " & oooPras
        Else
            e3App.PutInfo 0, "    �� E_Pras: <�����>"
        End If

        If Len(oooPnom) > 0 Then
            symbol.SetAttributeValue "�� E_Pnom", oooPnom
            e3App.PutInfo 0, "    �������� �� E_Pnom: " & oooPnom
        Else
            e3App.PutInfo 0, "    �� E_Pnom: <�����>"
        End If

        If Len(oooInom) > 0 Then
            symbol.SetAttributeValue "�� E_Inom", oooInom
            e3App.PutInfo 0, "    �������� �� E_Inom: " & oooInom
        Else
            e3App.PutInfo 0, "    �� E_Inom: <�����>"
        End If

        If Len(oooDProizv3) > 0 Then
            symbol.SetAttributeValue "�� D_Proizv3", oooDProizv3
            e3App.PutInfo 0, "    �������� �� D_Proizv3: " & oooDProizv3
        Else
            e3App.PutInfo 0, "    �� D_Proizv3: <�����>"
        End If

        If Len(oooIras) > 0 Then
            symbol.SetAttributeValue "�� E_Iras", oooIras
            e3App.PutInfo 0, "    �������� �� E_Iras: " & oooIras
        Else
            e3App.PutInfo 0, "    �� E_Iras: <�����>"
        End If
        
        If Len(oooDProizv2) > 0 Then
            symbol.SetAttributeValue "�� D_Proizv2", oooDProizv2
            e3App.PutInfo 0, "    �������� �� D_Proizv2: " & oooDProizv2
        Else
            e3App.PutInfo 0, "    �� D_Proizv2: <�����>"
        End If
        
        If Len(oooDProizv1) > 0 Then
            symbol.SetAttributeValue "�� D_Proizv1", oooDProizv1
            e3App.PutInfo 0, "    �������� �� D_Proizv1: " & oooDProizv1
        Else
            e3App.PutInfo 0, "    �� D_Proizv1: <�����>"
        End If
    Next

    e3App.PutInfo 0, "=== ���������� �������: �������� ������� �������� ==="

    ' 5. ������� �������� Excel
    excelWorkbook.Close False ' ������� ��� ����������
    excelApp.Quit
    
    Set excelSheet = Nothing
    Set excelWorkbook = Nothing
    Set excelApp = Nothing
    Set symbol = Nothing
    Set job = Nothing
    Set e3App = Nothing
    Set oooSymbolsMap = Nothing
End Sub

' === ��������������� ��������� === ���������� ��������� ������� �� �����������
Sub SortNumericArrayAsc(arr)
    Dim i, j, temp
    ' ���� ������ ���� ��� �������� ������ 1 �������, ���������� �� �����
    ' LBound(arr) � UBound(arr) ��������� ������������ ������ ����� ����������
    If UBound(arr) < LBound(arr) + 1 Then Exit Sub

    For i = LBound(arr) To UBound(arr) - 1
        For j = i + 1 To UBound(arr)
            If arr(i) > arr(j) Then
                temp = arr(i)
                arr(i) = arr(j)
                arr(j) = temp
            End If
        Next
    Next
End Sub

' === �������� ������ ������� ===
Call WriteOOOAttributesFromExcel()