Set app = CreateObject( "CT.Application" ) 
Set job = app.CreateJobObject()
Set device = job.CreateDeviceObject()
Set conductor = job.CreatePinObject()
Set pin = job.CreatePinObject()
Set dev = job.CreateDeviceObject()
Set Sig = Job.CreateSignalObject
set Cab = Job.CreateDeviceObject
set Cor = Job.CreatePinObject


call SheetGrid
call IndexSet
call Sort
call ReNameWire
call Sort


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
Const FORMAT = "#<.SHEET><.GRID>"

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
						' 6. ������-������ ������
						ElseIf WireColor = "������-������" Then
							NewName = "PE"								
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





Set dev = Nothing
Set pin = Nothing
Set conductor = Nothing
Set device = Nothing   
Set job = Nothing 
Set app = Nothing
Set Sig = Nothing
Set Cab = Nothing
Set Cor = Nothing