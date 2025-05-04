<%@ Page Title="Change Password" Language="C#" AutoEventWireup="true" CodeBehind="ChangePass.aspx.cs" Inherits="HospitalInfoSys.Shared.ChangePass" %>
<%@ MasterType VirtualPath="~/Site.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
       <style>
        body {
            background-color: #f8f8f8;
        }
        .login-container {
            max-width: 400px;
            margin: 100px auto;
            padding: 30px;
            background: #fff;
            border-radius: 5px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
        }
        .login-container h2 {
            text-align: center;
         
        }
    </style>
    <div class="container">
        <div class="login-container">
          <h4 class="text-center text-primary">Change Password</h4>
        <hr>
     
  
             <div class="form-group">
        <asp:Label ID="lblOldPass" runat="server" Text="Old Password: " />
        <asp:TextBox ID="txtOldPassword"  CssClass="form-control" placeholder="Enter Old password" runat="server" TextMode="Password" /><br />
                 </div>
             <div class="form-group">
        <asp:Label ID="lblNewPass" runat="server" Text="New Password: " />
        <asp:TextBox ID="txtNewPassword"  CssClass="form-control" placeholder="Enter New password" runat="server" TextMode="Password" /><br />
                 </div>
             <div class="form-group">
        <asp:Label ID="lblConfirmPass" runat="server" Text="Confirm Password: " />
        <asp:TextBox ID="txtConfirmPassword"  CssClass="form-control" placeholder="Enter Confirm password" runat="server" TextMode="Password" /><br />
                 </div>
            <div class="row">
          <div class="col-sm-12">
              <asp:Label ID="lblMessage" runat="server" ForeColor="Red" />
            
        <asp:Button ID="btnChangePassword"  CssClass="btn btn-primary btn-block" runat="server" Text="Change Password" OnClick="btnChangePassword_Click" />
           </div>
          </div>
    
            </div>
       </div>
      </div>
    </div>
</asp:Content>