Set e3Application = CreateObject("CT.Application")  
Set job = e3Application.CreateJobObject()  

' ��������� ���� � ����� ������� ��������
Dim templateFile  
templateFile = "D:\E3_config_backup\default.e3t"  ' ������� ���� ���� � ����� �������  

e3Application.PutInfo 0, "������������ �������� ������� ��: " & templateFile  

' �������� ����� ReloadSettings()
result = job.ReloadSettings(templateFile)  

If result = True Then  
    e3Application.PutInfo 0, "? ��������� ������� ���������"
Else  
    e3Application.PutInfo 0, "? �������� �������� � ��������"
End If  

' ����������� �������
Set job = Nothing  
Set e3Application = Nothing  
