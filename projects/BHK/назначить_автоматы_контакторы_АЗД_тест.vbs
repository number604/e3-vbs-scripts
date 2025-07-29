'*******************************************************************************
' �������� �������: E3_UZ_ComponentUpdater
' �����: E3.series VBScript Assistant
' ����: 01.07.2025
' ��������: ������ ��� ��������������� ���������� ���� ����������� ��� ��������� -QF � -KM
'           �� ������ ���������, ����������� �� OOO ��������, � ����� ������� ������������.
'           �� ��������� ��� ���������� �� "�������" ��� KM, ������ ��� QF.
'*******************************************************************************
Option Explicit

' --- ���������� ���������� ---
' ������ ���������� E3.series
Dim e3App
' ������ Job, �������������� ������� ������
Dim job
' ������� ��� �������� ID ��������� OOO ��������, ��������������� ���������.
' ����: ��������� �������� �� ����� OOO ������� (��������, "123" ��� "OOO123")
' ��������: ID ������� � E3.series
Dim global_foundOOOIds

' ������� ��� �������� ������������ ���������� � ��������� E_Inom ��� ��������� (QF)
' ����: ��� ���������� (String)
' ��������: ������ Double(2) - [�������������������, ��������������������]
Dim qfComponentMap

' ����� ������� ��� �������� ������������ ���������� � ��������� E_Inom ��� ����������� (KM)
Dim kmComponentMap

' --- �������� ��������� ������� ---
Sub Main()
    ' ������������� �������� E3.series
    Set e3App = CreateObject("CT.Application")
    Set job = e3App.CreateJobObject()

    ' ������������� ����������� ������� ��� �������� ��������� OOO ��������
    Set global_foundOOOIds = CreateObject("Scripting.Dictionary")
    
    ' ������������� � ���������� ������� ������������ ����������� QF
    Set qfComponentMap = CreateObject("Scripting.Dictionary")
    Call PopulateQFComponentMap() ' �������� ��������� ��� ���������� ������� ������������ QF

    ' �����: ������������� � ���������� ������� ������������ ����������� KM
    Set kmComponentMap = CreateObject("Scripting.Dictionary")
    Call PopulateKMComponentMap() ' �������� ��������� ��� ���������� ������� ������������ KM

    e3App.PutInfo 0, "=== ����� �������: ����� OOO �������� � ��������� � ���� ��������� ==="

    ' ��� 1: ������� � ��������� OOO ������� �� �������� ���������
    Call FindAndLogOOOSymbols()

    ' ��� 2: ������� � ������� ���������� � ��������� ����������� (-QF � -KM)
    Call FindAndLogRelatedDevices()

    ' ��� 3: ��������� ��������� QF �� ������ �������� OOO �������
    Call UpdateQFComponentsBasedOnOOOAttribute()

    ' �����: ��� 4: ��������� ��������� KM �� ������ �������� OOO �������
    Call UpdateKMComponentsBasedOnOOOAttribute()

    e3App.PutInfo 0, "=== ���������� ������� ==="

    ' ������� ���������� �������� ��� ������������ ��������
    Call CleanUpGlobalObjects()
End Sub

' --- ��������� ��� ���������� ������� ������������ ����������� QF (���������) ---
Sub PopulateQFComponentMap()
    ' ��� ������� �������� �������: Add "�������������", Array(�������������������, ��������������������)
    ' ���������� CDbl() ��� ������ �������������� ����� � ��������� ������.
    ' ������������ �������� � ��������� "�� X �� Y" ����� ������������ Y-0.0001 ��� ���������� ������ If-ElseIf
    
    qfComponentMap.Add "�������_3P_0.16-0.25A", Array(CDbl(0.16), CDbl(0.2499))
    qfComponentMap.Add "�������_3P_0.25-0.4A", Array(CDbl(0.25), CDbl(0.3999))
    qfComponentMap.Add "�������_3P_0.4-0.63A", Array(CDbl(0.40), CDbl(0.6299))
    qfComponentMap.Add "�������_3P_0.63-1.0A", Array(CDbl(0.63), CDbl(0.9999))
    qfComponentMap.Add "�������_3P_1.0-1.6A", Array(CDbl(1.00), CDbl(1.5999))
    qfComponentMap.Add "�������_3P_1.6-2.5A", Array(CDbl(1.60), CDbl(2.4999))
    qfComponentMap.Add "�������_3P_2.5-4.0A", Array(CDbl(2.50), CDbl(3.9999))
    qfComponentMap.Add "�������_3P_4.0-6.3A", Array(CDbl(4.00), CDbl(6.2999))
    qfComponentMap.Add "�������_3P_6.3-10.0A", Array(CDbl(6.30), CDbl(9.9999))
    qfComponentMap.Add "�������_3P_9-14A", Array(CDbl(9.00), CDbl(13.9999))
    qfComponentMap.Add "�������_3P_13-18A", Array(CDbl(13.00), CDbl(17.9999))
    qfComponentMap.Add "�������_3P_17-23A", Array(CDbl(17.00), CDbl(22.9999))
    qfComponentMap.Add "�������_3P_20-25A", Array(CDbl(20.00), CDbl(24.9999))
    qfComponentMap.Add "�������_3P_24-32A", Array(CDbl(24.00), CDbl(31.9999))
    qfComponentMap.Add "�������_3P_25-40A", Array(CDbl(25.00), CDbl(39.9999))
    qfComponentMap.Add "�������_3�_40-63�", Array(CDbl(40.00), CDbl(62.9999))
    qfComponentMap.Add "�������_3P_56-80A", Array(CDbl(56.00), CDbl(79.9999))
    
    e3App.PutInfo 0, "��������� " & qfComponentMap.Count & " ������������ ����������� QF (���������)."
End Sub

' ����� ���������: ��� ���������� ������� ������������ ����������� KM (�����������) ---
Sub PopulateKMComponentMap()
    kmComponentMap.Add "���������_��102_22001DEK", Array(CDbl(0.00), CDbl(9.00))
    kmComponentMap.Add "���������_��102_22002DEK", Array(CDbl(9.01), CDbl(12.00))
    kmComponentMap.Add "���������_��102_22003DEK", Array(CDbl(12.01), CDbl(18.00))
    kmComponentMap.Add "���������_��102_22004DEK", Array(CDbl(18.01), CDbl(25.00))
    kmComponentMap.Add "���������_��102_22005DEK", Array(CDbl(25.01), CDbl(32.00))
    kmComponentMap.Add "���������_��102_22006DEK", Array(CDbl(32.01), CDbl(40.00))
    kmComponentMap.Add "���������_��102_22007DEK", Array(CDbl(40.01), CDbl(50.00))
    kmComponentMap.Add "���������_��102_22008DEK", Array(CDbl(50.01), CDbl(65.00))
    kmComponentMap.Add "���������_��102_22009DEK", Array(CDbl(65.01), CDbl(80.00))
    kmComponentMap.Add "���������_��102_22010DEK", Array(CDbl(80.01), CDbl(95.00))
    kmComponentMap.Add "���������_��103_22150DEK", Array(CDbl(95.01), CDbl(115.00))
    kmComponentMap.Add "���������_��103_22152DEK", Array(CDbl(115.01), CDbl(150.00))
    kmComponentMap.Add "���������_��103_22154DEK", Array(CDbl(150.01), CDbl(185.00))
    kmComponentMap.Add "���������_��103_22156DEK", Array(CDbl(185.01), CDbl(225.00))
    kmComponentMap.Add "���������_��103_22158DEK", Array(CDbl(225.01), CDbl(265.00))
    kmComponentMap.Add "���������_��103_22160DEK", Array(CDbl(265.01), CDbl(330.00))
    kmComponentMap.Add "���������_��103_22162DEK", Array(CDbl(330.01), CDbl(400.00))

    e3App.PutInfo 0, "��������� " & kmComponentMap.Count & " ������������ ����������� KM (�����������)."
End Sub

' --- ��������� ��� ������ � ������ ���������� �� OOO �������� ---
Sub FindAndLogOOOSymbols()
    Dim symbol            ' ������ Symbol ��� ������ � ���������� ���������
    Dim allSymbolIds()    ' ������ ��� �������� ��������������� ���� �������� � �������
    Dim allSymbolCount    ' ����� ���������� �������� � �������
    Dim i                 ' ������� ����� ��� �������� ��������

    Dim symbolName        ' ��� �������� �������
    Dim dProizv3Value     ' �������� �������� "�� D_Proizv3" �������� �������
    Dim oooIndex          ' �������� ������ �� ����� OOO ������� (��������, 123 ��� "OOO123")

    ' ������� ������ Symbol
    Set symbol = job.CreateSymbolObject()

    ' �������� ������ ���� �������� � ������� �������
    allSymbolCount = job.GetSymbolIds(allSymbolIds)

    ' ���������, ���� �� ������� � �������
    If allSymbolCount = 0 Then
        e3App.PutInfo 0, "� ������� ������� �� ������� �������� ��� �������."
        Set symbol = Nothing ' ����������� ������ Symbol ����� �������
        Exit Sub
    End If    
    
    e3App.PutInfo 0, "������� " & allSymbolCount & " �������� � �������. ���� OOO ������� � '�� D_Proizv3' = '3', '4' ��� '8'..."

    Dim foundOOOCount : foundOOOCount = 0 ' ������� ��������� OOO ��������, ��������������� ���������

    ' ���������� ��� ������� � �������
    For i = 1 To allSymbolCount
        ' ������������� ������� ������ �� ��� ID ��� ���������� ������
        symbol.SetId(allSymbolIds(i))
        symbolName = symbol.GetName() ' �������� ��� �������

        ' ���������, ���������� �� ��� ������� � "OOO" (��� ����� ��������)
        If LCase(Left(symbolName, 3)) = "ooo" Then
            ' �������� �������� �������� "�� D_Proizv3"
            ' Trim() ������� ������ �������, CStr() ����������� � ������ ��� ��������� ���������
            dProizv3Value = Trim(CStr(symbol.GetAttributeValue("�� D_Proizv3")))

            ' ���������, ������������� �� �������� �������� ����� ��������� ("3" ��� "4" ��� "8")
            If dProizv3Value = "3" Or dProizv3Value = "4" Or dProizv3Value = "8" Then
                foundOOOCount = foundOOOCount + 1 ' ����������� �������
                
                ' ��������� �������� ������ �� ����� OOO ������� (��������, "123" �� "OOO123")
                On Error Resume Next ' �������� ��������� ������ ��� CLng
                oooIndex = CLng(Mid(symbolName, 4)) ' �������� ������������� ����� ����� � �����
                If Err.Number <> 0 Then
                    ' ���� �������������� �� ������� (��������, "OOOABC"), ���������� �������� ������
                    oooIndex = Mid(symbolName, 4)
                    e3App.PutInfo 0, "    ��������: �� ������� ������������� ������ '" & Mid(symbolName, 4) & "' � ����� ��� OOO ������� '" & symbolName & "'."
                    Err.Clear ' ������� ������
                End If
                On Error GoTo 0 ' ��������� ��������� ������

                ' ��������� ��������� ������ � ���������� �������
                ' ���������� CStr(oooIndex) ��� �����, ����� ���� ���������� � ���� ������ �����
                If Not global_foundOOOIds.Exists(CStr(oooIndex)) Then
                    global_foundOOOIds.Add CStr(oooIndex), allSymbolIds(i)
                    e3App.PutInfo 0, "  ������ � �������� OOO ������: '" & symbolName & "'" & _
                                     " (ID: " & allSymbolIds(i) & ")" & _
                                     " | ������� '�� D_Proizv3': '" & dProizv3Value & "'"
                Else
                    e3App.PutInfo 0, "  ��������: OOO ������ � �������� '" & CStr(oooIndex) & "' ��� ������. ��������� ID ��: " & allSymbolIds(i) & _
                                     " (���: '" & symbolName & "', D_Proizv3: '" & dProizv3Value & "')"
                    global_foundOOOIds.Item(CStr(oooIndex)) = allSymbolIds(i) ' ��������� ID, ���� ����� ������ ��� ����
                End If
            End If
        End If
    Next

    ' ������� �������� ��������� � ����������� ������ OOO ��������
    If foundOOOCount = 0 Then
        e3App.PutInfo 0, "�� ������� OOO �������� �� ��������� �������� '�� D_Proizv3' ������ '3', '4' ��� '8'."
    Else
        e3App.PutInfo 0, "����� ������� " & foundOOOCount & " OOO ��������, ��������������� �������� ���������."
        e3App.PutInfo 0, "ID ��������� OOO �������� ��������� � ���������� ������� 'global_foundOOOIds'."
    End If

    Set symbol = Nothing ' ����������� ������ Symbol
End Sub

' --- ��������� ��� ������ � ������ ���������� � ��������� ����������� (-QF � -KM) ---
Sub FindAndLogRelatedDevices()
    Dim device            ' ������ Device ��� ������ � ������������
    Dim oooIndex_str      ' ��������� ������������� ��������� ������� OOO �������
    Dim targetDeviceName    ' ��� ����������, ������� �� ���� (��������, "-QF123" ��� "-KM123")
    Dim allDeviceIds()      ' ������ ��� �������� ��������������� ���� ��������� � �������
    Dim allDeviceCount      ' ����� ���������� ��������� � �������
    Dim i                   ' ������� ����� ��� �������� ���������
    Dim currentDeviceName   ' ��� �������� ����������
    Dim componentName       ' ��� ���������� �������� ����������

    ' ���������, ���� �� ������� OOO ������� �� ���������� ����
    If global_foundOOOIds.Count = 0 Then
        e3App.PutInfo 0, "��� ��������������� OOO �������� (D_Proizv3=3, 4 ��� 8) ��� ������ ��������� ���������."
        Exit Sub
    End If

    Set device = job.CreateDeviceObject()

    e3App.PutInfo 0, "=== ������ ������ ��������� ��������� -QF � -KM ��� ��������� OOO �������� ==="
    
    ' �������� ������ ���� ��������� � ������� ���� ��� ��� �������������
    allDeviceCount = job.GetAllDeviceIds(allDeviceIds)

    ' ���������� ������ ��������������� OOO ������
    For Each oooIndex_str In global_foundOOOIds.Keys
        e3App.PutInfo 0, "  ����� ��������� ��������� ��� OOO" & oooIndex_str & ":"
        Dim foundRelatedDeviceForCurrentOOO : foundRelatedDeviceForCurrentOOO = False

        ' --- ����� -QF ��������� ---
        targetDeviceName = "-QF" & oooIndex_str
        Dim qfFoundCount : qfFoundCount = 0 ' ������� ��������� �������� -QF ���������
        
        For i = 1 To allDeviceCount ' ���������� ��� ����������, ����� ����� ��� ����������
            device.SetId(allDeviceIds(i))
            currentDeviceName = device.GetName()
            componentName = device.GetComponentName()

            If UCase(currentDeviceName) = UCase(targetDeviceName) Then
                ' ��� -QF ���������, ����� ���������, �������� �� ��������� "�������"
                If InStr(1, LCase(componentName), "�������") > 0 Then
                    qfFoundCount = qfFoundCount + 1
                    e3App.PutInfo 0, "    ������� -QF ����������: '" & currentDeviceName & "'" & _
                                     " (ID: " & allDeviceIds(i) & ")" & _
                                     " | ���������: '" & componentName & "'"
                    foundRelatedDeviceForCurrentOOO = True
                Else
                    e3App.PutInfo 0, "    ������o -QF ����������: '" & currentDeviceName & "' (ID: " & allDeviceIds(i) & "), �� ��� ��������� ('" & componentName & "') �� �������� '�������'. ��� ���������� ���������."
                End If
            End If
        Next
        
        If qfFoundCount = 0 Then
            e3App.PutInfo 0, "    -QF" & oooIndex_str & " (� ����������� '�������') �� ������� �� ������ ���������� ����� ���� ��������� �������."
        Else
            e3App.PutInfo 0, "    ����� ������� " & qfFoundCount & " -QF ��������� � ����������� '�������' ��� OOO" & oooIndex_str & "."
        End If

        ' --- ����� -KM ��������� ---
        targetDeviceName = "-KM" & oooIndex_str
        Dim kmFoundCount : kmFoundCount = 0 ' ������� ��������� -KM ���������

        For i = 1 To allDeviceCount ' ���������� ��� ����������, ����� ����� ��� ����������
            device.SetId(allDeviceIds(i))
            currentDeviceName = device.GetName()
            componentName = device.GetComponentName()

            If UCase(currentDeviceName) = UCase(targetDeviceName) Then
                kmFoundCount = kmFoundCount + 1
                e3App.PutInfo 0, "    ������� -KM ����������: '" & currentDeviceName & "'" & _
                                 " (ID: " & allDeviceIds(i) & ")" & _
                                 " | ���������: '" & componentName & "'"
                foundRelatedDeviceForCurrentOOO = True
            End If
        Next
        
        If kmFoundCount = 0 Then
            e3App.PutInfo 0, "    -KM" & oooIndex_str & " �� ������� �� ������ ���������� ����� ���� ��������� �������."
        Else
            e3App.PutInfo 0, "    ����� ������� " & kmFoundCount & " -KM ��������� ��� OOO" & oooIndex_str & "."
        End If

        If Not foundRelatedDeviceForCurrentOOO Then
            e3App.PutInfo 0, "  ��� OOO" & oooIndex_str & " �� ������� �� ������ ���������������� -QF (� ����������� '�������') ��� -KM ����������."
        End If
    Next

    e3App.PutInfo 0, "=== ���������� ������ ��������� ��������� ==="

    Set device = Nothing ' ����������� ������ Device
End Sub

' --- ��������� ��� ���������� ���������� QF �� ������ �������� OOO ������� ---
Sub UpdateQFComponentsBasedOnOOOAttribute()
    Dim symbolObj       ' ������ Symbol ��� ������ ��������� OOO
    Dim deviceObj       ' ������ Device ��� ���������� ����������� QF
    Dim oooIndex_str    ' ��������� ������������� ��������� ������� OOO �������
    Dim oooSymbolId     ' ID OOO �������
    Dim eInomValue_str  ' ��������� �������� �������� "�� E_Inom" (��������)
    Dim eInomValue_num  ' �������� �������� �������� "�� E_Inom"
    Dim isEInomValueValid ' ���� ��� �������� ���������� ��������������
    
    Dim targetDeviceName_QF ' ��������� ��� QF ����������
    Dim allDeviceIds()      ' ������ ID ���� ���������
    Dim allDeviceCount      ' ���������� ���� ���������
    Dim i                   ' ������� �����

    ' ����� ���������� ��� ������ ����������
    Dim componentName_to_set ' ��� ����������, ������� ����� ����������
    Dim rangeValues          ' ������ � ���/���� ���������� ��� �������� ���������� �� �������
    Dim foundMatchingComponent ' ����, �����������, ������ �� ���������� ���������
    Dim componentName_key    ' ���������� ��� �������� ������ �������

    ' ��������� ��� ������ ����������
    Const COMPONENT_VERSION = "1" ' ������ ����������

    ' ���������, ���� �� ������� OOO ������� �� ���������� ����
    If global_foundOOOIds.Count = 0 Then
        e3App.PutInfo 0, "COMM: ��� ��������������� OOO �������� (D_Proizv3=3, 4 ��� 8) ��� ���������� ����������� QF."
        Exit Sub
    End If

    Set symbolObj = job.CreateSymbolObject()
    Set deviceObj = job.CreateDeviceObject()

    e3App.PutInfo 0, "=== ������ ���������� ����������� -QF �� ������ �������� '�� E_Inom' OOO �������� ==="

    ' ���������, ��� ������� ������������ ����������� QF �� ����
    If qfComponentMap.Count = 0 Then
        e3App.PutInfo 0, "������: ������� ������������ ����������� QF ����. ���������� �������� ���������� QF."
        Exit Sub
    End If

    ' �������� ������ ���� ��������� � ������� ���� ��� ��� �������������
    allDeviceCount = job.GetAllDeviceIds(allDeviceIds)

    ' ���������� ������ ��������������� OOO ������
    For Each oooIndex_str In global_foundOOOIds.Keys
        oooSymbolId = global_foundOOOIds.Item(oooIndex_str)
        
        ' ������������� OOO ������ ��� ������ ��������
        symbolObj.SetId(oooSymbolId)
        
        ' ��������� ������� ������ ��� ��������� � �������������� �������� E_Inom
        eInomValue_str = CStr(symbolObj.GetAttributeValue("�� E_Inom"))    

        e3App.PutInfo 0, "  ��������� OOO" & oooIndex_str & " (ID: " & oooSymbolId & ") ��� QF"
        e3App.PutInfo 0, "    �������� ������� '�� E_Inom': '" & eInomValue_str & "'"
        e3App.PutInfo 0, "    ������� '�� E_Inom' ����� Trim(): '" & Trim(eInomValue_str) & "'"

        isEInomValueValid = False ' ���������� ������� ����������
        
        Dim trimmedEInomValue_str : trimmedEInomValue_str = Trim(eInomValue_str)

        If IsNumeric(trimmedEInomValue_str) And Len(trimmedEInomValue_str) > 0 Then
            On Error Resume Next ' �������� ��������� ������ ��� CDbl
            eInomValue_num = CDbl(trimmedEInomValue_str)
            If Err.Number = 0 Then
                isEInomValueValid = True ' �������������� �������
                e3App.PutInfo 0, "    �������: ��������������� �������� �������� '�� E_Inom': " & eInomValue_num
            Else
                e3App.PutInfo 0, "    ������: CDbl �� ������� ������������� ������ '" & trimmedEInomValue_str & "' � ����� (Err: " & Err.Description & ")"
                Err.Clear ' ������� ������
            End If
            On Error GoTo 0 ' ��������� ��������� ������
        Else
            e3App.PutInfo 0, "    ��������: ������� '�� E_Inom' ('" & eInomValue_str & "') ���� ��� �� �������� ������. ���������� ���������� QF."
        End If

        ' ������ ���� �������������� ������ �������, ���� ���������� ���������
        If isEInomValueValid Then
            foundMatchingComponent = False
            componentName_to_set = "" ' ���������� ��� ������� OOO �������

            ' ���������� ������� QF � ������� ����������� ���������
            For Each componentName_key In qfComponentMap.Keys
                rangeValues = qfComponentMap.Item(componentName_key) ' �������� ������ [min, max]
                
                If eInomValue_num >= rangeValues(0) And eInomValue_num <= rangeValues(1) Then
                    componentName_to_set = componentName_key ' ����� ���������� ��� ����������
                    foundMatchingComponent = True
                    e3App.PutInfo 0, "    ������� ���������� ��� ���������� QF: '" & componentName_to_set & "' ��� �������� " & eInomValue_num
                    Exit For ' ������� �� �����, ��� ��� ����� ������ ����������
                End If
            Next

            If foundMatchingComponent Then
                e3App.PutInfo 0, "    ����� ��������� -QF ��������� ��� ���������� ���������� ��: '" & componentName_to_set & "'..."
                
                targetDeviceName_QF = "-QF" & oooIndex_str
                Dim qfUpdatedCount : qfUpdatedCount = 0    

                For i = 1 To allDeviceCount
                    deviceObj.SetId(allDeviceIds(i))
                    Dim currentDeviceName : currentDeviceName = deviceObj.GetName()
                    Dim currentComponentName : currentComponentName = deviceObj.GetComponentName()

                    If UCase(currentDeviceName) = UCase(targetDeviceName_QF) Then
                        ' �������������� ��������, ��� ��������� QF �������� "�������"
                        If InStr(1, LCase(currentComponentName), "�������") > 0 Then
                            e3App.PutInfo 0, "      ������� -QF ���������� ��� ����������: '" & currentDeviceName & "'" & _
                                             " (ID: " & allDeviceIds(i) & ", ������� ���������: '" & currentComponentName & "')"
                            
                            On Error Resume Next ' �������� ��������� ������ ��� SetComponentName
                            deviceObj.SetComponentName componentName_to_set, COMPONENT_VERSION
                            If Err.Number = 0 Then
                                qfUpdatedCount = qfUpdatedCount + 1
                                e3App.PutInfo 0, "        �������: ��������� QF �������� ��: '" & componentName_to_set & "' (������: '" & COMPONENT_VERSION & "')."
                            Else
                                e3App.PutInfo 0, "        ������ ��� ���������� ���������� QF ��� '" & currentDeviceName & "': " & Err.Description
                                Err.Clear ' ������� ������
                            End If
                            On Error GoTo 0 ' ��������� ��������� ������
                        Else
                            e3App.PutInfo 0, "      ������o -QF ����������: '" & currentDeviceName & "' (ID: " & allDeviceIds(i) & "), �� ��� ��������� ('" & currentComponentName & "') �� �������� '�������'. ��������� ����������."
                        End If
                    End If
                Next
                
                If qfUpdatedCount = 0 Then
                    e3App.PutInfo 0, "    ��� OOO" & oooIndex_str & " �� ������� �� ������ -QF ���������� � ����������� '�������' ��� ����������."
                Else
                    e3App.PutInfo 0, "    ����� ��������� " & qfUpdatedCount & " -QF ��������� ��� OOO" & oooIndex_str & "."
                End If
            Else
                e3App.PutInfo 0, "    ��������: ��� �������� '�� E_Inom' (" & eInomValue_num & ") �� ������� ����������� ���������� � ������� ������������ QF. ���������� ���������."
            End If
        End If    
    Next ' ���������� � ���������� OOO �������

    e3App.PutInfo 0, "=== ���������� ���������� ����������� -QF ==="

    Set symbolObj = Nothing ' ����������� ������ Symbol
    Set deviceObj = Nothing ' ����������� ������ Device
End Sub

' ����� ���������: ��� ���������� ���������� KM �� ������ �������� OOO ������� ---
Sub UpdateKMComponentsBasedOnOOOAttribute()
    Dim symbolObj       ' ������ Symbol ��� ������ ��������� OOO
    Dim deviceObj       ' ������ Device ��� ���������� ����������� KM
    Dim oooIndex_str    ' ��������� ������������� ��������� ������� OOO �������
    Dim oooSymbolId     ' ID OOO �������
    Dim eInomValue_str  ' ��������� �������� �������� "�� E_Inom" (��������)
    Dim eInomValue_num  ' �������� �������� �������� "�� E_Inom"
    Dim isEInomValueValid ' ���� ��� �������� ���������� ��������������
    
    Dim targetDeviceName_KM ' ��������� ��� KM ����������
    Dim allDeviceIds()      ' ������ ID ���� ���������
    Dim allDeviceCount      ' ���������� ���� ���������
    Dim i                   ' ������� �����

    Dim componentName_to_set_km ' ��� ���������� KM, ������� ����� ����������
    Dim rangeValues_km          ' ������ � ���/���� ���������� ��� �������� KM ���������� �� �������
    Dim foundMatchingComponent_km ' ����, �����������, ������ �� ���������� KM ���������
    Dim componentName_key_km    ' ���������� ��� �������� ������ ������� KM

    Const COMPONENT_VERSION = "1" ' ������ ����������

    If global_foundOOOIds.Count = 0 Then
        e3App.PutInfo 0, "COMM: ��� ��������������� OOO �������� (D_Proizv3=3, 4 ��� 8) ��� ���������� ����������� KM."
        Exit Sub
    End If

    Set symbolObj = job.CreateSymbolObject()
    Set deviceObj = job.CreateDeviceObject()

    e3App.PutInfo 0, "=== ������ ���������� ����������� -KM �� ������ �������� '�� E_Inom' OOO �������� ==="

    If kmComponentMap.Count = 0 Then
        e3App.PutInfo 0, "������: ������� ������������ ����������� KM ����. ���������� �������� ���������� KM."
        Exit Sub
    End If

    allDeviceCount = job.GetAllDeviceIds(allDeviceIds)

    For Each oooIndex_str In global_foundOOOIds.Keys
        oooSymbolId = global_foundOOOIds.Item(oooIndex_str)
        
        symbolObj.SetId(oooSymbolId)
        eInomValue_str = CStr(symbolObj.GetAttributeValue("�� E_Inom"))    

        e3App.PutInfo 0, "  ��������� OOO" & oooIndex_str & " (ID: " & oooSymbolId & ") ��� KM"
        e3App.PutInfo 0, "    �������� ������� '�� E_Inom': '" & eInomValue_str & "'"

        isEInomValueValid = False
        Dim trimmedEInomValue_str_km : trimmedEInomValue_str_km = Trim(eInomValue_str)

        If IsNumeric(trimmedEInomValue_str_km) And Len(trimmedEInomValue_str_km) > 0 Then
            On Error Resume Next
            eInomValue_num = CDbl(trimmedEInomValue_str_km)
            If Err.Number = 0 Then
                isEInomValueValid = True
                e3App.PutInfo 0, "    �������: ��������������� �������� �������� '�� E_Inom': " & eInomValue_num
            Else
                e3App.PutInfo 0, "    ������: CDbl �� ������� ������������� ������ '" & trimmedEInomValue_str_km & "' � ����� (Err: " & Err.Description & ")"
                Err.Clear
            End If
            On Error GoTo 0
        Else
            e3App.PutInfo 0, "    ��������: ������� '�� E_Inom' ('" & eInomValue_str & "') ���� ��� �� �������� ������. ���������� ���������� KM."
        End If

        If isEInomValueValid Then
            foundMatchingComponent_km = False
            componentName_to_set_km = ""

            For Each componentName_key_km In kmComponentMap.Keys
                rangeValues_km = kmComponentMap.Item(componentName_key_km)
                
                If eInomValue_num >= rangeValues_km(0) And eInomValue_num <= rangeValues_km(1) Then
                    componentName_to_set_km = componentName_key_km
                    foundMatchingComponent_km = True
                    e3App.PutInfo 0, "    ������� ���������� ��� ���������� KM: '" & componentName_to_set_km & "' ��� �������� " & eInomValue_num
                    Exit For
                End If
            Next

            If foundMatchingComponent_km Then
                e3App.PutInfo 0, "    ����� ��������� -KM ��������� ��� ���������� ���������� ��: '" & componentName_to_set_km & "'..."
                
                targetDeviceName_KM = "-KM" & oooIndex_str
                Dim kmUpdatedCount : kmUpdatedCount = 0    

                For i = 1 To allDeviceCount
                    deviceObj.SetId(allDeviceIds(i))
                    Dim currentDeviceName : currentDeviceName = deviceObj.GetName()

                    If UCase(currentDeviceName) = UCase(targetDeviceName_KM) Then
                        e3App.PutInfo 0, "      ������� -KM ���������� ��� ����������: '" & currentDeviceName & "'" & _
                                         " (ID: " & allDeviceIds(i) & ", ������� ���������: '" & deviceObj.GetComponentName() & "')"
                        
                        On Error Resume Next
                        deviceObj.SetComponentName componentName_to_set_km, COMPONENT_VERSION
                        If Err.Number = 0 Then
                            kmUpdatedCount = kmUpdatedCount + 1
                            e3App.PutInfo 0, "        �������: ��������� KM �������� ��: '" & componentName_to_set_km & "' (������: '" & COMPONENT_VERSION & "')."
                        Else
                            e3App.PutInfo 0, "        ������ ��� ���������� ���������� KM ��� '" & currentDeviceName & "': " & Err.Description
                            Err.Clear
                        End If
                        On Error GoTo 0
                    End If
                Next
                
                If kmUpdatedCount = 0 Then
                    e3App.PutInfo 0, "    ��� OOO" & oooIndex_str & " �� ������� �� ������ -KM ���������� ��� ����������."
                Else
                    e3App.PutInfo 0, "    ����� ��������� " & kmUpdatedCount & " -KM ��������� ��� OOO" & oooIndex_str & "."
                End If
            Else
                e3App.PutInfo 0, "    ��������: ��� �������� '�� E_Inom' (" & eInomValue_num & ") �� ������� ����������� ���������� � ������� ������������ KM. ���������� ���������."
            End If
        End If    
    Next

    e3App.PutInfo 0, "=== ���������� ���������� ����������� -KM ==="

    Set symbolObj = Nothing
    Set deviceObj = Nothing
End Sub


' --- ��������������� ��������� ��� ������� ���������� �������� ---
Sub CleanUpGlobalObjects()
    ' ���������, ��� ������� ����������, ������ ��� �� �����������
    If Not job Is Nothing Then
        Set job = Nothing
    End If
    If Not e3App Is Nothing Then
        Set e3App = Nothing
    End If
    If Not global_foundOOOIds Is Nothing Then
        Set global_foundOOOIds = Nothing
    End If
    If Not qfComponentMap Is Nothing Then
        Set qfComponentMap = Nothing
    End If
    ' �����: ����������� ������ kmComponentMap
    If Not kmComponentMap Is Nothing Then
        Set kmComponentMap = Nothing
    End If
End Sub

' --- ����� ����� � ������: ��������� �������� ��������� ---
Call Main()