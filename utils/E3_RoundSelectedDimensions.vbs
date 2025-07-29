'*******************************************************************************
' �������� �������: E3_RoundSelectedDimensions
' �����: E3.series VBScript Assistant
' ����: 29.07.2025
' ��������: ������ ��� ���������� �������� �������� ��������,
'           ���������� ������������� � E3.series, �� ��������� 5 ��.
'           ��������������, ��� �������� ������� ������ �������� ������.
'           ������������ ������ �������� ������� ����� �������� �������.
'*******************************************************************************

Option Explicit

' --- ���������� ���������� ---
Dim e3Application
Dim job
Dim dimension
Dim message

' --- ��������� ---
Const ROUND_TO_NEAREST = 5 ' ���������� �� 5 ��

' --- ������������� �������� E3.series ---
Set e3Application = CreateObject("CT.Application")
If e3Application Is Nothing Then
    MsgBox "�� ������� ������������ � E3.series. ���������, ��� E3.series �������.", vbCritical
    WScript.Quit
End If

Set job = e3Application.CreateJobObject()
If job Is Nothing Then
    e3Application.PutInfo 2, "������: �� ������� ������� ������ Job."
    Set e3Application = Nothing
    WScript.Quit
End If

Set dimension = job.CreateDimensionObject()

' --- ��������� ���������� �������� ---
Dim selectedDimensionIds()
Dim dimensionCount
dimensionCount = job.GetSelectedDimensionIds(selectedDimensionIds)

If dimensionCount = 0 Then
    e3Application.PutInfo 1, "��������: � ������� �� �������� �� ������ �������. ����������, �������� �������, ������� �� ������ ���������, � ��������� �������."
Else
    e3Application.PutInfo 0, "������� " & dimensionCount & " ���������� �������(��)."

    Dim iDimensionIndex
    For iDimensionIndex = 1 To dimensionCount ' ������ � E3.series API ����� ���������� � 1
        Dim currentDimensionId
        currentDimensionId = selectedDimensionIds(iDimensionIndex)
        
        Dim result
        result = dimension.SetId(currentDimensionId)

        If result Then ' ������� ���������� ID ��� ������� dimension
            Dim dimensionText
            Dim isTextUsed ' 0 - ���������, 1 - ������������� �����
            Dim numericalValue
            Dim roundedValue
            
            result = dimension.GetText(dimensionText, isTextUsed)

            If result Then
                If IsNumeric(dimensionText) Then
                    numericalValue = CDbl(dimensionText)
                    roundedValue = RoundToNearest(numericalValue, ROUND_TO_NEAREST)

                    If roundedValue <> numericalValue Then
                        ' ������������� ����������� �������� ��� ������������� �����
                        ' �������� '1' � SetText ��������, ��� ����� ������������ ������������� �����.
                        result = dimension.SetText(CStr(roundedValue), 1) 
                        If result Then
                            e3Application.PutInfo 0, "������ ID: " & currentDimensionId & " �������� � " & numericalValue & " �� " & roundedValue
                        Else
                            e3Application.PutInfo 2, "������: �� ������� ���������� ����������� ����� ��� ������� ID: " & currentDimensionId
                        End If
                    Else
                        e3Application.PutInfo 0, "������ ID: " & currentDimensionId & " ��� ������������� ������������ �������� (" & numericalValue & "). ���������."
                    End If
                Else
                    e3Application.PutInfo 1, "��������: ������ ID: " & currentDimensionId & " �������� ���������� �������� '" & dimensionText & "'. ���������."
                End If
            Else
                e3Application.PutInfo 2, "������: �� ������� �������� ����� ������� ��� ID: " & currentDimensionId
            End If
        Else
            e3Application.PutInfo 2, "������: �� ������� ���������� ID ��� ������� Dimension (ID: " & currentDimensionId & "). ��������, ������ �� ���������� ��� �� �������� ��������."
        End If
    Next
End If

e3Application.PutInfo 0, "������ ��������."

' --- ������� �������� ---
Set dimension = Nothing
Set job = Nothing
Set e3Application = Nothing

' --- ��������������� ������� ��� ���������� ---
Function RoundToNearest(value, step)
    If step = 0 Then
        RoundToNearest = value
        Exit Function
    End If
    RoundToNearest = Round(value / step) * step
End Function