<%@ Page Title="Appointment" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Appointment.aspx.cs" Inherits="HospitalInfoSys.Appointment" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
   
      <style>
        body {
            background-color: #f8f8f8;
        }
        .login-container {
            max-width: 900px;
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
          <h4 class="text-center text-primary">Book Appointment</h4>
             <asp:Label ID="lblappointmentNumber" runat="server" Text="" ForeColor="#009933"></asp:Label>
        <hr>
       
            <div class="form-group row">
                  <div class="col-sm-3">
                <label for="Firstname">First Name</label>
                <asp:TextBox ID="Firstname" runat="server" CssClass="form-control" placeholder="Firstname"/>
                <asp:RequiredFieldValidator ID="rfvFirstname" runat="server" ControlToValidate="Firstname" InitialValue="" 
                    ErrorMessage="First Name is required" ForeColor="Red" Font-Size="Smaller"/>
            </div>
            <div class="col-sm-3">
                <label for="Middlename">Middle Name</label>
                <asp:TextBox ID="Middlename" runat="server" CssClass="form-control" placeholder="Middlename"/>
                <asp:RequiredFieldValidator ID="rfvMiddlename" runat="server" ControlToValidate="Middlename" InitialValue="" 
                    ErrorMessage="Middle Name is required" ForeColor="Red" Font-Size="Smaller"/>
            </div>
            <div class="col-sm-3">
                <label for="Lastname">Last Name</label>
                <asp:TextBox ID="Lastname" runat="server" CssClass="form-control" placeholder="Lastname"/>
                <asp:RequiredFieldValidator ID="rfvLastname" runat="server" ControlToValidate="Lastname" InitialValue="" 
                    ErrorMessage="Last Name is required" ForeColor="Red" Font-Size="Smaller"/>
            </div>
            <div class="col-sm-3">
                <label for="Sex">Sex</label>
                <asp:DropDownList ID="Sex" runat="server" CssClass="form-control">
                    <asp:ListItem Text="Select Sex" Value="" />
                    <asp:ListItem Text="Male" Value="Male" />
                    <asp:ListItem Text="Female" Value="Female" />
                </asp:DropDownList>
                <asp:RequiredFieldValidator ID="rfvSex" runat="server" ControlToValidate="Sex" InitialValue="" 
                    ErrorMessage="Please select Sex" ForeColor="Red" Font-Size="Smaller"/>
            </div>
            </div>
            
             <div class="form-group row">
                 <div class="col-sm-3">
                <label for="BirthDate">Birth Date</label>
                <asp:TextBox ID="BirthDate" runat="server" CssClass="form-control" TextMode="Date" />
                <asp:RequiredFieldValidator ID="rfvBirthDate" runat="server" ControlToValidate="BirthDate" InitialValue="" 
                    ErrorMessage="Birth Date is required" ForeColor="Red" Font-Size="Smaller"/>
            </div>
            <div class="col-sm-3">
                <label for="Email">Email</label>
                <asp:TextBox ID="Email" runat="server" CssClass="form-control" placeholder="Email"/>
                <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="Email" InitialValue="" 
                    ErrorMessage="Email is required" ForeColor="Red" Font-Size="Smaller"/>
                <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="Email"
                    ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$" ErrorMessage="Invalid email format" ForeColor="Red" Font-Size="Smaller"/>
            </div>
            <div class="col-sm-3">
                <label for="ContactNo">Contact No.</label>
                <asp:TextBox ID="ContactNo" runat="server" CssClass="form-control" placeholder="Contact No"/>
                <asp:RequiredFieldValidator ID="rfvContactNo" runat="server" ControlToValidate="ContactNo" InitialValue="" 
                    ErrorMessage="Contact No. is required" ForeColor="Red" Font-Size="Smaller"/>
            </div>
            <div class="col-sm-3">
                <label for="Address">Address</label>
                <asp:TextBox ID="Address" runat="server" CssClass="form-control" TextMode="MultiLine" placeholder="Address"/>
                <asp:RequiredFieldValidator ID="rfvAddress" runat="server" ControlToValidate="Address" InitialValue="" 
                    ErrorMessage="Address is required" ForeColor="Red" Font-Size="Smaller"/>
            </div>
            </div>
          <div class="form-group row">
             <div class="col-sm-4">
                <label for="PreferredDoctorID">Preferred Doctor</label>
                 <asp:DropDownList ID="PreferredDoctorID"  CssClass="form-control" runat="server"></asp:DropDownList>
                <asp:RequiredFieldValidator ID="rfvPreferredDoctorID" runat="server" ControlToValidate="PreferredDoctorID" InitialValue="" 
                    ErrorMessage="Preferred Doctor is required" ForeColor="Red" Font-Size="Smaller"/>
            </div>
            <div class="col-sm-4">
                <label for="AppointmentDateTime">Appointment Date & Time</label>
                <asp:TextBox ID="AppointmentDateTime" runat="server" CssClass="form-control" TextMode="DateTimeLocal" />
                <asp:RequiredFieldValidator ID="rfvAppointmentDateTime" runat="server" ControlToValidate="AppointmentDateTime" InitialValue="" 
                    ErrorMessage="Appointment Date & Time is required" ForeColor="Red" Font-Size="Smaller"/>
            </div>
            <div class="col-sm-4">
                <label for="Reason">Reason</label>
                <asp:TextBox ID="Reason" runat="server" CssClass="form-control" TextMode="MultiLine" placeholder="Reason"/>
                <asp:RequiredFieldValidator ID="rfvReason" runat="server" ControlToValidate="Reason" InitialValue="" 
                    ErrorMessage="Reason is required" ForeColor="Red" Font-Size="Smaller"/>
            </div>
                
         </div>
     <div class="form-group row">
                     <div class="col-sm-4">
                         </div>
             <div class="col-sm-6  text-center"  style="padding-top: 20px">
            <button type="submit" class="btn btn-primary" runat="server" OnServerClick="SubmitAppointment">Submit Appointment</button>
                 <br />
    <br />

                    <asp:HyperLink ID="linkprint" class="btn btn-default" runat="server"   Text="Preview Appointment" Target="_blank" ></asp:HyperLink>
                    </div>
          <div class="col-sm-4">
                         </div>
            </div>
            </div>
          </div>
   
</asp:Content>
