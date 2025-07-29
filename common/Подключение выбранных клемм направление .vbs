' ������ �������������� ������� �� ������ ������ �����

Set e3Application = CreateObject( "CT.Application" ) 
Set job = e3Application.CreateJobObject()
Set symbol = job.CreateSymbolObject()
Set pin = job.CreatePinObject()
Set devicePin = job.CreatePinObject()
Set device = job.CreateDeviceObject()

'Dim connectionDirection : connectionDirection = "7"  '����� 

' 0 - ������������ � ������ �����������
' 1 - ������������ ������
' 3 - ������������ ������
' 5 - ������������ �����
' 7 - ������������ �����
' 9 - ������������: ������������ ������ ��� �����
' 10 - ��������������: ������������ ����� ��� ������
' 14 - ��������������: ����������� ����������� ������� �� ��������� ������

connectionDirection = InputBox("0 - �����" & Chr(13)& "1 - ������ "& Chr(13)& _
							"3 - ������" & Chr(13)& "5 - ����� "& Chr(13)& _
							"7- �����" & Chr(13)& "9 - �����������"& Chr(13)& _
							"10- �������������" & Chr(13)& "14 - �������������"& Chr(13)_
							,"����������� ��������: ", "")

 

termCount = job.GetSelectedTerminalIds( terminalIds ) '������� ������


	If termCount > 0 Then 
		e3Application.PutInfo 0, "������� �����:" & termCount  

		For terminalIndex = 1 To termCount  '������� ������� ��������� �����
		terminalId = device.SetId( terminalIds( terminalIndex )  )

		terminalName = device.GetName()

		result = device.GetPinIds( pinIds )					'�������� ���� ����������

			If result > 0 Then							'���� ���� ����, ��
				For pinIndex = 1 To result 				'������� �����
				pinId = pin.SetId( pinIds( pinIndex ) ) '��������������� �������� ���
				pinName = pin.GetName()					'�������� ��� ����


					result2 = pin.SetPhysicalConnectionDirection( connectionDirection )  '��������������� ����������� �����������
				Select Case result2
					Case 0
						message = "�������� " & terminalName & " ; ������ " & pinName & " ����������� ����������� �������� �� �����"
					Case 1
						message = "�������� " & terminalName & " ; ������ " & pinName & " ����������� ����������� �������� �� ������"
					Case 3
						message = "�������� " & terminalName & " ; ������ " & pinName & " ����������� ����������� �������� �������"
					Case 5
						message = "�������� " & terminalName & " ; ������ " & pinName & " ����������� ����������� �������� �� �����"
					Case 7
						message = "�������� " & terminalName & " ; ������ " & pinName & " ����������� ����������� �������� ������"
					Case 9
						message = "�������� " & terminalName & " ; ������ " & pinName & " ����������� ����������� �������� �� ������������ (������-�����)"
					Case 10
						message = "�������� " & terminalName & " ; ������ " & pinName & " ����������� ����������� �������� �������������� (������-�����)"
					Case 14
						message = "�������� " & terminalName & " ; ������ " & pinName & " ����������� ����������� �������� ��������������"
					End Select
				e3Application.PutInfo 0, message        'output result of operation

				Next
			End If
		Next
	End If


Set device = Nothing
Set devicePin = Nothing
Set pin = Nothing
Set symbol = Nothing
Set job = Nothing 
Set e3Application = Nothing 
