<%@ Page Title="SignUp" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="SignUp.aspx.cs" Inherits="HospitalInfoSys.SignUp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
   <style>
        body {
            background-color: #f8f8f8;
        }
        .login-container {
            max-width: 800px;
            margin: 100px auto;
            padding: 30px;
            background: #fff;
            border-radius: 5px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
        }
        .login-container h2 {
            text-align: center;
            margin-bottom: 20px;
        }
    </style>
    <div class="container">
        <div class="login-container">
          <h4 class="text-center text-primary">Register Account</h4>
        <hr>
      <div class="form-group row">
        <div class="col-sm-4">
            <label class="form-label">First Name</label>
                <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-control" placeholder="Enter Firstname"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvFirstName" runat="server" ControlToValidate="txtFirstName" ErrorMessage="First name is required." CssClass="text-danger" Display="Dynamic"></asp:RequiredFieldValidator>
            </div>
           <div class="col-sm-4">
                <label class="form-label">Last Name</label>
                <asp:TextBox ID="txtLastName" runat="server" CssClass="form-control" placeholder="Enter Lastname"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvLastName" runat="server" ControlToValidate="txtLastName" ErrorMessage="Last name is required." CssClass="text-danger" Display="Dynamic"></asp:RequiredFieldValidator>
            </div>
              <div class="col-sm-4">
                <label class="form-label">Middle Name</label>
                <asp:TextBox ID="txtMiddleName" runat="server" CssClass="form-control" placeholder="Enter Middlename"></asp:TextBox>
            </div>
      </div>
           
       <div class="form-group row">
            <div class="col-sm-4"  style="display:none;">
                <label class="form-label">Position</label>
                <asp:TextBox ID="txtPosition" runat="server" CssClass="form-control" placeholder="Opti"></asp:TextBox>
            </div>
           <div class="col-sm-4">
                <label class="form-label">Email</label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" placeholder="Enter email"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" ErrorMessage="Email is required." CssClass="text-danger" Display="Dynamic"></asp:RequiredFieldValidator>
            </div>
            <div class="col-sm-4">
                <label class="form-label">Contact No</label>
                <asp:TextBox ID="txtContactNo" runat="server" CssClass="form-control" placeholder="Enter contact number"></asp:TextBox>
            </div>
           
        </div>
           <div class="form-group row">
            <div class="col-sm-8">
                <label class="form-label">Address</label>
                <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control" placeholder="Enter address"></asp:TextBox>
            </div>
           </div>
            <div class="form-group row">
              <div class="col-sm-4">
                    <label class="form-label">Username</label>
                    <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" placeholder="Enter username"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvUsername" runat="server" ControlToValidate="txtUsername" ErrorMessage="Username is required." CssClass="text-danger" Display="Dynamic"></asp:RequiredFieldValidator>
                </div>
               <div class="col-sm-4">
                    <label class="form-label">Password</label>
                    <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Enter password"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword" ErrorMessage="Password is required." CssClass="text-danger" Display="Dynamic"></asp:RequiredFieldValidator>
                </div>
              <div class="col-sm-4">
                    <label class="form-label">Confirm Password</label>
                    <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Confirm password"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvConfirmPassword" runat="server" ControlToValidate="txtConfirmPassword" ErrorMessage="Confirm password is required." CssClass="text-danger" Display="Dynamic"></asp:RequiredFieldValidator>
                    <asp:CompareValidator ID="cvPasswordMatch" runat="server" ControlToValidate="txtConfirmPassword" ControlToCompare="txtPassword" ErrorMessage="Passwords do not match." CssClass="text-danger" Display="Dynamic"></asp:CompareValidator>
                </div>
            </div>
               <div class="form-group row">
                     <div class="col-sm-4">
                         </div>
             <div class="col-sm-4  text-center"  style="padding-top: 20px">
                <asp:Button ID="btnSignup" runat="server" CssClass="btn btn-primary btn-block" Text="Sign Up" OnClick="btnSignup_Click" />
            </div>
                     <div class="col-sm-4">
                         </div>
                   </div>
          
            <div class="mt-3 text-center" style="padding-top: 10px">
                <p>Already have an account? <a href="Login" class="text-primary">Login here</a></p>
            </div>
  
    </div>
</div>

</asp:Content>
