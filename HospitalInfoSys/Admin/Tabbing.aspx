<%@ Page Title="" Language="C#" MasterPageFile="~/SiteAdmin.Master" AutoEventWireup="true" CodeBehind="Tabbing.aspx.cs" Inherits="HospitalInfoSys.Admin.Tabbing" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
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
    <!-- Patient Profile Form (already implemented) -->
  </div>

  <div class="tab-pane fade" id="tabConsultation">
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
      <asp:Button ID="btnSaveConsultation" runat="server" Text="Save Consultation" CssClass="btn btn-primary" OnClick="btnSaveConsultation_Click" />
    </asp:Panel>
  </div>
</div>
</asp:Content>
