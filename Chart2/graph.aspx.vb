Imports System.Xml
Imports System.Collections
Imports System.Collections.Generic

Partial Class _Default
    Inherits System.Web.UI.Page

    Private vws As List(Of View)
    Public query As String = "SELECT        dbo.CUSTOMERS.CUSTDES AS Customer, dbo.ORDERS.ORDNAME AS [Order], dbo.fnFormatDate(dbo.MINTODATE(dbo.ORDERS.CURDATE), 'DD/MM/YY') AS Date, " & _
                 "dbo.PART.PARTNAME AS [Part Number], dbo.PART.PARTDES AS [Part Description], dbo.fnFormatDate(dbo.MINTODATE(dbo.ORDERITEMS.DUEDATE), 'DD/MM/YY')" & _
                 "AS [Due Date], dbo.ORDERITEMS.TQUANT / 1000 AS [Ordered Qty], dbo.ORDERITEMS.TBALANCE / 1000 AS Balance, " & _
                 "dbo.TRANSORDER.TQUANT / 1000 AS [Transaction Quantity], " & _
                 "CASE WHEN TRANSORDER.TYPE = 'X' THEN INVOICES.IVNUM WHEN TRANSORDER.TYPE = 'V' THEN INVOICES.IVNUM ELSE DOCUMENTS.DOCNO END AS Expr1, " & _
                 "dbo.fnFormatDate(dbo.MINTODATE(dbo.TRANSORDER.CURDATE), 'DD/MM/YY') AS Expr2, " & _
                 "CASE WHEN TRANSORDER.CURDATE = 0 THEN '' " & _
                 "ELSE DATEDIFF(DAY, dbo.MINTODATE(ORDERITEMS.DUEDATE), dbo.MINTODATE(TRANSORDER.CURDATE)) " & _
                 "END AS [Day Diff]" & _
                 "FROM            dbo.ORDERS INNER JOIN" & _
                 "dbo.ORDERITEMS ON dbo.ORDERS.ORD = dbo.ORDERITEMS.ORD INNER JOIN" & _
                 "dbo.CUSTOMERS ON dbo.CUSTOMERS.CUST = dbo.ORDERS.CUST INNER JOIN" & _
                 "dbo.PART ON dbo.ORDERITEMS.PART = dbo.PART.PART INNER JOIN" & _
                 "dbo.PARTPARAM ON dbo.PART.PART = dbo.PARTPARAM.PART INNER JOIN" & _
                 "dbo.ORDSTATUS ON dbo.ORDERS.ORDSTATUS = dbo.ORDSTATUS.ORDSTATUS RIGHT OUTER JOIN" & _
                 "dbo.TRANSORDER ON dbo.ORDERITEMS.ORDI = dbo.TRANSORDER.ORDI RIGHT OUTER JOIN" & _
                 "dbo.DOCUMENTS ON dbo.DOCUMENTS.DOC = dbo.TRANSORDER.DOC AND dbo.TRANSORDER.TYPE = 'X' OR dbo.TRANSORDER.TYPE = 'Y' RIGHT OUTER JOIN" & _
                 "dbo.INVOICES ON dbo.INVOICES.IV = dbo.TRANSORDER.DOC AND dbo.TRANSORDER.TYPE = 'X' OR dbo.TRANSORDER.TYPE = 'V' RIGHT OUTER JOIN" & _
                 "dbo.DOCTYPES ON dbo.TRANSORDER.TYPE = dbo.DOCTYPES.TYPE" & _
                "WHERE        (dbo.PARTPARAM.INVFLAG = 'Y') AND (dbo.ORDSTATUS.MANAGERREPOUT <> 'Y') AND (dbo.ORDERS.FORECASTFLAG <> 'S') AND " & _
                 "(dbo.ORDERS.FORECASTFLAG <> 'F') AND (dbo.DOCTYPES.OTYPE <> 'P') AND (dbo.TRANSORDER.TYPE NOT IN ('F', 'I', 'J', 'K', 'P', 'W', 'Y', 'L')) AND " & _
                 "(dbo.ORDERITEMS.ORD <> 0) AND (dbo.DOCUMENTS.TYPE <> 'A') AND (dbo.TRANSORDER.TQUANT <> 0) AND (dbo.MINTODATE(dbo.ORDERITEMS.DUEDATE) "


    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            vws = Views()
            If MultiView1.ActiveViewIndex = -1 Then
                MultiView1.ActiveViewIndex = 0
                If Not IsNothing(Grid(vws(MultiView1.ActiveViewIndex))) Then
                    Grid(vws(MultiView1.ActiveViewIndex)).DataBind()
                    SetCaption(Grid(vws(MultiView1.ActiveViewIndex)))
                End If
                If Not IsNothing(Request("p")) Then
                    Try
                        Timer1.Interval = Request("p") * 1000
                    Catch
                    End Try
                End If
            End If
        Catch ex As Exception
            Response.Write(String.Format("{1}{0}{2}", "{br}", ex.Message, ex.StackTrace))
        End Try


        Dim d As Integer
        Try
            d = CInt(Request("d"))
        Catch ex As Exception
            d = 14
        End Try

        Query &= "BETWEEN DATEADD(day, - " & d & ", GETDATE()) AND GETDATE()) "

    End Sub

    Protected Sub Timer1_Tick(ByVal sender As Object, ByVal e As System.EventArgs) Handles Timer1.Tick

        'If Not IsNothing(Grid(vws(MultiView1.ActiveViewIndex + 1))) Then
        '    If Grid(vws(MultiView1.ActiveViewIndex)).PageIndex < _
        '        Grid(vws(MultiView1.ActiveViewIndex)).PageCount - 1 Then
        '        Grid(vws(MultiView1.ActiveViewIndex)).PageIndex += 1
        '    Else
        '        Grid(vws(MultiView1.ActiveViewIndex)).PageIndex = 0
        '        If MultiView1.ActiveViewIndex >= vws.Count - 1 Then
        '            MultiView1.ActiveViewIndex = 0
        '        Else
        '            MultiView1.ActiveViewIndex += 1
        '        End If
        '        Grid(vws(MultiView1.ActiveViewIndex)).DataBind()
        '    End If
        '    SetCaption(Grid(vws(MultiView1.ActiveViewIndex)))
        'Else
        '    If MultiView1.ActiveViewIndex >= vws.Count - 1 Then
        '        MultiView1.ActiveViewIndex = 0
        '    Else
        '        MultiView1.ActiveViewIndex += 1
        '    End If
        'End If
        Try
            If Not IncrementGrid(Grid(vws(MultiView1.ActiveViewIndex))) Then IncrementView()
        Catch ex As Exception
            Response.Write(String.Format("{1}{0}{2}", "{br}", ex.Message, ex.StackTrace))
        End Try
    End Sub

    Private Sub IncrementView()

        Dim retrycount As Integer = 0

        If MultiView1.ActiveViewIndex >= vws.Count - 1 Then
            MultiView1.ActiveViewIndex = 0
        Else
            MultiView1.ActiveViewIndex += 1
        End If
10:
        Try
            If Not IsNothing(Grid(vws(MultiView1.ActiveViewIndex))) Then
                Grid(vws(MultiView1.ActiveViewIndex)).DataBind()
                SetCaption(Grid(vws(MultiView1.ActiveViewIndex)))
            End If

        Catch ex As Exception
            ' A DIVZERO error may be caused by there being no data in the table
            ' whilst the data is refreshing

            ' Wait for two seconds.
            System.Threading.Thread.Sleep(2000)

            ' And then try again.            
            If retrycount < 10 Then
                retrycount += 1
                GoTo 10
            Else
                ' Return the error to the calling sub
                Throw ex
            End If

        End Try

    End Sub

    Private Function IncrementGrid(ByVal grid As GridView) As Boolean
        If Not IsNothing(grid) Then
            If grid.PageIndex < grid.PageCount - 1 Then
                grid.PageIndex += 1
                SetCaption(grid)
                Return True
            Else
                grid.PageIndex = 0
                Return False
            End If
        End If
        Return False
    End Function

    Private Function Grid(ByVal vw As View) As GridView
        For Each c As Control In vw.Controls
            If c.ToString = "System.Web.UI.WebControls.GridView" Then
                Return c
                Exit Function
            End If
        Next
        Return Nothing
    End Function

    Private Function Views() As List(Of View)
        Try
            Dim ret As New List(Of View)
            For Each c As Control In MultiView1.Controls
                ret.Add(c)
            Next
            Return ret
        Catch ex As Exception
            Response.Write(String.Format("{1}{0}{2}", "{br}", ex.Message, ex.StackTrace))
            Return Nothing
        End Try
    End Function

    Private Sub SetCaption(ByVal gv As GridView)
        Try
            Dim cap As String = gv.Caption
            If InStr(cap, ">") Then
                cap = Trim(Split(Split(gv.Caption, "|")(0), ">")(1))
            Else
                cap = Trim(Split(gv.Caption, "|")(0))
            End If
            gv.Caption = String.Format("<div style={0}align: center; width: 99%; border-style: outset; font-family: Verdana; font-size: xx-large; color: #FFFFFF; background-color: #{4}{5}{6}; text-align: center;{0}> {1} | Page {2} of {3}</div><Br />", _
                                       Chr(34), _
                                       cap, _
                                       gv.PageIndex + 1, _
                                       gv.PageCount, _
                                       Right("00" & Hex(gv.HeaderStyle.BackColor.R), 2), _
                                       Right("00" & Hex(gv.HeaderStyle.BackColor.G), 2), _
                                       Right("00" & Hex(gv.HeaderStyle.BackColor.B), 2) _
            )
        Catch ex As Exception
            Response.Write(String.Format("{1}{0}{2}", "{br}", ex.Message, ex.StackTrace))
        End Try
    End Sub

    Dim totalQuotes As Decimal = 0
    Dim totalIvs As Decimal = 0

    'Protected Sub SumColumns(ByVal sender As Object, ByVal e As GridViewRowEventArgs) Handles GridView1.RowDataBound
    '    Select Case e.Row.RowType
    '        Case DataControlRowType.DataRow
    '            If IsNumeric(e.Row.Cells(1).Text.Replace(",", "").Replace("&#163;", "")) Then totalQuotes += CDbl(e.Row.Cells(1).Text.Replace(",", "").Replace("&#163;", ""))
    '            If IsNumeric(e.Row.Cells(3).Text.Replace(",", "").Replace("&#163;", "")) Then totalIvs += CDbl(e.Row.Cells(3).Text.Replace(",", "").Replace("&#163;", ""))
    '        Case DataControlRowType.Footer
    '            With e.Row.Cells(1)
    '                .Text = String.Format("{0}", totalQuotes.ToString("###,###,###"))
    '                .HorizontalAlign = HorizontalAlign.Center
    '            End With
    '            With e.Row.Cells(3)
    '                .Text = String.Format("{0}", totalIvs.ToString("###,###,###"))
    '                .HorizontalAlign = HorizontalAlign.Center
    '            End With
    '    End Select
    'End Sub

End Class
