Option Explicit

' === ��������� 1 === ����� ��������� �� ���������� ��������
' ��� ��������� � �������� ������������ ��� ����������� ������� ������� OOO
' � ��� ������ ��������������� ���������� � ���������� ��������.
Sub FindDevicesBySelectedSymbols(foundDevices, ByRef hasOOOSymbol)
    Dim e3App, job, device, symbol
    Dim selectedSymbolIds(), selectedCount
    Dim deviceIds(), deviceCount
    Dim symbolIds(), result
    Dim selectedSymbolId, symbolRealId, currentSymbolId
    Dim foundDeviceId, symbolName
    Dim i, j, s

    Set e3App = CreateObject("CT.Application")
    Set job = e3App.CreateJobObject()
    Set device = job.CreateDeviceObject()
    Set symbol = job.CreateSymbolObject()

    hasOOOSymbol = False ' �������������� ���� OOO �������

    selectedCount = job.GetSelectedSymbolIds(selectedSymbolIds)
    If selectedCount = 0 Then
        e3App.PutInfo 0, "��� ���������� �������� �� �����."
        ' � ���� ������ ������ ��������� ������, ����� ��������� ����� QF/QS � KM,
        ' �� OOO ������ �� ����� ������, � �������� �� ����� ��������.
    Else
        e3App.PutInfo 0, "=== ��������� ���������� �������� ==="
        For s = 1 To selectedCount
            selectedSymbolId = selectedSymbolIds(s)
            symbol.SetId(selectedSymbolId)
            symbolRealId = symbol.GetId()
            symbolName = symbol.GetName()

            If LCase(Left(symbolName, 3)) = "ooo" Then
                e3App.PutInfo 0, "������ OOO: " & symbolName & " (ID: " & symbolRealId & ") � ������."
                hasOOOSymbol = True ' ������������� ����
            Else
                ' ����� ������ ������ ���������� �� ������� ��������� ��� ��������������� �����,
                ' �� ��� ������ QF/QS � KM ��������� ����� �������������� ������ ���� ������������.
                foundDeviceId = 0
                deviceCount = job.GetAllDeviceIds(deviceIds) ' �������� ��� ���������� ��� ������ ��������

                If deviceCount > 0 Then
                    For i = 1 To deviceCount
                        device.SetId(deviceIds(i))
                        result = device.GetSymbolIds(symbolIds, 3) ' �������� �������, ��������� � �����������

                        If result > 0 Then
                            For j = 1 To result
                                symbol.SetId(symbolIds(j))
                                currentSymbolId = symbol.GetId()

                                If currentSymbolId = symbolRealId Then
                                    foundDeviceId = deviceIds(i)
                                    Exit For ' ������ ������ ��� ����� ����������
                                    End If
                            Next
                        End If
                        If foundDeviceId <> 0 Then Exit For ' ���������� ������� ��� �������� �������
                    Next
                End If ' ����������� If ��� If deviceCount > 0 Then

                If foundDeviceId <> 0 Then
                    If Not foundDevices.Exists(CStr(foundDeviceId)) Then
                        device.SetId(foundDeviceId)
                        e3App.PutInfo 0, "������� ���������� ��� �������: " & device.GetName() & " (ID: " & foundDeviceId & ")"
                        foundDevices.Add CStr(foundDeviceId), True ' ��������� � ��������� ��������� ���������
                    End If
                Else
                    e3App.PutInfo 0, "���������� ��� ������� '" & symbolName & "' (ID: " & symbolRealId & ") �� �������."
                End If
            End If
        Next
        e3App.PutInfo 0, "=== ���������� ��������� ���������� �������� ==="
    End If
    
    e3App.PutInfo 0, "=== ����� ������� ��������� �� ���������� ��������: " & foundDevices.Count & " ==="
    e3App.PutInfo 0, "=== ������ OOO ������: " & hasOOOSymbol & " ==="

    Set symbol = Nothing
    Set device = Nothing
    Set job = Nothing
    Set e3App = Nothing
End Sub

' === ��������� 2 === �������� ��������� ��������� ��������� ��������� (QF/SF � KM)
Sub ProcessAndWriteDeviceAttributes(hasOOOSymbol)
    Dim e3App, job, device
    Dim deviceIds(), deviceCount ' ���������� ��� ���� ��������� � �������
    Dim i
    Dim userDeviceName ' ���������� ��� ����� ������������ (����� �������� ��� QF/SF � KM)
    Dim currentComponentName ' ��� ���������� �������� ����� ���������� ��� ��������
    Dim key ' ���������� ���������� key
    Dim deviceName ' ���������� ���������� deviceName

    ' --- ���������� ��� ��������� ���������� QF/SF "�������" ---
    Dim selectedAutomatDeviceId : selectedAutomatDeviceId = 0
    Dim automatTechDesc : automatTechDesc = ""
    Dim automatCompTitle : automatCompTitle = ""
    Dim automatCompSupplier : automatCompSupplier = ""

    ' --- ���������� ��� ��������� ���������� QF/SF "�������" ---
    Dim selectedContactDeviceId : selectedContactDeviceId = 0
    Dim contactCompName : contactCompName = ""

    ' --- ���������� ��� ��������� ���������� KM "���������" ---
    Dim selectedContactorDeviceId : selectedContactorDeviceId = 0
    Dim kmCompTitle : kmCompTitle = ""
    Dim kmCompSupplier : kmCompSupplier = ""
    Dim kmCompCurrent : kmCompCurrent = "" ' ��� �������� "(�����) ���"

    ' ���������� ������� ��� �������� ���� ��������� QF/SF � KM ��������� �� �����
    Dim matchingQfDevices
    Set matchingQfDevices = CreateObject("Scripting.Dictionary")
    Dim matchingKmDevices
    Set matchingKmDevices = CreateObject("Scripting.Dictionary")
    
    Set e3App = CreateObject("CT.Application")
    Set job = e3App.CreateJobObject()
    Set device = job.CreateDeviceObject()

    e3App.PutInfo 0, "=== ������ ��������� ��������� ��������� ==="
    
    ' �������� ��� ID ��������� � ������� ���� ���
    deviceCount = job.GetAllDeviceIds(deviceIds)
    If deviceCount = 0 Then
        e3App.PutInfo 0, "������: � ������� ��� ��������� ��� ������. ������ ��������."
        Set device = Nothing
        Set job = Nothing
        Set e3App = Nothing
        Exit Sub
    End If

    ' --- ��������� QF/SF ��������� (�����������) ---
    e3App.PutInfo 0, "--- ��������� ��������� QF/SF ---"
    userDeviceName = InputBox("������� ������ ��� ���������� QF/SF ��� ���������:", "��� ���������� QF/SF", "-QF")

    If Trim(userDeviceName) = "" Then
        e3App.PutInfo 0, "�������� �������� ������������� ��� ��� ���������� QF/SF �� �������. ������� ��������� QF/SF."
    Else
        e3App.PutInfo 0, "���� QF/SF ���������� �� �����: '" & userDeviceName & "' �� ���� �������..."
        For i = 1 To deviceCount
            device.SetId(deviceIds(i))
            deviceName = device.GetName()

            If LCase(deviceName) = LCase(userDeviceName) Then
                matchingQfDevices.Add CStr(deviceIds(i)), deviceName
                e3App.PutInfo 0, "  ������� QF/SF-����������: " & deviceName & " (ID: " & deviceIds(i) & ")"
            End If
        Next

        If matchingQfDevices.Count = 0 Then
            e3App.PutInfo 0, "���������� QF/SF � ������ '" & userDeviceName & "' �� ������� �� ���� �������."
        Else
            e3App.PutInfo 0, "��������� ��������� QF/SF ���������� �� ������� '�������' � '�������' � ����� ����������..."
            
            ' ���� ���������� � ����������� "�������" ����� QF/SF
            For Each key In matchingQfDevices.Keys
                device.SetId CLng(key)
                currentComponentName = device.GetComponentName()
                
                If InStr(1, LCase(currentComponentName), "�������") > 0 Then
                    selectedAutomatDeviceId = CLng(key)
                    automatTechDesc = device.GetAttributeValue("���. �������� 1")
                    automatCompTitle = device.GetComponentAttributeValue("������������")
                    automatCompSupplier = device.GetComponentAttributeValue("���������")
                    e3App.PutInfo 0, "  ������� ��� ��������� (�������): " & device.GetName() & " (ID: " & selectedAutomatDeviceId & ")"
                    ' ����������, ����� ����� "�������"
                End If
            Next

            ' ���� ���������� � ����������� "�������" ����� QF/SF
            For Each key In matchingQfDevices.Keys
                device.SetId CLng(key)
                currentComponentName = device.GetComponentName()

                If InStr(1, LCase(currentComponentName), "�������") > 0 Then
                    selectedContactDeviceId = CLng(key)
                    contactCompName = device.GetComponentAttributeValue("������������")
                    e3App.PutInfo 0, "  ������� ��� ��������� (�������): " & device.GetName() & " (ID: " & selectedContactDeviceId & ") (������������ ����������: '" & contactCompName & "')"
                    ' ����������
                End If
            Next
            
            If selectedAutomatDeviceId = 0 Then
                e3App.PutInfo 0, "  ��������������: ��� QF/SF � ������ '" & userDeviceName & "' ��������� '�������' �� ������."
            End If
            If selectedContactDeviceId = 0 Then
                e3App.PutInfo 0, "  ��������������: ��� QF/SF � ������ '" & userDeviceName & "' ��������� '�������' �� ������."
            End If
        End If
    End If

    ' --- ��������� KM ��������� (�����������) ---
    e3App.PutInfo 0, "--- ��������� ��������� KM ---"
    ' �����: userDeviceName ����������������, ������� �������� �� QF/SF ����� ������������.
    userDeviceName = InputBox("������� ������ ��� ���������� KM ��� ��������� (�������� ������, ���� �� ���):", "��� ���������� KM (�����������)", "-KM")

    If Trim(userDeviceName) = "" Then
        e3App.PutInfo 0, "�������� �������� ������������� ��� ��� ���������� KM �� �������. ������� ��������� KM."
    Else
        e3App.PutInfo 0, "���� KM ���������� �� �����: '" & userDeviceName & "' �� ���� �������..."
        For i = 1 To deviceCount
            device.SetId(deviceIds(i))
            deviceName = device.GetName()
            If LCase(deviceName) = LCase(userDeviceName) Then
                matchingKmDevices.Add CStr(deviceIds(i)), deviceName
                e3App.PutInfo 0, "  ������� KM-����������: " & deviceName & " (ID: " & deviceIds(i) & ")"
            End If
        Next

        If matchingKmDevices.Count = 0 Then
            e3App.PutInfo 0, "���������� KM � ������ '" & userDeviceName & "' �� ������� �� ���� �������."
        Else
            e3App.PutInfo 0, "��������� ��������� KM ���������� �� ������� '���������' � ����� ����������..."
            For Each key In matchingKmDevices.Keys
                device.SetId CLng(key)
                currentComponentName = device.GetComponentName()
                If InStr(1, LCase(currentComponentName), "���������") > 0 Then
                    selectedContactorDeviceId = CLng(key)
                    kmCompTitle = device.GetComponentAttributeValue("������������")
                    kmCompSupplier = device.GetComponentAttributeValue("���������")
                    kmCompCurrent = device.GetComponentAttributeValue("(�����) ���") ' ������ ������� "(�����) ���"
                    e3App.PutInfo 0, "  ������� ��� ��������� (���������): " & device.GetName() & " (ID: " & selectedContactorDeviceId & ")"
                    Exit For ' ����� ������ ��������� ���������� "���������"
                End If
            Next
            If selectedContactorDeviceId = 0 Then
                 e3App.PutInfo 0, "��������������: ����� ��������� KM ��������� � ������ '" & userDeviceName & "' �� ������� �� ������ � �����������, ���������� '���������'."
            End If
        End If
    End If

    ' --- ������ � ������ ��������� � OOO ������ ---
    If hasOOOSymbol Then
        ' �������� ������ ������ ���� ���� ���� �� ��������� ���� ����������
        If (selectedAutomatDeviceId > 0 Or selectedContactDeviceId > 0) Or selectedContactorDeviceId > 0 Then
            e3App.PutInfo 0, "--- ������ ��������� ��������� ��� ������ � OOO ������ ---"
            If selectedAutomatDeviceId > 0 Then
                e3App.PutInfo 0, "  �������� �� QF/SF (�������) ����� ��������."
            Else
                e3App.PutInfo 0, "  �������� QF/SF (�������) ����������� (����� �������)."
            End If
            If selectedContactDeviceId > 0 Then
                e3App.PutInfo 0, "  �������� �� QF/SF (�������) ����� ��������."
            Else
                e3App.PutInfo 0, "  �������� QF/SF (�������) ����������� (����� �������)."
            End If
            If selectedContactorDeviceId > 0 Then
                e3App.PutInfo 0, "  �������� �� KM (���������) ����� ��������."
            Else
                e3App.PutInfo 0, "  �������� KM (���������) ����������� (����� �������)."
            End If
            e3App.PutInfo 0, "-----------------------------------------------------"
            
            Call WriteAttributesToOOOSymbol(automatTechDesc, automatCompTitle, automatCompSupplier, _
                                            contactCompName, _
                                            kmCompTitle, kmCompSupplier, kmCompCurrent)
        Else
            e3App.PutInfo 0, "��������������: �� ������� �� ������ ����������� ���������� (QF/SF �������/������� ��� KM ���������) ��� ������ ��������� � OOO ������."
        End If
    Else
        e3App.PutInfo 0, "������ OOO �� ��� ������ ����� ����������, �������� �� ��������."
    End If

    e3App.PutInfo 0, "=== ���������� ��������� ��������� ��������� ==="

    Set device = Nothing
    Set job = Nothing
    Set e3App = Nothing
    Set matchingQfDevices = Nothing
    Set matchingKmDevices = Nothing
End Sub

' === ������� === ���������� �������� "kA" �� ������
Function ExtractkAValue(ByVal inputText)
    Dim re, matches
    Set re = New RegExp
    ' ���������� ��������� ��� ������ �����, �� �������� ����� ������� "kA" (��������, "10kA", "100kA")
    re.Pattern = "\b(\d+kA)\b" 
    re.IgnoreCase = True ' ������������ ������� ("kA" ��� "KA")
    re.Global = False    ' ����� ������ ������ ����������

    Set matches = re.Execute(inputText)

    If matches.Count > 0 Then
        ExtractkAValue = matches.Item(0).SubMatches.Item(0) ' �������� ����������� ������ (��������, "10kA")
    Else
        ExtractkAValue = "" ' ���� �� �������, ���������� ������ ������
    End If

    Set re = Nothing
End Function

' === ��������� 3 === ������ ��������� QF/SF � KM � ������ OOO
Sub WriteAttributesToOOOSymbol(ByVal automatTechDesc, ByVal automatCompTitle, ByVal automatCompSupplier, _
                               ByVal contactComponentNameForOOO, _
                               ByVal kmCompTitle, ByVal kmCompSupplier, ByVal kmCompCurrent)
    Dim e3App, job, symbol
    Dim selectedSymbolIds(), selectedCount
    Dim selectedSymbolId, symbolName
    Dim s

    Set e3App = CreateObject("CT.Application")
    Set job = e3App.CreateJobObject()
    Set symbol = job.CreateSymbolObject()

    e3App.PutInfo 0, "=== ������ ��������� � ������ OOO ==="

    selectedCount = job.GetSelectedSymbolIds(selectedSymbolIds)
    If selectedCount = 0 Then
        e3App.PutInfo 0, "������: ��� ���������� �������� ��� ������ ��������� � OOO. ��������, ������ OOO ��� ������ ��� �� �������."
        Set symbol = Nothing
        Set job = Nothing
        Set e3App = Nothing
        Exit Sub
    End If
    
    Dim oooSymbolFoundForWriting : oooSymbolFoundForWriting = False

    For s = 1 To selectedCount
        selectedSymbolId = selectedSymbolIds(s)
        symbol.SetId(selectedSymbolId)
        symbolName = symbol.GetName()

        If LCase(Left(symbolName, 3)) = "ooo" Then
            e3App.PutInfo 0, "������ ������ OOO ��� ������: " & symbolName & " (ID: " & selectedSymbolId & ")"
            
            ' --- ���������� �������� �� QF/SF ���������� (�������������� '�������') ---
            If Len("" & automatTechDesc) > 0 Then
                symbol.SetAttributeValue "�� V_Inom", automatTechDesc
                e3App.PutInfo 0, "�������� � �� V_Inom (�� ���. �������� 1 �������� QF/SF): " & automatTechDesc
            Else
                e3App.PutInfo 0, "������� '���. �������� 1' �������� QF/SF ����, ������ ���������� � �� V_Inom."
            End If
            
            If Len("" & automatCompTitle) > 0 Then
                symbol.SetAttributeValue "�� V_Type", automatCompTitle
                e3App.PutInfo 0, "�������� � �� V_Type (�� ������������ ���������� �������� QF/SF): " & automatCompTitle
                
                ' ���������� � ������ �������� "kA"
                Dim extractedkAValue
                extractedkAValue = ExtractkAValue(automatCompTitle) ' ���������� ����� �������
                If Len("" & extractedkAValue) > 0 Then
                    symbol.SetAttributeValue "�� V_Icu", extractedkAValue
                    e3App.PutInfo 0, "�������� � �� V_Icu (�� ������������ ���������� �������� QF/SF): " & extractedkAValue
                Else
                    e3App.PutInfo 0, "�������� 'kA' �� ������� � ������������ ���������� �������� QF/SF, ������ ���������� � �� V_Icu."
                End If

            Else
                e3App.PutInfo 0, "������� '������������' ���������� �������� QF/SF ����, ������ ���������� � �� V_Type � �� V_Icu."
            End If
            
            If Len("" & automatCompSupplier) > 0 Then
                symbol.SetAttributeValue "�� V_Proizv", automatCompSupplier
                e3App.PutInfo 0, "�������� � �� V_Proizv (�� ���������� ���������� �������� QF/SF): " & automatCompSupplier
            Else
                e3App.PutInfo 0, "������� '���������' ���������� �������� QF/SF ����, ������ ���������� � �� V_Proizv."
            End If
            
            ' --- ���������� ������� ��� ���������� "�������" ---
            If Len("" & contactComponentNameForOOO) > 0 Then
                symbol.SetAttributeValue "�� V_Dop ystr", contactComponentNameForOOO
                e3App.PutInfo 0, "�������� � �� V_Dop ystr (�� ������������ ���������� '�������' QF/SF): " & contactComponentNameForOOO
            Else
                e3App.PutInfo 0, "������� '������������' ���������� '�������' QF/SF ���� ��� �� ������, ������ ���������� � �� V_Dop ystr."
            End If

            ' --- ���������� �������� �� KM ���������� (�������������� '���������') ---
            If Len("" & kmCompTitle) > 0 Then
                symbol.SetAttributeValue "�� K_Type", kmCompTitle
                e3App.PutInfo 0, "�������� � �� K_Type (�� ������������ ���������� ���������� KM): " & kmCompTitle
            Else
                e3App.PutInfo 0, "������� '������������' ���������� ���������� KM ����, ������ ���������� � �� K_Type."
            End If

            If Len("" & kmCompSupplier) > 0 Then
                symbol.SetAttributeValue "�� K_Proizv", kmCompSupplier
                e3App.PutInfo 0, "�������� � �� K_Proizv (�� ���������� ���������� ���������� KM): " & kmCompSupplier
            Else
                e3App.PutInfo 0, "������� '���������' ���������� ���������� KM ����, ������ ���������� � �� K_Proizv."
            End If

            If Len("" & kmCompCurrent) > 0 Then
                symbol.SetAttributeValue "�� K_Inom", kmCompCurrent
                e3App.PutInfo 0, "�������� � �� K_Inom (�� (�����) ��� ���������� ���������� KM): " & kmCompCurrent
            Else
                e3App.PutInfo 0, "������� '(�����) ���' ���������� ���������� KM ����, ������ ���������� � �� K_Inom."
            End If


            e3App.PutInfo 0, "�������� ������� �������� � ������ OOO."
            oooSymbolFoundForWriting = True
            Exit For ' �������� � ������ ��������� OOO ������ � �������
        End If
    Next

    If Not oooSymbolFoundForWriting Then
        e3App.PutInfo 0, "�� ������ ������ OOO ����� ���������� ��� ������ ���������."
    End If

    Set symbol = Nothing
    Set job = Nothing
    Set e3App = Nothing
End Sub


' === �������� ������ ===
Dim foundDevices, e3App, hasOOOSymbol
Set foundDevices = CreateObject("Scripting.Dictionary") ' ��� ��������� ������ ������������ � �������� ��� �����������
Set e3App = CreateObject("CT.Application")

e3App.PutInfo 0, "=== ����� ������� ==="
Call FindDevicesBySelectedSymbols(foundDevices, hasOOOSymbol) ' ����������, ���� �� OOO ������ ����� ����������
Call ProcessAndWriteDeviceAttributes(hasOOOSymbol) ' ������ �������� ������ ���� OOO �������
e3App.PutInfo 0, "=== ����� ������� ==="

Set foundDevices = Nothing
Set e3App = Nothing
