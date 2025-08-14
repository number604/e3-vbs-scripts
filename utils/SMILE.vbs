' filepath: d:\E3_VBS_Scripts\utils\DrawSmile.vbs

Set App = CreateObject("CT.Application")
Set Job = App.CreateJobObject()

' ������ ����� ����
Set Sheet = Job.CreateSheetObject()
Sheet.SetName "Smile"
Sheet.SetFormat "A4"
' Sheet.SetOrientation 1 ' 1 = ���������, 0 = �������

' ���������� ������ ��������
Dim centerX, centerY, radius
centerX = 100
centerY = 100
radius = 50

Set Graphic = Job.CreateGraphObject()

Dim sheetCount, sheetIds, sheetId, result, message
sheetCount = Job.GetTreeSelectedSheetIds(sheetIds)

If sheetCount > 0 Then
    sheetId = Sheet.SetId(sheetIds(1))
    If sheetId > 0 Then
        ' ������ ���� (����������)
        result = Graphic.CreateCircle(sheetId, centerX, centerY, radius)
        ' ������ ����� ����
        result = Graphic.CreateCircle(sheetId, centerX - 20, centerY - 15, 5)
        ' ������ ������ ����
        result = Graphic.CreateCircle(sheetId, centerX + 20, centerY - 15, 5)
        ' ������ ������ (����)
        result = Graphic.CreateArc(sheetId, centerX, centerY + 10, 25, 200, 340)

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