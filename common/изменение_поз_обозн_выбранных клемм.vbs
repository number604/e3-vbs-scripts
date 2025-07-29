Set e3Application = CreateObject( "CT.Application" ) 
Set job = e3Application.CreateJobObject()
Set device = job.CreateDeviceObject()
'������ ���.����������� 
Dim deviceDesignation : deviceDesignation = InputBox("����� ���.�����������", "")

'deviceCount = job.GetTreeSelectedAllDeviceIds( deviceIds )        

termCount = job.GetTreeSelectedTerminalIds( terminalIds ) '������� ������

If termCount > 0 Then 
		e3Application.PutInfo 0, "������� �����:" & termCount  

		For terminalIndex = 1 To termCount  '������� ������� ��������� �����
		terminalId = device.SetId( terminalIds( terminalIndex )  )
		terminalName = device.GetName()
		
		'deviceId = device.SetId( deviceIds( 1 ) )        '������ ���������� � ������� 
		deviceName = device.GetName()

		result = device.SetName( deviceDesignation )

		If result = 0 Then
			message = "���������� " & deviceId & ": ������ ���. �����������" 
		Else
			message = "���������� " & deviceId & ": ���. ����������� �������� � " & deviceName & " �� " & deviceDesignation
		End If        
		e3Application.PutInfo 0, message        '����� ����������
	Next

End If

Set device = Nothing
Set job = Nothing 
Set e3Application = Nothing 
