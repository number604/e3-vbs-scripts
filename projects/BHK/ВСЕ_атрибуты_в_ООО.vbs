'*******************************************************************************
' �������� �������: E3_QF_TechDescUpdater_V_Devices
' �����: E3.series VBScript Assistant
' ����: 08.07.2025
' ��������: ���������� �������� ��������� � ���. ������ ��� �������������� ������ �������� � ������� "���. �������� 3"
'           ��� ��������� QF, �������� ��, � ���������� ������� ���������� "���".
'           ��������� ��������� ��������� � ��������� -V � ������ �� ����� ����������
'           � ������� "�� D_Proizv2" ���������������� ������� OOO.
'*******************************************************************************

Option Explicit

' === ������� === ���������� ������ �� ����� �������/����������
Function ExtractNumber(ByVal itemName)
    Dim re, matches
    Set re = New RegExp
    ' ���� ����� � ����� ������ ����� �������� (��������, OOO1, -QF1, -KM1, -KL1, -V1)
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

' === ������� === ���������� �������� "kA" �� ������
Function ExtractkAValue(ByVal inputText)
    Dim re, matches
    Set re = New RegExp
    ' ���������� ��������� ��� ������ �����, �� �������� ����� ������� "kA"
    re.Pattern = "\b(\d+kA)\b" 
    re.IgnoreCase = True
    re.Global = False
    
    Set matches = re.Execute(inputText)
    
    If matches.Count > 0 Then
        ExtractkAValue = matches.Item(0).SubMatches.Item(0)
    Else
        ExtractkAValue = ""
    End If
    
    Set re = Nothing
End Function

' === ������� === ��������� �������� �������� �� E_Inom �� ������� OOO
Function GetOOOAttributeEInom(ByVal e3AppObj, ByVal jobObj, ByVal oooSymbolId)
    Dim symbol, attributeValue
    
    Set symbol = jobObj.CreateSymbolObject()
    
    symbol.SetId(oooSymbolId)
    attributeValue = symbol.GetAttributeValue("�� E_Inom")
    
    GetOOOAttributeEInom = attributeValue
    
    Set symbol = Nothing
End Function

' === ��������� === ������ �������� � ������� "���. �������� 3" QF ����������
' �������������� ��� ���������� ��������� � "���" � ����� ����������.
Sub WriteToQFDeviceTechDesc3(ByVal e3AppObj, ByVal jobObj, ByVal deviceId, ByVal value)
    Dim device
    Dim componentName
    
    Set device = jobObj.CreateDeviceObject()
    
    device.SetId(deviceId)
    
    ' �������� ��� ���������� ��� ��������
    componentName = device.GetComponentName()
    
    ' ���������, �� �������� �� ��� ���������� "���"
    If InStr(1, LCase(componentName), "���") = 0 Then
        device.SetAttributeValue "���. �������� 3", value
        e3AppObj.PutInfo 0, "�������� � QF ���������� (ID: " & deviceId & ", ���������: " & componentName & ") ���. �������� 3: " & value
    Else
        e3AppObj.PutInfo 0, "��������� QF ���������� (ID: " & deviceId & ", ���������: " & componentName & "): �������� '���' � ����� ����������."
    End If
    
    Set device = Nothing
End Sub

' === ��������� === ����� ���� �������� OOO � �������
Sub FindAllOOOSymbols(ByVal e3AppObj, ByVal jobObj, ByRef oooSymbols)
    Dim symbol
    Dim symbolIds(), symbolCount
    Dim i, symbolName, symbolNumber
    
    Set symbol = jobObj.CreateSymbolObject()
    
    e3AppObj.PutInfo 0, "=== ����� ���� �������� OOO � ������� ==="
    
    symbolCount = jobObj.GetSymbolIds(symbolIds)
    If symbolCount = 0 Then
        e3AppObj.PutInfo 0, "� ������� �� ������� ��������."
        Set symbol = Nothing
        Exit Sub
    End If
    
    For i = 1 To symbolCount
        symbol.SetId(symbolIds(i))
        symbolName = symbol.GetName()
        
        If LCase(Left(symbolName, 3)) = "ooo" Then
            symbolNumber = ExtractNumber(symbolName)
            If symbolNumber > 0 Then
                oooSymbols.Add symbolNumber, symbolIds(i)
                e3AppObj.PutInfo 0, "������ ������ OOO: " & symbolName & " (�����: " & symbolNumber & ", ID: " & symbolIds(i) & ")"
            Else
                e3AppObj.PutInfo 0, "������ OOO ������, �� ����� �� ���������: " & symbolName
            End If
        End If
    Next
    
    e3AppObj.PutInfo 0, "����� ������� �������� OOO � ��������: " & oooSymbols.Count
    
    Set symbol = Nothing
End Sub

' === ��������� === ����� ���� ��������� QF, KM, KL, V � �������
Sub FindAllDevices(ByVal e3AppObj, ByVal jobObj, ByRef qfDevices, ByRef kmDevices, ByRef klDevices, ByRef vDevices)
    Dim device
    Dim deviceIds(), deviceCount
    Dim i, deviceName, deviceNumber
    
    Set device = jobObj.CreateDeviceObject()
    
    e3AppObj.PutInfo 0, "=== ����� ���� ��������� QF, KM, KL, V � ������� ==="
    
    deviceCount = jobObj.GetAllDeviceIds(deviceIds)
    If deviceCount = 0 Then
        e3AppObj.PutInfo 0, "� ������� �� ������� ���������."
        Set device = Nothing
        Exit Sub
    End If
    
    For i = 1 To deviceCount
        device.SetId(deviceIds(i))
        deviceName = device.GetName()
        
        ' ����� ��������� QF
        If InStr(1, LCase(deviceName), "-qf") > 0 Then
            deviceNumber = ExtractNumber(deviceName)
            If deviceNumber > 0 Then
                If Not qfDevices.Exists(deviceNumber) Then
                    qfDevices.Add deviceNumber, CreateObject("Scripting.Dictionary")
                End If
                qfDevices.Item(deviceNumber).Add CStr(deviceIds(i)), deviceName
                e3AppObj.PutInfo 0, "������� QF ����������: " & deviceName & " (�����: " & deviceNumber & ", ID: " & deviceIds(i) & ")"
            End If
        End If
        
        ' ����� ��������� KM
        If InStr(1, LCase(deviceName), "-km") > 0 Then
            deviceNumber = ExtractNumber(deviceName)
            If deviceNumber > 0 Then
                If Not kmDevices.Exists(deviceNumber) Then
                    kmDevices.Add deviceNumber, CreateObject("Scripting.Dictionary")
                End If
                kmDevices.Item(deviceNumber).Add CStr(deviceIds(i)), deviceName
                e3AppObj.PutInfo 0, "������� KM ����������: " & deviceName & " (�����: " & deviceNumber & ", ID: " & deviceIds(i) & ")"
            End If
        End If
        
        ' ����� ��������� KL
        If InStr(1, LCase(deviceName), "-kl") > 0 Then
            deviceNumber = ExtractNumber(deviceName)
            If deviceNumber > 0 Then
                If Not klDevices.Exists(deviceNumber) Then
                    klDevices.Add deviceNumber, CreateObject("Scripting.Dictionary")
                End If
                klDevices.Item(deviceNumber).Add CStr(deviceIds(i)), deviceName
                e3AppObj.PutInfo 0, "������� KL ����������: " & deviceName & " (�����: " & deviceNumber & ", ID: " & deviceIds(i) & ")"
            End If
        End If

        ' ����� ��������� V
        If InStr(1, LCase(deviceName), "-v") > 0 Then
            deviceNumber = ExtractNumber(deviceName)
            If deviceNumber > 0 Then
                If Not vDevices.Exists(deviceNumber) Then
                    vDevices.Add deviceNumber, CreateObject("Scripting.Dictionary")
                End If
                vDevices.Item(deviceNumber).Add CStr(deviceIds(i)), deviceName
                e3AppObj.PutInfo 0, "������� V ����������: " & deviceName & " (�����: " & deviceNumber & ", ID: " & deviceIds(i) & ")"
            End If
        End If
    Next
    
    e3AppObj.PutInfo 0, "������� QF ��������� � ��������: " & qfDevices.Count
    e3AppObj.PutInfo 0, "������� KM ��������� � ��������: " & kmDevices.Count
    e3AppObj.PutInfo 0, "������� KL ��������� � ��������: " & klDevices.Count
    e3AppObj.PutInfo 0, "������� V ��������� � ��������: " & vDevices.Count
    
    Set device = Nothing
End Sub

' === ��������� === ��������� ��������� ����������
' �������������� ��� �������� ����� ����������
Sub GetDeviceAttributes(ByVal jobObj, ByVal deviceId, ByRef techDesc, ByRef compTitle, ByRef compSupplier, ByRef compCurrent, ByRef compName)
    Dim device
    
    Set device = jobObj.CreateDeviceObject()
    
    device.SetId(deviceId)
    
    ' techDesc ������������ ������ ��� QF "���. �������� 1"
    If Not IsEmpty(techDesc) Then techDesc = device.GetAttributeValue("���. �������� 1")
    
    ' compTitle ������������ ��� QF, KM, KL, V "������������"
    If Not IsEmpty(compTitle) Then compTitle = device.GetComponentAttributeValue("������������")
    
    ' compSupplier ������������ ������ ��� QF, KM "���������"
    If Not IsEmpty(compSupplier) Then compSupplier = device.GetComponentAttributeValue("���������")
    
    ' compCurrent ������������ ������ ��� KM "(�����) ���"
    If Not IsEmpty(compCurrent) Then compCurrent = device.GetComponentAttributeValue("(�����) ���")
    
    ' compName ������������ ��� ����, ����� �������� ��� ����������
    compName = device.GetComponentName()
    
    Set device = Nothing
End Sub

' === ��������� === ������ ��������� � ������ OOO
Sub WriteAttributesToOOOSymbol(ByVal e3AppObj, ByVal jobObj, ByVal oooSymbolId, ByVal number, _
                                 ByVal qfTechDesc, ByVal qfCompTitle, ByVal qfCompSupplier, ByVal qfContactCompName, _
                                 ByVal kmCompTitle, ByVal kmCompSupplier, ByVal kmCompCurrent, _
                                 ByVal klCompTitle, ByVal vCompName)
    Dim symbol
    
    Set symbol = jobObj.CreateSymbolObject()
    
    symbol.SetId(oooSymbolId)
    
    e3AppObj.PutInfo 0, "=== ������ ��������� � ������ OOO" & number & " ==="
    
    ' �������� �� QF ����������
    If Len("" & qfTechDesc) > 0 Then
        symbol.SetAttributeValue "�� V_Inom", qfTechDesc
        e3AppObj.PutInfo 0, "�������� � �� V_Inom: " & qfTechDesc
    End If
    
    If Len("" & qfCompTitle) > 0 Then
        symbol.SetAttributeValue "�� V_Type", qfCompTitle
        e3AppObj.PutInfo 0, "�������� � �� V_Type: " & qfCompTitle
        
        ' ���������� � ������ �������� "kA"
        Dim extractedkAValue
        extractedkAValue = ExtractkAValue(qfCompTitle)
        If Len("" & extractedkAValue) > 0 Then
            symbol.SetAttributeValue "�� V_Icu", extractedkAValue
            e3AppObj.PutInfo 0, "�������� � �� V_Icu: " & extractedkAValue
        End If
    End If
    
    If Len("" & qfCompSupplier) > 0 Then
        symbol.SetAttributeValue "�� V_Proizv", qfCompSupplier
        e3AppObj.PutInfo 0, "�������� � �� V_Proizv: " & qfCompSupplier
    End If
    
    If Len("" & qfContactCompName) > 0 Then
        symbol.SetAttributeValue "�� V_Dop ystr", qfContactCompName
        e3AppObj.PutInfo 0, "�������� � �� V_Dop ystr: " & qfContactCompName
    End If
    
    ' �������� �� KM ����������
    If Len("" & kmCompTitle) > 0 Then
        symbol.SetAttributeValue "�� K_Type", kmCompTitle
        e3AppObj.PutInfo 0, "�������� � �� K_Type: " & kmCompTitle
    End If
    
    If Len("" & kmCompSupplier) > 0 Then
        symbol.SetAttributeValue "�� K_Proizv", kmCompSupplier
        e3AppObj.PutInfo 0, "�������� � �� K_Proizv: " & kmCompSupplier
    End If
    
    If Len("" & kmCompCurrent) > 0 Then
        symbol.SetAttributeValue "�� K_Inom", kmCompCurrent
        e3AppObj.PutInfo 0, "�������� � �� K_Inom: " & kmCompCurrent
    End If
    
    ' �������� �� KL ����������
    If Len("" & klCompTitle) > 0 Then
        symbol.SetAttributeValue "�� D_Proizv1", klCompTitle
        e3AppObj.PutInfo 0, "�������� � �� D_Proizv1: " & klCompTitle
    End If

    ' �������� �� V ���������� (����� ����������������)
    If Len("" & vCompName) > 0 Then
        symbol.SetAttributeValue "�� D_Proizv2", vCompName
        e3AppObj.PutInfo 0, "�������� � �� D_Proizv2: " & vCompName
    End If
    
    Set symbol = Nothing
End Sub

' === �������� ��������� === ��������� ���� �������� OOO � ���������
Sub ProcessAllOOOSymbolsAndDevices()
    Dim e3App, job ' ������� ������� ���� ���
    Dim oooSymbols, qfDevices, kmDevices, klDevices, vDevices ' �������� vDevices
    Dim oooNumber, oooSymbolId
    Dim qfTechDesc, qfCompTitle, qfCompSupplier, qfContactCompName
    Dim kmCompTitle, kmCompSupplier, kmCompCurrent
    Dim klCompTitle
    Dim vCompName ' ����� ���������� ��� ����� ���������� V ����������
    Dim qfAutomatDeviceId, qfContactDeviceId, kmContactorDeviceId, klDeviceId, vDeviceId
    Dim deviceId, deviceName, componentName
    Dim key
    Dim oooEInomValue ' ���������� ��� �������� �� E_Inom
    
    Set e3App = CreateObject("CT.Application")
    Set job = e3App.CreateJobObject() ' ������� JobObject ���� ���
    
    Set oooSymbols = CreateObject("Scripting.Dictionary")
    Set qfDevices = CreateObject("Scripting.Dictionary")
    Set kmDevices = CreateObject("Scripting.Dictionary")
    Set klDevices = CreateObject("Scripting.Dictionary")
    Set vDevices = CreateObject("Scripting.Dictionary") ' ������������� ������ �������
    
    e3App.PutInfo 0, "=== ����� ��������� ���� OOO �������� � ��������� ==="
    
    ' ������� ��� ������� OOO � ����������, ��������� e3App � job
    Call FindAllOOOSymbols(e3App, job, oooSymbols)
    Call FindAllDevices(e3App, job, qfDevices, kmDevices, klDevices, vDevices) ' �������� vDevices
    
    ' ������������ ������ ������ OOO
    For Each oooNumber In oooSymbols.Keys
        oooSymbolId = oooSymbols.Item(oooNumber)
        
        e3App.PutInfo 0, "--- ��������� OOO" & oooNumber & " ---"
        
        ' �������� �������� �� E_Inom �� �������� ������� OOO
        oooEInomValue = GetOOOAttributeEInom(e3App, job, oooSymbolId) ' �������� e3App � job
        e3App.PutInfo 0, "�������� �������� �� E_Inom �� OOO" & oooNumber & ": " & oooEInomValue
        
        ' ����� ���������� ��� �������� ������
        qfTechDesc = ""
        qfCompTitle = ""
        qfCompSupplier = ""
        qfContactCompName = ""
        kmCompTitle = ""
        kmCompSupplier = ""
        kmCompCurrent = ""
        klCompTitle = ""
        vCompName = "" ' ����� ��� V ����������
        
        qfAutomatDeviceId = 0
        qfContactDeviceId = 0
        kmContactorDeviceId = 0
        klDeviceId = 0
        vDeviceId = 0 ' ����� ��� V ����������
        
        ' ����� ��������������� QF ���������
        If qfDevices.Exists(oooNumber) Then
            For Each key In qfDevices.Item(oooNumber).Keys
                deviceId = CLng(key)
                deviceName = qfDevices.Item(oooNumber).Item(key)
                
                ' �������� ��������, ������� ��� ����������, ��� �������� QF ����������
                ' techDesc, compTitle, compSupplier ����� ������������, ���� ��������� QF
                Call GetDeviceAttributes(job, deviceId, qfTechDesc, qfCompTitle, qfCompSupplier, Empty, componentName) ' �������� job
                
                ' ����� ����������������: ������ �� E_Inom � ���. �������� 3 ��� ���� QF ��������� � ������ �������,
                ' ���� � ����� ���������� ��� "���"
                If Len("" & oooEInomValue) > 0 Then
                    ' �������� ����� ���������, ������� �������� �������� �� "���"
                    Call WriteToQFDeviceTechDesc3(e3App, job, deviceId, oooEInomValue) ' �������� e3App � job
                End If

                If InStr(1, LCase(componentName), "�������") > 0 Then
                    qfAutomatDeviceId = deviceId
                    e3App.PutInfo 0, "������ QF �������" & oooNumber & ": " & deviceName
                ElseIf InStr(1, LCase(componentName), "�������") > 0 Then
                    qfContactDeviceId = deviceId
                    qfContactCompName = qfCompTitle ' ���������� qfCompTitle ��� "�� V_Dop ystr"
                    e3App.PutInfo 0, "������ QF �������" & oooNumber & ": " & deviceName
                End If
                
            Next
        Else
            e3App.PutInfo 0, "QF" & oooNumber & " �� ������"
        End If
        
        ' ����� ��������������� KM ���������
        If kmDevices.Exists(oooNumber) Then
            For Each key In kmDevices.Item(oooNumber).Keys
                deviceId = CLng(key)
                deviceName = kmDevices.Item(oooNumber).Item(key)
                
                ' techDesc �� ����� ��� KM, ������� �������� Empty
                Call GetDeviceAttributes(job, deviceId, Empty, kmCompTitle, kmCompSupplier, kmCompCurrent, componentName) ' �������� job
                
                If InStr(1, LCase(componentName), "���������") > 0 Then
                    kmContactorDeviceId = deviceId
                    e3App.PutInfo 0, "������ KM ���������" & oooNumber & ": " & deviceName
                    Exit For ' ����� ������ ������ ��������� ��������� KM
                End If
            Next
        Else
            e3App.PutInfo 0, "KM" & oooNumber & " �� ������"
        End If
        
        ' ����� ��������������� KL ���������
        If klDevices.Exists(oooNumber) Then
            For Each key In klDevices.Item(oooNumber).Keys
                deviceId = CLng(key)
                deviceName = klDevices.Item(oooNumber).Item(key)
                
                ' techDesc, compSupplier, compCurrent �� ����� ��� KL, ������� �������� Empty
                Call GetDeviceAttributes(job, deviceId, Empty, klCompTitle, Empty, Empty, componentName) ' �������� job
                
                klDeviceId = deviceId
                e3App.PutInfo 0, "������ KL" & oooNumber & ": " & deviceName
                Exit For ' ����� ������ ��������� KL ����������
            Next
        Else
            e3App.PutInfo 0, "KL" & oooNumber & " �� ������"
        End If

        ' ����� ��������������� V ��������� (����� ����������������)
        If vDevices.Exists(oooNumber) Then
            For Each key In vDevices.Item(oooNumber).Keys
                deviceId = CLng(key)
                deviceName = vDevices.Item(oooNumber).Item(key)
                
                ' techDesc, compSupplier, compCurrent �� ����� ��� V, ������� �������� Empty
                Call GetDeviceAttributes(job, deviceId, Empty, Empty, Empty, Empty, vCompName) ' �������� job, �������� ������ compName
                
                vDeviceId = deviceId
                e3App.PutInfo 0, "������ V" & oooNumber & ": " & deviceName
                Exit For ' ����� ������ ��������� V ����������
            Next
        Else
            e3App.PutInfo 0, "V" & oooNumber & " �� ������"
        End If
        
        ' ���������� �������� � ������ OOO (�������� e3App, job � ����� vCompName)
        Call WriteAttributesToOOOSymbol(e3App, job, oooSymbolId, oooNumber, _
                                        qfTechDesc, qfCompTitle, qfCompSupplier, qfContactCompName, _
                                        kmCompTitle, kmCompSupplier, kmCompCurrent, _
                                        klCompTitle, vCompName)
    Next
    
    e3App.PutInfo 0, "=== ���������� ��������� ���� OOO �������� ==="
    
    Set oooSymbols = Nothing
    Set qfDevices = Nothing
    Set kmDevices = Nothing
    Set klDevices = Nothing
    Set vDevices = Nothing ' ����������� ����� �������
    Set job = Nothing ' ����������� JobObject
    Set e3App = Nothing ' ����������� E3.series Application Object
End Sub

' === �������� ������ ===
Dim e3App_main ' ���������� ������ ���, ����� �������� ���������� � ����������� �������

Set e3App_main = CreateObject("CT.Application")

e3App_main.PutInfo 0, "=== ����� ������� E3.SERIES OOO PROCESSOR ==="
Call ProcessAllOOOSymbolsAndDevices()
e3App_main.PutInfo 0, "=== ����� ������� ==="

Set e3App_main = Nothing