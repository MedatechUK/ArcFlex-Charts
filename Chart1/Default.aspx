<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="Default.aspx.vb" Inherits="_Default" Culture="en-gb" UICulture="en-gb"%>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:ScriptManager ID="ScriptManager1" runat="server">
    </asp:ScriptManager>
    <asp:Timer ID="Timer1" runat="server" Interval="30000">
    </asp:Timer>    
    <asp:Label ID="pageof" runat="server" Font-Size="X-Large"></asp:Label>
    <asp:MultiView ID="MultiView1" runat="server">
        <asp:View ID="View1" runat="server">                        
            <asp:GridView ID="GridView1" runat="server" AllowPaging="True" 
                AutoGenerateColumns="False" CellPadding="4" DataSourceID="SqlDataSource1" 
                Font-Size="X-Large" ForeColor="#333333" GridLines="None" 
                Caption="Work To List" CaptionAlign="Top" Width="100%" 
                ShowFooter="True" PageSize="30">
                <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
                <Columns>
                    <asp:BoundField DataField="Due_Date" HeaderText="Due Date" 
                        SortExpression="Due_Date" ReadOnly="True" >
                    </asp:BoundField>
                    <asp:BoundField DataField="Req_Dat" HeaderText="Req Date" 
                        SortExpression="Req_Dat" ReadOnly="True" >
                    </asp:BoundField>
                    <asp:BoundField DataField="Remark_1" HeaderText="Remark 1" ReadOnly="True" 
                        SortExpression="Remark_1" />
                    <asp:BoundField DataField="Remark_2" HeaderText="Remark 2" ReadOnly="True" 
                        SortExpression="Remark_2" />
                    <asp:BoundField DataField="SO_Number" HeaderText="SO Number" 
                        SortExpression="SO_Number" />
                    <asp:BoundField DataField="Cust_Part" HeaderText="Cust Part" 
                        SortExpression="Cust_Part" ReadOnly="True" />
                    <asp:BoundField DataField="Work_Order" HeaderText="Work Order" 
                        SortExpression="Work_Order" ReadOnly="True" />
                    <asp:BoundField DataField="column1" HeaderText="Part" 
                        SortExpression="column1" />
                    <asp:BoundField DataField="Part_Des" HeaderText="Part Des" 
                        SortExpression="Part_Des" />
                    <asp:BoundField DataField="Cust_Order" HeaderText="Cust Order" 
                        SortExpression="Cust_Order" />
                </Columns>
                <FooterStyle BackColor="#FF3000" Font-Bold="True" ForeColor="White" />
                <PagerStyle BackColor="#FF3000" ForeColor="White" HorizontalAlign="Center" />
                <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                <HeaderStyle BackColor="#FF3300" Font-Bold="True" ForeColor="White" 
                    HorizontalAlign="Center" />
                <EditRowStyle BackColor="#999999" />
                <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
            </asp:GridView>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
                ConnectionString="<%$ ConnectionStrings:demoConnectionString %>" 
                
                
                SelectCommand="SELECT [Due Date] AS Due_Date, [Req Dat] AS Req_Dat, [Remark 1] AS Remark_1, [Remark 2] AS Remark_2, [SO Number] AS SO_Number, [Cust Part] AS Cust_Part, [Work Order] AS Work_Order, [Part Des] AS Part_Des, [Part #] AS column1, [Cust Order] AS Cust_Order FROM [ArcflexReport1] ORDER BY [Due Date]"></asp:SqlDataSource>
        </asp:View>
    </asp:MultiView>       
</asp:Content>

