<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Migration.aspx.cs" Inherits="HospitalInfoSys.Migration" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Database Migration</title>
</head>
<body>
    <form id="form1" runat="server">
         <div>
            <h2>MySQL Database Migration</h2> 
                <table>
                    <thead>
                        
                    </thead>
                    <tbody>
                        <tr>
                            <td>Version:</td>
                            <td><asp:Label ID="lblVersion" runat="server" ForeColor="Red"></asp:Label></td>
                        </tr>
                          <tr>
                            <td>DBName:</td>
                            <td><asp:DropDownList ID="ddlDatabases" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlDatabases_SelectedIndexChanged" /></td>
                        </tr>
                    </tbody>
                </table>
            <asp:Button ID="btnMigrate" runat="server" Text="Run Migration" OnClick="btnMigrate_Click" />
            <br />
             <br />
             <hr />
              
           

             <table border="1">
                    <thead>
                        <tr>
                            <th>Database Name</th>
                            <th>Username</th>
                            <th>Password</th>
                            <th>Port</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>  <asp:TextBox ID="txtcreatedbname" runat="server" PlaceHolder="Create DB Name"></asp:TextBox></td>
                            <td><asp:TextBox ID="txtusname" runat="server" PlaceHolder="DB User"></asp:TextBox></td>
                            <td><asp:TextBox ID="txtpass" runat="server" PlaceHolder="Password" TextMode="Password"></asp:TextBox>
                                <asp:HiddenField ID="hdpass" runat="server" />

                            </td>
                            <td><asp:TextBox ID="txtport" runat="server" PlaceHolder="Port"></asp:TextBox></td>
                        </tr>
                    </tbody>
                </table><br />
               <asp:Button ID="btnCreateDB" runat="server" Text="Create DB" OnClick="btnCreateDB_Click" />

            <asp:Label ID="lblStatus" runat="server" ForeColor="Green"></asp:Label>
        </div>
    </form>
</body>
</html>
