' ===============================================================
' ===============================================================
'���. 03.10.2024
' ������ ������������ ��� ���������� ������ � �3 �� ������ F20
'������ ����� ������ �� ����� EXCEL
'���� ����������� ����� ����
'������ �������������� ��� ������ ������ , ���� ����������� ���������� �� ���������� ������ F20

' ===============================================================
' ===============================================================



' ������� ����������� � E3
'Set e3Application = CreateObject( "CT.Application" )
Set app = E3Connection()
Set job = app.CreateJobObject()
Set device = job.CreateDeviceObject()
Set dev = job.CreateDeviceObject()
Set symbol = job.CreateSymbolObject()
Set sym = job.CreateSymbolObject()
Set sheet = job.CreateSheetObject()
Set graphic = job.CreateGraphObject()
Set tree = job.CreateTreeObject()

Set Cab     = Job.CreateDeviceObject
Set Cor     = Job.CreatePinObject
Set Pin     = Job.CreatePinObject
Set Sheet   = Job.CreateSheetObject
Set Pin1     = Job.CreatePinObject
Set Pin2    = Job.CreatePinObject
Set Dev1     = Job.CreateDeviceObject
Set Dev2     = Job.CreateDeviceObject
Set signal = job.CreateSignalObject()
Set devicePin = job.CreatePinObject()


Set Excel = CreateObject("Excel.Application") 	' ������� ������ Excel
Set objExcel = CreateObject("Excel.Application")

' �������� ���������� ����������
Dim app, appId
' ===============================================================
' ������� ����������� � E3
' ===============================================================
Function E3Connection()
	' ������������ ������
	On Error Resume Next
		' ����������� �������� E3
		Set app = CreateObject("CT.Application")
		' ������ �������������� ��������
		appId = app.GetId()
		' ����� ��������� �� ������
		If (appId = 0) Then
			' ����� ���������
			MsgBox "������. ������� E3.series �� ������� ��� COM-������ ���������� E3.series �� ����������������!", 16, "������"
		End If
	On Error Goto 0
	' ������� �������
	Set E3Connection = app
End Function

' ===============================================================
' ������� ������ � ��������
' ===============================================================
'Function E3Job(ByRef jobId)
	' �������� ����������
'	Dim job
'	Set job = app.CreateJobObject()
	' ������ �������������� �������
'	jobId = job.GetId()
	' �������� ��������������
'	If (jobId = 0) Then
		' ����� ��������� �� ������
'		app.PutError 0, "������ �� ������!"
		' ��������� ���������� ������
'		Call ExitScript (False, job)
'	End If
	' ������� �������
'	Set E3Job = job
'End Function


' ===============================================================
' ��������� ������ �� ������ �������
' ===============================================================
Sub ExitScript(ByVal flagSuccessExit, ByRef job) 
	' �������� �����
	If (flagSuccessExit) Then
		' ����� ��������� �� �������� ���������
		Call app.PutInfo(0, "=====================================")
		Call app.PutInfo(0, "������������� ��������� �������!")
		Call app.PutInfo(0, "=====================================")
		
	Else
		' ����� ��������� � �� �������� ���������
		Call app.PutError(1, "������������� �� ���������!")
	End If
	
	' ������� ��������
	Set job = Nothing
	Set app = Nothing
	' ����� �� �������
	WScript.Quit
End Sub




' ===============================================================
' ===============================================================
' �������� ����� "F20_R2_������ � �3.xlsx"
' ����� ���� ��������, ��� ��������� ����� ���� ������
' ===============================================================
' ===============================================================

'fileName = "BGCC_16190-11-��������IO_R4.xlsx"
'Dim fso
'Set fso = CreateObject("Scripting.FileSystemObject")
'	Dim thisFolder: thisFolder = fso.GetParentFolderName(WScript.ScriptFullName)
	' ������ ���� �� ������� �������
'	Dim fileFullName
'	fileFullName = fso.BuildPath(thisFolder, fileName)
	' �������� �����
'	If (fso.FileExists(fileFullName)) Then
'		objExcel.Visible = False 
'		objExcel.Visible = True 
'		objExcel.Workbooks.Open fileFullName
'	Else
		' ����� ��������� �� ������
'		Call MsgBox("������ �������� ����� " & fileFullName & ". ����� �� ����������!", 16, "������ �������� �����")
		' ������� �������
'		Set fso = Nothing
		' ����� �� ���������� �������
'		WScript.Quit
'	End If
	' ������� �������
'	Set fso = Nothing

'objExcel.Visible = False 
'objExcel.Visible = True 
'objExcel.Workbooks.Open "D:\E3_Generation\___.xlsx"
'objExcel.Worksheets("����1").Activate

'ii= 5



'--------------------------------------------------------------------------------------------

Dim fso
Set fso = CreateObject("Scripting.FileSystemObject")
	Dim thisFolder: thisFolder = fso.GetParentFolderName(WScript.ScriptFullName)
	' ������ ���� �� ������� �������
	Dim fileFullName
	fileFullName = InputBox("������� ���� � ����� EXCEL � �������� �����������", "", "")
'	fileFullName = fso.BuildPath(thisFolder, fileName)
	' �������� �����
	If (fso.FileExists(fileFullName)) Then
'		objExcel.Visible = False 
'		objExcel.Visible = True 
		objExcel.Workbooks.Open fileFullName
	Else
		' ����� ��������� �� ������
		Call MsgBox("������ �������� ����� " & fileFullName & ". ����� �� ����������!", 16, "������ �������� �����")
		' ������� �������
		Set fso = Nothing
		' ����� �� ���������� �������
		WScript.Quit
	End If
	' ������� �������
'	Set fso = Nothing

'objExcel.Visible = False 
objExcel.Visible = True 
'objExcel.Workbooks.Open "D:\E3_Generation\___.xlsx"
objExcel.Worksheets("����1").Activate

'--------------------------------------------------------------------------------------------















'			objExcel.Cells( i + 1 + ii+j, 1 ) = A1 													' �� ����������� (0) ����� ������ / Raw No
'			objExcel.Cells( i + 1 + ii, 2 ) = ArrDeviceIds_2(i, 0) 													' (1) ����������� ����������� / Position TAG
'			objExcel.Cells( i + 1 + ii, 4 ) = A1													' �� ����������� (2) ������������ ������� / TAG
'			objExcel.Cells( i + 1 + ii, 6 ) = ArrDeviceIds_2(i, 1)													' (3) �������� ������� / TAG discription
'			objExcel.Cells( i + 1 + ii, 9 ) = ArrDeviceIds_2(i, 5)													' (4) ������� ����������� / Field connection 
'			objExcel.Cells( i + 1 + ii, 11 ) = ArrDeviceIds_2(i, 2)													' (5) ��� ������� / Signal type
'			objExcel.Cells( i + 1 + ii, 12 ) = ArrDeviceIds_2(i, 3)													' (6) ��� ����������� / Connection type
'			objExcel.Cells( i + 1 + ii, 13 ) = ArrDeviceIds_2(i, 4)													' (7) ��. ��� / Measurement type
'			objExcel.Cells( i + 1 + ii+j, 14 ) = Dev.GetComponentAttributeValue("���. �������� 1")	' �� �����������(8) ��� ������ / Module type
'			objExcel.Cells( i + 1 + ii+j, 17 ) = Dev.GetComponentAttributeValue("���. �������� 1")	' �� ����������� (9) ����������� ������ / Module TAG
'			objExcel.Cells( i + 1 + ii+j, 18 ) = Dev.GetComponentAttributeValue("���. �������� 1")	' �� ����������� (10) � ������ / Channel �

' ===============================================================
' ===============================================================
' ������������ ���������� ���������� ������� 
' ===============================================================
' ===============================================================
'i - ������
i = 0
ii= 5 '�������� � 6-�� ������
j = 0
For i = 0 To 2000
	A2 = objExcel.Cells( i + 1 + ii, 2 )
		If A2 <> "" Then
			j = j + 1
		Else
			Exit for
		End If
Next 



kDI = 0
kDO = 0
kAI = 0
kAO = 0

kDI_0 = 0
kDO_0 = 0
kAI_0 = 0
kAO_0 = 0


' ===============================================================
' ������� ���������� ������� ���� �������
' ===============================================================
For i = 0 To j - 1
	A11 = objExcel.Cells( i + 1 + ii, 8 )
	If A11 = "DI" Then 
		kDI = kDI + 1
	End If
	
	If A11 = "DO" Then 
		kDO = kDO + 1
	End if

	If A11 = "AI" Then 
		kAI = kAI + 1
	End if

	If A11 = "AO" Then 
		kAO = kAO + 1
	End if

	If A11 = "DI" Or A11 = "DO" Or A11 = "AI" Or A11 = "AO" Then 
	Else 
		kPR = kPR + 1
	End If
Next 



' ===============================================================
' ������� ������ �������� �� EXCEL
' ===============================================================
Redim ArrDeviceIds_ExcelDI(kDI, 6)
Redim ArrDeviceIds_ExcelDO(kDO, 6)
Redim ArrDeviceIds_ExcelAI(kAI, 6)
Redim ArrDeviceIds_ExcelAO(kAO, 6)
Redim ArrDeviceIds_ExcelPR(kPR, 6)


For i = 0 To j-1
'	A1 = objExcel.Cells( i + 1 + ii, 1 )
	A2 = objExcel.Cells( i + 1 + ii, 2 )			' (1) ����������� ����������� / Position TAG
'	A4 = objExcel.Cells( i + 1 + ii, 3 )			' (2) ������ ��� ������������
'	A6 = objExcel.Cells( i + 1 + ii, 4 )			' (3) ������� ��������������
'	A6 = objExcel.Cells( i + 1 + ii, 5 )			' (4) ������������ ������� / TAG
	A6 = objExcel.Cells( i + 1 + ii, 6 )			' (5) �������� ������� / TAG discription
'	A9 = objExcel.Cells( i + 1 + ii, 7 )			' (6)  ������� �����������/Field connection 
	A11 = objExcel.Cells( i + 1 + ii, 8 )			' (7) ��� ������� / Signal type
	A12 = objExcel.Cells( i + 1 + ii, 9 )			' (8) ��� ����������� / Connection type
	A13 = objExcel.Cells( i + 1 + ii, 10 )			' (9) ��. ��� / Measurement type
'	A14 = objExcel.Cells( i + 1 + ii, 14 )
'	A17 = objExcel.Cells( i + 1 + ii, 17 )
'	A18 = objExcel.Cells( i + 1 + ii, 18 )
	
	
	If A11 = "DI" Then 
		ArrDeviceIds_ExcelDI(kDI_0, 0) = A2					' (1) ����������� ����������� / Position TAG
		ArrDeviceIds_ExcelDI(kDI_0, 1) = A6 				' (5) �������� ������� / TAG discription
		ArrDeviceIds_ExcelDI(kDI_0, 2) = A11 				' (7) ��� ������� / Signal type
		ArrDeviceIds_ExcelDI(kDI_0, 3) = A12 				' (8) ��� ����������� / Connection type
		ArrDeviceIds_ExcelDI(kDI_0, 4) = A13 				' (9) ��. ��� / Measurement type
		ArrDeviceIds_ExcelDI(kDI_0, 5) = 0 					' ���� 0 - ����� �����������, 1 - ��� �����������
		kDI_0 = kDI_0 + 1
	End If 
	
	If A11 = "DO" Then 
		ArrDeviceIds_ExcelDO(kDO_0, 0) = A2					' (1) ����������� ����������� / Position TAG
		ArrDeviceIds_ExcelDO(kDO_0, 1) = A6 				' (3) �������� ������� / TAG discription
		ArrDeviceIds_ExcelDO(kDO_0, 2) = A11 				' (5) ��� ������� / Signal type
		ArrDeviceIds_ExcelDO(kDO_0, 3) = A12 				' (6) ��� ����������� / Connection type
		ArrDeviceIds_ExcelDO(kDO_0, 4) = A13 				' (7) ��. ��� / Measurement type
		ArrDeviceIds_ExcelDO(kDO_0, 5) = 0 					' ���� 0 - ����� �����������, 1 - ��� �����������
		kDO_0 = kDO_0 + 1
	End If 
'	
	If A11 = "AI" Then 
		ArrDeviceIds_ExcelAI(kAI_0, 0) = A2					' (1) ����������� ����������� / Position TAG
		ArrDeviceIds_ExcelAI(kAI_0, 1) = A6 				' (3) �������� ������� / TAG discription
		ArrDeviceIds_ExcelAI(kAI_0, 2) = A11 				' (5) ��� ������� / Signal type
		ArrDeviceIds_ExcelAI(kAI_0, 3) = A12 				' (6) ��� ����������� / Connection type
		ArrDeviceIds_ExcelAI(kAI_0, 4) = A13 				' (7) ��. ��� / Measurement type
		ArrDeviceIds_ExcelAI(kAI_0, 5) = 0 				' ���� 0 - ����� �����������, 1 - ��� �����������
		kAI_0 = kAI_0 + 1
	End If 
'	
	If A11 = "AO" Then 
		ArrDeviceIds_ExcelAO(kAO_0, 0) = A2					' (1) ����������� ����������� / Position TAG
		ArrDeviceIds_ExcelAO(kAO_0, 1) = A6 				' (3) �������� ������� / TAG discription
		ArrDeviceIds_ExcelAO(kAO_0, 2) = A11 				' (5) ��� ������� / Signal type
		ArrDeviceIds_ExcelAO(kAO_0, 3) = A12 				' (6) ��� ����������� / Connection type
		ArrDeviceIds_ExcelAO(kAO_0, 4) = A13 				' (7) ��. ��� / Measurement type
		ArrDeviceIds_ExcelAO(kAO_0, 5) = 0 					' ���� 0 - ����� �����������, 1 - ��� �����������
		kAO_0 = kAO_0 + 1
	End If 
	
'	If A11 = "DI" Or A11 = "DO" Or A11 = "AI" Or A11 = "AO" Then 
'	Else 
'		ArrDeviceIds_ExcelPR(i + kPR_0, 0) = A2					' (1) ����������� ����������� / Position TAG
'		ArrDeviceIds_ExcelPR(i + kPR_0, 1) = A6 				' (3) �������� ������� / TAG discription
'		ArrDeviceIds_ExcelPR(i + kPR_0, 2) = A11 				' (5) ��� ������� / Signal type
'		ArrDeviceIds_ExcelPR(i + kPR_0, 3) = A12 				' (6) ��� ����������� / Connection type
'		ArrDeviceIds_ExcelPR(i + kPR_0, 4) = A13 				' (7) ��. ��� / Measurement type
'		kPR_0 = kPR_0 + 1
'	End If 
Next 












'================================================================================================
' ������� ��� ���� ������� 2 DI
'================================================================================================
namePozObozDI = "DI"
namepinDI = "DI"
k = 0
i = 1

deviceCount = job.GetAllDeviceIds( deviceIds )        'get selected devices in the project tree
'deviceCount = job.GetTreeSelectedAllDeviceIds( deviceIds )        'get selected devices in the project tree
If deviceCount > 0 Then 
	For deviceIndex = 1 To deviceCount
'	If i <= kAI_0 Then
		deviceId = device.SetId( deviceIds( deviceIndex ) )
		deviceName = device.GetName()
		deviceNam = device.GetAttributeValue( "����������� ����������� (������� �������)" )
		If InStr(1, deviceNam, namePozObozDI, 1) Then
			result = device.GetPinIds( pinIds )
			If result = 0 Then
				app.PutInfo 0, "No pins found for device item " & deviceName & " ( " & deviceId & " )"
				Else
				app.PutInfo 0, result & " pins found for device item " & deviceName & " ( " & deviceId & " ) :"
					For pinIndex = 1 To result
						attributeName = "�� (PLC) - ���������� �����"
						pinId = pin.SetId( pinIds( pinIndex ) )
						pinName = pin.GetName()
						pinName_Attr = pin.GetAttributeValue( attributeName )
'						If pinName_Attr => namepinAI Then
						If InStr(1, pinName_Attr, namepinDI, 1) Then
							app.PutInfo 0, "    " & pinName & " ( " & pinId & " )"
							result1 = pin.GetAttributeValue( "TAG �������" )
							If result1 = "HOLD" Then
								If i <= kDI_0 Then	
									For k = 0 To kDI
										AA_0_1 = ArrDeviceIds_ExcelDI(k, 5)				' ���� 0 - ����� �����������, 1 - ��� �����������
										If AA_0_1 = 0 Then 
										
											A2_1 = ArrDeviceIds_ExcelDI(k, 0)				' (1) ����������� ����������� / Position TAG
											A6_1 = ArrDeviceIds_ExcelDI(k, 1)				' (3) �������� ������� / TAG discription
											A11_1 = ArrDeviceIds_ExcelDI(k, 2)				' (5) ��� ������� / Signal type
											A12_1 = ArrDeviceIds_ExcelDI(k, 3)				' (6) ��� ����������� / Connection type
											A13_1 = ArrDeviceIds_ExcelDI(k, 4)				' (7) ��. ��� / Measurement type
											AA_0_1 = ArrDeviceIds_ExcelDI(k, 5)				' ���� 0 - ����� �����������, 1 - ��� �����������
											ArrDeviceIds_ExcelDI(k, 5) = 1				' ���� 0 - ����� �����������, 1 - ��� �����������
										i = i + 1
										Exit for
										End If
									Next 
									
										C11 = pin.SetAttributeValue( "TAG �������" , A2_1 ) ' �������������  ����� �������
										C21 = pin.SetAttributeValue( "TAG ��������", A6_1 ) ' �������������  ����� �������
										C31 = pin.SetAttributeValue( "��� - ��� �������", A11_1 ) ' �������������  ����� �������
										C41 = pin.SetAttributeValue( "��� - ��� �����������", A12_1 ) ' �������������  ����� �������
										C51 = pin.SetAttributeValue( "��� - ������� ���������", A13_1 ) ' �������������  ����� �������
								End If
							End If
						End If
					Next
			End If
		End If
'	Exit for
'	End If
	Next
End If


'================================================================================================
' ������� ��� ���� ������� 2 DO
'================================================================================================
namePozObozDO = "DO"
namepinDI = "DO"

k = 0
i = 1

deviceCount = job.GetAllDeviceIds( deviceIds )        'get selected devices in the project tree
'deviceCount = job.GetTreeSelectedAllDeviceIds( deviceIds )        'get selected devices in the project tree
If deviceCount > 0 Then 
	For deviceIndex = 1 To deviceCount
'	If i <= kAI_0 Then
		deviceId = device.SetId( deviceIds( deviceIndex ) )
		deviceName = device.GetName()
		deviceNam = device.GetAttributeValue( "����������� ����������� (������� �������)" )
		If InStr(1, deviceNam, namePozObozDO, 1) Then
			result = device.GetPinIds( pinIds )
			If result = 0 Then
				app.PutInfo 0, "No pins found for device item " & deviceName & " ( " & deviceId & " )"
				Else
				app.PutInfo 0, result & " pins found for device item " & deviceName & " ( " & deviceId & " ) :"
					For pinIndex = 1 To result
						attributeName = "�� (PLC) - ���������� �����"
						pinId = pin.SetId( pinIds( pinIndex ) )
						pinName = pin.GetName()
						pinName_Attr = pin.GetAttributeValue( attributeName )
'						If pinName_Attr => namepinAI Then
						If InStr(1, pinName_Attr, namepinDO, 1) Then
							app.PutInfo 0, "    " & pinName & " ( " & pinId & " )"
							result1 = pin.GetAttributeValue( "TAG �������" )
							If result1 = "HOLD" Then
								If i <= kDO_0 Then	
									For k = 0 To kDO
										AA_0_1 = ArrDeviceIds_ExcelDO(k, 5)				' ���� 0 - ����� �����������, 1 - ��� �����������
										If AA_0_1 = 0 Then 
										
											A2_1 = ArrDeviceIds_ExcelDO(k, 0)				' (1) ����������� ����������� / Position TAG
											A6_1 = ArrDeviceIds_ExcelDO(k, 1)				' (3) �������� ������� / TAG discription
											A11_1 = ArrDeviceIds_ExcelDO(k, 2)				' (5) ��� ������� / Signal type
											A12_1 = ArrDeviceIds_ExcelDO(k, 3)				' (6) ��� ����������� / Connection type
											A13_1 = ArrDeviceIds_ExcelDO(k, 4)				' (7) ��. ��� / Measurement type
											AA_0_1 = ArrDeviceIds_ExcelDO(k, 5)				' ���� 0 - ����� �����������, 1 - ��� �����������
											ArrDeviceIds_ExcelDO(k, 5) = 1				' ���� 0 - ����� �����������, 1 - ��� �����������
										i = i + 1
										Exit for
										End If
									Next 
									
										C11 = pin.SetAttributeValue( "TAG �������" , A2_1 ) ' �������������  ����� �������
										C21 = pin.SetAttributeValue( "TAG ��������", A6_1 ) ' �������������  ����� �������
										C31 = pin.SetAttributeValue( "��� - ��� �������", A11_1 ) ' �������������  ����� �������
										C41 = pin.SetAttributeValue( "��� - ��� �����������", A12_1 ) ' �������������  ����� �������
										C51 = pin.SetAttributeValue( "��� - ������� ���������", A13_1 ) ' �������������  ����� �������
								End If
							End If
						End If
					Next
			End If
		End If
'	Exit for
'	End If
	Next
End If


'================================================================================================
' ������� ��� ���� ������� 2 AI
'================================================================================================
'namePozObozAI = InputBox("������� ����������� ���������� ������ AI", "", "")
'namepinAI = InputBox("������� ����������� ���������� ����� ������ AI", "", "")

namePozObozAI = "AI"
namepinAI = "AI"
k = 0
i = 1

deviceCount = job.GetAllDeviceIds( deviceIds )        'get selected devices in the project tree
'deviceCount = job.GetTreeSelectedAllDeviceIds( deviceIds )        'get selected devices in the project tree
If deviceCount > 0 Then 
	For deviceIndex = 1 To deviceCount
'	If i <= kAI_0 Then
		deviceId = device.SetId( deviceIds( deviceIndex ) )
		deviceName = device.GetName()
		deviceNam = device.GetAttributeValue( "����������� ����������� (������� �������)" )
		If InStr(1, deviceNam, namePozObozAI, 1) Then
			result = device.GetPinIds( pinIds )
			If result = 0 Then
				app.PutInfo 0, "No pins found for device item " & deviceName & " ( " & deviceId & " )"
				Else
				app.PutInfo 0, result & " pins found for device item " & deviceName & " ( " & deviceId & " ) :"
					For pinIndex = 1 To result
						attributeName = "�� (PLC) - ���������� �����"
						pinId = pin.SetId( pinIds( pinIndex ) )
						pinName = pin.GetName()
						pinName_Attr = pin.GetAttributeValue( attributeName )
'						If pinName_Attr => namepinAI Then
						If InStr(1, pinName_Attr, namepinAI, 1) Then
							app.PutInfo 0, "    " & pinName & " ( " & pinId & " )"
							result1 = pin.GetAttributeValue( "TAG �������" )
							If result1 = "HOLD" Then
								If i <= kAI_0 Then	
									For k = 0 To kAI
										AA_0_1 = ArrDeviceIds_ExcelAI(k, 5)				' ���� 0 - ����� �����������, 1 - ��� �����������
										If AA_0_1 = 0 Then 
										
											A2_1 = ArrDeviceIds_ExcelAI(k, 0)				' (1) ����������� ����������� / Position TAG
											A6_1 = ArrDeviceIds_ExcelAI(k, 1)				' (3) �������� ������� / TAG discription
											A11_1 = ArrDeviceIds_ExcelAI(k, 2)				' (5) ��� ������� / Signal type
											A12_1 = ArrDeviceIds_ExcelAI(k, 3)				' (6) ��� ����������� / Connection type
											A13_1 = ArrDeviceIds_ExcelAI(k, 4)				' (7) ��. ��� / Measurement type
											AA_0_1 = ArrDeviceIds_ExcelAI(k, 5)				' ���� 0 - ����� �����������, 1 - ��� �����������
											ArrDeviceIds_ExcelAI(k, 5) = 1				' ���� 0 - ����� �����������, 1 - ��� �����������
										i = i + 1
										Exit for
										End If
									Next 
									
										C11 = pin.SetAttributeValue( "TAG �������" , A2_1 ) ' �������������  ����� �������
										C21 = pin.SetAttributeValue( "TAG ��������", A6_1 ) ' �������������  ����� �������
										C31 = pin.SetAttributeValue( "��� - ��� �������", A11_1 ) ' �������������  ����� �������
										C41 = pin.SetAttributeValue( "��� - ��� �����������", A12_1 ) ' �������������  ����� �������
										C51 = pin.SetAttributeValue( "��� - ������� ���������", A13_1 ) ' �������������  ����� �������
								End If
							End If
						End If
					Next
			End If
		End If
'	Exit for
'	End If
	Next
End If

'================================================================================================
' ������� ��� ���� ������� 2 AO
'================================================================================================
namePozObozAO = "AO"
namepinAI = "AO"

k = 0
i = 1

deviceCount = job.GetAllDeviceIds( deviceIds )        'get selected devices in the project tree
'deviceCount = job.GetTreeSelectedAllDeviceIds( deviceIds )        'get selected devices in the project tree
If deviceCount > 0 Then 
	For deviceIndex = 1 To deviceCount
'	If i <= kAO_0 Then
		deviceId = device.SetId( deviceIds( deviceIndex ) )
		deviceName = device.GetName()
		deviceNam = device.GetAttributeValue( "����������� ����������� (������� �������)" )
		If InStr(1, deviceNam, namePozObozAO, 1) Then
			result = device.GetPinIds( pinIds )
			If result = 0 Then
				app.PutInfo 0, "No pins found for device item " & deviceName & " ( " & deviceId & " )"
				Else
				app.PutInfo 0, result & " pins found for device item " & deviceName & " ( " & deviceId & " ) :"
					For pinIndex = 1 To result
						attributeName = "�� (PLC) - ���������� �����"
						pinId = pin.SetId( pinIds( pinIndex ) )
						pinName = pin.GetName()
						pinName_Attr = pin.GetAttributeValue( attributeName )
						If InStr(1, pinName_Attr, namepinAO, 1) Then
							app.PutInfo 0, "    " & pinName & " ( " & pinId & " )"
							result1 = pin.GetAttributeValue( "TAG ��������" )
							If result1 = "HOLD" Then
								If i <= kAO_0 Then
									For k = 0 To kAO
										AA_0_1 = ArrDeviceIds_ExcelAO(k, 5)				' ���� 0 - ����� �����������, 1 - ��� �����������
										If AA_0_1 = 0 Then 
											A2_1 = ArrDeviceIds_ExcelAO(k, 0)				' (1) ����������� ����������� / Position TAG
											A6_1 = ArrDeviceIds_ExcelAO(k, 1)				' (3) �������� ������� / TAG discription
											A11_1 = ArrDeviceIds_ExcelAO(k, 2)				' (5) ��� ������� / Signal type
											A12_1 = ArrDeviceIds_ExcelAO(k, 3)				' (6) ��� ����������� / Connection type
											A13_1 = ArrDeviceIds_ExcelAO(k, 4)				' (7) ��. ��� / Measurement type
											AA_0_1 = ArrDeviceIds_ExcelAO(k, 5)				' ���� 0 - ����� �����������, 1 - ��� �����������
											ArrDeviceIds_ExcelAo(k, 5) = 1				' ���� 0 - ����� �����������, 1 - ��� �����������
										i = i + 1
										Exit for
										End If
									Next 
									C11 = pin.SetAttributeValue( "TAG �������" , A2_1 ) ' �������������  ����� �������
									C21 = pin.SetAttributeValue( "TAG ��������", A6_1 ) ' �������������  ����� �������
									C31 = pin.SetAttributeValue( "��� - ��� �������", A11_1 ) ' �������������  ����� �������
									C41 = pin.SetAttributeValue( "��� - ��� �����������", A12_1 ) ' �������������  ����� �������
									C51 = pin.SetAttributeValue( "��� - ������� ���������", A13_1 ) ' �������������  ����� �������
								
								End If
							End If
						End If
					Next
			End If
		End If
'	Exit for
'	End If
	Next
End If





'	wscript.Quit






'====================================================================================================================
App.PutMessage "=================================================" 
App.PutMessage "��������� ��������� �������!" 
App.PutMessage "=================================================" 

ExitScript true, job




Set signal = Nothing
Set Dev2 = Nothing
Set Dev1 = Nothing
Set Pin2 = Nothing
Set Pin1 = Nothing
Set Sheet = Nothing
Set Pin = Nothing
Set Cor = Nothing
Set Cab = Nothing

Set tree = Nothing
Set graphic = Nothing
Set sheet = Nothing
Set sym = Nothing
Set symbol = Nothing
Set dev = Nothing
Set device = Nothing
Set job = Nothing
Set app = Nothing

	wscript.Quit






