Set e3Application = CreateObject("CT.Application")
Set job = e3Application.CreateJobObject()
Set sheet = job.CreateSheetObject()

result = job.GetAllSheetIds(sheetIds)

If result > 0 Then

    For i = 1 To result
        sheetId = sheet.SetId(sheetIds(i))

        attrValue = sheet.GetAttributeValue("��� ���������")

        If attrValue = "�������� ���������" Or attrValue = "������� ����������" Then
            sheetName = sheet.GetName()
            sheetAssignment = sheet.GetAssignment()
            sheetLocation = sheet.GetLocation()

            delResult = sheet.Delete()

            Select Case delResult
                Case 0
                    message = "����� ����: " & sheetName & " " & sheetAssignment & " " & sheetLocation & " (" & sheetId & ")"
                Case -1
                    message = "������ ��������: �� ������� ������������� ����"
                Case -2
                    message = "������ ��������: ���� ������� ������� ����� ����������"
                Case -3
                    message = "������ ��������: ���� ������������"
                Case -4
                    message = "������ ��������: ���� �������� ��������"
                Case -5
                    message = "������ ��������: ���� ������ ��� ������"
                Case -6
                    message = "������ ��������: ���� �� ����������"
            End Select

            e3Application.PutInfo 0, message
        End If
    Next

Else
    e3Application.PutInfo 0, "� ������� ��� ������."
End If

Set sheet = Nothing
Set job = Nothing
Set e3Application = Nothing
