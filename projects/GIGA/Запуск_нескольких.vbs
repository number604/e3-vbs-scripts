' ����� � ������ ���� � ��������, ������� ����� ���������
Const SCRIPT1_PATH = "C:\Users\SEK\Desktop\DWG_4_E3\����� �����\�������\���������_��������_���.vbs"
Const SCRIPT2_PATH = "C:\Users\SEK\Desktop\DWG_4_E3\����� �����\�������\���������_��������_��.vbs"
Const SCRIPT3_PATH = "C:\Users\SEK\Desktop\DWG_4_E3\����� �����\�������\���_��������_�_���.vbs"

' ������� ������ WScript.Shell ��� ������� ������� ��������
Set WshShell = CreateObject("WScript.Shell")

' ��������� ������ ������
WshShell.Run Chr(34) & SCRIPT1_PATH & Chr(34), 1, True
' Chr(34) ������������ ��� ���������� ������� ������ ����,
' ����� ��������� ������������ ���� � ���������.
' 1 - ����� ���� (���������� ����)
' True - ��������� ���������� ���������� �������

' ��������� ������ ������
WshShell.Run Chr(34) & SCRIPT2_PATH & Chr(34), 1, True

' ��������� ������ ������
WshShell.Run Chr(34) & SCRIPT3_PATH & Chr(34), 1, True

' �������� � ����������
WScript.Echo "��� ������� ������� �������� �� �������."

' ����������� ������
Set WshShell = Nothing