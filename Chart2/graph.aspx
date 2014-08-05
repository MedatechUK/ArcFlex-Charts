<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="graph.aspx.vb" Inherits="_Default" Culture="en-gb" UICulture="en-gb"%>

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
                    <asp:BoundField DataField="Customer" HeaderText="Customer" 
                        SortExpression="Customer" >
                    </asp:BoundField>
                    <asp:BoundField DataField="Order" HeaderText="Order" 
                        SortExpression="Order" >
                    </asp:BoundField>
                    <asp:BoundField DataField="Date" HeaderText="Date" ReadOnly="True" 
                        SortExpression="Date" />
                    <asp:BoundField DataField="Part_Number" HeaderText="Part Number" 
                        SortExpression="Part_Number" />
                    <asp:BoundField DataField="Part_Description" HeaderText="Part Description" 
                        SortExpression="Part_Description" />
                    <asp:BoundField DataField="Due_Date" HeaderText="Due Date" 
                        SortExpression="Due_Date" ReadOnly="True" />
                    <asp:BoundField DataField="Ordered_Qty" HeaderText="Ordered Qty" 
                        ReadOnly="True" SortExpression="Ordered_Qty" />
                    <asp:BoundField DataField="Balance" HeaderText="Balance" ReadOnly="True" 
                        SortExpression="Balance" />
                    <asp:BoundField DataField="Transaction_Quantity" HeaderText="Transact. Qty" 
                        ReadOnly="True" SortExpression="Transaction_Quantity" />
                    <asp:BoundField DataField="Expr2" HeaderText="Transact. Date" ReadOnly="True" 
                        SortExpression="Expr2" />
                    <asp:BoundField DataField="Expr1" HeaderText="Inv/Doc Num." ReadOnly="True" 
                        SortExpression="Expr1" />
                    <asp:BoundField DataField="Expr3" HeaderText="Some Date" ReadOnly="True" 
                        SortExpression="Expr3" />
                </Columns>
                <FooterStyle BackColor="#FF3000" Font-Bold="True" ForeColor="White" />
                <PagerStyle BackColor="#FF3000" ForeColor="White" HorizontalAlign="Center" />
                <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                <HeaderStyle BackColor="#FF3300" Font-Bold="True" ForeColor="White" 
                    HorizontalAlign="Center" />
                <EditRowStyle BackColor="#999999" />
                <AlternatingRowStyle BackColor="#E9E9E9" ForeColor="#284775" />
            </asp:GridView>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
                ConnectionString="Data Source=PADDY\PRI;Initial Catalog=demo;User ID=tabula;Password=Tabula!" 
                SelectCommand="<% =query %>" />
        </asp:View>
    </asp:MultiView>       
</asp:Content>

