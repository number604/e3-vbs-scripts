Set e3Application = CreateObject("CT.Application")  
Set job = e3Application.CreateJobObject()  

' ��������� ���� � ����� �������� ������� ���������
Dim levelFile  
levelFile = "C:\Templates\default_visibility.vis"  ' ������� ���� ���� � �����  

e3Application.PutInfo 0, "�������� ������� ��������� ��: " & levelFile  

' ��������� ������ ���������
result = job.LoadLevelConfiguration(levelFile)  

If result = 0 Then  
    e3Application.PutInfo 0, "������ �������� ������� ��������� �� " & levelFile  
Else  
    e3Application.PutInfo 0, "������ ��������� ������� ��������� �� " & levelFile  
End If  

' ����������� �������
Set job = Nothing  
Set e3Application = Nothing  
