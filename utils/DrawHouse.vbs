
Set App = CreateObject("CT.Application")
Set Job = App.CreateJobObject()

' ������ ������ �����
Set Sheet = Job.CreateSheetObject()

' ��������� ��� �������� �����
Dim moduleId, sheetName, symbolName, position, isBeforePosition
moduleId = 0                        ' ��� ������
sheetName = "House"                ' ��� �����
symbolName = "������_�3_���_1����" ' ������ �����
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
    
    ' ������� ���������� ����
    Dim baseX, baseY
    baseX = 100  ' ������ ���� �����
    baseY = 100  ' ��������� ����

    ' ������� ����
    Dim houseWidth, houseHeight, roofHeight
    houseWidth = 80   ' ������ ����
    houseHeight = 60  ' ������ ����
    roofHeight = 30   ' ������ �����

    ' ����� ��� ������ ���������
    Const COLOR_WALLS = 1      ' ����� ��� ����
    Const COLOR_ROOF = 13      ' ������� ��� �����
    
    ' ������ ��������� ���� (������������� ������ �������)
    result = Graphic.CreateLine(sheetId, baseX, baseY, baseX + houseWidth, baseY)                          ' ������ �����
    Graphic.SetLineColour COLOR_WALLS
    result = Graphic.CreateLine(sheetId, baseX, baseY, baseX, baseY + houseHeight)                         ' ����� �����
    Graphic.SetLineColour COLOR_WALLS
    result = Graphic.CreateLine(sheetId, baseX + houseWidth, baseY, baseX + houseWidth, baseY + houseHeight) ' ������ �����
    Graphic.SetLineColour COLOR_WALLS
    result = Graphic.CreateLine(sheetId, baseX, baseY + houseHeight, baseX + houseWidth, baseY + houseHeight) ' ������� �����
    Graphic.SetLineColour COLOR_WALLS

    ' ������ �����
    Set RoofGraphic = Job.CreateGraphObject()
    
    ' ������ ��������� �����
    result = RoofGraphic.CreateLine(sheetId, baseX, baseY + houseHeight, baseX + houseWidth, baseY + houseHeight)
    RoofGraphic.SetLineColour COLOR_ROOF
    
    ' ������ ����� ����
    result = RoofGraphic.CreateLine(sheetId, baseX, baseY + houseHeight, baseX + houseWidth/2, baseY + houseHeight + roofHeight)
    RoofGraphic.SetLineColour COLOR_ROOF
    
    ' ������ ������ ����
    result = RoofGraphic.CreateLine(sheetId, baseX + houseWidth/2, baseY + houseHeight + roofHeight, baseX + houseWidth, baseY + houseHeight)
    RoofGraphic.SetLineColour COLOR_ROOF
    
    ' ������ ��� ����� ����� ������� ������
    result = RoofGraphic.CreateLine(sheetId, baseX, baseY + houseHeight, baseX + houseWidth, baseY + houseHeight)             ' ���������
    result = RoofGraphic.CreateLine(sheetId, baseX, baseY + houseHeight, baseX + houseWidth/2, baseY + houseHeight + roofHeight)  ' ����� ����
    result = RoofGraphic.CreateLine(sheetId, baseX + houseWidth/2, baseY + houseHeight + roofHeight, baseX + houseWidth, baseY + houseHeight)  ' ������ ����
    
    ' ������� ������
    Set RoofGraphic = Nothing

    ' ������ ����� (���������� ������)
    Dim doorWidth, doorHeight
    doorWidth = 20
    doorHeight = 30
    Dim doorX : doorX = baseX + 15  ' ��������� ����� �� ������ ����
    Dim doorY : doorY = baseY       ' ����� ����� �� �����
    Graphic.SetColour 6  ' ����������
    result = Graphic.CreateLine(sheetId, doorX, doorY, doorX, doorY + doorHeight)                   ' ����� ������� �����
    result = Graphic.CreateLine(sheetId, doorX + doorWidth, doorY, doorX + doorWidth, doorY + doorHeight) ' ������ ������� �����
    result = Graphic.CreateLine(sheetId, doorX, doorY + doorHeight, doorX + doorWidth, doorY + doorHeight) ' ���� �����

    ' ������ ���� (������� � ������� ������� ������)
    Dim windowSize : windowSize = 20
    Dim windowX : windowX = baseX + houseWidth - 35  ' ��������� ���� �� ������ ����
    Dim windowY : windowY = baseY + 20               ' ������ ���� �� �����
    result = Graphic.CreateLine(sheetId, windowX, windowY, windowX + windowSize, windowY)                     ' ������ ����� ����
    result = Graphic.CreateLine(sheetId, windowX, windowY, windowX, windowY + windowSize)                     ' ����� ����� ����
    result = Graphic.CreateLine(sheetId, windowX + windowSize, windowY, windowX + windowSize, windowY + windowSize) ' ������ ����� ����
    result = Graphic.CreateLine(sheetId, windowX, windowY + windowSize, windowX + windowSize, windowY + windowSize) ' ������� ����� ����
    ' ����� � ����
    result = Graphic.CreateLine(sheetId, windowX, windowY + windowSize/2, windowX + windowSize, windowY + windowSize/2) ' �������������� �����
    result = Graphic.CreateLine(sheetId, windowX + windowSize/2, windowY, windowX + windowSize/2, windowY + windowSize) ' ������������ �����

    ' ������ ������
    Dim treeX : treeX = baseX + houseWidth + 30  ' ��������� ������ ������ �� ����
    Dim treeY : treeY = baseY                    ' ������ ������ �� �����
    Dim trunkHeight : trunkHeight = 40           ' ������ ������
    Dim trunkWidth : trunkWidth = 8             ' ������ ������
    Dim crownRadius : crownRadius = 20          ' ������ �����

    ' ����� ������ (����������)
    Graphic.SetColour 6  ' ����������
    result = Graphic.CreateLine(sheetId, treeX, treeY, treeX, treeY + trunkHeight)                         ' �����
    result = Graphic.CreateLine(sheetId, treeX - trunkWidth/2, treeY, treeX + trunkWidth/2, treeY)         ' ��������� ������

    ' ����� ������ (��� ����� ������� ������� ������� ������)
    Graphic.SetColour 2  ' �������
    result = Graphic.CreateCircle(sheetId, treeX, treeY + trunkHeight + crownRadius/2, crownRadius)        ' ������ ����
    result = Graphic.CreateCircle(sheetId, treeX - crownRadius/2, treeY + trunkHeight + crownRadius, crownRadius-5)  ' ����� �������
    result = Graphic.CreateCircle(sheetId, treeX + crownRadius/2, treeY + trunkHeight + crownRadius, crownRadius-5)  ' ������ �������

    If result = 0 Then
        message = "������ ��� �������� �������"
    Else
        message = "����� ������� ���������"
    End If

    App.PutInfo 0, message
End If

Set Graphic = Nothing
Set Sheet = Nothing
Set Job = Nothing
Set App = Nothing
