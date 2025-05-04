<%@ Page Title="MyHome" Language="C#" MasterPageFile="~/SitePatient.Master" AutoEventWireup="true" CodeBehind="MyHome.aspx.cs" Inherits="HospitalInfoSys.Patient.MyHome" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        body {
            background-color: #f8f8f8;
        }
        .login-container {
         max-width: 1600px;
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
         /* Modal Background */
    .modal {
        display: none;
        position: fixed;
        z-index: 1;
        left: 0;
        top: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.5);
    }

    /* Modal Content */
    .modal-content {
        background-color: white;
        padding: 20px;
        border-radius: 5px;
        width: 900px;
        margin: 10% auto;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
    }

    /* Close Button */
    .close {
        float: right;
        font-size: 20px;
        cursor: pointer;
    }

    /* Input Styling */
    .form-control {
        width: 100%;
        
        margin: 5px 0;
    }
    </style>
    <div class="container">
        <div class="login-container">
        <h4 class="text-center text-primary">My Appointment</h4>
        <hr>
            <div class="row">
                <div class="col-md-12">
                   <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                    <ContentTemplate>
                                             <div class="form-group row">
                               
                                                <div class="col-sm-4">
                                       
                                                 <asp:TextBox ID="txt_search" CssClass="form-control form-control-sm" placeholder="Enter keyword" runat="server"></asp:TextBox>
                                                </div>
                                              
                                                <div class="col-sm-8">
                                                 
                                                 <asp:LinkButton ID="btn_filter" CssClass=" btn btn-info" 
                                                         runat="server" onclick="btn_filter_Click" > Search</asp:LinkButton>
                                                          <asp:LinkButton ID="btn_reset" CssClass="btn btn-default" 
                                                         runat="server" onclick="btn_reset_Click" BackColor="#999999">Refresh</asp:LinkButton>
                                                 
                                                    <asp:LinkButton ID="btn_add"  CssClass="btn btn-success" runat="server" 
                                     OnClick="btn_add_Click">Book Appointment</asp:LinkButton>
                                                </div>
                                             
                                                  </div>
                            <div class="table-responsive">
                           <asp:GridView ID="gv_masterlist" runat="server" 
                              CssClass="table  table-bordered table-sm  table-hover" 
                              AutoGenerateColumns="false" AllowPaging="true"
                              OnPageIndexChanging="OnPaging" PageSize="10" 
                            GridLines="None" PagerSettings-Mode="NumericFirstLast"
                              HeaderStyle-HorizontalAlign="Center" HeaderStyle-VerticalAlign="Middle" Font-Size="Smaller">
                                  <Columns>
                           <asp:TemplateField>
                                        <HeaderTemplate> Appt. No </HeaderTemplate>
                                     <ItemTemplate>
                                         <asp:HyperLink ID="HyperLink1" runat="server"  Text='<%# Eval("AppointmentNumber") %>' Target="_blank" NavigateUrl='<%#  "~/AppointmentPrint?id=" + Eval("ID") %> '></asp:HyperLink>

                                           </ItemTemplate>
                                   </asp:TemplateField>
                                     
                                               <asp:BoundField DataField="Fullname" HeaderText="Fullname"  />
                                       <asp:BoundField DataField="Age" HeaderText="Age"   />
                                                <asp:BoundField DataField="Sex" HeaderText="Sex"   />
                                      <asp:BoundField DataField="ContactNo" HeaderText="Contact No"    ItemStyle-HorizontalAlign="Left" />
                                                 <asp:BoundField DataField="AppointmentDateTime"   DataFormatString="{0:MMM d, yyyy hh tt}" HtmlEncode="False" HeaderText="Date Appoitment"    ItemStyle-HorizontalAlign="Left" />
                                       <asp:BoundField DataField="Reason" HeaderText="Reason"    ItemStyle-HorizontalAlign="Left" />
                                       <asp:BoundField DataField="PreferedDoctorName" HeaderText="Doctor"    ItemStyle-HorizontalAlign="Left" />
                                        <asp:BoundField DataField="remainingdays" HeaderText="Status" ItemStyle-HorizontalAlign="Center" />

                                   <asp:TemplateField>
                                        <HeaderTemplate> Action </HeaderTemplate>
                                     <ItemTemplate>
                                      <asp:HiddenField ID="hd_id" Value='<%#Eval("ID") %>' runat="server"></asp:HiddenField>
                           <asp:HiddenField ID="hd_status" Value='<%#Eval("Status") %>' runat="server"></asp:HiddenField>
                                      <asp:HiddenField ID="hd_name" Value='<%#Eval("Fullname") %>' runat="server"></asp:HiddenField>
                                         <asp:HiddenField ID="hdFirstname" Value='<%#Eval("Firstname") %>' runat="server"></asp:HiddenField>
                                         <asp:HiddenField ID="hdLastname" Value='<%#Eval("Lastname") %>' runat="server"></asp:HiddenField>
                                         <asp:HiddenField ID="hdBirthDate" Value='<%#Eval("BirthDate") %>' runat="server"></asp:HiddenField>
                                         <asp:HiddenField ID="hdSex" Value='<%#Eval("Sex") %>' runat="server"></asp:HiddenField>
                                      <asp:LinkButton ID="btn_select" CssClass="btn btn-primary btn-xs "  CommandArgument='<%# Eval("ID") %>' onclick="btn_select_Click"  runat="server" >Edit</asp:LinkButton>
                                          
                                      <asp:LinkButton ID="btn_delete" CssClass="btn btn-danger btn-xs " onclick="btn_delete_Click" runat="server"
                                      OnClientClick="return getConfirmation_verify();"
                                       >Delete</asp:LinkButton>
                                     </ItemTemplate>
                                   </asp:TemplateField>
                                 </Columns>
                               </asp:GridView>
                                         <asp:Label ID="lbl_item" runat="server" Text="" CssClass="form-control-label"></asp:Label>
                             </div>
                    </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </div>

    <!-- Modal Container -->
<div id="registerModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeModal()">&times;</span>

          <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                    <ContentTemplate>
        <asp:HiddenField ID="hd_apptid" Value="0" runat="server" />
       
       <div >
          <h4 id="modalTitle" style="text-align: center">Book Appointment</h4>
             <asp:Label ID="lblappointmentNumber" runat="server" Text="" ForeColor="#009933"></asp:Label>
        <hr>
       
            <div class="form-group row">
                  <div class="col-sm-3">
                <label >First Name</label>
                <asp:TextBox ID="Firstname" runat="server" CssClass="form-control" placeholder="Firstname"/>
                <asp:RequiredFieldValidator ID="rfvFirstname" runat="server" ControlToValidate="Firstname" InitialValue="" 
                    ErrorMessage="First Name is required" ForeColor="Red" Font-Size="Smaller" ValidationGroup="add" />
            </div>
            <div class="col-sm-3">
                <label >Middle Name</label>
                <asp:TextBox ID="Middlename" runat="server" CssClass="form-control" placeholder="Middlename"/>
                <asp:RequiredFieldValidator ID="rfvMiddlename" runat="server" ControlToValidate="Middlename" InitialValue="" ValidationGroup="add"
                    ErrorMessage="Middle Name is required" ForeColor="Red" Font-Size="Smaller"/>
            </div>
            <div class="col-sm-3">
                <label >Last Name</label>
                <asp:TextBox ID="Lastname" runat="server" CssClass="form-control" placeholder="Lastname"/>
                <asp:RequiredFieldValidator ID="rfvLastname" runat="server" ControlToValidate="Lastname" InitialValue="" ValidationGroup="add"
                    ErrorMessage="Last Name is required" ForeColor="Red" Font-Size="Smaller"/>
            </div>
            <div class="col-sm-3">
                <label >Sex</label>
                <asp:DropDownList ID="Sex" runat="server" CssClass="form-control">
                    <asp:ListItem Text="Select Sex" Value="" />
                    <asp:ListItem Text="Male" Value="Male" />
                    <asp:ListItem Text="Female" Value="Female" />
                </asp:DropDownList>
                <asp:RequiredFieldValidator ID="rfvSex" runat="server" ControlToValidate="Sex" InitialValue=""  ValidationGroup="add"
                    ErrorMessage="Please select Sex" ForeColor="Red" Font-Size="Smaller"/>
            </div>
            </div>
            
             <div class="form-group row">
                 <div class="col-sm-3">
                <label >Birth Date</label>
                <asp:TextBox ID="BirthDate" runat="server" CssClass="form-control" TextMode="Date" />
                <asp:RequiredFieldValidator ID="rfvBirthDate" runat="server" ControlToValidate="BirthDate" InitialValue="" ValidationGroup="add"
                    ErrorMessage="Birth Date is required" ForeColor="Red" Font-Size="Smaller"/>
            </div>
            <div class="col-sm-3">
                <label >Email</label>
                <asp:TextBox ID="Email" runat="server" CssClass="form-control" placeholder="Email"/>
                <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="Email" InitialValue="" ValidationGroup="add"
                    ErrorMessage="Email is required" ForeColor="Red" Font-Size="Smaller"/>
                <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="Email"
                    ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$" ErrorMessage="Invalid email format" ForeColor="Red" Font-Size="Smaller"/>
            </div>
            <div class="col-sm-3">
                <label >Contact No.</label>
                <asp:TextBox ID="ContactNo" runat="server" CssClass="form-control" placeholder="Contact No"/>
                <asp:RequiredFieldValidator ID="rfvContactNo" runat="server" ControlToValidate="ContactNo" InitialValue="" ValidationGroup="add"
                    ErrorMessage="Contact No. is required" ForeColor="Red" Font-Size="Smaller"/>
            </div>
            <div class="col-sm-3">
                <label >Address</label>
                <asp:TextBox ID="Address" runat="server" CssClass="form-control" TextMode="MultiLine" placeholder="Address"/>
                <asp:RequiredFieldValidator ID="rfvAddress" runat="server" ControlToValidate="Address" InitialValue="" ValidationGroup="add"
                    ErrorMessage="Address is required" ForeColor="Red" Font-Size="Smaller"/>
            </div>
            </div>
          <div class="form-group row">
             <div class="col-sm-4">
                <label>Preferred Doctor</label>
                 <asp:DropDownList ID="PreferredDoctorID"  CssClass="form-control" runat="server"></asp:DropDownList>
                <asp:RequiredFieldValidator ID="rfvPreferredDoctorID" runat="server" ControlToValidate="PreferredDoctorID" InitialValue="" ValidationGroup="add"
                    ErrorMessage="Preferred Doctor is required" ForeColor="Red" Font-Size="Smaller"/>
            </div>
            <div class="col-sm-4">
                <label >Appointment Date & Time</label>
                <asp:TextBox ID="AppointmentDateTime" runat="server" CssClass="form-control" TextMode="DateTimeLocal" />
                <asp:RequiredFieldValidator ID="rfvAppointmentDateTime" runat="server" ControlToValidate="AppointmentDateTime" InitialValue=""  ValidationGroup="add"
                    ErrorMessage="Appointment Date & Time is required" ForeColor="Red" Font-Size="Smaller"/>
            </div>
            <div class="col-sm-4">
                <label>Reason</label>
                <asp:TextBox ID="Reason" runat="server" CssClass="form-control" TextMode="MultiLine" placeholder="Reason"/>
                <asp:RequiredFieldValidator ID="rfvReason" runat="server" ControlToValidate="Reason" InitialValue=""  ValidationGroup="add"
                    ErrorMessage="Reason is required" ForeColor="Red" Font-Size="Smaller"/>
            </div>
                
         </div>
     <div class="form-group row">
                     <div class="col-sm-4">
                         </div>
             <div class="col-sm-6  text-center"  style="padding-top: 20px">
                 <asp:Button ID="btn_submitappt" CssClass="btn btn-success" OnClick="btn_submitappt_Click" ValidationGroup="add"  runat="server" Text="Submit Appointment" />
           
                 <br />
    <br />

                    <asp:HyperLink ID="linkprint" class="btn btn-default" runat="server"   Text="Preview Appointment" Target="_blank" ></asp:HyperLink>
                    </div>
          <div class="col-sm-4">
                         </div>
            </div>
            </div>
                           </ContentTemplate>
                    </asp:UpdatePanel>
    </div>
</div>

<script type="text/javascript">
    function getConfirmation_verify() {
        return confirm("Are you sure you want to delete?");
    }
    function getConfirmation_activate(status) {
        var action = status === "Active" ? "deactivate" : "activate";
        return confirm("Are you sure you want to " + action + "?");
    }
    // MODAL
    function openModal(userId) {
        var title = document.getElementById("modalTitle");
     //   var hdId = document.getElementById("<%= hd_apptid.ClientID %>");
       // userId = hdId.value;
     <%--   var username = document.getElementById("<%= txtUsername.ClientID %>");
        var fname = document.getElementById("<%= txtFirstName.ClientID %>");
        var lname = document.getElementById("<%= txtLastName.ClientID %>");
        var mi = document.getElementById("<%= txtMiddleName.ClientID %>");
        var position = document.getElementById("<%= txtPosition.ClientID %>");
        var position = document.getElementById("<%= txtAddress.ClientID %>");
        var position = document.getElementById("<%= txtContactNo.ClientID %>");
        var position = document.getElementById("<%= dprole.ClientID %>");--%>

        if (userId > 0) {
            title.innerHTML = "Edit Appointment";

       
        } else {
            title.innerHTML = "Add Appointment";

       
        }

        document.getElementById("registerModal").style.display = "block";
    }

    function closeModal() {
        document.getElementById("registerModal").style.display = "none";
    }
    function closeModal1() {
        $('#registerModal').modal('hide'); // For Bootstrap modals
    }
    // Close modal when clicking outside
    window.onclick = function (event) {
        var modal = document.getElementById("registerModal");
        if (event.target == modal) {
            modal.style.display = "none";
        }
    };
</script>
</asp:Content>
