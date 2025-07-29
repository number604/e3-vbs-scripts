Set e3Application = CreateObject("CT.Application")  
Set job = e3Application.CreateJobObject()  
Set device = job.CreateDeviceObject()  

' �������� ��� ���������� � �������
nDevices = job.GetAllDeviceIds(deviceIds)  

' ��������� ���� ��� �����
Dim fso, logFile  
Set fso = CreateObject("Scripting.FileSystemObject")  
Set logFile = fso.OpenTextFile("C:\Scripts\placement_log.txt", 8, True)  

' ���������� ��� ���������� � �������� ��
logFile.WriteLine "=== ��������� ����������: " & Now & " ==="

For i = 0 To nDevices - 1  
    device.SetId deviceIds(i)  
    logFile.WriteLine "����������: " & device.GetName() & " (ID: " & device.GetId() & ")"  
Next  

logFile.WriteLine "======================================="  
logFile.Close  

' ����� � PutInfo
e3Application.PutInfo 0, "? ��� ����������� ��������� �������!"  

' ����������� �������  
Set logFile = Nothing  
Set fso = Nothing  
Set device = Nothing  
Set job = Nothing  
Set e3Application = Nothing  
