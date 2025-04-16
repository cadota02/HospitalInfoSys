<%@ Page Title="Login" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="HospitalInfoSys.Login" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
     <style>
        body {
            background-color: #f8f8f8;
        }
        .login-container {
            max-width: 350px;
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
        <h4 class="text-center text-primary">Hospital Information System</h4>

        <hr>
           
          <p class="text-center ">Sign in to start your session</p>
           <asp:Login ID="Login2" runat="server" OnAuthenticate="ValidateUser_Auth"   width="100%" >
                    <LayoutTemplate>
           <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Always">
                <ContentTemplate>
                     <div class="form-group">
                    <label for="username" class="small">Username:</label>
        
                       <asp:TextBox ID="UserName" runat="server" CssClass="form-control" name="loginUsername"   PlaceHolder="Username" ToolTip="Enter Username" TabIndex="1"></asp:TextBox>
         
                    </div>
                        <div class="form-group">
                    <label for="password" class="small">Password:</label>
                     <asp:TextBox ID="Password" runat="server" AutoPostBack="false" CssClass="form-control" name="loginPassword" TextMode="Password" PlaceHolder="Password" ToolTip="Enter password" TabIndex="2"></asp:TextBox>
         
                    </div>
                      <div  class="row col-sm-12">
                            
                              <small style="color: #FC7367"> <asp:Literal ID="FailureText" runat="server" EnableViewState="False"></asp:Literal></small>
                        </div>
        <div class="row">
          <div class="col-sm-12">
                  <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server"  Display="None" ErrorMessage="Username is required!" Font-Size="Smaller" ForeColor="#FC7367" 
                        ControlToValidate="UserName" SetFocusOnError="True" ValidationGroup="login"></asp:RequiredFieldValidator>
                   <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server"  Display="None" ErrorMessage="Password is required!" Font-Size="Smaller" ForeColor="#FC7367" 
                        ControlToValidate="Password" SetFocusOnError="True" ValidationGroup="login"></asp:RequiredFieldValidator>
         
              <asp:ValidationSummary ID="vsSummary" Font-Size="Smaller" ForeColor="#CC3300" runat="server"
    ValidationGroup="login"  />
          </div>
          <!-- /.col -->
          <div class="col-sm-12  style="padding-top: 20px"">
         
            <asp:Button ID="LoginButton" runat="server" CommandName="Login" Text="Login" CssClass="btn btn-primary btn-block" TabIndex="3" ValidationGroup="login"/>
          </div>
          <!-- /.col -->
        </div>
     
                         </ContentTemplate>
                  </asp:UpdatePanel>
        </LayoutTemplate>
                 </asp:Login>
  
        <div class="mt-3 text-center" style="margin-top: 15px">
            <p>Don't have an account? <a href="SignUp" class="text-primary">Sign up here</a></p>
        </div>
    </div>
</div>
   
</asp:Content>
