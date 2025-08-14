
Set App = CreateObject("CT.Application")
Set Job = App.CreateJobObject()

' ������ ������ �����
Set Sheet = Job.CreateSheetObject()

' ��������� ��� �������� �����
Dim moduleId, sheetName, symbolName, position, isBeforePosition
moduleId = 0                        ' ��� ������
sheetName = "Car"                  ' ��� �����
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
    
    ' ������� ���������� ����������
    Dim baseX, baseY
    baseX = 100  ' ������ ���������� �����
    baseY = 100  ' ��������� ����������

    ' ������� ����������
    Dim carWidth, carHeight, wheelRadius
    carWidth = 120    ' ����� ����������
    carHeight = 40    ' ������ ������
    wheelRadius = 12  ' ������ �����

    ' ������� ����� ��� ������
    Dim frontBottom : frontBottom = baseX + 20        ' �������� ������ �����
    Dim rearBottom : rearBottom = baseX + carWidth - 20  ' ������ ������ �����
    Dim bodyHeight : bodyHeight = baseY + 15          ' ������ ��������� ������

    ' ������ �������� ����� (������ �����)
    result = Graphic.CreateLine(sheetId, frontBottom, baseY, rearBottom, baseY)                ' ������ �����
    result = Graphic.CreateLine(sheetId, baseX, bodyHeight, frontBottom, baseY)               ' �������� ����
    result = Graphic.CreateLine(sheetId, rearBottom, baseY, baseX + carWidth, bodyHeight)     ' ������ ����
    
    ' ������ ������� ����� ������ (������)
    Dim cabinStartX : cabinStartX = baseX + 30
    Dim cabinWidth : cabinWidth = 50
    ' ��������, ��� ������ ���������� �� ����� ������
    result = Graphic.CreateLine(sheetId, cabinStartX, bodyHeight, cabinStartX, baseY + carHeight)         ' �������� ������
    result = Graphic.CreateLine(sheetId, cabinStartX + cabinWidth, bodyHeight, cabinStartX + cabinWidth, baseY + carHeight) ' ������ ������
    result = Graphic.CreateLine(sheetId, cabinStartX, baseY + carHeight, cabinStartX + cabinWidth, baseY + carHeight) ' �����
    
    ' ������ ����
    ' ������� ������ (���������) - �������� �� ������ ������
    result = Graphic.CreateLine(sheetId, cabinStartX - 10, bodyHeight + 5, cabinStartX, baseY + carHeight)
    ' ������ ������ (���������) - �������� �� �����
    result = Graphic.CreateLine(sheetId, cabinStartX + cabinWidth, baseY + carHeight, cabinStartX + cabinWidth + 10, bodyHeight + 5)

    ' ������ ������ (�������� � ������)
    ' �������� ������ - ����������� � �������� ������
    result = Graphic.CreateCircle(sheetId, frontBottom, baseY, wheelRadius)
    result = Graphic.CreateCircle(sheetId, frontBottom, baseY, wheelRadius - 4) ' ���������� ����
    ' ������ ������ - ����������� � ������ ������
    result = Graphic.CreateCircle(sheetId, rearBottom, baseY, wheelRadius)
    result = Graphic.CreateCircle(sheetId, rearBottom, baseY, wheelRadius - 4) ' ���������� ����

    ' ������ ����
    Dim headlightRadius : headlightRadius = 5
    ' �������� ���� - ����������� � ��������� �����
    result = Graphic.CreateCircle(sheetId, baseX + 5, bodyHeight, headlightRadius)
    ' ������ ���� - ����������� � ������� �����
    result = Graphic.CreateCircle(sheetId, baseX + carWidth - 5, bodyHeight, headlightRadius)

    ' ������ ������� - ����������� � ������
    result = Graphic.CreateLine(sheetId, baseX - 5, bodyHeight, baseX + 10, bodyHeight)     ' �������� ������
    result = Graphic.CreateLine(sheetId, baseX + carWidth - 10, bodyHeight, baseX + carWidth + 5, bodyHeight) ' ������ ������

    ' ������ ������������ ��������
    ' ������� ���������
    For i = 0 To 3
        result = Graphic.CreateLine(sheetId, baseX + 5, baseY + 12 + i*3, baseX + 15, baseY + 12 + i*3)
    Next

    ' ����� �����
    result = Graphic.CreateLine(sheetId, cabinStartX + 30, baseY + 25, cabinStartX + 40, baseY + 25)

    If result = 0 Then
        message = "������ ��� �������� �������"
    Else
        message = "���������� ������� ���������"
    End If

    App.PutInfo 0, message
End If

Set Graphic = Nothing
Set Sheet = Nothing
Set Job = Nothing
Set App = Nothing
