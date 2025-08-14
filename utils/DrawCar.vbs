
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

    ' ������ �������� ����� (������ �����)
    result = Graphic.CreateLine(sheetId, baseX + 20, baseY, baseX + carWidth - 20, baseY)                  ' ������ �����
    result = Graphic.CreateLine(sheetId, baseX, baseY + 15, baseX + 20, baseY)                            ' �������� ����
    result = Graphic.CreateLine(sheetId, baseX + carWidth - 20, baseY, baseX + carWidth, baseY + 15)      ' ������ ����

    ' ������ ������� ����� ������ (������)
    Dim cabinStartX : cabinStartX = baseX + 30
    Dim cabinWidth : cabinWidth = 50
    result = Graphic.CreateLine(sheetId, cabinStartX, baseY + 15, cabinStartX, baseY + carHeight)         ' �������� ������
    result = Graphic.CreateLine(sheetId, cabinStartX + cabinWidth, baseY + 15, cabinStartX + cabinWidth, baseY + carHeight) ' ������ ������
    result = Graphic.CreateLine(sheetId, cabinStartX, baseY + carHeight, cabinStartX + cabinWidth, baseY + carHeight) ' �����
    
    ' ������ ����
    Dim windowHeight : windowHeight = 15
    ' ������� ������ (���������)
    result = Graphic.CreateLine(sheetId, cabinStartX - 10, baseY + 20, cabinStartX, baseY + carHeight)
    ' ������ ������ (���������)
    result = Graphic.CreateLine(sheetId, cabinStartX + cabinWidth, baseY + carHeight, cabinStartX + cabinWidth + 10, baseY + 20)

    ' ������ ������ (�������� � ������)
    ' �������� ������
    result = Graphic.CreateCircle(sheetId, baseX + 25, baseY, wheelRadius)
    result = Graphic.CreateCircle(sheetId, baseX + 25, baseY, wheelRadius - 4) ' ���������� ����
    ' ������ ������
    result = Graphic.CreateCircle(sheetId, baseX + carWidth - 25, baseY, wheelRadius)
    result = Graphic.CreateCircle(sheetId, baseX + carWidth - 25, baseY, wheelRadius - 4) ' ���������� ����

    ' ������ ����
    Dim headlightRadius : headlightRadius = 5
    ' �������� ����
    result = Graphic.CreateCircle(sheetId, baseX + 5, baseY + 20, headlightRadius)
    ' ������ ����
    result = Graphic.CreateCircle(sheetId, baseX + carWidth - 5, baseY + 20, headlightRadius)

    ' ������ �������
    result = Graphic.CreateLine(sheetId, baseX - 5, baseY + 10, baseX + 10, baseY + 10)     ' �������� ������
    result = Graphic.CreateLine(sheetId, baseX + carWidth - 10, baseY + 10, baseX + carWidth + 5, baseY + 10) ' ������ ������

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
