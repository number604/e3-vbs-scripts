' ���������� ���������� ��� ��������
Dim A(), A_Names(), B(), B_Names(), C(), C_Names(), E(), E_Names()

Set app = CreateObject( "CT.Application" ) 
Set job = app.CreateJobObject()
Set device = job.CreateDeviceObject()
Set conductor = job.CreatePinObject()
Set pin = job.CreatePinObject()
Set dev = job.CreateDeviceObject()
Set Sig = Job.CreateSignalObject()
set Cab = Job.CreateDeviceObject()
set Cor = Job.CreatePinObject()

' ��������� ��� ����� �������������
Dim excelFilePath
excelFilePath = GetExcelFileName(Job)
If excelFilePath = "" Then
    WScript.Quit
End If

'call SheetGrid
'call IndexSet
'call Sort
'call ReNameWire
'call Sort

' ������������� �������� ����� ��������������
ReDim A(0) : ReDim A_Names(0)
ReDim B(0) : ReDim B_Names(0)
ReDim C(0) : ReDim C_Names(0)
ReDim E(0) : ReDim E_Names(0)


call GetWireCrossSections
call ExportWireDataToExcel(excelFilePath, A, A_Names, B, B_Names, C, C_Names, E, E_Names)

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




Sub GetWireCrossSections
    nCabs = Job.GetCableCount
    If nCabs = 0 Then
        App.PutInfo 1, "No cables in project, exiting..."
        wscript.quit
    End If

    ' ������� ��� �������� ������
    Dim WireCrossSections(), WireNames()
    ReDim WireCrossSections(0)
    ReDim WireNames(0)

    ' ���� ������
    cablecount = Job.GetCableIds(cableids)
    For i = 1 To cablecount
        Cab.SetId cableids(i)
        If Cab.IsWiregroup Then
            wircnt = Cab.GetPinIds(wirids)
            For j = 1 To wircnt
                Cor.SetId wirids(j)
                WireCrossSection = Cor.GetCrossSectionDescription
                WireName = Cor.GetName
                
                If WireCrossSection <> "" Then
                    If UBound(WireCrossSections) = 0 And WireCrossSections(0) = "" Then
                        WireCrossSections(0) = WireCrossSection
                        WireNames(0) = WireName
                    Else
                        ReDim Preserve WireCrossSections(UBound(WireCrossSections) + 1)
                        ReDim Preserve WireNames(UBound(WireNames) + 1)
                        WireCrossSections(UBound(WireCrossSections)) = WireCrossSection
                        WireNames(UBound(WireNames)) = WireName
                    End If
                End If
            Next
        End If
    Next

    For k = 0 To UBound(WireCrossSections)
        section = WireCrossSections(k)
        wireName = WireNames(k)
        
        If InStr(section, "0.75") > 0 Or InStr(section, "1.5") > 0 Then
            AddToArray A, A_Names, section, wireName
        ElseIf InStr(section, "10") > 0 Or InStr(section, "16") > 0 Or InStr(section, "25") > 0 Or InStr(section, "35") > 0 Then
            AddToArray C, C_Names, section, wireName
        ElseIf InStr(section, "2.5") > 0 Or InStr(section, "4") > 0 Or InStr(section, "6") > 0 Then
            AddToArray B, B_Names, section, wireName
        ElseIf InStr(section, "50") > 0 Or InStr(section, "70") > 0 Then
            AddToArray E, E_Names, section, wireName
        End If
    Next

    ' ����� ����������
    ShowGroupInfo "A", A, A_Names, "0,75-1,5", "�����-��-2�-3,2/1,6� (50�), ���. ���2�-032-�50"
    ShowGroupInfo "B", B, B_Names, "2,5-6", "�����-��-2�-6,4/3,2� (50�), ���. ���2�-064-�50"
    ShowGroupInfo "C", C, C_Names, "10-35", "�����-��-2�-12,7/6,4� (50�), ���. ���2�-127-�50"
    ShowGroupInfo "E", E, E_Names, "50-70", "�����-��-2�-19,1/9,5� (50�), ���. ���2�-191-�50"
End Sub

' ��������� ��������� ��� ���������� � ������
Sub AddToArray(arr(), namesArr(), section, wireName)
    If UBound(arr) = 0 And arr(0) = "" Then
        arr(0) = section
        namesArr(0) = wireName
    Else
        ReDim Preserve arr(UBound(arr) + 1)
        ReDim Preserve namesArr(UBound(namesArr) + 1)
        arr(UBound(arr)) = section
        namesArr(UBound(namesArr)) = wireName
    End If
End Sub

' ��������� ��������� ��� ������ ����������
Sub ShowGroupInfo(groupName, sectionsArray, namesArray, sizeRange, tubeSpec)
    If UBound(sectionsArray) >= 0 And sectionsArray(0) <> "" Then
        tubeLength = (UBound(sectionsArray) + 1) * 2 * 0.015
        App.PutInfo 0, "-------------------------------"
        App.PutInfo 0, "������ " & groupName & " (������� " & sizeRange & "):"
        App.PutInfo 0, "������: " & tubeSpec
        App.PutInfo 0, "����� �����: " & tubeLength & " �"
        App.PutInfo 0, "������ ��������:"
        
        For m = 0 To UBound(namesArray)
            App.PutInfo 0, "  " & namesArray(m) & " (" & sectionsArray(m) & ")"
        Next
    End If
End Sub

' ��������������� ��������� ��� ���������� ������ � �������
Sub AddToArray(arr(), namesArr(), section, wireName)
    If UBound(arr) = 0 And arr(0) = "" Then
        arr(0) = section
        namesArr(0) = wireName
    Else
        ReDim Preserve arr(UBound(arr) + 1)
        ReDim Preserve namesArr(UBound(namesArr) + 1)
        arr(UBound(arr)) = section
        namesArr(UBound(namesArr)) = wireName
    End If
End Sub


'==============================================
' ��������� ������������ ����� XLS �����
' ���������� ������ ���� � ����� � �������:
' <����_�������>\<���_�������>.xls
' � ������� "Sch2_" �� "brk" � ��������� ".e3d"
'==============================================
Function GetExcelFileName(Job)
    Dim projectPath, projectName, excelFileName
    
    ' �������� ���� �������
    projectPath = Job.GetPath()
    If Len("" & projectPath) = 0 Then
        App.PutInfo 1, "������ ��������� ���� �������"
        GetExcelFileName = ""
        Exit Function
    End If
    
    ' �������� ��� �������
    projectName = Job.GetName()
    If Len("" & projectName) = 0 Then
        App.PutInfo 1, "������ ��������� ����� �������"
        GetExcelFileName = ""
        Exit Function
    End If
    
    ' �������� "Sch2_" �� "brk" � ����� �������
    projectName = Replace(projectName, "Sch2_", "brk", 1, -1, vbTextCompare)
    
    ' ������� ���������� .e3d ���� ���� (������������������)
    projectName = Replace(projectName, ".e3d", "", 1, -1, vbTextCompare)
    projectName = Replace(projectName, ".E3D", "", 1, -1, vbTextCompare)
    
    ' ������� ��� ����� Excel (��� ������ ���������)
    excelFileName = projectPath & "\" & projectName & ".xls"
    
    App.PutInfo 0, "����������� ���� � ����� Excel: " & excelFileName
    GetExcelFileName = excelFileName
End Function

'��������� ��� �������� ������ � Excel
Sub ExportWireDataToExcel(excelFilePath, A, A_Names, B, B_Names, C, C_Names, E, E_Names)
    On Error Resume Next
    
    ' ������� ������ Excel
    Dim ExcelApp, ExcelBook, ExcelSheet
    Set ExcelApp = CreateObject("Excel.Application")
    ExcelApp.Visible = True ' ��� �������
    
    ' �������� ������� ����
    Set ExcelBook = ExcelApp.Workbooks.Open(excelFilePath)
    If Err.Number <> 0 Then
        App.PutInfo 1, "������ �������� ����� " & excelFilePath & ": " & Err.Description
        ExcelApp.Quit
        Set ExcelApp = Nothing
        Exit Sub
    End If
    
    ' �������� �������� ����
    Set ExcelSheet = Nothing
    On Error Resume Next
    Set ExcelSheet = ExcelBook.Sheets("������������������")
    If ExcelSheet Is Nothing Then
        ' ������� ����� ����, ���� �� ����������
        Set ExcelSheet = ExcelBook.Sheets.Add
        ExcelSheet.Name = "������������������"
    End If
    On Error GoTo 0
    
    ' ������� ���� ���������
    ExcelSheet.Cells.Clear
    
    ' ������������� ��������� ������ ��� ���� ����� (�����!)
    ExcelSheet.Cells.NumberFormat = "@"
    
    ' ���������� ����� �������
    With ExcelSheet
        ' ��������� �������
        .Cells(1, 1).Value = "0.75-1.5 ��2"
        .Cells(1, 2).Value = "2.5-6 ��2"
        .Cells(1, 3).Value = "10-35 ��2"
        .Cells(1, 4).Value = "50-70 ��2"
        
        ' �������������� ����� (������, �������������, ����)
        With .Range("A1:D1")
            .Font.Bold = True
            .HorizontalAlignment = -4108 ' xlCenter
            .Interior.Color = 13434879 ' ������-������� ���
            .Borders.Weight = 2 ' xlThin
        End With
        
        ' ���������� ������ �� ������� (��� �������� ����� ��� �����)
        If UBound(A) >= 0 And A(0) <> "" Then
            For i = 0 To UBound(A)
                .Cells(i + 2, 1).Value = "'" & A_Names(i) ' �������� ��� �������� ���������� �������
            Next
        End If
        
        If UBound(B) >= 0 And B(0) <> "" Then
            For i = 0 To UBound(B)
                .Cells(i + 2, 2).Value = "'" & B_Names(i)
            Next
        End If
        
        If UBound(C) >= 0 And C(0) <> "" Then
            For i = 0 To UBound(C)
                .Cells(i + 2, 3).Value = "'" & C_Names(i)
            Next
        End If
        
        If UBound(E) >= 0 And E(0) <> "" Then
            For i = 0 To UBound(E)
                .Cells(i + 2, 4).Value = "'" & E_Names(i)
            Next
        End If
        
        ' ���������� ������ ��������
        .Columns("A:D").AutoFit
    End With
    
    ' ��������� � ���������
    ExcelBook.Save
    ExcelBook.Close
    ExcelApp.Quit
    
    Set ExcelSheet = Nothing
    Set ExcelBook = Nothing
    Set ExcelApp = Nothing
    
    App.PutInfo 0, "������ ������� �������������� � " & excelFilePath & " �� ���� '������������������'"
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