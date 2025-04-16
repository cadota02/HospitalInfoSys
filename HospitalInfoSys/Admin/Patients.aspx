<%@ Page Title="Patient"  Async="true" Language="C#" MasterPageFile="~/SiteAdmin.Master" AutoEventWireup="true" CodeBehind="Patients.aspx.cs" Inherits="HospitalInfoSys.Admin.Patients" %>
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
        width: 800px;
        margin: 10% auto;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
    }
     .modal-dialog-scrollable .modal-body {
      max-height: 400px;
      overflow-y: auto;
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
     .dashboard {
    display: flex;
    gap: 1rem;
    font-family: 'Segoe UI', sans-serif;
  }

  .card {
      border-radius: 1rem;
      box-shadow: 0 4px 8px rgba(0,0,0,0.1);
      padding: 12px;
    }
    .dashboard-title {
      font-size: 1.2rem;
      font-weight: bold;
    }
    .count {
      font-size: 2rem;
      font-weight: bold;
    }
    .subtext {
      font-size: 0.9rem;
      color: #000000;
    }
    </style>
    <div class="container">
       

        <div class="login-container">

             <div class="dashboard">
  <div class="container py-5">
    <h4 class="mb-4 text-center">Hospital Dashboard</h4>
    <div class="row g-4">

      <!-- Inpatient Admission -->
      <div class="col-md-4">
        <div class="card text-white bg-success p-4">
          <div class="dashboard-title">Inpatient Admission</div>
          <div class="count"><%= TodayAdmitted %> / <%= TotalAdmitted %></div>
          <div class="subtext">Today Admitted / Total Admitted</div>
        </div>
      </div>

      <!-- Outpatient -->
      <div class="col-md-4">
        <div class="card text-white bg-warning p-4">
          <div class="dashboard-title">Outpatient (OPD)</div>
          <div class="count"><%= TodayOPD %> / <%= TotalOPD %></div>
          <div class="subtext">Today OPD / Total OPD</div>
        </div>
      </div>

      <!-- Emergency -->
      <div class="col-md-4">
        <div class="card text-white bg-danger p-4">
          <div class="dashboard-title">Emergency Cases</div>
          <div class="count"><%= TodayER %> / <%= TotalER %></div>
          <div class="subtext">Today ER / Total ER Cases</div>
        </div>
      </div>

    </div>
  </div>
</div>
       
        <hr>
            <div class="row">
                <div class="col-md-12">
                   <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                    <ContentTemplate>
                                             <div class="form-group row">
                               
                                                <div class="col-sm-4">
                                       
                                                 <asp:TextBox ID="txt_search" CssClass="form-control form-control-sm" placeholder="Enter keyword" runat="server"></asp:TextBox>
                                                </div>
                                                 <div class="col-sm-2">

                                                      <asp:DropDownList ID="dpfilterstatus" runat="server" CssClass="form-control">
                                                           <asp:ListItem Text="Type of Visit" Value=""></asp:ListItem>
                                            <asp:ListItem Text="Admission" Value="Admission"></asp:ListItem>
                                            <asp:ListItem Text="Outpatient" Value="Outpatient"></asp:ListItem>
                                        <asp:ListItem Text="Emergency" Value="Emergency"></asp:ListItem>
                                        </asp:DropDownList>
                                                 </div>
                                              
                                                <div class="col-sm-6">
                                                 
                                                 <asp:LinkButton ID="btn_filter" CssClass=" btn btn-info" 
                                                         runat="server" onclick="btn_filter_Click" > Search</asp:LinkButton>
                                                          <asp:LinkButton ID="btn_reset" CssClass="btn btn-default" 
                                                         runat="server" onclick="btn_reset_Click" BackColor="#999999">Refresh</asp:LinkButton>
                                                       <asp:LinkButton ID="btn_add"  CssClass="btn btn-success" runat="server" PostBackUrl="~/ManagePatient">Add Patient</asp:LinkButton>
                                       
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
                                        <HeaderTemplate>Health No </HeaderTemplate>
                                     <ItemTemplate>
                                         <asp:HyperLink ID="HyperLink1" runat="server"   Text='<%# Eval("HEALTHNO") %>' Target="_blank"  NavigateUrl='<%# "~/PatientPrint?prid=" + Eval("PRID") %>'></asp:HyperLink>

                                           </ItemTemplate>
                                   </asp:TemplateField>
                                     
                                               <asp:BoundField DataField="FULLNAME" HeaderText="Fullname"  />
                                       <asp:BoundField DataField="AGE" HeaderText="Age"   />
                                                <asp:BoundField DataField="CHIEFCOMPLAINT" HeaderText="COMPLAINT"   />
                                      <asp:BoundField DataField="TYPECONSULTATION" HeaderText="Type"    ItemStyle-HorizontalAlign="Left" />
                                                 <asp:BoundField DataField="PATLOGDATE"   DataFormatString="{0:MMM d, yyyy hh tt}" HtmlEncode="False" HeaderText="Date Encounter"    ItemStyle-HorizontalAlign="Left" />
                                       <asp:BoundField DataField="DoctorFullName" HeaderText="Doctor"    ItemStyle-HorizontalAlign="Left" />
                                      <asp:BoundField DataField="DIAGNOSIS" HeaderText="Diagnosis"    ItemStyle-HorizontalAlign="Left" />
                                      
                                      
                                        <asp:BoundField DataField="PATDISPOSITION" HeaderText="Disposition" ItemStyle-HorizontalAlign="Center" />

                                   <asp:TemplateField>
                                        <HeaderTemplate> Action </HeaderTemplate>
                                     <ItemTemplate>
                                      <asp:HiddenField ID="hd_id" Value='<%#Eval("PRID") %>' runat="server"></asp:HiddenField>
                                           <asp:HiddenField ID="hd_profid" Value='<%#Eval("PID") %>' runat="server"></asp:HiddenField>
                           <asp:HiddenField ID="hd_status" Value='<%#Eval("PRID") %>' runat="server"></asp:HiddenField>
                                      <asp:HiddenField ID="hd_name" Value='<%#Eval("FULLNAME") %>' runat="server"></asp:HiddenField>
                                  
                                            <asp:HyperLink ID="hlPRID" CssClass="btn btn-primary btn-xs " runat="server" Text='Edit'  NavigateUrl='<%# "~/ManagePatient?prid=" + Eval("PRID") %>'>    </asp:HyperLink>
                                         <asp:LinkButton ID="btn_delete" CssClass="btn btn-danger btn-xs " onclick="btn_delete_Click" runat="server"
                                      OnClientClick="return getConfirmation_verify();"
                                       >Remove</asp:LinkButton>
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
        <asp:HiddenField ID="hd_appointmentid" Value="0" runat="server" />
        <h4 id="modalTitle" style="text-align: center">Manage Patient</h4>
        <hr />
   
<ul class="nav nav-tabs">
  <li class="nav-item">
    <a class="nav-link active" data-toggle="tab" href="#tabPatient">Patient Profile</a>
  </li>
  <li class="nav-item">
    <a class="nav-link" data-toggle="tab" href="#tabConsultation" id="consultTabLink" runat="server" disabled="true">Consultation Details</a>
  </li>
</ul>

<div class="tab-content">
  <div class="tab-pane fade show active" id="tabPatient">
      <asp:Panel ID="pnlProfile" runat="server" Visible="true" ScrollBars="Vertical" Height="400px">
        
      </asp:Panel>
    <!-- Patient Profile Form (already implemented) -->
  </div>

  <div class="tab-pane fade" id="tabConsultation">
    <asp:Panel ID="pnlConsultation" runat="server" Visible="true" ScrollBars="Vertical" Height="400px">
      <div class="form-group">
        <label>Date of Consultation</label>
        <asp:TextBox ID="txtConsultDate" runat="server" CssClass="form-control" TextMode="DateTime" />
      </div>
      <div class="form-group">
        <label>Type of Consultation</label>
        <asp:DropDownList ID="ddlConsultType" runat="server" CssClass="form-control">
          <asp:ListItem Text="Select" Value="" />
          <asp:ListItem Text="Admission" Value="Admission" />
          <asp:ListItem Text="Outpatient" Value="Outpatient" />
          <asp:ListItem Text="Emergency" Value="Emergency" />
        </asp:DropDownList>
      </div>
      <div class="form-group">
        <label>Chief Complaint</label>
        <asp:TextBox ID="txtChiefComplaint" runat="server" CssClass="form-control" />
      </div>
      <div class="form-group">
        <label>Medical History</label>
        <asp:TextBox ID="txtMedicalHistory" runat="server" CssClass="form-control" TextMode="MultiLine" />
      </div>
      <div class="form-group">
        <label>Allergies</label>
        <asp:TextBox ID="txtAllergies" runat="server" CssClass="form-control" />
      </div>
      <div class="form-group">
        <label>Diagnosis</label>
        <asp:TextBox ID="txtDiagnosis" runat="server" CssClass="form-control" />
      </div>
      <div class="form-group">
        <label>Room ID</label>
        <asp:TextBox ID="txtRoomID" runat="server" CssClass="form-control" />
      </div>
      <div class="form-group">
        <label>Doctor ID</label>
        <asp:TextBox ID="txtDoctorID" runat="server" CssClass="form-control" />
      </div>
      <div class="form-group">
        <label>Discharge Date</label>
        <asp:TextBox ID="txtDischarge" runat="server" CssClass="form-control" TextMode="DateTime" />
      </div>
      <div class="form-group">
        <label>Disposition</label>
        <asp:TextBox ID="txtDisposition" runat="server" CssClass="form-control" />
      </div>
      <asp:Button ID="btnSaveConsultation" runat="server" Text="Save Consultation" CssClass="btn btn-primary" />
    </asp:Panel>
  </div>
</div>         
       
           
   
           
        <div style="text-align: center">
        <asp:Button ID="btnRegister" OnClick="btnRegister_Click" runat="server" Text="Submit" CssClass="btn btn-success" ValidationGroup="add" />
      </div>
                           </ContentTemplate>
                    </asp:UpdatePanel>
    </div>
</div>

<script type="text/javascript">
    function getConfirmation_verify() {
        return confirm("Are you sure you want to delete?");
    }
    
     // MODAL
    function openModal(userId) {
        var title = document.getElementById("modalTitle");
     

        if (userId > 0) {
            title.innerHTML = "Edit Patient";
           
            document.getElementById("<%= btnRegister.ClientID %>").value = "Update";
        } else {
            title.innerHTML = "Add Patient";
          
            document.getElementById("<%= btnRegister.ClientID %>").value = "Submit";
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


