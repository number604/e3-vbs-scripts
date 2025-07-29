' ��������: ����� ����, ��� ������� ���� ������� ���������� 
' �������� ����� ������� � �����������
' 
' ����� ������� � ����������� ������������� 

Set app = CreateObject( "CT.Application" ) 
Set job = app.CreateJobObject()
Set symbol = job.CreateSymbolObject()
Set pin = job.CreatePinObject()
Set devicePin = job.CreatePinObject()
Set device = job.CreateDeviceObject()
Set connection = job.CreateConnectionObject()

Set dictPinIds1 = Nothing
Set dictPinIds1 = CreateObject("Scripting.Dictionary")

' ������ ������ � �����������, ������ ��� ����� �������
wiregroupName = InputBox("��� �������", "", "������(�)-LS")
If wiregroupName = "" Then
    app.PutInfo 0, "�������� �������������."
    WScript.Quit
End If
databaseWireName = InputBox("������� � ����", "", "1�0.75(�����)")
If databaseWireName = "" Then
    app.PutInfo 0, "�������� �������������."
    WScript.Quit
End If
wireName = InputBox("��� �������", "", "N")
If wireName = "" Then
    app.PutInfo 0, "�������� �������������."
    WScript.Quit
End If
signalName1 = InputBox("��� ����", "", "N")
If signalName1 = "" Then
    app.PutInfo 0, "�������� �������������."
    WScript.Quit
End If




app.PutInfo 0, "�������� � ����������� �������"

namePozOboz = "-SF" ' ������ ��� ����� �������
poiskpin = SOZDANIE_PINA
namePozOboz = "-QF" ' ������ ��� ����� �������
poiskpin = SOZDANIE_PINA
namePozOboz = "-FU" ' ������ ��� ����� �������
poiskpin = SOZDANIE_PINA
namePozOboz = "-KM" ' ������ ��� ����� �������
poiskpin = SOZDANIE_PINA
namePozOboz = "-G" ' ������ ��� ����� �������
poiskpin = SOZDANIE_PINA
namePozOboz = "-TV" ' ������ ��� ����� �������
poiskpin = SOZDANIE_PINA
namePozOboz = "-A" ' ������ ��� ����� �������
poiskpin = SOZDANIE_PINA_CPU
namePozOboz = "-QFD" ' ������ ��� ����� �������
poiskpin = SOZDANIE_PINA_CPU
namePozOboz = "-V" ' ������ ��� ����� �������
poiskpin = SOZDANIE_PINA_CPU
namePozOboz = "-KL" ' ������ ��� ����� �������
poiskpin = SOZDANIE_PINA
namePozOboz = "-1KL" ' ������ ��� ����� �������
poiskpin = SOZDANIE_PINA
namePozOboz = "-2KL" ' ������ ��� ����� �������
poiskpin = SOZDANIE_PINA
namePozOboz = "-KT" ' ������ ��� ����� �������
poiskpin = SOZDANIE_PINA
namePozOboz = "-KV" ' ������ ��� ����� �������
poiskpin = SOZDANIE_PINA
namePozOboz = "-QS" ' ������ ��� ����� �������

poiskpin = SOZDANIE_PINA
namePozOboz = "-SK" ' ������ ��� ����� �������
poiskpin = SOZDANIE_PINA
namePozOboz = "-EL" ' ������ ��� ����� �������
poiskpin = SOZDANIE_PINA
namePozOboz = "-M" ' ������ ��� ����� �������
poiskpin = SOZDANIE_PINA

namePozOboz = "-HL" ' ������ ��� ����� �������
poiskpin = SOZDANIE_PINA
namePozOboz = "-SB" ' ������ ��� ����� �������
poiskpin = SOZDANIE_PINA
namePozOboz = "-SA" ' ������ ��� ����� �������
poiskpin = SOZDANIE_PINA

namePozOboz = "-XT1"   ' ������ ��� ����� �������
poiskpin = SOZDANIE_PINAXT
namePozOboz = "-XT2"   ' ������ ��� ����� �������
poiskpin = SOZDANIE_PINAXT
namePozOboz = "-XT3"   ' ������ ��� ����� �������
poiskpin = SOZDANIE_PINAXT
namePozOboz = "-XT4"   ' ������ ��� ����� �������
poiskpin = SOZDANIE_PINAXT
namePozOboz = "-XT5"   ' ������ ��� ����� �������
poiskpin = SOZDANIE_PINAXT
namePozOboz = "-XT6"   ' ������ ��� ����� �������
poiskpin = SOZDANIE_PINAXT
namePozOboz = "-XT7"   ' ������ ��� ����� �������
poiskpin = SOZDANIE_PINAXT
namePozOboz = "-XT8"   ' ������ ��� ����� �������
poiskpin = SOZDANIE_PINAXT
namePozOboz = "-XT9"   ' ������ ��� ����� �������
poiskpin = SOZDANIE_PINAXT
namePozOboz = "-XT10"   ' ������ ��� ����� �������
poiskpin = SOZDANIE_PINAXT
namePozOboz = "-XT11"   ' ������ ��� ����� �������
poiskpin = SOZDANIE_PINAXT
namePozOboz = "-XT12"   ' ������ ��� ����� �������
poiskpin = SOZDANIE_PINAXT
namePozOboz = "-XT13"   ' ������ ��� ����� �������
poiskpin = SOZDANIE_PINAXT
namePozOboz = "-XT14"   ' ������ ��� ����� �������
poiskpin = SOZDANIE_PINAXT
namePozOboz = "-XT15"   ' ������ ��� ����� �������
poiskpin = SOZDANIE_PINAXT
namePozOboz = "-XT16"   ' ������ ��� ����� �������
poiskpin = SOZDANIE_PINAXT
namePozOboz = "-XT17"   ' ������ ��� ����� �������
poiskpin = SOZDANIE_PINAXT
namePozOboz = "-XT18"   ' ������ ��� ����� �������
poiskpin = SOZDANIE_PINAXT
namePozOboz = "-XT19"   ' ������ ��� ����� �������
poiskpin = SOZDANIE_PINAXT
namePozOboz = "-XT20"   ' ������ ��� ����� �������
poiskpin = SOZDANIE_PINAXT

'----------------------------------
' ��� �����������
'----------------------------------
Function SOZDANIE_PINA_CPU

connectionCount = job.GetConnectionIds( connectionIds )        ' ������� �������� (pin's) ��� ��������� ����
deviceCount = job.GetDeviceIds( deviceIds )        ' ������� �������� (pin's) ��� ��������� ����

	For deviceIndex = 1 To deviceCount
		deviceId = device.SetId( deviceIds( deviceIndex ) )
		deviceName = device.GetName()
	
		If InStr(1, deviceName, namePozOboz, 1) Then
		pinCount = device.GetPinIds( pinIds )
		For pinIndex = 1 To pinCount
			pinId = pin.SetId( pinIds( pinIndex ) )
			pinName = pin.GetName()
			deviceId = device.SetId( pinId )
			deviceName = device.GetName()
			result2 = pin.GetSignalName()
				If result2 = signalName1 Then
					For connectionIndex = 1 To connectionCount
					connectionId = connection.SetId( connectionIds( connectionIndex ) )
					connectionName = connection.GetName()
					result3 = connection.GetSignalName()
						If result3 = signalName1 Then
							pinId = pin.SetId( pinIds( pinIndex ) )
							pinName = pin.GetName()
							dictPinIds1.Add pinId, deviceName
							app.PutInfo 0, "��� ���� ��� �������� " & pinName & " ( " & pinId & " ) ������� " & deviceName & " ( " & deviceId & " ) - " & result2
						Exit For
						End If
					Next
				End If
		Next
		End If
	Next
		' ����� ���������
		app.PutInfo 0, deviceName & " - " & pinName & "( " & pinId & " )"
End Function



'----------------------------------
' ��� �������
'----------------------------------
Function SOZDANIE_PINA

connectionCount = job.GetConnectionIds( connectionIds )        ' ������� �������� (pin's) ��� ��������� ����
deviceCount = job.GetDeviceIds( deviceIds )        ' ������� �������� (pin's) ��� ��������� ����

Redim ArrDeviceIds(deviceCount-1, 2)
k = 0
	
	For deviceIndex = 1 To deviceCount
		deviceId = device.SetId( deviceIds( deviceIndex ) )
		deviceName = device.GetName()
	
		If InStr(1, deviceName, namePozOboz, 1) Then
		pinCount = device.GetPinIds( pinIds )
		For pinIndex = 1 To pinCount
			pinId = pin.SetId( pinIds( pinIndex ) )
			pinName = pin.GetName()
			deviceId = device.SetId( pinId )
			deviceName = device.GetName()
			result2 = pin.GetSignalName()
				If result2 = signalName1 Then
					For connectionIndex = 1 To connectionCount
					connectionId = connection.SetId( connectionIds( connectionIndex ) )
					connectionName = connection.GetName()
					result3 = connection.GetSignalName()
						If result3 = signalName1 Then
							pinId = pin.SetId( pinIds( pinIndex ) )
							pinName = pin.GetName()
							app.PutInfo 0, "��� ���� ��� �������� " & pinName & " ( " & pinId & " ) ������� " & deviceName & " ( " & deviceId & " ) - " & result2

							'���������� ������� ��� ����������
								ArrDeviceIds(k, 0) = deviceName
								ArrDeviceIds(k, 1) = pinName
								ArrDeviceIds(k, 2) = pinId
								k = k + 1
						Exit For
						End If
					Next
				End If
		Next
		End If
	Next
	
Redim options (2, 2)
	' ������ ������� ��� ����������
	options (0, 0) = 1 ' ����� �������
	options (0, 1) = 2 ' ������ ����������, 2 - ����������
	' ������ ������� ��� ����������
	options (1, 0) = 3 ' ����� �������
	options (1, 1) = 2 ' ������ ����������, 2 - ����������

	' ��������� �������
	app.SortArrayByIndexEx ArrDeviceIds, options
	app.PutMessage "����� ����������"
	
	' ������� ����� ����������
	For i=0 To k-1
		' ��������������� ���������� �� �������
		deviceName = ArrDeviceIds(i, 0)
		pinName = ArrDeviceIds(i, 1)
		pinId = ArrDeviceIds(i, 2)
		dictPinIds1.Add pinId, deviceName

		' ����� ���������
		app.PutInfo 0, deviceName & " - " & pinName & "( " & pinId & " )"
	Next	
	
End Function


'----------------------------------
' ��� �����
'----------------------------------
Function SOZDANIE_PINAXT

connectionCount = job.GetConnectionIds( connectionIds )        ' ������� �������� (pin's) ��� ��������� ����
deviceCount = job.GetDeviceIds( deviceIds )        ' ������� �������� (pin's) ��� ��������� ����

deviceId = device.Search(namePozOboz, assignment, location)
deviceId = deviceId
deviceName = device.GetName()
sborka = device.IsAssembly()
klemmnik = device.IsTerminalBlock()

deviceName = namePozOboz
deviceCount = device.SearchAll( deviceName , deviceAssignment, deviceLocation, deviceIds )

' �������� ������� ����������
Redim ArrDeviceIds(deviceCount-1, 2)

	If deviceCount > 0 Then 
	k = 0
		For i = 1 To deviceCount
			deviceId = device.SetId( deviceIds( i ) )
			deviceName = device.GetName()
			result = device.GetPinIds( pinIds )
			
			If result = 0 Then
			Else

			For pinIndex = 1 To result
			
			pinId = pin.SetId( pinIds( pinIndex ) )
			pinName = pin.GetName()
			result2 = pin.GetSignalName()
				If signalName1 = result2 Then
					app.PutInfo 0, "��� ���� ��� ������ " & pinName & " ( " & pinId & " ) ��������� " & namePozOboz & " ( " & deviceId & " ) - " & result2
					'���������� ������� ��� ����������
						ArrDeviceIds(i-1, 0) = deviceName
						ArrDeviceIds(i-1, 1) = pinName
						ArrDeviceIds(i-1, 2) = pinId
						k = k + 1
						' ����� ���������
						app.PutInfo 0, deviceName & " - " & pinName & " - " & pinId
					Exit For
				Else
				End If
			Next
			End If
		Next
	End If

Redim options (2, 2)
	' ������ ������� ��� ����������
	options (0, 0) = 2 ' ����� �������
	options (0, 1) = 2 ' ������ ����������, 2 - ����������
	' ������ ������� ��� ����������
	options (1, 0) = 3 ' ����� �������
	options (1, 1) = 2 ' ������ ����������, 2 - ����������

	' ��������� �������
	app.SortArrayByIndexEx ArrDeviceIds, options
	
	app.PutMessage "����� ����������"
	
	' ������� ����� ����������
	For i=0 To k-1
		' ��������������� ���������� �� �������
		deviceName = ArrDeviceIds(i, 0)
		pinName = ArrDeviceIds(i, 1)
		pinId = ArrDeviceIds(i, 2)

		dictPinIds1.Add pinId, deviceId

		' ����� ���������
		app.PutInfo 0, deviceName & " - " & pinName & "( " & pinId & " )" & k
	Next
End Function

Arr = dictPinIds1.Items
For i=0 To dictPinIds1.Count-1
	app.PutInfo 0, "�������:  " & dictPinIds1.Keys()(i)
	If i <> dictPinIds1.Count-1 Then
		firstTerminalPinId = dictPinIds1.Keys()(i)
		secondTerminalPinId = dictPinIds1.Keys()(i+1)
		iDPIN3 = SOZDANIE_PROVODA
	End If
Next


'==========================================
'�������� �������
'==========================================
Function SOZDANIE_PROVODA
If firstTerminalPinId>0 And secondTerminalPinId>0 Then
cableCount = job.GetCableIds( cableIds )
	For cableIndex = 1 To cableCount
		cableId = device.SetId( cableIds( cableIndex ) )
		cableName = device.GetName()
		isWireGroup = device.isWireGroup()
			If isWireGroup = 1 Then
				pinCount = device.GetPinIds( pinIds )
				result = pin.CreateWire( wireName, wiregroupName, databaseWireName, cableId, 0, 0 )
				If result = 0 Then
				app.PutError 0, "������ �������� ������� " & wireName
				Else    
					wireName = pin.GetName()
					app.PutInfo 0, "����� ������ " & wireName & " , " & wiregroupName & " , " & databaseWireName & " , ������, ( " & cableId & " )"
				End If
			End If
	Next
	pin.SetEndPinId 1, firstTerminalPinId
	pin.SetEndPinId 2, secondTerminalPinId
	app.PutInfo 0, "����� ������ " & wireName & " , " & wiregroupName & " , " & databaseWireName & " , ���������, ( " & cableId & " )"
End If
End Function

Set dictPinIds1 = Nothing

app.PutInfo 0, " ==============================================================="

Set connection = Nothing
Set device = Nothing
Set devicePin = Nothing
Set pin = Nothing
Set symbol = Nothing
Set job = Nothing 
Set app = Nothing 