<%@ Page Title="Patient" Language="C#" MasterPageFile="~/SiteAdmin.Master"  EnableEventValidation="true" AutoEventWireup="true" CodeBehind="ManagePatient.aspx.cs" Inherits="HospitalInfoSys.Admin.ManagePatient" %>
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
        .form-control {
        width: 100%;  
        margin: 5px 0;
    }
        .panel-margin20px{
             margin: 20px;
        }
        .text-sm
        {
            font-size:smaller;
        }
        .badge-custom-success {
            background-color: #28a745; /* Green */
            color: white;
            padding: 5px 10px;
            border-radius: 12px;
            font-size: 12px;
        }

        .badge-custom-info {
            background-color: #17a2b8; /* Blue */
            color: white;
            padding: 5px 10px;
            border-radius: 12px;
            font-size: 12px;
        }

        .badge-custom-warning {
            background-color: #ffc107; /* Yellow */
            color: white;
            padding: 5px 10px;
            border-radius: 12px;
            font-size: 12px;
        }

        .badge-custom-danger {
            background-color: #dc3545; /* Red */
            color: white;
            padding: 5px 10px;
            border-radius: 12px;
            font-size: 12px;
        }
 </style>
    <div class="container pt-10">
        <div class="login-container mt-5">
            <div class="row">
                 <div class="col-md-4">
                    <h4>Patient Management:  
                        <span class="badge <%= (statusentry == "New") ? "badge-custom-success" : "badge-custom-info" %>">
                            <%= statusentry %>
                        </span>
                    </h4> 
                  </div>
                 <div class="col-md-8" style="text-align:right;">
                        <asp:UpdatePanel ID="UpdatePanel2" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                    <asp:Button ID="btnOpenModal"  runat="server" Text="Search Patient"
            CssClass="btn btn-default btn-sm" OnClick="btnOpenModal_Click" />
                        </ContentTemplate>
                            </asp:UpdatePanel>
                     </div>
                </div>
        <!-- Bootstrap NavTabs for Tab Navigation -->
        <ul class="nav nav-tabs" id="myTabs" role="tablist">
            <li class="nav-item">
                <a class="nav-link active" id="profile-tab" data-toggle="tab" href="#profile" role="tab" aria-controls="profile" aria-selected="true">Patient Profile</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" id="medical-tab" data-toggle="tab" href="#medical" role="tab" aria-controls="medical" aria-selected="false">Medical Information</a>
            </li>
           
        </ul>

        <!-- Tab Content -->
        <div class="tab-content mt-3">
            <div class="tab-pane fade panel-margin20px" id="profile" role="tabpanel" aria-labelledby="profile-tab">
                <asp:UpdatePanel ID="UpdatePanelProfile" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <asp:Panel ID="PanelProfile"  runat="server" >
                            <asp:HiddenField ID="hd_profileid" Value="0" runat="server" />
              <div class="row mb-2">
    <div class="col-md-4">
        <asp:Label ID="lblHealthNo" runat="server" Text="Health Record No" CssClass="form-label" AssociatedControlID="txtHealthNo" />
        <asp:TextBox ID="txtHealthNo"  ReadOnly="true" runat="server" CssClass="form-control" PlaceHolder="Health Number" />
            <asp:RequiredFieldValidator ID="rfvHealthNo" runat="server" ControlToValidate="txtHealthNo"
            ErrorMessage="Required" Display="Dynamic" CssClass="text-danger text-sm" ValidationGroup="saveprofile" />
    </div>
    <div class="col-md-4">
        <asp:Label ID="lblFirstName" runat="server" Text="First Name" CssClass="form-label" AssociatedControlID="txtFirstName" />
        <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-control" PlaceHolder="Firstname" />
        <asp:RequiredFieldValidator ID="rfvFirstName" runat="server" ControlToValidate="txtFirstName"
            ErrorMessage="Required" Display="Dynamic" CssClass="text-danger text-sm" ValidationGroup="saveprofile" />
    </div>
      <div class="col-md-4">
        <asp:Label ID="lblLastName" runat="server" Text="Last Name" CssClass="form-label" AssociatedControlID="txtLastName" />
        <asp:TextBox ID="txtLastName" runat="server" CssClass="form-control" PlaceHolder="Lastname" />
        <asp:RequiredFieldValidator ID="rfvLastName" runat="server" ControlToValidate="txtLastName"
            ErrorMessage="Required" Display="Dynamic" CssClass="text-danger text-sm" ValidationGroup="saveprofile" />
    </div>
</div>

<div class="row mb-2">
   
    <div class="col-md-4">
        <asp:Label ID="lblMiddleName" runat="server" Text="Middle Name" CssClass="form-label" AssociatedControlID="txtMiddleName" />
        <asp:TextBox ID="txtMiddleName" runat="server" CssClass="form-control" PlaceHolder="Middlename" />
    </div>
     <div class="col-md-4">
        <asp:Label ID="lblBirthDate" runat="server" Text="Birthdate" CssClass="form-label" AssociatedControlID="txtBirthDate" />
        <asp:TextBox ID="txtBirthDate" runat="server" CssClass="form-control" TextMode="Date" />
        <asp:RequiredFieldValidator ID="rfvBirthDate" runat="server" ControlToValidate="txtBirthDate"
            ErrorMessage="Required" Display="Dynamic" CssClass="text-danger text-sm" ValidationGroup="saveprofile" />
      <asp:CompareValidator ID="cvBirthDate" runat="server" ControlToValidate="txtBirthDate"
                    Operator="LessThanEqual"  Type="Date" ErrorMessage ="Birthdate cannot be in the future"
                    CssClass="text-danger text-sm" Display="Dynamic" ValidationGroup="saveprofile" />
    </div>
    <div class="col-md-4">
        <asp:Label ID="lblSex" runat="server" Text="Sex" CssClass="form-label" AssociatedControlID="ddlSex" />
        <asp:DropDownList ID="ddlSex" runat="server" CssClass="form-control">
            <asp:ListItem Text="-- Select --" Value="" />
            <asp:ListItem Text="Male" Value="Male" />
            <asp:ListItem Text="Female" Value="Female" />
        </asp:DropDownList>
        <asp:RequiredFieldValidator ID="rfvSex" runat="server" ControlToValidate="ddlSex"
            InitialValue="" ErrorMessage="Required" Display="Dynamic" CssClass="text-danger text-sm" ValidationGroup="saveprofile" />
    </div>
</div>



<div class="row mb-2">
    <div class="col-md-4">
        <asp:Label ID="lblAddress" runat="server" Text="Address" CssClass="form-label" AssociatedControlID="txtAddress" />
        <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control" PlaceHolder="Address" />
         <asp:RequiredFieldValidator ID="rfvaddress" runat="server" ControlToValidate="txtAddress"
            InitialValue="" ErrorMessage="Required" Display="Dynamic" CssClass="text-danger text-sm" ValidationGroup="saveprofile" />
    </div>
    <div class="col-md-4">
        <asp:Label ID="lblContactNo" runat="server" Text="Contact No" CssClass="form-label" AssociatedControlID="txtContactNo" />
        <asp:TextBox ID="txtContactNo" runat="server" CssClass="form-control" PlaceHolder="Contact No" />
    </div>
     <div class="col-md-4">
        <asp:Label ID="lblEmail" runat="server" Text="Email" CssClass="form-label" AssociatedControlID="txtEmail" />
        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" PlaceHolder="Email Address" />
        <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail"
            ValidationExpression="\w+([-+.'']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
            ErrorMessage="Invalid Email Format" Display="Dynamic" CssClass="text-danger text-sm" ValidationGroup="saveprofile" />
    </div>
</div>



<div class="row mb-2">
     <div class="col-md-4">
        <asp:Label ID="lblOccupation" runat="server" Text="Occupation" CssClass="form-label" AssociatedControlID="txtOccupation" />
        <asp:TextBox ID="txtOccupation" runat="server" CssClass="form-control" PlaceHolder="Occupation" />
    </div>
    <div class="col-md-4">
        <asp:Label ID="lblCPName" runat="server" Text="Contact Person Name" CssClass="form-label" AssociatedControlID="txtCPName" />
        <asp:TextBox ID="txtCPName" runat="server" CssClass="form-control" PlaceHolder="Contact Person" />
    </div>
    <div class="col-md-4">
        <asp:Label ID="lblCPContactNo" runat="server" Text="Contact Person No" CssClass="form-label" AssociatedControlID="txtCPContactNo" />
        <asp:TextBox ID="txtCPContactNo" runat="server" CssClass="form-control" PlaceHolder="Contact No" />
    </div>
</div>

<div class="row mb-2">
    <div class="col-md-4">
        <asp:Label ID="lblDateRegistered" runat="server" Text="Date Registered" CssClass="form-label" AssociatedControlID="txtDateRegistered" />
        <asp:TextBox ID="txtDateRegistered" runat="server" CssClass="form-control" TextMode="Date" />
        <asp:RequiredFieldValidator ID="rfvDateRegistered" runat="server" ControlToValidate="txtDateRegistered"
            ErrorMessage="Required" Display="Dynamic" CssClass="text-danger text-sm" ValidationGroup="saveprofile" />
    </div>
</div>

  <div style="text-align: center">
                             <asp:Button ID="btnSelectProfile" Visible="false" runat="server" Text="Go to Profile Tab" OnClientClick="$('#medical-tab').tab('show'); return false;" />
                      <asp:Button ID="btnSaveProfile" runat="server" CssClass="btn btn-success"
                            Text="Submit" OnClick="btnSaveProfile_Click" ValidationGroup="saveprofile" />
                            <asp:Button ID="btnNext" runat="server" CssClass="btn btn-info"
                            Text="Next" OnClick="btnNext_Click" ValidationGroup="saveprofile" />
      </div>
                            </asp:Panel>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
            <div class="tab-pane fade panel-margin20px" id="medical" role="tabpanel" aria-labelledby="medical-tab">
                <asp:UpdatePanel ID="UpdatePanelMedical" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <asp:HiddenField ID="hd_medicalid" Value="0" runat="server" />
                        <asp:Panel ID="PanelMedical" runat="server">
                         <div class="row mb-2">
                              <div class="col-md-4">
                                <div class="form-group">
                                  <label>Date of Visit</label>
                                  <asp:TextBox ID="txtConsultDate" runat="server" CssClass="form-control" TextMode="DateTimeLocal" Placeholder="Enter consultation date" />
                                  <asp:RequiredFieldValidator ID="rfvConsultDate" runat="server" ControlToValidate="txtConsultDate"
                                    ErrorMessage="Required" Display="Dynamic" CssClass="text-danger text-sm" ValidationGroup="medicalsave" />
                                </div>
                              </div>

                              <div class="col-md-4">
                                <div class="form-group">
                                  <label>Type of Visit</label>
                                  <asp:DropDownList ID="ddlConsultType" runat="server" CssClass="form-control" AutoPostBack="True" OnSelectedIndexChanged="ddlConsultType_SelectedIndexChanged">
                               
                                    <asp:ListItem Text="Admission" Value="Admission" />
                                    <asp:ListItem Text="Outpatient" Value="Outpatient" />
                                    <asp:ListItem Text="Emergency" Value="Emergency" />
                                  </asp:DropDownList>
                                  <asp:RequiredFieldValidator ID="rfvConsultType" runat="server" ControlToValidate="ddlConsultType"
                                    InitialValue="" ErrorMessage="Required" Display="Dynamic" CssClass="text-danger text-sm" ValidationGroup="medicalsave" />
                                </div>
                              </div>

                              <div class="col-md-4">
                                <div class="form-group">
                                  <label>Chief Complaint</label>
                                  <asp:TextBox ID="txtChiefComplaint" runat="server" CssClass="form-control" Placeholder="Enter chief complaint" />
                                  <asp:RequiredFieldValidator ID="rfvChiefComplaint" runat="server" ControlToValidate="txtChiefComplaint"
                                    ErrorMessage="Required" Display="Dynamic" CssClass="text-danger text-sm" ValidationGroup="medicalsave" />
                                </div>
                              </div>

                              <div class="col-md-4">
                                <div class="form-group">
                                  <label>Medical History</label>
                                  <asp:TextBox ID="txtMedicalHistory" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="2" Placeholder="Enter medical history" />
                                  <asp:RequiredFieldValidator ID="rfvMedicalHistory" runat="server" ControlToValidate="txtMedicalHistory"
                                    ErrorMessage="Required" Display="Dynamic" CssClass="text-danger text-sm" ValidationGroup="medicalsave" />
                                </div>
                              </div>

                              <div class="col-md-4">
                                <div class="form-group">
                                  <label>Allergies</label>
                                  <asp:TextBox ID="txtAllergies" runat="server" CssClass="form-control" Placeholder="Enter known allergies" />
                                
                                </div>
                              </div>

                              <div class="col-md-4">
                                <div class="form-group">
                                  <label>Diagnosis</label>
                                  <asp:TextBox ID="txtDiagnosis" runat="server" CssClass="form-control" Placeholder="Enter diagnosis" />
                                  <asp:RequiredFieldValidator ID="rfvDiagnosis" runat="server" ControlToValidate="txtDiagnosis"
                                    ErrorMessage="Required" Display="Dynamic" CssClass="text-danger text-sm" ValidationGroup="medicalsave" />
                                </div>
                              </div>

                              <div class="col-md-4">
                                <div class="form-group">
                                  <label>Room </label>
                                  <asp:DropDownList ID="ddlRoom" runat="server" CssClass="form-control" AppendDataBoundItems="true">
                              
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="rfvRoom" runat="server" ControlToValidate="ddlRoom"
                                  InitialValue="" ErrorMessage="Required" Display="Dynamic" CssClass="text-danger text-sm" ValidationGroup="medicalsave" />
                                </div>
                              </div>

                              <div class="col-md-4">
                                <div class="form-group">
                                  <label>Doctor ID</label>
                                 <asp:DropDownList ID="ddlDoctor" runat="server" CssClass="form-control" AppendDataBoundItems="true">
                              
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="rfvDoctor" runat="server" ControlToValidate="ddlDoctor"
                                  InitialValue="" ErrorMessage="Required" Display="Dynamic" CssClass="text-danger text-sm" ValidationGroup="medicalsave" />
                                </div>
                              </div>

                              <div class="col-md-4">
                                <div class="form-group">
                                  <label>Discharge Date</label>
                                  <asp:TextBox  ID="txtDischarge" runat="server" CssClass="form-control" TextMode="DateTimeLocal" Placeholder="Enter discharge date" />
                                  
                                </div>
                              </div>

                              <div class="col-md-4">
                                <div class="form-group">
                                  <label>Disposition</label>
                                  <asp:TextBox ID="txtDisposition" runat="server" CssClass="form-control" Placeholder="Enter patient disposition" />
                               
                                </div>
                              </div>
                             
                              <div class="col-md-12 text-end" style="text-align: center">
                                <asp:Button ID="btnSaveConsultation" runat="server" Text="Submit"
                                  CssClass="btn btn-primary" OnClick="btnSaveConsultation_Click" ValidationGroup="medicalsave" />
                              </div>
                            </div>
                        </asp:Panel>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
            
        </div>
             <div class="col-md-12 text-end" style="text-align: right">
             <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl="~/PatientRecord">Back to Patient List</asp:HyperLink>
        </div>
    </div>
        
        </div>

     <!-- Modal Search Patient -->
        <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">

                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                        <h4 class="modal-title" id="myModalLabel">Search Patient</h4>
                    </div>

                    <div class="modal-body">
                         <asp:UpdatePanel ID="UpdatePanelSearch" runat="server" >
                    <ContentTemplate>
                         <!-- Search Inputs -->
                        <div class="form-inline">
                            <asp:TextBox ID="txt_searchlname" runat="server" CssClass="form-control" Placeholder="Last Name" />
                            <asp:TextBox ID="txt_searchfname" runat="server" CssClass="form-control" Placeholder="First Name" />
                            <asp:TextBox ID="txt_searchmi" runat="server" CssClass="form-control" Placeholder="Middle Name" />
                            <asp:Button ID="btnSearch" runat="server" CssClass="btn btn-primary" Text="Search" OnClick="btnSearch_Click" />
                               <asp:Button ID="btnResetSearch" runat="server" CssClass="btn btn-default" Text="Reset" OnClick="btnResetSearch_Click" />
                        </div>

                        <hr />

                        <!-- Results Grid -->
                        <asp:GridView ID="gvPatients" runat="server" AutoGenerateColumns="False" CssClass="table table-bordered" >
                            <Columns>
                                <asp:BoundField DataField="HEALTHNO" HeaderText="Health No" />
                                <asp:BoundField DataField="LASTNAME" HeaderText="Last Name" />
                                <asp:BoundField DataField="FIRSTNAME" HeaderText="First Name" />
                                <asp:BoundField DataField="MIDDLENAME" HeaderText="Middle Name" />
                              <asp:TemplateField>
                                        <HeaderTemplate> Action </HeaderTemplate>
                                     <ItemTemplate>
                                      <asp:HiddenField ID="hd_id" Value='<%#Eval("PID") %>' runat="server"></asp:HiddenField>
                                       <asp:LinkButton ID="btn_select" CssClass="btn btn-info btn-xs " onclick="btn_select_Click" runat="server" >Select</asp:LinkButton>
                                   </ItemTemplate>
                                   </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                      
                        </ContentTemplate>
                             </asp:UpdatePanel>
                   
                     </div>
              </div>
           </div>
     </div>

    <script type="text/javascript">
        $(document).ready(function () {
            // Make the second tab active by default when the page loads
            $('#profile-tab').tab('show');
          
            $("#btnSelectProfile").click(function () {
                $('#profile-tab').tab('show');
            });
        });
        function showModal() {
            $('#myModal').modal('show'); //show search patient
        }
        function cleanModal() {
            $('#myModal').modal('hide');
            $('.modal-backdrop').remove();
            $('body').removeClass('modal-open');
        }
</script>
</asp:Content>
