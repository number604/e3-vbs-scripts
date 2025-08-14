' filepath: d:\E3_VBS_Scripts\utils\DrawSmile.vbs

Set App = CreateObject("CT.Application")
Set Job = App.CreateJobObject()

' ������ ������ �����
Set Sheet = Job.CreateSheetObject()

' ��������� ��� �������� �����
Dim moduleId, sheetName, symbolName, position, isBeforePosition
moduleId = 0                        ' ��� ������
sheetName = "Smile"                ' ��� �����
symbolName = "������_�3_���_1����"               ' ������ A4 �� ���� ������ Misc_Sheet
position = 0                       ' � ����� �������
isBeforePosition = 0              ' ����� ��������� �������

' ������ ����� ����
Dim sheetId, result, message
result = Sheet.Create(moduleId, sheetName, symbolName, position, isBeforePosition)

' ��������� ���������� ��������
If result > 0 Then
    sheetId = result
    
    ' ������� ������ ��� ���������
    Set Graphic = Job.CreateGraphObject()
    
    ' ���������� ������ ��������
    Dim centerX, centerY, radius
    centerX = 100
    centerY = 100
    radius = 50
    If sheetId > 0 Then
        ' ������ ���� (����������)
        result = Graphic.CreateCircle(sheetId, centerX, centerY, radius)
        ' ������ ����� ����
        result = Graphic.CreateCircle(sheetId, centerX - 20, centerY + 25, 5)
        ' ������ ������ ����
        result = Graphic.CreateCircle(sheetId, centerX + 20, centerY + 25, 5)
        ' ������ ������ (����)
        result = Graphic.CreateArc(sheetId, centerX, centerY - 15, 25, 200, 340)

        If result = 0 Then
            message = "������ ��� �������� �������"
        Else
            message = "������� ������� ������ �� �����"
        End If

        App.PutInfo 0, message
    End If
End If

Set Graphic = Nothing
Set Sheet = Nothing
Set Job = Nothing
Set App = Nothing