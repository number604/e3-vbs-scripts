' ===============================================================
' ����������, ��������� ���� REGUL � ����������
' ===============================================================


' ===============================================================
' �������� ���������� ����������
Dim app, appId

' ������� ����������� � E3
'Set app = CreateObject( "CT.Application" ) 
Set app = E3Connection()
Set job = app.CreateJobObject()
Set sheet = job.CreateSheetObject()

Set dev = job.CreateDeviceObject
Set device = job.CreateDeviceObject()
Set subDevice = job.CreateDeviceObject()
Set pin = job.CreatePinObject
Set connection = job.CreateConnectionObject()
Set devicePin = job.CreatePinObject()

Set slot = job.CreateSlotObject()
Set symbol = job.CreateSymbolObject()
Set component = job.CreateComponentObject()
Set sym = job.CreateSymbolObject()







' ��������� ������
'Call ExitScript(True, 0)


' ===============================================================
' ������� ����������� � E3
' ===============================================================
Function E3Connection()
'	 ������������ ������
	On Error Resume Next
'		 ����������� �������� E3
		Set app = CreateObject("CT.Application")
'		 ������ �������������� ��������
		appId = app.GetId()
'		 ����� ��������� �� ������
		If (appId = 0) Then
'			 ����� ���������
			MsgBox "������. ������� E3.series �� ������� ��� COM-������ ���������� E3.series �� ����������������!", 16, "������"
		End If
	On Error Goto 0
'	 ������� �������
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
'Sub ExitScript(ByVal flagSuccessExit, ByRef job) 
	' �������� �����
'	If (flagSuccessExit) Then
		' ����� ��������� �� �������� ���������
'		Call app.PutInfo(0, "������������� ��������� �������!")
'	Else
		' ����� ��������� � �� �������� ���������
'		Call app.PutError(1, "������������� �� ���������!")
'	End If
'	
	' ������� ��������
'	Set job = Nothing
'	Set app = Nothing
	' ����� �� �������
'	WScript.Quit
'End Sub

' ===============================================================
' ������ � ������������: ����������� ���������
' ===============================================================
'OBOZNACHENIE = InputBox("����������� ���������", "", "")
' If OBOZNACHENIE = "" Then 
' 	app.PutInfo 0, " ==============================================================="
'	app.PutError 0, OBOZNACHENIE
'	app.PutError 0, "������: ����������� ���������. ������ �����������" 
'	app.PutError 0, " ==============================================================="
'	wscript.Quit
' wscript.Quit
' End if

' ===============================================================
' �������� ������� � ������ ����� "OBOZNACHENIE"
' ===============================================================
'Call Include("�����_200_�������� �����.vbs") 


' ===============================================================
' ���������� ����� �������� ����������
' ===============================================================
'Call Include("SPEC_Markirovka_proverka_v1.vbs") 




Set objExcel = CreateObject("Excel.Application")

' ===============================================================
' ===============================================================
' �������� ����� "______.xlsx"
' � ������� ���� ������� ���� �����
' ===============================================================
' ===============================================================

Dim fso
Set fso = CreateObject("Scripting.FileSystemObject")
	Dim thisFolder: thisFolder = fso.GetParentFolderName(WScript.ScriptFullName)
	' ������ ���� �� ������� �������
	Dim fileFullName
	fileFullName = InputBox("������� ���� � ����� EXCEL � �������� �����������", "", "")
'	 fileFullName = "D:\���\Script\������������� �����������.xlsx"
'	fileFullName = fso.BuildPath(thisFolder, fileName)
	' �������� �����
	If (fso.FileExists(fileFullName)) Then
'		objExcel.Visible = False 
'		objExcel.Visible = True 
		'fileFullName = "D:\���\Script\������������� �����������.xlsx"
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
objExcel.Worksheets("Start").Activate

' ===============================================================
' ���������� ��� ���������� ��� ������� - ������ ��� ������
' ===============================================================
SHIFR_soed = InputBox("������� ��� ���������� ��� ������� �����������:" & vbNewLine & "1 - ���������� ��������" & vbNewLine & "2 - ���������� �������", "", "")


' ===============================================================
' ���������� ���������� ������� �� �����
' ===============================================================


Kol_AI_kanal = objExcel.Cells( 3, 3 ) ' ����� ���������� �������
Kol_AQ_kanal = objExcel.Cells( 4, 3 ) ' ����� ���������� �������
Kol_DI_kanal = objExcel.Cells( 5, 3 ) ' ����� ���������� �������
Kol_DQ_kanal = objExcel.Cells( 6, 3 ) ' ����� ���������� �������

Kol_AI_mod = objExcel.Cells( 3, 4 ) ' ����� ���������� �������
Kol_AQ_mod = objExcel.Cells( 4, 4 ) ' ����� ���������� �������
Kol_DI_mod = objExcel.Cells( 5, 4 ) ' ����� ���������� �������
Kol_DQ_mod = objExcel.Cells( 6, 4 ) ' ����� ���������� �������



' ===============================================================
' ����������� ���������� ������
' ===============================================================
Kol_sheet = 0
Kol_sh_AI_mod = 0
Kol_sh_AQ_mod = 0
Kol_sh_DI_mod = 0
Kol_sh_DQ_mod = 0

Kol_sh_AI_mod = Kol_sh_AI_mod * 1
Kol_sh_AQ_mod = Kol_sh_AQ_mod * 1
Kol_sh_DI_mod = Kol_sh_DI_mod * 4
Kol_sh_DQ_mod = Kol_sh_DQ_mod * 4

Kol_sheet = Kol_sh_AI_mod * 1 + Kol_sh_AQ_mod * 1 + Kol_sh_DI_mod * 4 + Kol_sh_DQ_mod * 4

' ===============================================================
' ������� ������� ��� �3
' ===============================================================
'Call Vstavka_stranits
'wscript.Quit

' ===============================================================
' ������� ������ ������� ��� ������ 1
' ===============================================================

kol1 = objExcel.Cells(3, 8 )' ����� ���� ����� ������ � ����� - ���������� �������
Redim ArrDeviceIds_ExcelKR1(kol1, 11)
kol11 = kol1
kol1 = 0
For i = 0 To kol11 - 1

KR_1_shassi = objExcel.Cells( i + 21, 3 )				' ����� ��/�
KR_1_shassiCatalog = objExcel.Cells( i + 21, 4 )		' ����� � �������
KR_1_modul = objExcel.Cells( i + 21, 5 )				' ������ 
KR_1_modulCatalog = objExcel.Cells( i + 21, 6 )			' ������ � �������
KR_1_kolodka = objExcel.Cells( i + 21, 7 )				' �������
KR_1_kolodkaCatalog = objExcel.Cells( i + 21, 8 )		' ������� � �������
KR_1_rele = objExcel.Cells( i + 21, 9 )					' ����
KR_1_klemmnik1 = objExcel.Cells( i + 21, 10 )			' �������� 1
KR_1_klemmnik2 = objExcel.Cells( i + 21, 11 )			' �������� 2
KR_1_kabel1 = objExcel.Cells( i + 21, 12 )				' ������ 1
KR_1_kabel2 = objExcel.Cells( i + 21, 13 )				' ������ 2

	ArrDeviceIds_ExcelKR1(kol1, 0) = KR_1_shassi				' ���.�����. �����
	ArrDeviceIds_ExcelKR1(kol1, 1) = KR_1_shassiCatalog			' ���.�����. ����� � �������
	ArrDeviceIds_ExcelKR1(kol1, 2) = KR_1_modul 				' ���.�����. ������
	ArrDeviceIds_ExcelKR1(kol1, 3) = KR_1_modulCatalog 			' ���.�����. ������ � �������
	ArrDeviceIds_ExcelKR1(kol1, 4) = KR_1_kolodka 				' ���.�����. �������
	ArrDeviceIds_ExcelKR1(kol1, 5) = KR_1_kolodkaCatalog 		' ���.�����. ������� � �������
	ArrDeviceIds_ExcelKR1(kol1, 6) = KR_1_rele 					' ���.�����. ����
	ArrDeviceIds_ExcelKR1(kol1, 7) = KR_1_klemmnik1 			' ���.�����. �������� 1
	ArrDeviceIds_ExcelKR1(kol1, 8) = KR_1_klemmnik2 			' ���.�����. �������� 2
	ArrDeviceIds_ExcelKR1(kol1, 9) = KR_1_kabel1 				' ���.�����. ������ 1
	ArrDeviceIds_ExcelKR1(kol1, 10) = KR_1_kabel2 				' ���.�����. ������ 2
	kol1 = kol1 + 1
Next

' ===============================================================
' ������� ������ ������� ��� ������ 2
' ===============================================================

kol2 = objExcel.Cells(4, 8 )' ����� ���� ����� ������ � ����� - ���������� �������
Redim ArrDeviceIds_ExcelKR2(kol2, 11)
kol21 = kol2
kol2 = 0
For i = 0 To kol21 - 1

KR_2_shassi = objExcel.Cells( i + 41, 3 )				' ����� ��/�
KR_2_shassiCatalog = objExcel.Cells( i + 41, 4 )		' ����� � �������
KR_2_modul = objExcel.Cells( i + 41, 5 )				' ������ 
KR_2_modulCatalog = objExcel.Cells( i + 41, 6 )			' ������ � �������
KR_2_kolodka = objExcel.Cells( i + 41, 7 )				' �������
KR_2_kolodkaCatalog = objExcel.Cells( i + 41, 8 )		' ������� � �������
KR_2_rele = objExcel.Cells( i + 41, 9 )					' ����
KR_2_klemmnik1 = objExcel.Cells( i + 41, 10 )			' �������� 1
KR_2_klemmnik2 = objExcel.Cells( i + 41, 11 )			' �������� 2
KR_2_kabel1 = objExcel.Cells( i + 41, 12 )				' ������ 1
KR_2_kabel2 = objExcel.Cells( i + 41, 13 )				' ������ 2

	ArrDeviceIds_ExcelKR2(kol2, 0) = KR_2_shassi				' ���.�����. �����
	ArrDeviceIds_ExcelKR2(kol2, 1) = KR_2_shassiCatalog			' ���.�����. ����� � �������
	ArrDeviceIds_ExcelKR2(kol2, 2) = KR_2_modul 				' ���.�����. ������
	ArrDeviceIds_ExcelKR2(kol2, 3) = KR_2_modulCatalog 			' ���.�����. ������ � �������
	ArrDeviceIds_ExcelKR2(kol2, 4) = KR_2_kolodka 				' ���.�����. �������
	ArrDeviceIds_ExcelKR2(kol2, 5) = KR_2_kolodkaCatalog 		' ���.�����. ������� � �������
	ArrDeviceIds_ExcelKR2(kol2, 6) = KR_2_rele 					' ���.�����. ����
	ArrDeviceIds_ExcelKR2(kol2, 7) = KR_2_klemmnik1 			' ���.�����. �������� 1
	ArrDeviceIds_ExcelKR2(kol2, 8) = KR_2_klemmnik2 			' ���.�����. �������� 2
	ArrDeviceIds_ExcelKR2(kol2, 9) = KR_2_kabel1 				' ���.�����. ������ 1
	ArrDeviceIds_ExcelKR2(kol2, 10) = KR_2_kabel2 				' ���.�����. ������ 2
	kol2 = kol2 + 1
Next

' ===============================================================
' ������� ������ ������� ��� ������ 3
' ===============================================================

kol3 = objExcel.Cells(5, 8 )' ����� ���� ����� ������ � ����� - ���������� �������
Redim ArrDeviceIds_ExcelKR3(kol3, 11)
kol31 = kol3
kol3 = 0
For i = 0 To kol31 - 1

KR_3_shassi = objExcel.Cells( i + 61, 3 )				' ����� ��/�
KR_3_shassiCatalog = objExcel.Cells( i + 61, 4 )		' ����� � �������
KR_3_modul = objExcel.Cells( i + 61, 5 )				' ������ 
KR_3_modulCatalog = objExcel.Cells( i + 61, 6 )			' ������ � �������
KR_3_kolodka = objExcel.Cells( i + 61, 7 )				' �������
KR_3_kolodkaCatalog = objExcel.Cells( i + 61, 8 )		' ������� � �������
KR_3_rele = objExcel.Cells( i + 61, 9 )					' ����
KR_3_klemmnik1 = objExcel.Cells( i + 61, 10 )			' �������� 1
KR_3_klemmnik2 = objExcel.Cells( i + 61, 11 )			' �������� 2
KR_3_kabel1 = objExcel.Cells( i + 61, 12 )				' ������ 1
KR_3_kabel2 = objExcel.Cells( i + 61, 13 )				' ������ 2

	ArrDeviceIds_ExcelKR3(kol3, 0) = KR_3_shassi				' ���.�����. �����
	ArrDeviceIds_ExcelKR3(kol3, 1) = KR_3_shassiCatalog			' ���.�����. ����� � �������
	ArrDeviceIds_ExcelKR3(kol3, 2) = KR_3_modul 				' ���.�����. ������
	ArrDeviceIds_ExcelKR3(kol3, 3) = KR_3_modulCatalog 			' ���.�����. ������ � �������
	ArrDeviceIds_ExcelKR3(kol3, 4) = KR_3_kolodka 				' ���.�����. �������
	ArrDeviceIds_ExcelKR3(kol3, 5) = KR_3_kolodkaCatalog 		' ���.�����. ������� � �������
	ArrDeviceIds_ExcelKR3(kol3, 6) = KR_3_rele 					' ���.�����. ����
	ArrDeviceIds_ExcelKR3(kol3, 7) = KR_3_klemmnik1 			' ���.�����. �������� 1
	ArrDeviceIds_ExcelKR3(kol3, 8) = KR_3_klemmnik2 			' ���.�����. �������� 2
	ArrDeviceIds_ExcelKR3(kol3, 9) = KR_3_kabel1 				' ���.�����. ������ 1
	ArrDeviceIds_ExcelKR3(kol3, 10) = KR_3_kabel2 				' ���.�����. ������ 2
	kol3 = kol3 + 1
Next


' ===============================================================
' ===============================================================
' ������� ������� ������ 1 �� ����
' ===============================================================
kol1 = objExcel.Cells(3, 8 ) ' ���������� ���������� ������� � ������ 1
If kol1 > 0 Then 
i = 0
For i = 0 To kol1
BB0 = ArrDeviceIds_ExcelKR1(i, 0) 			' ����� ��/�
BB1 = ArrDeviceIds_ExcelKR1(i, 1)			' ����� � �������
BB2 = ArrDeviceIds_ExcelKR1(i, 2)			' ������ 
BB3 = ArrDeviceIds_ExcelKR1(i, 3)			' ������ � �������
BB4 = ArrDeviceIds_ExcelKR1(i, 4)			' �������
BB5 = ArrDeviceIds_ExcelKR1(i, 5)			' ������� � �������
BB6 = ArrDeviceIds_ExcelKR1(i, 6)			' ����
BB7 = ArrDeviceIds_ExcelKR1(i, 7)			' �������� 1
BB8 = ArrDeviceIds_ExcelKR1(i, 8)			' �������� 2
BB9 = ArrDeviceIds_ExcelKR1(i, 9)			' ������ 1
BB10 = ArrDeviceIds_ExcelKR1(i, 10)			' ������ 2


'-------------------------------------------------------------------------------------------------
If BB3 = "R500 AI 08 052-000-AAA" Then
	DocumentTypeAttr = ".DOCUMENT_TYPE" 	'������� - ��� ���������
	NameDocument = "Naimenovanie_Documenta" '������� - ������������ ���������
	SheetFormat = "Format" 					'������� - ������
	NumSheets = "_numSheetsInDoc" 			'������� - ���-�� ������
	
	Total_sheet = job.GetSheetCount()
	
	SheetName = Total_sheet + 1
	Sheet.Create 0, sheetName, "������_�3_���_2����", 0, 1
	Sheet.SetAttributeValue DocumentTypeAttr, "����� ������������� ��������������"
	
	searchSheetName = SheetName
	sheetId = sheet.Search( moduleId, searchSheetName )
	
	Call Include ("����������_R500_AI08_052-000-AAA_0.vbs") ' ������� ��������� ��������� ���� (������) - ���������� ���������
	Call Include ("����������_R500_AI08_052-000-AAA_1.vbs") ' ������� ��������� ��������� ���� (������) - ���������� ���������

	name = "-1000CH1"
	deviceDesignation = BB0
	Call Pereimenovanie_Chassi
	
	name = "-1000AI1"
	deviceDesignation = BB2
	Call Pereimenovanie
	
	name = "-1000X1"
	deviceDesignation = BB4
	Call Pereimenovanie
	
	name = "-1000XT1"
	deviceDesignation = BB7
	Call Pereimenovanie
	
	name = "-1000XT2"
	deviceDesignation = BB8
	Call Pereimenovanie
	
	name = "-1000W1"
	deviceDesignation = BB9
	Call Pereimenovanie
End If
'-------------------------------------------------------------------------------------------------
If BB3 = "R500 AI 16 012-000-AAA" Then
	DocumentTypeAttr = ".DOCUMENT_TYPE" 	'������� - ��� ���������
	NameDocument = "Naimenovanie_Documenta" '������� - ������������ ���������
	SheetFormat = "Format" 					'������� - ������
	NumSheets = "_numSheetsInDoc" 			'������� - ���-�� ������
	
	Total_sheet = job.GetSheetCount()
	
	SheetName = Total_sheet + 1
	Sheet.Create 0, sheetName, "������_�3_���_2����", 0, 1
	Sheet.SetAttributeValue DocumentTypeAttr, "����� ������������� ��������������"
	
	searchSheetName = SheetName
	sheetId = sheet.Search( moduleId, searchSheetName )
	
	Call Include ("����������_R500_AI16_012-000-AAA_0.vbs") ' ������� ��������� ��������� ���� (������) - ���������� ���������
	Call Include ("����������_R500_AI16_012-000-AAA_1.vbs") ' ������� ��������� ��������� ���� (������) - ���������� ���������


	Total_sheet = job.GetSheetCount()
	SheetName = Total_sheet + 1
	Sheet.Create 0, sheetName, "������_�3_���_2����", 0, 1
	Sheet.SetAttributeValue DocumentTypeAttr, "����� ������������� ��������������"
		searchSheetName = SheetName
		sheetId = sheet.Search( moduleId, searchSheetName )
			Call Include ("����������_R500_AI16_012-000-AAA_2.vbs") ' ������� ��������� ��������� ���� (������) - ���������� ���������

	name = "-1001CH1"
	deviceDesignation = BB0
	Call Pereimenovanie_Chassi
	
	name = "-1001AI1"
	deviceDesignation = BB2
	Call Pereimenovanie
	
	name = "-1001X1"
	deviceDesignation = BB4
	Call Pereimenovanie
	
	name = "-1001XT1"
	deviceDesignation = BB7
	Call Pereimenovanie
	
	name = "-1001XT2"
	deviceDesignation = BB8
	Call Pereimenovanie
	
	name = "-1001W1"
	deviceDesignation = BB9
	Call Pereimenovanie
	
	name = "-1001W2"
	deviceDesignation = BB10
	Call Pereimenovanie
	
End If


'-------------------------------------------------------------------------------------------------
If BB3 = "R500 AO 08 011-000-AAA" Then
	DocumentTypeAttr = ".DOCUMENT_TYPE" 	'������� - ��� ���������
	NameDocument = "Naimenovanie_Documenta" '������� - ������������ ���������
	SheetFormat = "Format" 					'������� - ������
	NumSheets = "_numSheetsInDoc" 			'������� - ���-�� ������
	
	Total_sheet = job.GetSheetCount()
	
	SheetName = Total_sheet + 1
	Sheet.Create 0, sheetName, "������_�3_���_2����", 0, 1
	Sheet.SetAttributeValue DocumentTypeAttr, "����� ������������� ��������������"
	
	searchSheetName = SheetName
	sheetId = sheet.Search( moduleId, searchSheetName )
	
	Call Include ("����������_R500_AO08_052-000-AAA_0.vbs") ' ������� ��������� ��������� ���� (������) - ���������� ���������
	Call Include ("����������_R500_AO08_052-000-AAA_1.vbs") ' ������� ��������� ��������� ���� (������) - ���������� ���������

	name = "-2000CH1"
	deviceDesignation = BB0
	Call Pereimenovanie_Chassi
	
	name = "-2000AO1"
	deviceDesignation = BB2
	Call Pereimenovanie
	
	name = "-2000X1"
	deviceDesignation = BB4
	Call Pereimenovanie
	
	name = "-2000XT1"
	deviceDesignation = BB7
	Call Pereimenovanie
	
	name = "-2000XT2"
	deviceDesignation = BB8
	Call Pereimenovanie
	
	name = "-2000W1"
	deviceDesignation = BB9
	Call Pereimenovanie
End If

'-------------------------------------------------------------------------------------------------
If BB3 = "R500 DI 32 012-000-AAA" Then
	DocumentTypeAttr = ".DOCUMENT_TYPE" 	'������� - ��� ���������
	NameDocument = "Naimenovanie_Documenta" '������� - ������������ ���������
	SheetFormat = "Format" 					'������� - ������
	NumSheets = "_numSheetsInDoc" 			'������� - ���-�� ������
	
	Total_sheet = job.GetSheetCount()
	SheetName = Total_sheet + 1
	Sheet.Create 0, sheetName, "������_�3_���_2����", 0, 1
	Sheet.SetAttributeValue DocumentTypeAttr, "����� ������������� ��������������"
		searchSheetName = SheetName
		sheetId = sheet.Search( moduleId, searchSheetName )
			Call Include ("����������_R500_DI32_012-000-AAA_0.vbs") ' ������� ��������� ��������� ���� (������) - ���������� ���������
			Call Include ("����������_R500_DI32_012-000-AAA_1.vbs") ' ������� ��������� ��������� ���� (������) - ���������� ���������

	Total_sheet = job.GetSheetCount()
	SheetName = Total_sheet + 1
	Sheet.Create 0, sheetName, "������_�3_���_2����", 0, 1
	Sheet.SetAttributeValue DocumentTypeAttr, "����� ������������� ��������������"
		searchSheetName = SheetName
		sheetId = sheet.Search( moduleId, searchSheetName )
			Call Include ("����������_R500_DI32_012-000-AAA_2.vbs") ' ������� ��������� ��������� ���� (������) - ���������� ���������

	Total_sheet = job.GetSheetCount()
	SheetName = Total_sheet + 1
	Sheet.Create 0, sheetName, "������_�3_���_2����", 0, 1
	Sheet.SetAttributeValue DocumentTypeAttr, "����� ������������� ��������������"
		searchSheetName = SheetName
		sheetId = sheet.Search( moduleId, searchSheetName )
			Call Include ("����������_R500_DI32_012-000-AAA_3.vbs") ' ������� ��������� ��������� ���� (������) - ���������� ���������

	Total_sheet = job.GetSheetCount()
	SheetName = Total_sheet + 1
	Sheet.Create 0, sheetName, "������_�3_���_2����", 0, 1
	Sheet.SetAttributeValue DocumentTypeAttr, "����� ������������� ��������������"
		searchSheetName = SheetName
		sheetId = sheet.Search( moduleId, searchSheetName )
			Call Include ("����������_R500_DI32_012-000-AAA_4.vbs") ' ������� ��������� ��������� ���� (������) - ���������� ���������


	name = "-3001CH1"
	deviceDesignation = BB0
	Call Pereimenovanie_Chassi
	
	name = "-3001DI1"
	deviceDesignation = BB2
	Call Pereimenovanie
	
	name = "-3001X1"
	deviceDesignation = BB4
	Call Pereimenovanie
	
	name = "-3001KL"
	deviceDesignation = BB6
	Call Pereimenovanie_KL
	
	name = "-3001XT1"
	deviceDesignation = BB7
	Call Pereimenovanie
	
	name = "-3001XT2"
	deviceDesignation = BB8
	Call Pereimenovanie
	
	name = "-3001W1"
	deviceDesignation = BB9
	Call Pereimenovanie
End If


'-------------------------------------------------------------------------------------------------
If BB3 = "R500 DI 32 013-000-AAA" Then
	DocumentTypeAttr = ".DOCUMENT_TYPE" 	'������� - ��� ���������
	NameDocument = "Naimenovanie_Documenta" '������� - ������������ ���������
	SheetFormat = "Format" 					'������� - ������
	NumSheets = "_numSheetsInDoc" 			'������� - ���-�� ������
	
	Total_sheet = job.GetSheetCount()
	SheetName = Total_sheet + 1
	Sheet.Create 0, sheetName, "������_�3_���_2����", 0, 1
	Sheet.SetAttributeValue DocumentTypeAttr, "����� ������������� ��������������"
		searchSheetName = SheetName
		sheetId = sheet.Search( moduleId, searchSheetName )
			Call Include ("����������_R500_DI32_013-000-AAA_0.vbs") ' ������� ��������� ��������� ���� (������) - ���������� ���������
			Call Include ("����������_R500_DI32_013-000-AAA_1.vbs") ' ������� ��������� ��������� ���� (������) - ���������� ���������

	Total_sheet = job.GetSheetCount()
	SheetName = Total_sheet + 1
	Sheet.Create 0, sheetName, "������_�3_���_2����", 0, 1
	Sheet.SetAttributeValue DocumentTypeAttr, "����� ������������� ��������������"
		searchSheetName = SheetName
		sheetId = sheet.Search( moduleId, searchSheetName )
			Call Include ("����������_R500_DI32_013-000-AAA_2.vbs") ' ������� ��������� ��������� ���� (������) - ���������� ���������

	Total_sheet = job.GetSheetCount()
	SheetName = Total_sheet + 1
	Sheet.Create 0, sheetName, "������_�3_���_2����", 0, 1
	Sheet.SetAttributeValue DocumentTypeAttr, "����� ������������� ��������������"
		searchSheetName = SheetName
		sheetId = sheet.Search( moduleId, searchSheetName )
			Call Include ("����������_R500_DI32_013-000-AAA_3.vbs") ' ������� ��������� ��������� ���� (������) - ���������� ���������

	Total_sheet = job.GetSheetCount()
	SheetName = Total_sheet + 1
	Sheet.Create 0, sheetName, "������_�3_���_2����", 0, 1
	Sheet.SetAttributeValue DocumentTypeAttr, "����� ������������� ��������������"
		searchSheetName = SheetName
		sheetId = sheet.Search( moduleId, searchSheetName )
			Call Include ("����������_R500_DI32_013-000-AAA_4.vbs") ' ������� ��������� ��������� ���� (������) - ���������� ���������


	name = "-3001CH1"
	deviceDesignation = BB0
	Call Pereimenovanie_Chassi
	
	name = "-3001DI1"
	deviceDesignation = BB2
	Call Pereimenovanie
	
	name = "-3001X1"
	deviceDesignation = BB4
	Call Pereimenovanie
	
	name = "-3001KL"
	deviceDesignation = BB6
	Call Pereimenovanie_KL
	
	name = "-3001XT1"
	deviceDesignation = BB7
	Call Pereimenovanie
	
	name = "-3001XT2"
	deviceDesignation = BB8
	Call Pereimenovanie
	
	name = "-3001W1"
	deviceDesignation = BB9
	Call Pereimenovanie
End If

'-------------------------------------------------------------------------------------------------
If BB3 = "R500 DO 32 012-000-AAA" Then
	DocumentTypeAttr = ".DOCUMENT_TYPE" 	'������� - ��� ���������
	NameDocument = "Naimenovanie_Documenta" '������� - ������������ ���������
	SheetFormat = "Format" 					'������� - ������
	NumSheets = "_numSheetsInDoc" 			'������� - ���-�� ������
	
	Total_sheet = job.GetSheetCount()
	SheetName = Total_sheet + 1
	Sheet.Create 0, sheetName, "������_�3_���_2����", 0, 1
	Sheet.SetAttributeValue DocumentTypeAttr, "����� ������������� ��������������"
		searchSheetName = SheetName
		sheetId = sheet.Search( moduleId, searchSheetName )
			Call Include ("����������_R500_DO32_012-000-AAA_0.vbs") ' ������� ��������� ��������� ���� (������) - ���������� ���������
			Call Include ("����������_R500_DO32_012-000-AAA_1.vbs") ' ������� ��������� ��������� ���� (������) - ���������� ���������

	Total_sheet = job.GetSheetCount()
	SheetName = Total_sheet + 1
	Sheet.Create 0, sheetName, "������_�3_���_2����", 0, 1
	Sheet.SetAttributeValue DocumentTypeAttr, "����� ������������� ��������������"
		searchSheetName = SheetName
		sheetId = sheet.Search( moduleId, searchSheetName )
			Call Include ("����������_R500_DO32_012-000-AAA_2.vbs") ' ������� ��������� ��������� ���� (������) - ���������� ���������

	Total_sheet = job.GetSheetCount()
	SheetName = Total_sheet + 1
	Sheet.Create 0, sheetName, "������_�3_���_2����", 0, 1
	Sheet.SetAttributeValue DocumentTypeAttr, "����� ������������� ��������������"
		searchSheetName = SheetName
		sheetId = sheet.Search( moduleId, searchSheetName )
			Call Include ("����������_R500_DO32_012-000-AAA_3.vbs") ' ������� ��������� ��������� ���� (������) - ���������� ���������

	Total_sheet = job.GetSheetCount()
	SheetName = Total_sheet + 1
	Sheet.Create 0, sheetName, "������_�3_���_2����", 0, 1
	Sheet.SetAttributeValue DocumentTypeAttr, "����� ������������� ��������������"
		searchSheetName = SheetName
		sheetId = sheet.Search( moduleId, searchSheetName )
			Call Include ("����������_R500_DO32_012-000-AAA_4.vbs") ' ������� ��������� ��������� ���� (������) - ���������� ���������


	name = "-4000CH1"
	deviceDesignation = BB0
	Call Pereimenovanie_Chassi
	
	name = "-4000DO1"
	deviceDesignation = BB2
	Call Pereimenovanie
	
	name = "-4000X1"
	deviceDesignation = BB4
	Call Pereimenovanie
	
	name = "-4000KL"
	deviceDesignation = BB6
	Call Pereimenovanie_KL
	
	name = "-4000XT1"
	deviceDesignation = BB7
	Call Pereimenovanie
	
	name = "-4000XT2"
	deviceDesignation = BB8
	Call Pereimenovanie
	
	name = "-4000W1"
	deviceDesignation = BB9
	Call Pereimenovanie
End If
Next 
End If
' ======================================================================================================



Sub  Pereimenovanie
	deviceId = device.Search(name, assignment, location)
	deviceName = device.GetName()
	result = device.SetName( deviceDesignation )
End Sub

Sub  Pereimenovanie_controller
	deviceId = device.Search(name, assignment, location)
	deviceName = device.GetName()
	result = device.SetName( deviceDesignation )
End sub


Sub  Pereimenovanie_Chassi
Dim componentVersion : componentVersion = "1"
	deviceId = device.Search(name, assignment, location)
	deviceName = device.GetName()
	result2 = device.SetName( deviceDesignation ) ' �������������� ���.�����������
	result2_1 = device.GetComponentName() ' ������������ � �� �3
	
	objExcel.Worksheets("Perechen").Activate
	For j=1 To 120
		If BB1 = objExcel.Cells( j, 4 ) Then 
			AA = objExcel.Cells( j, 2 )
			result2_2 = device.SetComponentName( AA, componentVersion )
			Exit for
		End If
	Next
	
	objExcel.Worksheets("Start").Activate
	
End sub





Function Pereimenovanie_KL
deviceCnt = job.GetAllDeviceIds(deviceIds)
For deviceIndex = 1 To deviceCnt
	deviceId = device.SetId( deviceIds( deviceIndex ) )
	
	deviceName1 = device.GetName()
	
	If InStr(1, deviceName1, name, 1) Then
	AA = Replace (deviceName1, name, deviceDesignation, 1, -1)
	result = device.SetName( AA )

	End If

Next
End Function


'===============================================================================================


'wscript.Quit




















' ===============================================================
' ===============================================================
' ������� ������� ������ 2 �� ����
' ===============================================================
kol2 = objExcel.Cells(4, 8 ) ' ���������� ���������� ������� � ������ 2
If kol2 > 0 Then 
i = 0
For i = 0 To kol2
BB0 = ArrDeviceIds_ExcelKR2(i, 0)
BB1 = ArrDeviceIds_ExcelKR2(i, 1)
BB2 = ArrDeviceIds_ExcelKR2(i, 2)
BB3 = ArrDeviceIds_ExcelKR2(i, 3)
BB4 = ArrDeviceIds_ExcelKR2(i, 4)
BB5 = ArrDeviceIds_ExcelKR2(i, 5)
BB6 = ArrDeviceIds_ExcelKR2(i, 6)
BB7 = ArrDeviceIds_ExcelKR2(i, 7)
BB8 = ArrDeviceIds_ExcelKR2(i, 8)
BB9 = ArrDeviceIds_ExcelKR2(i, 9)
BB10 = ArrDeviceIds_ExcelKR2(i, 10)

'-------------------------------------------------------------------------------------------------
'-------------------------------------------------------------------------------------------------
If BB3 = "R500 AI 08 052-000-AAA" Then
	DocumentTypeAttr = ".DOCUMENT_TYPE" 	'������� - ��� ���������
	NameDocument = "Naimenovanie_Documenta" '������� - ������������ ���������
	SheetFormat = "Format" 					'������� - ������
	NumSheets = "_numSheetsInDoc" 			'������� - ���-�� ������
	
	Total_sheet = job.GetSheetCount()
	
	SheetName = Total_sheet + 1
	Sheet.Create 0, sheetName, "������_�3_���_2����", 0, 1
	Sheet.SetAttributeValue DocumentTypeAttr, "����� ������������� ��������������"
	
	searchSheetName = SheetName
	sheetId = sheet.Search( moduleId, searchSheetName )
	
	Call Include ("����������_R500_AI08_052-000-AAA_0.vbs") ' ������� ��������� ��������� ���� (������) - ���������� ���������
	Call Include ("����������_R500_AI08_052-000-AAA_1.vbs") ' ������� ��������� ��������� ���� (������) - ���������� ���������

	name = "-1000CH1"
	deviceDesignation = BB0
	Call Pereimenovanie_Chassi
	
	name = "-1000AI1"
	deviceDesignation = BB2
	Call Pereimenovanie
	
	name = "-1000X1"
	deviceDesignation = BB4
	Call Pereimenovanie
	
	name = "-1000XT1"
	deviceDesignation = BB7
	Call Pereimenovanie
	
	name = "-1000XT2"
	deviceDesignation = BB8
	Call Pereimenovanie
	
	name = "-1000W1"
	deviceDesignation = BB9
	Call Pereimenovanie
End If
'-------------------------------------------------------------------------------------------------
If BB3 = "R500 AI 16 012-000-AAA" Then
	DocumentTypeAttr = ".DOCUMENT_TYPE" 	'������� - ��� ���������
	NameDocument = "Naimenovanie_Documenta" '������� - ������������ ���������
	SheetFormat = "Format" 					'������� - ������
	NumSheets = "_numSheetsInDoc" 			'������� - ���-�� ������
	
	Total_sheet = job.GetSheetCount()
	
	SheetName = Total_sheet + 1
	Sheet.Create 0, sheetName, "������_�3_���_2����", 0, 1
	Sheet.SetAttributeValue DocumentTypeAttr, "����� ������������� ��������������"
	
	searchSheetName = SheetName
	sheetId = sheet.Search( moduleId, searchSheetName )
	
	Call Include ("����������_R500_AI16_012-000-AAA_0.vbs") ' ������� ��������� ��������� ���� (������) - ���������� ���������
	Call Include ("����������_R500_AI16_012-000-AAA_1.vbs") ' ������� ��������� ��������� ���� (������) - ���������� ���������


	Total_sheet = job.GetSheetCount()
	SheetName = Total_sheet + 1
	Sheet.Create 0, sheetName, "������_�3_���_2����", 0, 1
	Sheet.SetAttributeValue DocumentTypeAttr, "����� ������������� ��������������"
		searchSheetName = SheetName
		sheetId = sheet.Search( moduleId, searchSheetName )
			Call Include ("����������_R500_AI16_012-000-AAA_2.vbs") ' ������� ��������� ��������� ���� (������) - ���������� ���������

	name = "-1001CH1"
	deviceDesignation = BB0
	Call Pereimenovanie_Chassi
	
	name = "-1001AI1"
	deviceDesignation = BB2
	Call Pereimenovanie
	
	name = "-1001X1"
	deviceDesignation = BB4
	Call Pereimenovanie
	
	name = "-1001XT1"
	deviceDesignation = BB7
	Call Pereimenovanie
	
	name = "-1001XT2"
	deviceDesignation = BB8
	Call Pereimenovanie
	
	name = "-1001W1"
	deviceDesignation = BB9
	Call Pereimenovanie
	
	name = "-1001W2"
	deviceDesignation = BB10
	Call Pereimenovanie
	
End If


'-------------------------------------------------------------------------------------------------
If BB3 = "R500 AO 08 011-000-AAA" Then
	DocumentTypeAttr = ".DOCUMENT_TYPE" 	'������� - ��� ���������
	NameDocument = "Naimenovanie_Documenta" '������� - ������������ ���������
	SheetFormat = "Format" 					'������� - ������
	NumSheets = "_numSheetsInDoc" 			'������� - ���-�� ������
	
	Total_sheet = job.GetSheetCount()
	
	SheetName = Total_sheet + 1
	Sheet.Create 0, sheetName, "������_�3_���_2����", 0, 1
	Sheet.SetAttributeValue DocumentTypeAttr, "����� ������������� ��������������"
	
	searchSheetName = SheetName
	sheetId = sheet.Search( moduleId, searchSheetName )
	
	Call Include ("����������_R500_AO08_052-000-AAA_0.vbs") ' ������� ��������� ��������� ���� (������) - ���������� ���������
	Call Include ("����������_R500_AO08_052-000-AAA_1.vbs") ' ������� ��������� ��������� ���� (������) - ���������� ���������

	name = "-2000CH1"
	deviceDesignation = BB0
	Call Pereimenovanie_Chassi
	
	name = "-2000AO1"
	deviceDesignation = BB2
	Call Pereimenovanie
	
	name = "-2000X1"
	deviceDesignation = BB4
	Call Pereimenovanie
	
	name = "-2000XT1"
	deviceDesignation = BB7
	Call Pereimenovanie
	
	name = "-2000XT2"
	deviceDesignation = BB8
	Call Pereimenovanie
	
	name = "-2000W1"
	deviceDesignation = BB9
	Call Pereimenovanie
End If

'-------------------------------------------------------------------------------------------------
If BB3 = "R500 DI 32 012-000-AAA" Then
	DocumentTypeAttr = ".DOCUMENT_TYPE" 	'������� - ��� ���������
	NameDocument = "Naimenovanie_Documenta" '������� - ������������ ���������
	SheetFormat = "Format" 					'������� - ������
	NumSheets = "_numSheetsInDoc" 			'������� - ���-�� ������
	
	Total_sheet = job.GetSheetCount()
	SheetName = Total_sheet + 1
	Sheet.Create 0, sheetName, "������_�3_���_2����", 0, 1
	Sheet.SetAttributeValue DocumentTypeAttr, "����� ������������� ��������������"
		searchSheetName = SheetName
		sheetId = sheet.Search( moduleId, searchSheetName )
			Call Include ("����������_R500_DI32_012-000-AAA_0.vbs") ' ������� ��������� ��������� ���� (������) - ���������� ���������
			Call Include ("����������_R500_DI32_012-000-AAA_1.vbs") ' ������� ��������� ��������� ���� (������) - ���������� ���������

	Total_sheet = job.GetSheetCount()
	SheetName = Total_sheet + 1
	Sheet.Create 0, sheetName, "������_�3_���_2����", 0, 1
	Sheet.SetAttributeValue DocumentTypeAttr, "����� ������������� ��������������"
		searchSheetName = SheetName
		sheetId = sheet.Search( moduleId, searchSheetName )
			Call Include ("����������_R500_DI32_012-000-AAA_2.vbs") ' ������� ��������� ��������� ���� (������) - ���������� ���������

	Total_sheet = job.GetSheetCount()
	SheetName = Total_sheet + 1
	Sheet.Create 0, sheetName, "������_�3_���_2����", 0, 1
	Sheet.SetAttributeValue DocumentTypeAttr, "����� ������������� ��������������"
		searchSheetName = SheetName
		sheetId = sheet.Search( moduleId, searchSheetName )
			Call Include ("����������_R500_DI32_012-000-AAA_3.vbs") ' ������� ��������� ��������� ���� (������) - ���������� ���������

	Total_sheet = job.GetSheetCount()
	SheetName = Total_sheet + 1
	Sheet.Create 0, sheetName, "������_�3_���_2����", 0, 1
	Sheet.SetAttributeValue DocumentTypeAttr, "����� ������������� ��������������"
		searchSheetName = SheetName
		sheetId = sheet.Search( moduleId, searchSheetName )
			Call Include ("����������_R500_DI32_012-000-AAA_4.vbs") ' ������� ��������� ��������� ���� (������) - ���������� ���������


	name = "-3001CH1"
	deviceDesignation = BB0
	Call Pereimenovanie_Chassi
	
	name = "-3001DI1"
	deviceDesignation = BB2
	Call Pereimenovanie
	
	name = "-3001X1"
	deviceDesignation = BB4
	Call Pereimenovanie
	
	name = "-3001KL"
	deviceDesignation = BB6
	Call Pereimenovanie_KL
	
	name = "-3001XT1"
	deviceDesignation = BB7
	Call Pereimenovanie
	
	name = "-3001XT2"
	deviceDesignation = BB8
	Call Pereimenovanie
	
	name = "-3001W1"
	deviceDesignation = BB9
	Call Pereimenovanie
End If


'-------------------------------------------------------------------------------------------------
If BB3 = "R500 DI 32 013-000-AAA" Then
	DocumentTypeAttr = ".DOCUMENT_TYPE" 	'������� - ��� ���������
	NameDocument = "Naimenovanie_Documenta" '������� - ������������ ���������
	SheetFormat = "Format" 					'������� - ������
	NumSheets = "_numSheetsInDoc" 			'������� - ���-�� ������
	
	Total_sheet = job.GetSheetCount()
	SheetName = Total_sheet + 1
	Sheet.Create 0, sheetName, "������_�3_���_2����", 0, 1
	Sheet.SetAttributeValue DocumentTypeAttr, "����� ������������� ��������������"
		searchSheetName = SheetName
		sheetId = sheet.Search( moduleId, searchSheetName )
			Call Include ("����������_R500_DI32_013-000-AAA_0.vbs") ' ������� ��������� ��������� ���� (������) - ���������� ���������
			Call Include ("����������_R500_DI32_013-000-AAA_1.vbs") ' ������� ��������� ��������� ���� (������) - ���������� ���������

	Total_sheet = job.GetSheetCount()
	SheetName = Total_sheet + 1
	Sheet.Create 0, sheetName, "������_�3_���_2����", 0, 1
	Sheet.SetAttributeValue DocumentTypeAttr, "����� ������������� ��������������"
		searchSheetName = SheetName
		sheetId = sheet.Search( moduleId, searchSheetName )
			Call Include ("����������_R500_DI32_013-000-AAA_2.vbs") ' ������� ��������� ��������� ���� (������) - ���������� ���������

	Total_sheet = job.GetSheetCount()
	SheetName = Total_sheet + 1
	Sheet.Create 0, sheetName, "������_�3_���_2����", 0, 1
	Sheet.SetAttributeValue DocumentTypeAttr, "����� ������������� ��������������"
		searchSheetName = SheetName
		sheetId = sheet.Search( moduleId, searchSheetName )
			Call Include ("����������_R500_DI32_013-000-AAA_3.vbs") ' ������� ��������� ��������� ���� (������) - ���������� ���������

	Total_sheet = job.GetSheetCount()
	SheetName = Total_sheet + 1
	Sheet.Create 0, sheetName, "������_�3_���_2����", 0, 1
	Sheet.SetAttributeValue DocumentTypeAttr, "����� ������������� ��������������"
		searchSheetName = SheetName
		sheetId = sheet.Search( moduleId, searchSheetName )
			Call Include ("����������_R500_DI32_013-000-AAA_4.vbs") ' ������� ��������� ��������� ���� (������) - ���������� ���������


	name = "-3001CH1"
	deviceDesignation = BB0
	Call Pereimenovanie_Chassi
	
	name = "-3001DI1"
	deviceDesignation = BB2
	Call Pereimenovanie
	
	name = "-3001X1"
	deviceDesignation = BB4
	Call Pereimenovanie
	
	name = "-3001KL"
	deviceDesignation = BB6
	Call Pereimenovanie_KL
	
	name = "-3001XT1"
	deviceDesignation = BB7
	Call Pereimenovanie
	
	name = "-3001XT2"
	deviceDesignation = BB8
	Call Pereimenovanie
	
	name = "-3001W1"
	deviceDesignation = BB9
	Call Pereimenovanie
End If

'-------------------------------------------------------------------------------------------------
If BB3 = "R500 DO 32 012-000-AAA" Then
	DocumentTypeAttr = ".DOCUMENT_TYPE" 	'������� - ��� ���������
	NameDocument = "Naimenovanie_Documenta" '������� - ������������ ���������
	SheetFormat = "Format" 					'������� - ������
	NumSheets = "_numSheetsInDoc" 			'������� - ���-�� ������
	
	Total_sheet = job.GetSheetCount()
	SheetName = Total_sheet + 1
	Sheet.Create 0, sheetName, "������_�3_���_2����", 0, 1
	Sheet.SetAttributeValue DocumentTypeAttr, "����� ������������� ��������������"
		searchSheetName = SheetName
		sheetId = sheet.Search( moduleId, searchSheetName )
			Call Include ("����������_R500_DO32_012-000-AAA_0.vbs") ' ������� ��������� ��������� ���� (������) - ���������� ���������
			Call Include ("����������_R500_DO32_012-000-AAA_1.vbs") ' ������� ��������� ��������� ���� (������) - ���������� ���������

	Total_sheet = job.GetSheetCount()
	SheetName = Total_sheet + 1
	Sheet.Create 0, sheetName, "������_�3_���_2����", 0, 1
	Sheet.SetAttributeValue DocumentTypeAttr, "����� ������������� ��������������"
		searchSheetName = SheetName
		sheetId = sheet.Search( moduleId, searchSheetName )
			Call Include ("����������_R500_DO32_012-000-AAA_2.vbs") ' ������� ��������� ��������� ���� (������) - ���������� ���������

	Total_sheet = job.GetSheetCount()
	SheetName = Total_sheet + 1
	Sheet.Create 0, sheetName, "������_�3_���_2����", 0, 1
	Sheet.SetAttributeValue DocumentTypeAttr, "����� ������������� ��������������"
		searchSheetName = SheetName
		sheetId = sheet.Search( moduleId, searchSheetName )
			Call Include ("����������_R500_DO32_012-000-AAA_3.vbs") ' ������� ��������� ��������� ���� (������) - ���������� ���������

	Total_sheet = job.GetSheetCount()
	SheetName = Total_sheet + 1
	Sheet.Create 0, sheetName, "������_�3_���_2����", 0, 1
	Sheet.SetAttributeValue DocumentTypeAttr, "����� ������������� ��������������"
		searchSheetName = SheetName
		sheetId = sheet.Search( moduleId, searchSheetName )
			Call Include ("����������_R500_DO32_012-000-AAA_4.vbs") ' ������� ��������� ��������� ���� (������) - ���������� ���������


	name = "-4000CH1"
	deviceDesignation = BB0
	Call Pereimenovanie_Chassi
	
	name = "-4000DO1"
	deviceDesignation = BB2
	Call Pereimenovanie
	
	name = "-4000X1"
	deviceDesignation = BB4
	Call Pereimenovanie
	
	name = "-4000KL"
	deviceDesignation = BB6
	Call Pereimenovanie_KL
	
	name = "-4000XT1"
	deviceDesignation = BB7
	Call Pereimenovanie
	
	name = "-4000XT2"
	deviceDesignation = BB8
	Call Pereimenovanie
	
	name = "-4000W1"
	deviceDesignation = BB9
	Call Pereimenovanie
End If
Next 
End If
' ======================================================================================================


'wscript.Quit

' ===============================================================
' ===============================================================
' ������� ������� ������ 3 �� ����
' ===============================================================
kol3 = objExcel.Cells(5, 8 ) ' ���������� ���������� ������� � ������ 2
If kol3 > 0 Then 
i = 0
For i = 0 To kol3
BB0 = ArrDeviceIds_ExcelKR3(i, 0)
BB1 = ArrDeviceIds_ExcelKR3(i, 1)
BB2 = ArrDeviceIds_ExcelKR3(i, 2)
BB3 = ArrDeviceIds_ExcelKR3(i, 3)
BB4 = ArrDeviceIds_ExcelKR3(i, 4)
BB5 = ArrDeviceIds_ExcelKR3(i, 5)
BB6 = ArrDeviceIds_ExcelKR3(i, 6)
BB7 = ArrDeviceIds_ExcelKR3(i, 7)
BB8 = ArrDeviceIds_ExcelKR3(i, 8)
BB9 = ArrDeviceIds_ExcelKR3(i, 9)
BB10 = ArrDeviceIds_ExcelKR3(i, 10)

'-------------------------------------------------------------------------------------------------
'-------------------------------------------------------------------------------------------------
If BB3 = "R500 AI 08 052-000-AAA" Then
	DocumentTypeAttr = ".DOCUMENT_TYPE" 	'������� - ��� ���������
	NameDocument = "Naimenovanie_Documenta" '������� - ������������ ���������
	SheetFormat = "Format" 					'������� - ������
	NumSheets = "_numSheetsInDoc" 			'������� - ���-�� ������
	
	Total_sheet = job.GetSheetCount()
	
	SheetName = Total_sheet + 1
	Sheet.Create 0, sheetName, "������_�3_���_2����", 0, 1
	Sheet.SetAttributeValue DocumentTypeAttr, "����� ������������� ��������������"
	
	searchSheetName = SheetName
	sheetId = sheet.Search( moduleId, searchSheetName )
	
	Call Include ("����������_R500_AI08_052-000-AAA_0.vbs") ' ������� ��������� ��������� ���� (������) - ���������� ���������
	Call Include ("����������_R500_AI08_052-000-AAA_1.vbs") ' ������� ��������� ��������� ���� (������) - ���������� ���������

	name = "-1000CH1"
	deviceDesignation = BB0
	Call Pereimenovanie_Chassi
	
	name = "-1000AI1"
	deviceDesignation = BB2
	Call Pereimenovanie
	
	name = "-1000X1"
	deviceDesignation = BB4
	Call Pereimenovanie
	
	name = "-1000XT1"
	deviceDesignation = BB7
	Call Pereimenovanie
	
	name = "-1000XT2"
	deviceDesignation = BB8
	Call Pereimenovanie
	
	name = "-1000W1"
	deviceDesignation = BB9
	Call Pereimenovanie
End If
'-------------------------------------------------------------------------------------------------
If BB3 = "R500 AI 16 012-000-AAA" Then
	DocumentTypeAttr = ".DOCUMENT_TYPE" 	'������� - ��� ���������
	NameDocument = "Naimenovanie_Documenta" '������� - ������������ ���������
	SheetFormat = "Format" 					'������� - ������
	NumSheets = "_numSheetsInDoc" 			'������� - ���-�� ������
	
	Total_sheet = job.GetSheetCount()
	
	SheetName = Total_sheet + 1
	Sheet.Create 0, sheetName, "������_�3_���_2����", 0, 1
	Sheet.SetAttributeValue DocumentTypeAttr, "����� ������������� ��������������"
	
	searchSheetName = SheetName
	sheetId = sheet.Search( moduleId, searchSheetName )
	
	Call Include ("����������_R500_AI16_012-000-AAA_0.vbs") ' ������� ��������� ��������� ���� (������) - ���������� ���������
	Call Include ("����������_R500_AI16_012-000-AAA_1.vbs") ' ������� ��������� ��������� ���� (������) - ���������� ���������


	Total_sheet = job.GetSheetCount()
	SheetName = Total_sheet + 1
	Sheet.Create 0, sheetName, "������_�3_���_2����", 0, 1
	Sheet.SetAttributeValue DocumentTypeAttr, "����� ������������� ��������������"
		searchSheetName = SheetName
		sheetId = sheet.Search( moduleId, searchSheetName )
			Call Include ("����������_R500_AI16_012-000-AAA_2.vbs") ' ������� ��������� ��������� ���� (������) - ���������� ���������

	name = "-1001CH1"
	deviceDesignation = BB0
	Call Pereimenovanie_Chassi
	
	name = "-1001AI1"
	deviceDesignation = BB2
	Call Pereimenovanie
	
	name = "-1001X1"
	deviceDesignation = BB4
	Call Pereimenovanie
	
	name = "-1001XT1"
	deviceDesignation = BB7
	Call Pereimenovanie
	
	name = "-1001XT2"
	deviceDesignation = BB8
	Call Pereimenovanie
	
	name = "-1001W1"
	deviceDesignation = BB9
	Call Pereimenovanie
	
	name = "-1001W2"
	deviceDesignation = BB10
	Call Pereimenovanie
	
End If


'-------------------------------------------------------------------------------------------------
If BB3 = "R500 AO 08 011-000-AAA" Then
	DocumentTypeAttr = ".DOCUMENT_TYPE" 	'������� - ��� ���������
	NameDocument = "Naimenovanie_Documenta" '������� - ������������ ���������
	SheetFormat = "Format" 					'������� - ������
	NumSheets = "_numSheetsInDoc" 			'������� - ���-�� ������
	
	Total_sheet = job.GetSheetCount()
	
	SheetName = Total_sheet + 1
	Sheet.Create 0, sheetName, "������_�3_���_2����", 0, 1
	Sheet.SetAttributeValue DocumentTypeAttr, "����� ������������� ��������������"
	
	searchSheetName = SheetName
	sheetId = sheet.Search( moduleId, searchSheetName )
	
	Call Include ("����������_R500_AO08_052-000-AAA_0.vbs") ' ������� ��������� ��������� ���� (������) - ���������� ���������
	Call Include ("����������_R500_AO08_052-000-AAA_1.vbs") ' ������� ��������� ��������� ���� (������) - ���������� ���������

	name = "-2000CH1"
	deviceDesignation = BB0
	Call Pereimenovanie_Chassi
	
	name = "-2000AO1"
	deviceDesignation = BB2
	Call Pereimenovanie
	
	name = "-2000X1"
	deviceDesignation = BB4
	Call Pereimenovanie
	
	name = "-2000XT1"
	deviceDesignation = BB7
	Call Pereimenovanie
	
	name = "-2000XT2"
	deviceDesignation = BB8
	Call Pereimenovanie
	
	name = "-2000W1"
	deviceDesignation = BB9
	Call Pereimenovanie
End If

'-------------------------------------------------------------------------------------------------
If BB3 = "R500 DI 32 012-000-AAA" Then
	DocumentTypeAttr = ".DOCUMENT_TYPE" 	'������� - ��� ���������
	NameDocument = "Naimenovanie_Documenta" '������� - ������������ ���������
	SheetFormat = "Format" 					'������� - ������
	NumSheets = "_numSheetsInDoc" 			'������� - ���-�� ������
	
	Total_sheet = job.GetSheetCount()
	SheetName = Total_sheet + 1
	Sheet.Create 0, sheetName, "������_�3_���_2����", 0, 1
	Sheet.SetAttributeValue DocumentTypeAttr, "����� ������������� ��������������"
		searchSheetName = SheetName
		sheetId = sheet.Search( moduleId, searchSheetName )
			Call Include ("����������_R500_DI32_012-000-AAA_0.vbs") ' ������� ��������� ��������� ���� (������) - ���������� ���������
			Call Include ("����������_R500_DI32_012-000-AAA_1.vbs") ' ������� ��������� ��������� ���� (������) - ���������� ���������

	Total_sheet = job.GetSheetCount()
	SheetName = Total_sheet + 1
	Sheet.Create 0, sheetName, "������_�3_���_2����", 0, 1
	Sheet.SetAttributeValue DocumentTypeAttr, "����� ������������� ��������������"
		searchSheetName = SheetName
		sheetId = sheet.Search( moduleId, searchSheetName )
			Call Include ("����������_R500_DI32_012-000-AAA_2.vbs") ' ������� ��������� ��������� ���� (������) - ���������� ���������

	Total_sheet = job.GetSheetCount()
	SheetName = Total_sheet + 1
	Sheet.Create 0, sheetName, "������_�3_���_2����", 0, 1
	Sheet.SetAttributeValue DocumentTypeAttr, "����� ������������� ��������������"
		searchSheetName = SheetName
		sheetId = sheet.Search( moduleId, searchSheetName )
			Call Include ("����������_R500_DI32_012-000-AAA_3.vbs") ' ������� ��������� ��������� ���� (������) - ���������� ���������

	Total_sheet = job.GetSheetCount()
	SheetName = Total_sheet + 1
	Sheet.Create 0, sheetName, "������_�3_���_2����", 0, 1
	Sheet.SetAttributeValue DocumentTypeAttr, "����� ������������� ��������������"
		searchSheetName = SheetName
		sheetId = sheet.Search( moduleId, searchSheetName )
			Call Include ("����������_R500_DI32_012-000-AAA_4.vbs") ' ������� ��������� ��������� ���� (������) - ���������� ���������


	name = "-3001CH1"
	deviceDesignation = BB0
	Call Pereimenovanie_Chassi
	
	name = "-3001DI1"
	deviceDesignation = BB2
	Call Pereimenovanie
	
	name = "-3001X1"
	deviceDesignation = BB4
	Call Pereimenovanie
	
	name = "-3001KL"
	deviceDesignation = BB6
	Call Pereimenovanie_KL
	
	name = "-3001XT1"
	deviceDesignation = BB7
	Call Pereimenovanie
	
	name = "-3001XT2"
	deviceDesignation = BB8
	Call Pereimenovanie
	
	name = "-3001W1"
	deviceDesignation = BB9
	Call Pereimenovanie
End If


'-------------------------------------------------------------------------------------------------
If BB3 = "R500 DI 32 013-000-AAA" Then
	DocumentTypeAttr = ".DOCUMENT_TYPE" 	'������� - ��� ���������
	NameDocument = "Naimenovanie_Documenta" '������� - ������������ ���������
	SheetFormat = "Format" 					'������� - ������
	NumSheets = "_numSheetsInDoc" 			'������� - ���-�� ������
	
	Total_sheet = job.GetSheetCount()
	SheetName = Total_sheet + 1
	Sheet.Create 0, sheetName, "������_�3_���_2����", 0, 1
	Sheet.SetAttributeValue DocumentTypeAttr, "����� ������������� ��������������"
		searchSheetName = SheetName
		sheetId = sheet.Search( moduleId, searchSheetName )
			Call Include ("����������_R500_DI32_013-000-AAA_0.vbs") ' ������� ��������� ��������� ���� (������) - ���������� ���������
			Call Include ("����������_R500_DI32_013-000-AAA_1.vbs") ' ������� ��������� ��������� ���� (������) - ���������� ���������

	Total_sheet = job.GetSheetCount()
	SheetName = Total_sheet + 1
	Sheet.Create 0, sheetName, "������_�3_���_2����", 0, 1
	Sheet.SetAttributeValue DocumentTypeAttr, "����� ������������� ��������������"
		searchSheetName = SheetName
		sheetId = sheet.Search( moduleId, searchSheetName )
			Call Include ("����������_R500_DI32_013-000-AAA_2.vbs") ' ������� ��������� ��������� ���� (������) - ���������� ���������

	Total_sheet = job.GetSheetCount()
	SheetName = Total_sheet + 1
	Sheet.Create 0, sheetName, "������_�3_���_2����", 0, 1
	Sheet.SetAttributeValue DocumentTypeAttr, "����� ������������� ��������������"
		searchSheetName = SheetName
		sheetId = sheet.Search( moduleId, searchSheetName )
			Call Include ("����������_R500_DI32_013-000-AAA_3.vbs") ' ������� ��������� ��������� ���� (������) - ���������� ���������

	Total_sheet = job.GetSheetCount()
	SheetName = Total_sheet + 1
	Sheet.Create 0, sheetName, "������_�3_���_2����", 0, 1
	Sheet.SetAttributeValue DocumentTypeAttr, "����� ������������� ��������������"
		searchSheetName = SheetName
		sheetId = sheet.Search( moduleId, searchSheetName )
			Call Include ("����������_R500_DI32_013-000-AAA_4.vbs") ' ������� ��������� ��������� ���� (������) - ���������� ���������


	name = "-3001CH1"
	deviceDesignation = BB0
	Call Pereimenovanie_Chassi
	
	name = "-3001DI1"
	deviceDesignation = BB2
	Call Pereimenovanie
	
	name = "-3001X1"
	deviceDesignation = BB4
	Call Pereimenovanie
	
	name = "-3001KL"
	deviceDesignation = BB6
	Call Pereimenovanie_KL
	
	name = "-3001XT1"
	deviceDesignation = BB7
	Call Pereimenovanie
	
	name = "-3001XT2"
	deviceDesignation = BB8
	Call Pereimenovanie
	
	name = "-3001W1"
	deviceDesignation = BB9
	Call Pereimenovanie
End If

'-------------------------------------------------------------------------------------------------
If BB3 = "R500 DO 32 012-000-AAA" Then
	DocumentTypeAttr = ".DOCUMENT_TYPE" 	'������� - ��� ���������
	NameDocument = "Naimenovanie_Documenta" '������� - ������������ ���������
	SheetFormat = "Format" 					'������� - ������
	NumSheets = "_numSheetsInDoc" 			'������� - ���-�� ������
	
	Total_sheet = job.GetSheetCount()
	SheetName = Total_sheet + 1
	Sheet.Create 0, sheetName, "������_�3_���_2����", 0, 1
	Sheet.SetAttributeValue DocumentTypeAttr, "����� ������������� ��������������"
		searchSheetName = SheetName
		sheetId = sheet.Search( moduleId, searchSheetName )
			Call Include ("����������_R500_DO32_012-000-AAA_0.vbs") ' ������� ��������� ��������� ���� (������) - ���������� ���������
			Call Include ("����������_R500_DO32_012-000-AAA_1.vbs") ' ������� ��������� ��������� ���� (������) - ���������� ���������

	Total_sheet = job.GetSheetCount()
	SheetName = Total_sheet + 1
	Sheet.Create 0, sheetName, "������_�3_���_2����", 0, 1
	Sheet.SetAttributeValue DocumentTypeAttr, "����� ������������� ��������������"
		searchSheetName = SheetName
		sheetId = sheet.Search( moduleId, searchSheetName )
			Call Include ("����������_R500_DO32_012-000-AAA_2.vbs") ' ������� ��������� ��������� ���� (������) - ���������� ���������

	Total_sheet = job.GetSheetCount()
	SheetName = Total_sheet + 1
	Sheet.Create 0, sheetName, "������_�3_���_2����", 0, 1
	Sheet.SetAttributeValue DocumentTypeAttr, "����� ������������� ��������������"
		searchSheetName = SheetName
		sheetId = sheet.Search( moduleId, searchSheetName )
			Call Include ("����������_R500_DO32_012-000-AAA_3.vbs") ' ������� ��������� ��������� ���� (������) - ���������� ���������

	Total_sheet = job.GetSheetCount()
	SheetName = Total_sheet + 1
	Sheet.Create 0, sheetName, "������_�3_���_2����", 0, 1
	Sheet.SetAttributeValue DocumentTypeAttr, "����� ������������� ��������������"
		searchSheetName = SheetName
		sheetId = sheet.Search( moduleId, searchSheetName )
			Call Include ("����������_R500_DO32_012-000-AAA_4.vbs") ' ������� ��������� ��������� ���� (������) - ���������� ���������


	name = "-4000CH1"
	deviceDesignation = BB0
	Call Pereimenovanie_Chassi
	
	name = "-4000DO1"
	deviceDesignation = BB2
	Call Pereimenovanie
	
	name = "-4000X1"
	deviceDesignation = BB4
	Call Pereimenovanie
	
	name = "-4000KL"
	deviceDesignation = BB6
	Call Pereimenovanie_KL
	
	name = "-4000XT1"
	deviceDesignation = BB7
	Call Pereimenovanie
	
	name = "-4000XT2"
	deviceDesignation = BB8
	Call Pereimenovanie
	
	name = "-4000W1"
	deviceDesignation = BB9
	Call Pereimenovanie
End If
Next 
End If
' ======================================================================================================
































'===============================================================================================


' ===============================================================
' ���������� ������ �� ������
' ===============================================================
'Call Include("�����_200_Proekt.vbs")


' ===============================================================
' ������� ������� ��� �3
' ===============================================================
'Call Vstavka_stranits



'

app.PutInfo 0, "==============================================================="
app.PutInfo 0, "��������� ���������"
app.PutInfo 0, "==============================================================="





' ===============================================================
' ��������� ����������� ����
' ===============================================================
Sub Include (ByVal fileName)
	' ���������� ��� ������ � �������
	Dim fso
	Set fso = CreateObject("Scripting.FileSystemObject")
	' ������ ������ ����� �������
	Dim thisFolder: thisFolder = fso.GetParentFolderName(WScript.ScriptFullName)
	' ������ ���� �� ������� �������
	Dim fileFullName
	fileFullName = fso.BuildPath(thisFolder, fileName)
	' �������� �����
	If (fso.FileExists(fileFullName)) Then
		' ��������� ���
'		Call ExecuteGlobal(fso.OpenTextFile(fileFullName).ReadAll())
		Call ExecuteGlobal(fso.OpenTextFile(fileFullName, 1, False, -2 ).ReadAll())
	Else
		' ����� ��������� �� ������
		Call MsgBox("������ �������� ����� " & fileFullName & ". ����� �� ����������!", 16, "������ �������� �����")
		' ������� �������
		Set fso = Nothing
		' ����� �� ���������� �������
		WScript.Quit
	End If
	' ������� �������
	Set fso = Nothing
End Sub




Set sym = Nothing
Set component = Nothing
Set symbol = Nothing
Set slot = Nothing
Set devicePin = Nothing
Set connection = Nothing
Set pin = Nothing
Set device = Nothing
Set dev = Nothing
Set sheet = Nothing
Set job = Nothing
Set e3 = Nothing
wscript.Quit