' ������������� �������� ��� ���������
Const INFO_MESSAGE = 0
Const WARNING_MESSAGE = 1
Const ERROR_MESSAGE = 2

' --- ������ ������� ---

Set e3App = CreateObject("CT.Application")

If e3App Is Nothing Then
    WScript.Echo "������: �� ������� ������� ������ CT.Application. ���������, ��� E3.series �������."
    WScript.Quit
End If

' ������������� �������� E3.series
Set job = e3App.CreateJobObject()

If job Is Nothing Then
    e3App.PutInfo ERROR_MESSAGE, "������: �� ������� ������� ������ Job."
    CleanupAndExit
End If

Set e3Text = job.CreateTextObject()

If e3Text Is Nothing Then
    e3App.PutInfo ERROR_MESSAGE, "������: �� ������� ������� ������ Text. ��������� API E3.series."
    CleanupAndExit
End If

Dim selectedTextIds ' ������ ��� �������� ID ��������� ��������� ��������
Dim textCount ' ���������� ��������� ��������� ��������
Dim processedTextCount : processedTextCount = 0 ' ������� ���������� �������

' �������� ID ���� ��������� ��������� ��������.
On Error Resume Next ' �������� ��������� ������ �� ������, ���� ����� ����������
textCount = job.GetSelectedTextIds(selectedTextIds)

If Err.Number <> 0 Then
    On Error GoTo 0
    e3App.PutInfo ERROR_MESSAGE, "������ ��� ������ job.GetSelectedTextIds: " & Err.Description & ". ���������, ��� ��������� ������� ������� � ����� �������� � ����� ������ E3.series API."
    CleanupAndExit
End If
On Error GoTo 0 ' ��������� ��������� ������

If textCount = 0 Then
    e3App.PutInfo WARNING_MESSAGE, "��� ��������� ��������� �������� ��� ���������. ����������, �������� �������."
Else
    e3App.PutInfo INFO_MESSAGE, "������� " & textCount & " ��������� ��������� ��������. �������� ���������..."
    Dim currentTextId
    Dim currentText
    Dim newText
    Dim setResult

    For i = 1 To textCount
        currentTextId = selectedTextIds(i)
        
        e3Text.SetId currentTextId 
        
        currentText = e3Text.GetText() 

        If Left(currentText, 2) = "-t" Then
            newText = Replace(currentText, "-t", "-") 
            setResult = e3Text.SetText(newText) 

            If setResult = 0 Then
                e3App.PutInfo ERROR_MESSAGE, "������: �� ������� �������� ����� '" & currentText & "' (ID: " & currentTextId & ") �� '" & newText & "'."
            Else
                e3App.PutInfo INFO_MESSAGE, "����� �������: '" & currentText & "' -> '" & newText & "'"
                processedTextCount = processedTextCount + 1
            End If
        Else
            ' ���� ��� ���������, ����� ���������� ���������, ����� �� "��������" ���,
            ' ��� �������� ��� ��� ������ ������������.
            ' e3App.PutInfo INFO_MESSAGE, "����� '" & currentText & "' (ID: " & currentTextId & ") �� ������������� ������� '-t'. ��������."
        End If
    Next
End If

If processedTextCount = 0 And textCount > 0 Then ' ���� ���� ��������� ������, �� �� ���� �� ���������
    e3App.PutInfo WARNING_MESSAGE, "����� ��������� ��������� �������� �� ������� �� ������, ���������������� ������� '-t' ��� ���������."
ElseIf processedTextCount = 0 And textCount = 0 Then ' ���� ������ �� ���� ������� ����������
    ' ��������� ��� ���� �������� � ����� If textCount = 0 Then
Else ' ���� ���� ���������
    e3App.PutInfo INFO_MESSAGE, "������� �������� " & processedTextCount & " ��������� ��������� ��������."
End If

e3App.PutInfo INFO_MESSAGE, "������ ��������."

' ������� ��� ������� �������� � ������
Sub CleanupAndExit()
    Set e3Text = Nothing
    Set job = Nothing
    Set e3App = Nothing
    WScript.Quit
End Sub