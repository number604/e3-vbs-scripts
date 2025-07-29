'*******************************************************************************
' �������� �������: E3_PlaceFragmentsSorted
' �����: E3.series VBScript Assistant
' ����: 15.07.2025
' ��������: ������ ��� ��������������� ���������� ���������� �� ������ �3.
'          ������� ������� ��� ������� "OOO", ��������� �� �� �������,
'          � ����� ��������� ��������� � ��������������� �������.
'*******************************************************************************
Option Explicit

Sub PlaceFragmentsOnSheets()
    Dim result
    result = MsgBox("������ ���������� ���������� �� ������ �3?", vbOKCancel + vbQuestion, "�������������")
    
    If result = vbCancel Then
        Exit Sub
    End If
    
    Dim e3App, job, symbol, sheet, device
    
    ' --- ���������� �������� ���������� ---
    Dim allSymbolIds
    Dim allSymbolCount
    Dim currentSymbolId, symbolName, symbolIndex
    Dim subcircuitPath, subcircuitVersion
    Dim attrValue
    
    ' --- ���������� ��� ������ � ������� ---
    Dim currentSheetId
    Dim fragmentCountOnCurrentSheet
    Dim sheetNumber
    Dim sheetName
    Dim allSheetIds
    Dim sheetCount
    Dim foundSheet
    Dim i
    
    ' --- ���������� ��� ������ � ��������� (������������) ---
    Dim existingDeviceIdsBeforeInsert
    Dim existingDeviceCountBeforeInsert
    Dim existingDevicesMap
    Dim allDeviceIdsAfterInsert
    Dim allDeviceCountAfterInsert
    Dim newDeviceIds()
    Dim newDeviceCount
    Dim currentDeviceId
    Dim devName, newName
    Dim prefixList, p, prefix
    
    ' --- ���������� ��� ������� ���������� ---
    Dim xCoords(5)
    Dim yCoords(5)    
    Dim insertX, insertY
    
    ' --- ���������� 'd' �������� ��������� � ���������� ������ ---
    Dim d
    
    ' --- ���������� ��� ���������� ---
    Dim oooSymbols()
    Dim oooSymbolCount
    Dim currentOOOId
    Dim currentOOOIndex
    Dim tempSymbolId
    Dim tempSymbolIndex
    Dim j
    
    xCoords(1) = 36
    yCoords(1) = 24
    
    xCoords(2) = 108
    yCoords(2) = 24
    
    xCoords(3) = 180
    yCoords(3) = 24
    
    xCoords(4) = 252
    yCoords(4) = 24
    
    xCoords(5) = 324
    yCoords(5) = 24

    Set e3App = CreateObject("CT.Application")
    Set job = e3App.CreateJobObject()
    Set symbol = job.CreateSymbolObject()
    Set sheet = job.CreateSheetObject()
    Set device = job.CreateDeviceObject()    

    e3App.PutInfo 0, "=== ����� �������: ���������� ���������� ==="

    ' ������������� ���������� ��� ������
    currentSheetId = 0
    fragmentCountOnCurrentSheet = 0
    sheetNumber = 1
    oooSymbolCount = 0

    ' --- ������ �����������: ���� � ���������� "OOO" �������� ---
    e3App.PutInfo 0, "����� � ���������� �������� 'OOO'..."

    allSymbolCount = job.GetSymbolIds(allSymbolIds)
    ReDim oooSymbols(1, -1)

    If allSymbolCount > 0 Then
        For i = 1 To allSymbolCount
            currentSymbolId = allSymbolIds(i)
            symbol.SetId(currentSymbolId)
            symbolName = symbol.GetName()

            If UCase(Left(symbolName, 3)) = "OOO" Then
                symbolIndex = CLng(Mid(symbolName, 4))
                
                oooSymbolCount = oooSymbolCount + 1
                ReDim Preserve oooSymbols(1, oooSymbolCount - 1)
                oooSymbols(0, oooSymbolCount - 1) = currentSymbolId
                oooSymbols(1, oooSymbolCount - 1) = symbolIndex
            End If
        Next
    End If

    If oooSymbolCount = 0 Then
        e3App.PutInfo 0, "� ������� �� ������� �������� 'OOO'."
    Else
        ' ���������� ������� oooSymbols �� �������
        For i = 0 To oooSymbolCount - 2
            For j = i + 1 To oooSymbolCount - 1
                If oooSymbols(1, i) > oooSymbols(1, j) Then
                    ' ������ ������� ID
                    tempSymbolId = oooSymbols(0, i)
                    oooSymbols(0, i) = oooSymbols(0, j)
                    oooSymbols(0, j) = tempSymbolId
                    
                    ' ������ ������� �������
                    tempSymbolIndex = oooSymbols(1, i)
                    oooSymbols(1, i) = oooSymbols(1, j)
                    oooSymbols(1, j) = tempSymbolIndex
                End If
            Next
        Next
        e3App.PutInfo 0, "������� 'OOO' ������� �������������."

        ' --- ������ ��������� ����� �� ��������������� �������� ---
        For i = 0 To oooSymbolCount - 1
            currentSymbolId = oooSymbols(0, i)
            symbolIndex = oooSymbols(1, i)
            
            symbol.SetId(currentSymbolId)
            symbolName = symbol.GetName()
            
            attrValue = Trim(symbol.GetAttributeValue("�� D_Proizv3"))

            If attrValue <> "" And (attrValue >= "1" And attrValue <= "6") Then
                Select Case attrValue
                    Case "1": subcircuitPath = "C:\Users\SEK\Desktop\DWG_4_E3\����� �����\�������\���������\1.e3p"
                    Case "2": subcircuitPath = "C:\Users\SEK\Desktop\DWG_4_E3\����� �����\�������\���������\2.e3p"
					Case "3": subcircuitPath = "C:\Users\SEK\Desktop\DWG_4_E3\����� �����\�������\���������\3.e3p"
					Case "4": subcircuitPath = "C:\Users\SEK\Desktop\DWG_4_E3\����� �����\�������\���������\4.e3p"
					Case "5": subcircuitPath = "C:\Users\SEK\Desktop\DWG_4_E3\����� �����\�������\���������\5.e3p"
					Case "6": subcircuitPath = "C:\Users\SEK\Desktop\DWG_4_E3\����� �����\�������\���������\6.e3p"
                End Select
                
                subcircuitVersion = "1"

                If fragmentCountOnCurrentSheet = 5 Then
                    fragmentCountOnCurrentSheet = 0
                    sheetNumber = sheetNumber + 1
                    currentSheetId = 0
                End If

                If currentSheetId = 0 Then
                    sheetName = CStr(sheetNumber)
                    
                    sheetCount = job.GetSheetIds(allSheetIds)
                    foundSheet = False
                    
                    If sheetCount > 0 Then
                        For d = 1 To sheetCount
                            sheet.SetId allSheetIds(d)
                            If sheet.GetName() = sheetName And UCase(Trim(sheet.GetAttributeValue("��� ���������"))) = "�3" Then
                                currentSheetId = allSheetIds(d)
                                foundSheet = True
                                e3App.PutInfo 0, "������ ���� ��� �������: '" & sheetName & "' (ID: " & currentSheetId & ")"
                                Exit For
                            End If
                        Next
                    End If
                    
                    If Not foundSheet Then
                        e3App.PutInfo 2, "������: ���� '" & sheetName & "' � ��������� '��� ���������' = '�3' �� ������. ������ ����������."
                        Exit For ' ������� �� ����� ��������� ��������
                    End If
                End If
                
                If foundSheet Or currentSheetId <> 0 Then
                    sheet.SetId currentSheetId
                    
                    fragmentCountOnCurrentSheet = fragmentCountOnCurrentSheet + 1
                    insertX = xCoords(fragmentCountOnCurrentSheet)
                    insertY = yCoords(fragmentCountOnCurrentSheet)
                    
                    e3App.PutInfo 0, "��������� " & symbolName & " (������� = " & attrValue & ") > �������: " & subcircuitPath & " �� ���� '" & sheet.GetName() & "' � ������� (" & insertX & ", " & insertY & ")"

                    existingDeviceCountBeforeInsert = job.GetDeviceIds(existingDeviceIdsBeforeInsert)            
                    Set existingDevicesMap = CreateObject("Scripting.Dictionary")            
                    If existingDeviceCountBeforeInsert > 0 Then
                        For d = 1 To existingDeviceCountBeforeInsert            
                            existingDevicesMap.Add existingDeviceIdsBeforeInsert(d), True            
                        Next
                    End If
                    e3App.PutInfo 0, "���������� ��������� � ������� �� �������: " & existingDeviceCountBeforeInsert

                    Dim insertResult
                    insertResult = sheet.PlacePart(subcircuitPath, subcircuitVersion, insertX, insertY, 0.0)

                    If insertResult = 0 Or insertResult = -3 Then
                        e3App.PutInfo 0, "�������� ������� ����������. ������ �������������� ����� ��������..."

                        allDeviceCountAfterInsert = job.GetDeviceIds(allDeviceIdsAfterInsert)            
                        e3App.PutInfo 0, "���������� ��������� � ������� ����� �������: " & allDeviceCountAfterInsert

                        newDeviceCount = 0
                        ReDim newDeviceIds(-1)

                        If allDeviceCountAfterInsert > 0 Then
                            For d = 1 To allDeviceCountAfterInsert            
                                currentDeviceId = allDeviceIdsAfterInsert(d)
                                If Not existingDevicesMap.Exists(currentDeviceId) Then
                                    If newDeviceCount = 0 Then
                                        ReDim newDeviceIds(0)
                                    Else
                                        ReDim Preserve newDeviceIds(newDeviceCount)
                                    End If
                                    newDeviceIds(newDeviceCount) = currentDeviceId
                                    newDeviceCount = newDeviceCount + 1
                                End If
                            Next
                        End If
                        e3App.PutInfo 0, "������� ����� �������� ��� ��������������: " & newDeviceCount

                        prefixList = Array("-tQF", "-tKM")
                        
                        If newDeviceCount > 0 Then
                            For d = 0 To newDeviceCount - 1
                                currentDeviceId = newDeviceIds(d)
                                device.SetId currentDeviceId
                                devName = device.GetName()

                                For p = 0 To UBound(prefixList)
                                    prefix = prefixList(p)
                                    If LCase(Left(devName, Len(prefix))) = LCase(prefix) Then
                                        newName = prefix & symbolIndex
                                        e3App.PutInfo 0, "�������������� �������: '" & devName & "' > '" & newName & "'"
                                        device.SetName newName
                                        Exit For
                                    End If
                                Next
                            Next
                        Else
                            e3App.PutInfo 1, "��������: �� ������� ����� ����� ������� ��� �������������� ����� ������� ���������."
                        End If
                        Set existingDevicesMap = Nothing

                    Else
                        e3App.PutInfo 2, "������ ������� ��������� (���: " & insertResult & ") ��� ������� " & symbolName
                    End If
                End If
            Else
                e3App.PutInfo 1, "������� " & symbolName & ": ������������ �������� �������� '�� D_Proizv3' = '" & attrValue & "'"
            End If
        Next
    End If
    e3App.PutInfo 0, "=== ������ �������� ==="

    Set device = Nothing
    Set symbol = Nothing
    Set sheet = Nothing
    Set job = Nothing
    Set e3App = Nothing
End Sub

Call PlaceFragmentsOnSheets()