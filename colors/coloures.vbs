' =================
' ��������� �������
' =================

' ����������
' �������� ������ �� ��������� ����� (��������� 1)
Const flagModeDoOnlyActiveSheet = False
' ��������� ������������� ��� ���������� ������ (��������� 2)
Const flagModeDoSelectedSheets = True
' ��������� ������������� ��� ���� �������� � ���������� ������ (��������� 2)
Const flagModeDoSelectedFolders = True

' �������� � ��������� ������ � ����� ������, �� ���� ���� ���������� ������ �������� ����, �� ������ ������ ������, ���� ����� ��������
Const flagModeDoSelectedOnlyOneSheet = False

'--------------------------------------------------------------

' ����� ������� �������� ������ ("��" = true, "���" - false)
Const deBugInputMode = false
' ����� ������� �������� ��������� ������ ("��" = true, "���" - false)
Const deBugProcessMode = false
' ����� ������� ������ ������ ("��" = true, "���" - false)
Const deBugOutputMode = false
' ����� ������ ��������� � ���� ����������� ��� ������ ������������� ��� ��������� ������������
Const showMessageMode = True

' ���� ���� �������, ���������������� (��������� ������ ���� ���������), �� �������� = 1
' ���� ��������� ����������� � ������������ � ������ �������/����, �� �������� = 2
' ���� ��������� ����������� � ������������ � ������ ���� �������/����, �� �������� = 0 
Const modeManualSetting = 2
' ������������� ����, ���� ��������� ������������ ��������� �� �������� ����� ���� ������ ��� ����� ��� ����������� �����������, �� true
Const flagSetColourFromSignalName = True
' ������������� ����, ���� ��������� ������������ ��������� �� ���������� �������� ���� ���� -  ������ ��� ����� ��� ����������� �����������, �� true
Const flagSetColourFromCoreForSignalName = False

' ������� ����� ����� ��-���������
Const netSegmentLineWidthForOneSignal = 0.5
' ���������� ��������� ��� ����������� ���� ��� ����� ����� � ��������
Const netSegmentLineWidthForTwoSignal = 0.8

' ===============================================================================================
' ��������� � ���������� �� ��������� ������ ��� ���������� (��� modeManualSetting = 1)
Sub SubGetColourByUserSetting(ByVal cor, ByVal cab, ByVal job, ByRef netSegmentLineColour, ByRef netSegmentLineStyle, ByRef netSegmentLineWidth)
	' ���������� ������� �� ������� ����� ����������� ����

	' ��������� ������� � ������������ � ����������	�� ���������
	netSegmentLineWidth = netSegmentLineWidthForOneSignal
	' ������� 1
	If cab.IsWiregroup Then
		' ������� 1 - ���� ������ �� ����� ����� ������ ����� ���� 15
		netSegmentLineColour = "15"
		netSegmentLineStyle = "1"
		If netCoreColourDescription = "�����-�������" Then
			netSegmentLineColour = "58"
			netSegmentLineStyle = "5"
		End If
		' -----------------------	
	ElseIf cab.GetAttributeValue("���. �������� 1") = "1" Then
		' ������� 2 - ���� ������ �� ����� ����� ������ ����� ���� 17
		netSegmentLineColour = "17"
		netSegmentLineStyle = "1"
		netSegmentLineWidth = netSegmentLineWidthForTwoSignal
		' -----------------------
	ElseIf cab.GetAttributeValue("���. �������� 1") = "2" Then
		' ������� 3 - ���� ������ �� ����� ����� ������ ����� ���� 18
		netSegmentLineColour = "18"
		netSegmentLineStyle = "1"
		netSegmentLineWidth = netSegmentLineWidthForTwoSignal
		' -----------------------
	Else
		' ������� �� ����������� - ����� ����� ������ ����� ���� ������, �.�. 0
		netSegmentLineColour = "0"
		netSegmentLineStyle = "1"
		' -----------------------				
	End If
End Sub


' ===============================================================================================
' ��������� ���������� ������ �� ����� ���������� (��� modeManualSetting = 2)
Sub SubGetColourFromCore(ByVal coreColourDescription, ByRef netSegmentLineColour, ByRef netSegmentLineStyle, ByRef netSegmentLineWidth)
	' ��������� �������� �� ���������
	netSegmentLineColour = "256"
	netSegmentLineStyle = "1"
	' ��������� ������� � ������������ � ����������	�� ���������
	netSegmentLineWidth = netSegmentLineWidthForOneSignal
	' ������� ������������
	If coreColourDescription = "������" Then
		netSegmentLineColour = "0"
		netSegmentLineStyle = "1"
	ElseIf coreColourDescription = "�����" Then
		netSegmentLineColour = "19"
		netSegmentLineStyle = "1"
	ElseIf coreColourDescription = "�������" Then
		netSegmentLineColour = "13"
		netSegmentLineStyle = "1"
	ElseIf coreColourDescription = "�������" Or coreColourDescription = "������" Then
		netSegmentLineColour = "14"
		netSegmentLineStyle = "1"
	ElseIf coreColourDescription = "����������" Then
		netSegmentLineColour = "30"
		netSegmentLineStyle = "1"
	ElseIf coreColourDescription = "�������" Then
		netSegmentLineColour = "16"
		netSegmentLineStyle = "1"
	ElseIf coreColourDescription = "���������" Then
		netSegmentLineColour = "57"
		netSegmentLineStyle = "1"
	ElseIf coreColourDescription = "������" Or coreColourDescription = "�����" Then
		netSegmentLineColour = "15"
		netSegmentLineStyle = "1"
	ElseIf coreColourDescription = "����������" Then
		netSegmentLineColour = "5"
		netSegmentLineStyle = "1"
	ElseIf coreColourDescription = "�����" Then
		netSegmentLineColour = "12"
		netSegmentLineStyle = "1"
	ElseIf coreColourDescription = "�������" Then
		netSegmentLineColour = "17"
		netSegmentLineStyle = "1"
	ElseIf coreColourDescription = "����������" Then
		netSegmentLineColour = "63"
		netSegmentLineStyle = "1"
	ElseIf coreColourDescription = "���������" Then
		netSegmentLineColour = "200"
		netSegmentLineStyle = "1"
	ElseIf coreColourDescription = "�����������" Then
		netSegmentLineColour = "8"
		netSegmentLineStyle = "1"
	ElseIf coreColourDescription = "�����-�������" Or coreColourDescription = "����-������" Or coreColourDescription = "������-������" Or coreColourDescription = "�����-�����" Then
		netSegmentLineColour = "58"
		netSegmentLineStyle = "5"
	ElseIf coreColourDescription = "�����" Then
		netSegmentLineColour = "16"
		netSegmentLineStyle = "1"
	End If
End Sub

' ===============================================================================================
' ��������� ���������� ������ �� �������� ����� ���� (��� modeManualSetting = 0 � flagSetColourFromSignalName = True)
Sub SubGetColourFromSignalName(ByVal signalName, ByRef netSegmentLineColour, ByRef netSegmentLineStyle, ByRef netSegmentLineWidth)
	' ��������� �������� �� ���������
	netSegmentLineColour = "205"
	netSegmentLineStyle = "1"
	' ��������� ������� � ������������ � ����������	�� ���������
	netSegmentLineWidth = netSegmentLineWidthForOneSignal
	' ������� ������������
	If signalName = "2L1" Or signalName = "L1" Or signalName = "1L1" Then
		netSegmentLineColour = "0"
		netSegmentLineStyle = "1"
		netSegmentLineWidth = 2
	ElseIf signalName = "2L2" Or signalName = "L2" Or signalName = "1L2" Then
		netSegmentLineColour = "38"
		netSegmentLineStyle = "1"
		netSegmentLineWidth = 2
	ElseIf signalName = "2L3" Or signalName = "L3" Or signalName = "1L3" Then
		netSegmentLineColour = "11"
		netSegmentLineStyle = "1"
		netSegmentLineWidth = 2
	ElseIf signalName = "N" Or signalName = "1N" Or signalName = "2N" Or signalName = "3N" Or signalName = "N1" Or signalName = "N2" Or signalName = "N.A" Or signalName = "N2_1" Or signalName = "N2_2" Then
		netSegmentLineColour = "160"
		netSegmentLineStyle = "4"
		netSegmentLineWidth = 1
	ElseIf signalName = "PE" Or signalName = "PEN" Then
		netSegmentLineColour = "58"
		netSegmentLineStyle = "5"
		netSegmentLineWidth = 1
	ElseIf signalName = "L1.A" Or signalName = "-24D" Then
		netSegmentLineColour = "0"
		netSegmentLineStyle = "4"
		netSegmentLineWidth = 1	
	ElseIf signalName = "+24" Or signalName = "+24_1" Or signalName = "+24_2" Or signalName = "+24_3" Or signalName = "+24_4" Or signalName = "A" Then
		netSegmentLineColour = "10"
		netSegmentLineStyle = "4"
		netSegmentLineWidth = 1	
	ElseIf signalName = "-24" Or signalName = "B" Or signalName = "-24_1" Or signalName = "-24_2" Or signalName = "-24_3" Or signalName = "-24_4" Then
		netSegmentLineColour = "12"
		netSegmentLineStyle = "4"
		netSegmentLineWidth = 1
    ElseIf signalName = "L24" Or signalName = "N24" Or signalName = "N24_1" Or signalName = "24AC" Or signalName = "+24D" Then
		netSegmentLineColour = "25"
		netSegmentLineStyle = "4"
		netSegmentLineWidth = 1		
	End If
End Sub
' ===============================================================================================
' =============================
' ���������� ���������� ����������
Dim app, appId, appVersion, jobId, jobName, resultMsg

' ��������� ������
Call SubStartScript()

' ��������� � ��������� ���� �������
Call SubMainProcessScript()

' ��������� ������
Call SubFinishScript(False)

' ������ ������� ���������
' =====================================
' ===============================================================================================
' ===============================================================================================

' ==========
' ���������:
' ==========
' =========================
' ��������� ������� �������
' =========================
Sub SubStartScript()
	' ������ ������ app
	Set app = CreateObject ("CT.Application")
	' ������������� ��������
	appId = app.GetId()
	' ���� ��� ��������� ���������� E3.series ��
	If (appId = 0) Then
		' ������� ��������� �� ������
		msgbox("��� ����������� ���������� E3.series. �����!")
		' �������
		Call SubFinishScript(True)
	End If
	' ������� ������ E3.series
	appVersion = CInt(app.GetVersion())
	' ������ ������ job
	Dim job
	Set job = app.CreateJobObject ()
	' ���������� ������������� �������
	jobId = job.GetId()
	' �������� ��������� �������
	If (jobId = 0) Then
		' ������� ��������� �� ������
		resultMsg = app.PutError(1, "��� ��������� �������!")
		' �������
		Call SubFinishScript(True)
	End If

	' ��������� ��� �������
	jobName = job.GetName
	If showMessageMode Then resultMsg = resultMsg = app.PutMessage("")
	If showMessageMode Then resultMsg = app.PutMessage("")
	If showMessageMode Then resultMsg = app.PutMessage("")
	If showMessageMode Then resultMsg = app.PutInfo(0, "=========================================")
	If showMessageMode Then resultMsg = app.PutInfo(0, "������ ������ ��������������� ���������� ������ ������ ����� '" & jobName & "'", job.GetId)

	' �������
	Set job = Nothing

End Sub

' ===================================
' ��������� ���������
Sub SubFinishScript(ByVal flagExitScript)
	' ������ ������ job
	Dim job
	Set job = app.CreateJobObject ()

	' �������� ����� ���������� ������
	If flagExitScript Then
		' ����� � �������
		If showMessageMode Then resultMsg = app.PutInfo(0, "=========================================")
		If showMessageMode Then resultMsg = app.PutError(0, "������ ������������� �� ���������! �����...")
	Else
		' �������� �����
		If showMessageMode Then resultMsg = app.PutInfo(0, "=========================================")
		If showMessageMode Then resultMsg = app.PutInfo(0, "������ ������������� ������� ���������! �����...")
	End If
	' �������� �������
	Set job = Nothing
	Set app = Nothing

	'������ ���������, �������
	wscript.quit
End Sub

' ===============================
' ��������� �������� ���� �������

Sub SubMainProcessScript()
	' ������ ������ job
	Dim job
	Set job = app.CreateJobObject ()

	' �������� ������������ ��������
	' ����� ��������� ��������

	If flagModeDoOnlyActiveSheet Then
		If showMessageMode Then resultMsg = app.PutInfo(0, "�������� ����� ������ ������ � �������� ������ � ���������!")
	Else
		If showMessageMode Then resultMsg = app.PutInfo(0, "��������� ����� ������ ������ � �������� ������ � ���������!")

		If flagModeDoSelectedSheets Then
			If showMessageMode Then resultMsg = app.PutInfo(0, "�������� ����� ������ � ����������� �������!")
		Else
			If showMessageMode Then resultMsg = app.PutInfo(0, "��������� ����� ������ � ����������� �������!")
		End If
		If flagModeDoSelectedFolders Then
			If showMessageMode Then resultMsg = app.PutInfo(0, "�������� ����� ������ � ����������� �������!")
		Else
			If showMessageMode Then resultMsg = app.PutInfo(0, "��������� ����� ������ � ����������� �������!")
		End If
	End If

	If flagModeDoSelectedOnlyOneSheet Then
		If showMessageMode Then resultMsg = app.PutInfo(0, "�������� ����� ������ ������ � ����� ���������� ������ � ���������!")
	Else
		If showMessageMode Then resultMsg = app.PutInfo(0, "��������� ����� ������ ������ � ����� ���������� ������ � ���������!")
	End If


	' ------------------------------------------------------
	If showMessageMode Then resultMsg = app.PutInfo(0, "----------------------------------------")

	' ===============================================
	' ������ ������ tree
	Dim tree, treeId
	Set tree = job.CreateTreeObject
	' ������������� �������� ������ �������
	treeId = tree.SetId(job.GetActiveTreeId())
	' �������� ���� (�������������)
	activeSheetId = job.GetActiveSheetId

	' ===============================================
	' ���������� �������������� ���������� ��������
	Dim shtId, activeSheetId
	' ���������� ������� ��� �������� ������
	Dim dictSheetIds, dictSheetCnt
	Set dictSheetIds = CreateObject("Scripting.Dictionary")
	dictSheetCnt = 0
	' ������� ��� ���
	Dim dictCoreIds, dictCoreCnt
	Set dictCoreIds = CreateObject("Scripting.Dictionary")
	dictCoreCnt = 0

	' ===========================
	' ���� �������� ������
	'-------------------------------------------
	' ������ ������ � ����������� �� ���������� ��������� ����� 
	If (flagModeDoOnlyActiveSheet) Then
		' ���� ���, �� �������� ������ �� ��������� ����� ��
		' ��������� � ���������
		dictSheetCnt = FunGetDictSheetIds(activeSheetId, dictSheetIds, dictCoreIds)
		If deBugInputMode Then resultMsg = app.PutInfo(0, "������������� ����������� �� ��������� �����...", activeSheetId)
	Else
		' ����� ����� � ������ ������
		' ����� ���������� � ������ ������
		cntTreeSelectedSheet = tree.GetSelectedSheetIds(treeSelectedSheetIds)
		If deBugInputMode Then resultMsg = app.PutInfo(0, "���������� ���������� ������ � ������ = " & cntTreeSelectedSheet)
		' �������� ������� ���������� � ������ ��������
		If (cntTreeSelectedSheet > 0) And flagModeDoSelectedSheets Then
			' ������� �������� 
			For iTreeSelectedSheet = 1 To cntTreeSelectedSheet
				shtId = treeSelectedSheetIds(iTreeSelectedSheet)
				dictSheetCnt = FunGetDictSheetIds(shtId, dictSheetIds, dictCoreIds)
			Next
		End If

		' ����� ������ � ���������� ������
		cntTreeSelectedSheetByFolder = tree.GetSelectedSheetIdsByFolder(treeSelectedSheetIdsByFolder)
		If deBugInputMode Then resultMsg = app.PutInfo(0, "���������� ���������� ������ � ����� ������ = " & cntTreeSelectedSheetByFolder)
		' �������� ������� ���������� � ������ ������� 
		If (cntTreeSelectedSheetByFolder > 0) And flagModeDoSelectedFolders Then
			' ������� ��������� ������� 
			For iTreeSelectedSheetByFolder = 1 To cntTreeSelectedSheetByFolder
				shtId = treeSelectedSheetIdsByFolder(iTreeSelectedSheetByFolder)
				dictSheetCnt = FunGetDictSheetIds(shtId, dictSheetIds, dictCoreIds)
			Next
		End If
	End If

	' ���� �� ����� ���������� �����, �� ���� ��������
	If ((activeSheetId > 0) And (dictSheetCnt = 0)) Then
		' ��������� � ���������
		dictSheetCnt = FunGetDictSheetIds(activeSheetId, dictSheetIds, dictCoreIds)
		If deBugInputMode Then resultMsg = app.PutInfo(0, "������������� ����������� �� ��������� �����...", activeSheetId)
	End If

	If showMessageMode Then resultMsg = app.PutInfo(0, "----------------------------------------")
	If showMessageMode Then resultMsg = app.PutInfo(0, "���������� ������ � ��������� = " & dictSheetCnt)

	' ================================
	' ������ �� ����� ���������� �������
	If ((dictSheetCnt > 0) And (Not flagModeDoSelectedOnlyOneSheet)) Or ((dictSheetCnt = 1) And (flagModeDoSelectedOnlyOneSheet)) Then
		If showMessageMode Then resultMsg = app.PutMessage(vbTab & "����������� ���� ������ � ������ � �� ����������...")
		' �������� ������� ��� �������� ���� ������ ������
		ReDim arrSortSheetIds(dictSheetCnt - 1, 4)
		' ���������� �������
		For shti = 0 To dictSheetCnt - 1
			' ��������� ��������������
			shtId = dictSheetIds.Keys()(shti)
			' ���������� �������
			arrSortSheetIds(shti, 0) = shtId
			arrSortSheetIds(shti, 1) = dictSheetIds.Item(shtId).Assignment
			arrSortSheetIds(shti, 2) = dictSheetIds.Item(shtId).Location
			arrSortSheetIds(shti, 3) = dictSheetIds.Item(shtId).DOCUMENTTYPE
			arrSortSheetIds(shti, 4) = dictSheetIds.Item(shtId).Name

		Next

		' ���������� ������
		Call subSortArrayByIndexEx(arrSortSheetIds, array(2, 3, 4, 5), array(2, 2, 2, 2), array(0, 0, 0, 0))

		' ------------------------------------------
		' ������� ������� ������
		For shti = 0 To dictSheetCnt - 1
			' ��������� ��������������
			shtId = dictSheetIds.Keys()(shti)
			If showMessageMode Then resultMsg = app.PutInfo(0, "----------------------------------------")
			If showMessageMode Then resultMsg = app.PutInfo(0, "�������� � ������ = " & dictSheetIds.Item(shtId).Assignment & " " & dictSheetIds.Item(shtId).Location & " / " & dictSheetIds.Item(shtId).DOCUMENTTYPE & " / ���� " & dictSheetIds.Item(shtId).Name & " - ������ �����: " & dictSheetIds.Item(shtId).Format, shtId)

			' �������� ���������� ��������� ����� �� �����
			If (dictSheetIds.Item(shtId).DictNetSegmentIds.Count > 0) Then
				' ����� ���������
				If showMessageMode Then resultMsg = app.PutInfo(0, vbTab & "����������� ���� ������ ��������� ����������� �����...")
				' �������
				For Each nsegId In dictSheetIds.Item(shtId).DictNetSegmentIds.Keys()
					' ������� � ������ � ������ �� �����
					Call subWorkShtNetSegmentIds(nsegId, dictCoreIds)
				Next
			Else
				' ���� �� ������� �������� ������, �� ������� ��������� � ������� � �������...
				If showMessageMode Then resultMsg = app.PutWarning(0, vbTab & "�� ������� ����� � ������� ��� ����������� �����!")
			End If
		Next

		' ������� ��������
		Erase arrSortSheetIds

	ElseIf ((dictSheetCnt = 0) And ((flagModeDoOnlyActiveSheet) Or (flagModeDoSelectedSymbols) Or (flagModeDoTriggerAfterModifySymbol))) Then
		If showMessageMode Then resultMsg = app.PutError(1, "� ������� '" & jobName & "' �� ������ �������� ����!", job.GetId)
		' �������
		Call SubFinishScript(True)
	Else
		If ((Not flagModeDoSelectedSymbols) And (Not flagModeDoTriggerAfterModifySymbol)) Then
			If showMessageMode Then resultMsg = app.PutError(1, "��� ���������� � ������ ������ � ������� '" & jobName & "'", job.GetId)
			' �������
			Call SubFinishScript(Not flagExitScript)
		End If
	End If

	If ((dictSheetCnt > 1) And (flagModeDoSelectedOnlyOneSheet)) Then
		If showMessageMode Then resultMsg = app.PutError(1, "� ��������� ������ ���� ������ ���� ����!")
		' �������
		Call SubFinishScript(True)
	End If

	' �������
	Set tree = Nothing
	Set treeId = Nothing
	
	Set dictSheetIds = Nothing
	Set dictSheetCnt = Nothing
	Set dictCoreIds = Nothing
	Set dictCoreCnt = Nothing

	' �������
	Set job = Nothing

End Sub

' ====================================================================
' ====================================================================
' ��������� ������ � ����� �������
Sub subWorkShtNetSegmentIds(ByVal itemId, ByRef dictCoreIds)
	' ��������
	If (itemId > 0) Then
		' ������ ������ job
		Dim job
		Set job = app.CreateJobObject ()

		' �������� ��������
		Dim nseg, nsegId, nsegLineColour, nsegLineStyle, nsegLineWidth, nsegSignalName
		Dim corId, corSignalName
		Set nseg = job.CreateNetSegmentObject()
		' ������������� ������� �������������
		nsegId = nseg.SetId(itemId)
		' ��������
		If (nsegId > 0) Then
			' ���� ����� ���� = 256 �� ���������
			nsegLineColour = "256"
			nsegLineStyle = "1"
			' ���������� �������� ������� �� ���������
			nsegLineWidth = netSegmentLineWidthForOneSignal
			' ������ ����� ���� � ��������
			nsegSignalName = nseg.GetSignalName()
			' �������� ���������� ��� ��������� ���������������� ����� (�������� ������ ��� �� ����������� ������������ �����)
			If (flagSetColourFromSignalName) Then
				' ������ ������������ ����� � ����������� �� ����� ����
				Call SubGetColourFromSignalName(nsegSignalName, nsegLineColour, nsegLineStyle, nsegLineWidth)
			End If

			' ------------------------------------
			' �������� ���������� ��� ��������� ���������������� ����� (�������� ������ ��� �� ����������� ������������ �����) ������������ � ������ ����� ��������� ���
			If (flagSetColourFromCoreForSignalName) Then
				' ������� ���� ���
				For Each corId In dictCoreIds.Keys()
					' ��� ���� ����
					corSignalName = dictCoreIds.Item(corId).SignalName
					' ����� ���� � ����������� �����
					If (nsegSignalName = corSignalName) Then
						' ���� � ����� ����� ������� - ��������� ��������� �� ���� ����
						nsegLineColour = dictCoreIds.Item(corId).NetSegmentColour
						nsegLineStyle = dictCoreIds.Item(corId).NetSegmentLineStyle
						nsegLineWidth = dictCoreIds.Item(corId).NetSegmentLineWidth
						' ����� �� �����
						Exit For
					End If
				Next
			End If

			' ------------------------------------
			' ������ ��� � ������ ��������
			nsegCoreCnt = nseg.GetCoreIds(nsegCoreIds)
			' �������� ���������� ��� � ��������
			If (nsegCoreCnt > 0) Then
				' �������� ������
				Dim flagDifferentByColour, flagDifferentByStyle, flagDifferentBySignal
				' ��������� ������
				flagDifferentByColour = False
				flagDifferentByStyle = False
				flagDifferentBySignal = False

				' ���������� ����
				For cori = 1 To nsegCoreCnt
					' ������� ���� 
					corId = nsegCoreIds(cori)
					' ����� ���� � �������
					If (dictCoreIds.Exists(corId)) Then
						' ���� ������� - ��������� ��������� �� ���� ����
						nsegLineColour = dictCoreIds.Item(corId).NetSegmentColour
						nsegLineStyle = dictCoreIds.Item(corId).NetSegmentLineStyle
						nsegLineWidth = dictCoreIds.Item(corId).NetSegmentLineWidth
						corSignalName = dictCoreIds.Item(corId).SignalName
						' --------------------
						' ���� � �������� ����� �������� ������� ���������������� �����
						' ��������� �������� �����, ������������ ��� ������ ���� � ��������
						If cori = 1 Then
							' �������� ����� ��� ������� ��������
							nsegColourFirst = nsegLineColour
							' ��������� �������� ���� �����
							nsegLineStyleFirst = nsegLineStyle
							' ��������� �������� ����� ���� ����
							corSignalNameFirst = corSignalName
						End If

						' ��������� ��������� ����� ��� ������ ���� � ������ ������ ���� � � �����
						If (nsegColourFirst <> nsegLineColour) Or (nsegLineStyleFirst <> nsegLineStyle) Then
							' ����������, ��� � �������� ������ � ������ ��� � ����, �.�. � 256
							nsegLineColour = "256"
							nsegLineStyle = "1"
							' ��������� ������ ��� ������ �� �����
							flagDifferentByColour = True
							flagDifferentByStyle = True
						End If
						' �������� ����� ����
						If (corSignalNameFirst <> corSignalName) Then
							' ����� ���������
							nsegLineWidth = netSegmentLineWidthForTwoSignal
							' ��������� ������ ��� ������ �� �����
							flagDifferentBySignal = True
						End If
						' �������� ������
						If (flagDifferentByColour And flagDifferentByStyle And flagDifferentBySignal) Then
							' ����� �� �����
							Exit For
						End If
					End If
				Next
				' �������
				Set flagDifferentByColour = Nothing
				Set flagDifferentByStyle = Nothing
				Set flagDifferentBySignal = Nothing
			End If

			' ------------------------------------
			' ���������� ������ � ����� ����� ������ �����
			' ------------------------------------
			' ����� ����������� �� ����� 
			nsegSetLineStyleResult = nseg.SetLineStyle(nsegLineStyle)
			' ����������� ���������� �����, ������� �� ���� �����, ������� ���� ����� ����������� �����
			segSetLineColourResult = nseg.SetLineColour(nsegLineColour)

			If deBugOutputMode Then resultMsg = app.PutError(0, vbTab & "netSegmentId = " & nsegId & ",  netSegmentLineColour = " & nsegLineColour & ", netSegmentLineStyle = " & nsegLineStyle, nsegId)

			' -------------------------------------------------------------------------------
			' ��������� ��������� ��������� ����� ����� ��� ����������� ���������� ����� (���� � �����) � ����� �����
			nsegSetLineWidthResult = nseg.SetLineWidth(nsegLineWidth)
			If deBugOutputMode Then resultMsg = app.PutError(0, vbTab & "netSegmentLineWidth = " & nsegLineWidth, nsegId)

			'�������� ������ E3.series
			If (appVersion >= 2018) Then
				' ������� � RGB
				jobRGBValueRet = job.GetRGBValue(nsegLineColour, rColour, gColour, bColour)
				' ����� ���������
				If showMessageMode Then resultMsg = app.PutInfoEx(0, vbTab & "������� ��������� ���������� ����, ����� � ������� ��� ����� ����� -" & nsegId & "-...", nsegId, rColour, gColour, bColour)
			Else
				' ����� ���������
				If showMessageMode Then resultMsg = app.PutInfo(0, vbTab & "������� ��������� ���������� ����, ����� � ������� ��� ����� ����� -" & nsegId & "-...", nsegId)
			End If


		End If

		' �������
		Set nseg = Nothing
		Set nsegId = Nothing
		Set nsegLineColour = Nothing
		Set nsegLineStyle = Nothing
		Set nsegLineWidth = Nothing
		Set nsegSignalName = Nothing
		Set corId = Nothing
		Set corSignalName = Nothing
		' �������
		Set job = Nothing
	End If

End Sub
' =====================================

' ==============================================================
' ��������������� ��������� ��� ���������� ����������� ����������
Sub subSortArrayByIndexEx(ByRef arraySort, ByVal columnSort, ByVal parameterSort, ByVal directionSort)
	' �������, ��� �� ����� � ��� ������������� ������
	If (IsArray(arraySort)) Then
		' ��������
		If (IsArray(columnSort) Or IsArray(parameterSort) Or IsArray(directionSort)) Then
			' ��������
			If (Not IsArray(columnSort) Or Not IsArray(parameterSort) Or Not IsArray(directionSort)) Then
				' ����� ���������
				resultMsg = app.PutError(0, "�� ������ ������������ ������� ����� ����������!")
				' �������
				Call SubFinishScript(True)
			End If

			' ������ ����������
			columnSortZise = UBound(columnSort)
			parameterSortZise = UBound(parameterSort)
			directionSortZise = UBound(directionSort)
			' ��������
			If (columnSortZise <> parameterSortZise) Or (columnSortZise <> directionSortZise) Then
				' ����� ���������
				resultMsg = app.PutError(0, "���������� ���������� � ������� ����� ���������� �� ���������!")
				' �������
				Call SubFinishScript(True)
			End If
			' ������ ����������� ������
			'---------------------------
			ReDim optionsSort(columnSortZise, 2)
			' ������� ��������
			For opti = 0 To columnSortZise
				' ����������
				optionsSort(opti, 0) = Trim(columnSort(opti))
				optionsSort(opti, 1) = Trim(parameterSort(opti))
				optionsSort(opti, 2) = Trim(directionSort(opti))
			Next
		Else
			' ������ ����������� ������
			'---------------------------
			ReDim optionsSort(0, 2)
			' 1 = ���������� �� 1-� ������� (���������� � ������� ������)
			optionsSort(0, 0) = Trim(columnSort)
			' �������� ���������� �� ��� ���������� - � ������ ������ ������������ ���������� = 2
			optionsSort(0, 1) = Trim(parameterSort)
			' �������� ���������� �� ����������� (0) ��� �������� (1) 
			optionsSort(0, 2) = Trim(directionSort)
			'---------------------------
		End If

		'���������� ����������
		Call app.SortArrayByIndexEx(arraySort, optionsSort)
		'���������� ������ ��� ���������
		' ����� ����������, ����� ����� �����, ��� ������ ����� ���������� �� 0-�� ������� � 1-�, ���� directionSort = 0,
		' ��-�� ����, ��� ��������� ������ ��������� ������� ������ ����� ������ ��������, ������� ����������� � ������� ������ ��������� �������
	End If
End Sub
' ==============================================================

' ==============================================================
' ������� ���������� ������� ������
Function FunGetDictSheetIds(ByVal itemId, ByRef dictSheetIds, ByRef dictCoreIds)
	' ���� ������ �������� �� ������������� ����� �� ����� ����� ����
	If (itemId > 0) Then
		' ������ ������ job
		Dim job
		Set job = app.CreateJobObject ()
		' �������� ��������
		Dim sht, shtId
		Set sht = job.CreateSheetObject()
		' ��������� �������� ��������������
		shtId = sht.SetId(itemId)
		' �������� ���� ���������� �����
		If (sht.IsPanel) Or (sht.IsTopology) Or (sht.IsFormboard) Then
			shtId = sht.SetId(sht.GetParentSheetId())
		End If
		' ��������
		If (shtId > 0) Then
			' �������� � �������
			If (Not dictSheetIds.Exists(shtId)) Then
				' ���������� � �������
				Call dictSheetIds.Add(shtId, New classSheet)
				' ��������� ������� ���������
				With dictSheetIds.Item(shtId)
					' �������������
					.Id = shtId
					.Assignment = sht.GetAssignment()
					.Location = sht.GetLocation()
					.Name = sht.GetName()
					' ������ ���� ���������
					.DOCUMENTTYPE = sht.GetAttributeValue(".DOCUMENT_TYPE")
					' ��� ����� (������ � ���� ������)
					.Format = sht.GetFormat()

					' ������ net (����� �� ������� �����)
					shtNetCnt = sht.GetNetIds(shtNetIds)
					' ��������
					If (shtNetCnt > 0) Then
						' �������� ��������
						Dim net, netId
						Set net = job.CreateNetObject()
						' ������� � ������ � ������
						For neti = 1 To shtNetCnt
							' ������������� ������� ��������
							netId = net.Setid(shtNetIds(neti))
							' ---------------------------------------
							' ������ ��� � ����������� ����
							netCoreCnt = net.GetCoreIds(netCoreIds)
							' �������� ����������
							If (netCoreCnt > 0) Then
								' ��������� ������� ������� ���
								For cori = 1 To netCoreCnt
									' ������� � ������� ���������� ���
									Call FunGetDictCoreIds(netCoreIds(cori), dictCoreIds)
								Next
							End If
							' ---------------------------------------
							' ������ ���������
							netNetSegmentCnt = net.GetNetSegmentIds(netNetSegmentIds)
							' �������� ����������
							If (netNetSegmentCnt > 0) Then
								' �������� ��������
								Dim nsegId
								' �������
								For nsegi = 1 To netNetSegmentCnt
									' ������� ������� ����
									nsegId = netNetSegmentIds(nsegi)
									' ��������
									If (Not .DictNetSegmentIds.Exists(nsegId)) Then Call .DictNetSegmentIds.Add(nsegId, "")
								Next
								' �������
								Set nsegId = Nothing
							End If
						Next
					End If
				End With
				' ���������� � ����� ������ ���� �� � ����� ������� (���� ���� �������� E3.Panel, E3.Formboard, ����������)
				shtEmbeddedSheetCnt = sht.GetEmbeddedSheetIds(shtEmbeddedSheetIds)
				' ��������
				If (shtEmbeddedSheetCnt > 0) Then
					' ��������� ������� �� ����� � �������
					For shti = 1 To shtEmbeddedSheetCnt
						Call FunGetDictSheetIds(shtEmbeddedSheetIds(shti), dictSheetIds, dictCoreIds)
					Next
				End If
			End If
		End If
		' �������
		Set sht = Nothing
		Set shtId = Nothing
		' �������
		Set job = Nothing
	End If
	' ������� �������
	FunGetDictSheetIds = dictSheetIds.Count
End Function
' =============================================================
' �������� ������ ������
Class classSheet
	' �������� ��������
	Public Id, Assignment, Location, Name, DOCUMENTTYPE, Format
	Public DictNetSegmentIds
	' --------------------------------------------------------------------
	' ����������� ������
	Private Sub Class_Initialize()
		'MsgBox("class classSheet started")
		Set DictNetSegmentIds = CreateObject("Scripting.Dictionary")
	End Sub
	' --------------------------------------------------------------------
	' ���������� ������
	Private Sub Class_Terminate()
		'MsgBox("class classSheet terminated")
		' ������� ��������
		Set Id = Nothing
		Set Assignment = Nothing
		Set Location = Nothing
		Set Name = Nothing
		Set DOCUMENTTYPE = Nothing
		Set Format = Nothing
		DictNetSegmentIds.RemoveAll
		Set DictNetSegmentIds = Nothing
	End Sub
End Class
' ==============================================================
' ������� ���������� ������� ���
Function FunGetDictCoreIds(ByVal itemId, ByRef dictCoreIds)
	' ��������
	If (itemId > 0) Then
		' ������ ������ job
		Dim job
		Set job = app.CreateJobObject ()
		' �������������� ����������
		Dim cor, corId
		Set cor = job.CreatePinObject()
		Dim cab, cabId
		Set cab = job.CreateDeviceObject()
		' ��������� ��������������

		' �������������� ������� ����
		corId = cor.SetId(itemId)
		' ��������
		' ��������
		If (corId > 0) Then
			' ��������
			If (Not dictCoreIds.Exists(corId)) Then
				' ���������� � �������
				Call dictCoreIds.Add(corId, New classCore)
				' ���������
				With dictCoreIds.Item(corId)
					' �������������
					.Id = corId
					' ������� ������
					cabId = cab.SetId(corId)
					' ������������� ������
					.CableId = cabId
					' ������ ����� �������
					.ColourDescription = cor.GetColourDescription()
					' ������ ���� �������
					.SignalName = cor.GetSignalName()

					' ============================================================================
					' �������� ��������
					Dim nsegLineColour, nsegLineStyle, nsegLineWidth

					' ���������� ���� ��������, ���� ������� ������������ ���������, �� ���� �������
					If modeManualSetting = 1 Then
						' -----------------------
						' ������� 1 - �� �������� ������������
						Call SubGetColourByUserSetting(cor, cab, job, nsegLineColour, nsegLineStyle, nsegLineWidth)
					ElseIf modeManualSetting = 2 Then
						' -----------------------
						' ������� 2 - �� ����� ����
						' ������ ������������ ����� �� ����� ����������
						Call SubGetColourFromCore(.ColourDescription, nsegLineColour, nsegLineStyle, nsegLineWidth)

					Else
						' -----------------------
						' ������� ��� ����������� ��������� ��� 0, �� - �� ����� ���� ����/�������
						' ������ ������������ ����� � ����������� �� ����� ���� ����������
						Call SubGetColourFromSignalName(.SignalName, nsegLineColour, nsegLineStyle, nsegLineWidth)
					End If
					' ===========================================
					' ���������� ������� ������ �������������� � ���������� ���������� �� �����, ���� � ����� ���� ��� ������ �����
					.NetSegmentColour = nsegLineColour
					.NetSegmentLineStyle = nsegLineStyle
					.NetSegmentLineWidth = nsegLineWidth
					' ----------------------------------
					' �������
					Set nsegLineColour = Nothing 
					Set nsegLineStyle = Nothing 
					Set nsegLineWidth = Nothing 

					' ============================================================================
				End With
			End If
		End If

		' �������
		Set cor = Nothing
		Set corId = Nothing
		Set cab = Nothing
		Set cabId = Nothing
		' �������
		Set job = Nothing
	End If
	' ������� �������
	FunGetDictCoreIds = dictCoreIds.Count
End Function
' =============================================================
' �������� ������ ���
Class classCore
	' �������� ��������
	Public Id, CableId, ColourDescription, SignalName, NetSegmentColour, NetSegmentLineStyle, NetSegmentLineWidth
	' --------------------------------------------------------------------
	' ����������� ������
	Private Sub Class_Initialize()
		'MsgBox("class classCore started")
	End Sub
	' --------------------------------------------------------------------
	' ���������� ������
	Private Sub Class_Terminate()
		'MsgBox("class classCore terminated")
		' ������� ��������
		Set Id = Nothing
		Set CableId = Nothing
		Set ColourDescription = Nothing
		Set SignalName = Nothing
		Set NetSegmentColour = Nothing
		Set NetSegmentLineStyle = Nothing
		Set NetSegmentLineWidth = Nothing
	End Sub
End Class
' =============================================================
' �������� ������ �������� ����
Class classNetSegment
	' �������� ��������
	Public Id
	' --------------------------------------------------------------------
	' ����������� ������
	Private Sub Class_Initialize()
		'MsgBox("class classNetSegment started")
	End Sub
	' --------------------------------------------------------------------
	' ���������� ������
	Private Sub Class_Terminate()
		'MsgBox("class classNetSegment terminated")
		' ������� ��������
		Set Id = Nothing
		
	End Sub
End Class