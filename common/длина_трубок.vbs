Set app = CreateObject( "CT.Application" ) 
Set job = app.CreateJobObject()
Set device = job.CreateDeviceObject()
Set conductor = job.CreatePinObject()
Set pin = job.CreatePinObject()
Set dev = job.CreateDeviceObject()
Set Sig = Job.CreateSignalObject()
set Cab = Job.CreateDeviceObject()
set Cor = Job.CreatePinObject()


'call SheetGrid
'call IndexSet
'call Sort
'call ReNameWire
'call Sort
call GetWireCrossSections


Sub IndexSet ' ��� ������� = ��� ����
	deviceCount = Job.GetAllDeviceIds( deviceIds )     
	If deviceCount > 0 Then 
		For deviceIndex = 1 To deviceCount
		deviceId = device.SetId( deviceIds( deviceIndex ) )
		conductorCount = device.GetAllCoreIds( conductorIds )
			If conductorCount > 0 Then
			deviceName = device.GetName()
				if deviceName = "�������" then
					For conductorIndex = 1 To conductorCount
						conductorId = conductor.SetId( conductorIds( conductorIndex ) )				
						result = conductor.GetEndPinId( 1 )
						pinId = pin.SetId( result )
						pinName = pin.GetName()
						devId = dev.SetId( pinId )
						devName = dev.GetName()
						signal = pin.GetSignalName()
						conductor.SetName(signal)
					
					next
				end if
			end if
		next
	end If 
end Sub



sub Sort ' ��������� ������� � ������ �������
	Const ASCENDING = 1    ' �� �����������	
	' Const DESCENDING = 2 ' �� ��������
	Dim sortOrder : sortOrder = ASCENDING
 
	deviceCount = Job.GetAllDeviceIds( deviceIds )
	If deviceCount > 0 Then 
		For deviceIndex = 1 To deviceCount
			deviceId = device.SetId( deviceIds( deviceIndex ) )
			deviceName = device.GetName()
			if deviceName = "�������" then
			result = device.Sort( sortOrder )
				If result = 0 Then
					message = "Error sorting device " & deviceName & " ( " & deviceId & " )"
				Else
					message = "�������: " & deviceName & " ( " & deviceId & " ) �������������."
				End If
				app.PutInfo 0, "==========================================================="
				app.PutInfo 0, message    
			end if
		Next
	End If
end sub



Sub SheetGrid ' ��� ����� �� �������
	sigcnt = Job.GetSignalIds(sigids)
	If sigcnt = 0 Then
		App.PutInfo 1, "No signals found, exiting..."
		WScript.Quit
	End If

' ������ ��� ��������������
	const FORMAT = "#<.SHEET><.GRID>"

' ��������������� ����, ������������ � #
	For i = 1 To sigcnt
		Sig.SetId sigids(i)
		SignalName = Sig.GetName
		If Left(SignalName, 1) = "#" Then
			result = Sig.SetNameFormat(FORMAT)
			If result = 0 Then
				App.PutInfo 1, "������ �������������� ���� " & SignalName
			Else
				App.PutInfo 0, "���� " & SignalName & " ������������� � ������ " & FORMAT
			End If
		End If
	Next
end sub


Sub ReNameWire ' ��� ������� �� �����
	nCabs = Job.GetCableCount				' ���������� ������� � �������
	if nCabs = 0 then
		App.PutInfo 1, "No cables in project, exiting..."
		wscript.quit
	end If

	LCounter = 1
	L1Counter = 1
	L2Counter = 1
	L3Counter = 1
	L1aCounter = 1
	NCounter = 5

' ������� ������� ��� �������� ������������ �������� � ����� ����
	Set NameMapping = CreateObject("Scripting.Dictionary")

	cablecount = Job.GetCableIds(cableids)
	For i = 1 To cablecount
		Cab.SetId cableids(i)
		If Cab.IsWiregroup Then
			wircnt = Cab.GetPinIds(wirids)
			For j = 1 To wircnt
				Cor.SetId wirids(j)							
				WireName = Cor.GetName
				WireColor = Cor.GetColourDescription
				' 1. ��������������� ������ �������, ��� ������� ���������� � #
					If Left(WireName, 1) = "#" Then
					' ���������, ���� �� ��� ����� ��� ��� ����� ��������� �����
						If NameMapping.Exists(WireName) Then
							NewName = NameMapping(WireName)
						Else
						' 2. ������ ������
							If WireColor = "������" Then
								NewName = "L1." & L1Counter
								L1Counter = L1Counter + 1
						' 3. ���������� ������
							ElseIf WireColor = "����������" Then
								NewName = "L2." & L2Counter
								L2Counter = L2Counter + 1
						' 4. ����� ������
							ElseIf WireColor = "�����" Then
								NewName = "L3." & L3Counter
								L3Counter = L3Counter + 1
						' 5. ����� ������
							ElseIf WireColor = "�����" Then
								NewName = "N" & NCounter
								NCounter = NCounter + 1	
							
							Else
								NewName = LCounter
								LCounter = LCounter + 1	
							End If

						' ��������� ����� ��� � �������
							NameMapping.Add WireName, NewName
						End If

					' ��������������� ������
						If Not IsEmpty(NewName) Then
							Cor.SetName NewName
							App.PutInfo 0, "������ " & WireName & " ������������ � " & NewName
						End If
					End If
			Next
		End If 
	Next

end sub




Sub GetWireCrossSections ' ����� ���������������� ������ ��� ���������� ��������
    nCabs = Job.GetCableCount ' ���������� ������� � �������
    If nCabs = 0 Then
        App.PutInfo 1, "No cables in project, exiting..."
        wscript.quit
    End If

    ' ������� ������ ��� �������� ������� ��������
    Dim WireCrossSections()
    ReDim WireCrossSections(0) ' �������������� ������ � ������� ��������

    cablecount = Job.GetCableIds(cableids)
    For i = 1 To cablecount
        Cab.SetId cableids(i)
        If Cab.IsWiregroup Then
            wircnt = Cab.GetPinIds(wirids)
            For j = 1 To wircnt
                Cor.SetId wirids(j)
                WireCrossSection = Cor.GetCrossSectionDescription ' �������� ������� �������

                ' ��������� ������� ������� � ������
                If WireCrossSection <> "" Then
                    If UBound(WireCrossSections) = 0 And WireCrossSections(0) = "" Then
                        WireCrossSections(0) = WireCrossSection
                    Else
                        ReDim Preserve WireCrossSections(UBound(WireCrossSections) + 1)
                        WireCrossSections(UBound(WireCrossSections)) = WireCrossSection
                    End If
                End If
            Next
        End If
    Next

    ' ������� ������� ��� ������ �������
    Dim A(), B(), C(), E()
    ReDim A(0)
    ReDim B(0)
    ReDim C(0)
    ReDim E(0)

    ' ��������� ������� �� �������� ���������
    For k = 0 To UBound(WireCrossSections)
        section = WireCrossSections(k)

        ' ���������, �������� �� ������ ������������ ���������
        If InStr(section, "0.75") > 0 Or InStr(section, "1.5") > 0 Then
            If UBound(A) = 0 And A(0) = "" Then
                A(0) = section
            Else
                ReDim Preserve A(UBound(A) + 1)
                A(UBound(A)) = section
            End If
		ElseIf InStr(section, "10") > 0 Or InStr(section, "16") > 0 Or InStr(section, "25") > 0 Or InStr(section, "35") > 0 Then
            If UBound(C) = 0 And C(0) = "" Then
                C(0) = section
            Else
                ReDim Preserve C(UBound(C) + 1)
                C(UBound(C)) = section
            End If	
        ElseIf InStr(section, "2.5") > 0 Or InStr(section, "4") > 0 Or InStr(section, "6") > 0 Then
            If UBound(B) = 0 And B(0) = "" Then
                B(0) = section
            Else
                ReDim Preserve B(UBound(B) + 1)
                B(UBound(B)) = section
            End If
        
        ElseIf InStr(section, "50") > 0 Or InStr(section, "70") > 0 Then
            If UBound(E) = 0 And E(0) = "" Then
                E(0) = section
            Else
                ReDim Preserve E(UBound(E) + 1)
                E(UBound(E)) = section
            End If
        End If
    Next

    ' ������� ����������
    App.PutInfo 0, "����� ������:"

    ' ��������� ������ A
    If UBound(A) >= 0 And A(0) <> "" Then
        tubeALength = (UBound(A) + 1) * 2 * 0.015 ' ����� ������ ��� ������� A
		App.PutInfo 0, "������� 0,75-1,5"
        App.PutInfo 0, "������ ���������������� ��� ���������������� ������ �����-��-2�-3,2/1,6� (50�) + ������ �� 22.21.29-005-65321637-2019 ���. ���2�-032-�50"
		App.PutInfo 0, tubeALength
    End If

    ' ��������� ������ B
    If UBound(B) >= 0 And B(0) <> "" Then
        tubeBLength = (UBound(B) + 1) * 2 * 0.015 ' ����� ������ ��� ������� B
		App.PutInfo 0, "������� 2,5-6"
        App.PutInfo 0, "������ ���������������� ��� ���������������� ������ �����-��-2�-6,4/3,2� (50�) + ������ �� 22.21.29-005-65321637-2019 ���. ���2�-064-�50"
		App.PutInfo 0, tubeBLength
    End If

    ' ��������� ������ C
    If UBound(C) >= 0 And C(0) <> "" Then
        tubeCLength = (UBound(C) + 1) * 2 * 0.015 ' ����� ������ ��� ������� C
		App.PutInfo 0, "������� 10-35"
        App.PutInfo 0, "������ ���������������� ��� ���������������� ������ �����-��-2�-12,7/6,4� (50�) + ������ �� 22.21.29-005-65321637-2019 ���. ���2�-127-�50"
		App.PutInfo 0, tubeCLength
    End If

    ' ��������� ������ E
    If UBound(E) >= 0 And E(0) <> "" Then
        tubeELength = (UBound(E) + 1) * 2 * 0.015 ' ����� ������ ��� ������� E
		App.PutInfo 0, "������� 50-70"
        App.PutInfo 0, "������ ���������������� ��� ���������������� ������ �����-��-2�-19,1/9,5� (50�) + ������ �� 22.21.29-005-65321637-2019 ���. ���2�-191-�50"
		App.PutInfo 0, tubeELength
    End If
End Sub



Set dev = Nothing
Set pin = Nothing
Set conductor = Nothing
Set device = Nothing   
Set job = Nothing 
Set app = Nothing
Set Sig = Nothing
Set Cab = Nothing
Set Cor = Nothing