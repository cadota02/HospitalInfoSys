<%@ Page Title="tab" Language="C#" MasterPageFile="~/SiteAdmin.Master" AutoEventWireup="true" CodeBehind="tabbing.aspx.cs" Inherits="HospitalInfoSys.tabbing" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
         .nav-tabs li.disabled a {
        pointer-events: none;
        color: #aaa;
        cursor: not-allowed;
    }
    </style>
    <br />
     <br />
     <br />
     <br />
     <br />
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
   <h2>tab1</h2>
        <asp:Button ID="btnSaveConsultation" runat="server" Text="Save Consultation" CssClass="btn btn-primary" OnClick="btnSaveConsultation_Click" />
  </div>

  <div class="tab-pane fade" id="tabConsultation">
      <h2>tab2</h2>
    <asp:Panel ID="pnlConsultation" runat="server" Visible="false">
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
    
    </asp:Panel>
  </div>
</div>
    <hr />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
    <ContentTemplate>

        <asp:Button ID="btnOpenModal" runat="server" Text="Open Modal"
            CssClass="btn btn-primary" OnClick="btnOpenModal_Click" />

        <!-- Modal -->
        <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">

                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                        <h4 class="modal-title" id="myModalLabel">Manage Patient</h4>
                    </div>

                    <div class="modal-body">
                        <!-- Tabs -->
                        <ul class="nav nav-tabs">
                            <li class="active"><a data-toggle="tab" href="#tab1">Patient Profile</a></li>
                            <li class="disabled" id="tab2Tab"><a data-toggle="tab" href="#tab2" onclick="return false;" >Medical Details</a></li>
                        </ul>

                        <div class="tab-content" style="margin-top: 10px;">
                            <div id="tab1" class="tab-pane fade in active">
                                <p>Content for Tab 1</p>
                                      <asp:TextBox ID="txtName" runat="server" CssClass="form-control" placeholder="Enter your name"></asp:TextBox>
                                    <asp:Button ID="btnNext" runat="server" Text="Next" CssClass="btn btn-primary" OnClick="btnNext_Click" />
                            </div>
                            <div id="tab2" class="tab-pane fade">
                                <p>Content for Tab 2</p>
                            </div>
                        </div>

                        <asp:Button ID="btnSubmitModal" runat="server" CssClass="btn btn-success"
                            Text="Submit" OnClick="btnSubmitModal_Click" />

                    </div>    <asp:Button ID="Button1" runat="server" CssClass="btn btn-success"
                            Text="Close" OnClick="btnSubmitCloseModal_Click" />

                </div>
            </div>
        </div>

    </ContentTemplate>
</asp:UpdatePanel>

<!-- Your Modal Show Script -->
<script type="text/javascript">
    function showModal() {
        $('#myModal').modal('show');

        // Restore tab after postback
        var activeTab = sessionStorage.getItem("activeTab");
        if (activeTab) {
            $('.nav-tabs a[href="' + activeTab + '"]').tab('show');
        }
    }
    function cleanModal() {
        $('#myModal').modal('hide');
        $('.modal-backdrop').remove();
        $('body').removeClass('modal-open');
    }
    function closeModal() {
        $('#myModal').modal('hide');             // Hide the modal
        $('.modal-backdrop').remove();           // Remove the gray background
        $('body').removeClass('modal-open');     // Enable page scroll again
    }
    // Save selected tab on click
    $(document).on('shown.bs.tab', 'a[data-toggle="tab"]', function (e) {
        sessionStorage.setItem("activeTab", $(e.target).attr('href'));
    });
</script>
</asp:Content>
