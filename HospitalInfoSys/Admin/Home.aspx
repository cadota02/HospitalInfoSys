<%@ Page Title="Home"  Async="true" Language="C#" MasterPageFile="~/SiteAdmin.Master" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="HospitalInfoSys.Admin.Home" %>
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
        width: 400px;
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
     .dashboard {
    display: flex;
    gap: 1rem;
    font-family: 'Segoe UI', sans-serif;
  }

  .card {
    flex: 1;
    background-color: #f8f9fa;
    border-left: 5px solid;
    border-radius: 8px;
    padding: 1rem;
    box-shadow: 0 2px 5px rgba(0,0,0,0.1);
  }

  .card h2 {
    margin: 0;
    font-size: 2.5rem;
  }

  .card p {
    margin: 0;
    color: #666;
    font-size: 1.2rem;
  }

  .pending { border-color: #ffc107; }
  .approved { border-color: #28a745; }
  .rejected { border-color: #dc3545; }

  .pagination-container {
    margin-top: 20px;
}

.pagination .page-link {
    color: #007bff;
    border: 1px solid #dee2e6;
}

.pagination .page-link:hover {
    background-color: #f8f9fa;
    color: #0056b3;
}
    </style>
    <div class="container">
       

        <div class="login-container">
 <h4 class="text-primary">Appointment Request</h4>

             <div class="dashboard">
  <div class="card pending">
    <p>Pending</p>
    <h2><%= pendingCount %></h2>
  </div>
  <div class="card approved">
    <p>Approved</p>
    <h2><%= approvedCount %></h2>
  </div>
  <div class="card rejected">
    <p>Rejected</p>
    <h2><%= rejectedCount %></h2>
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
                                            <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                            <asp:ListItem Text="Approved" Value="Approved"></asp:ListItem>
                                        <asp:ListItem Text="Rejected" Value="Rejected"></asp:ListItem>
                                        </asp:DropDownList>
                                                 </div>
                                              
                                                <div class="col-sm-6">
                                                 
                                                 <asp:LinkButton ID="btn_filter" CssClass=" btn btn-info" 
                                                         runat="server" onclick="btn_filter_Click" > Search</asp:LinkButton>
                                                          <asp:LinkButton ID="btn_reset" CssClass="btn btn-default" 
                                                         runat="server" onclick="btn_reset_Click" BackColor="#999999">Refresh</asp:LinkButton>
                                       
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
                                         <asp:HyperLink ID="HyperLink1" runat="server"  Text='<%# Eval("AppointmentNumber") %>' Target="_blank" NavigateUrl='<%# "~/Content/pdf/" + Eval("AppointmentNumber") +".pdf" %> '></asp:HyperLink>

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
                                      <asp:LinkButton ID="btn_select" CssClass="btn btn-primary btn-xs "  CommandArgument='<%# Eval("ID") %>' onclick="btn_select_Click"  runat="server" >Edit</asp:LinkButton>
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
        <h4 id="modalTitle" style="text-align: center">Manage Appointment</h4>
        <hr />
                        <div class="row">
                            <div class="col-sm-12">
                        <p><strong>Full Name: </strong> <asp:Label ID="lblFullname" runat="server" Text=""></asp:Label></p>
                            <p><strong>Reason: </strong> <asp:Label ID="lblReason" runat="server" Text=""></asp:Label> </p>
                            <p><strong>Date of Appointment: </strong> <asp:Label ID="lblDateOfAppointment" runat="server" Text=""></asp:Label></p>
                         <p><strong>Doctor: </strong> <asp:Label ID="lbldoctor" runat="server" Text=""></asp:Label></p>
                                </div>
                            </div>
        <div class="form-group">
        <div class="col-sm-12">
            <label class="form-label">Action Taken/Remarks</label>
                <asp:TextBox ID="txtremarks" runat="server" CssClass="form-control" placeholder="Action Taken/Remarks" TextMode="MultiLine"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvFirstName" runat="server"  ControlToValidate="txtremarks" ErrorMessage="Remarks is required." CssClass="text-danger" Display="Dynamic"  ValidationGroup="add"></asp:RequiredFieldValidator>
            </div>
           <div class="col-sm-12">
                <label class="form-label">DateTime <asp:Label ID="lbldt" runat="server" Text=""></asp:Label></label>
                <asp:TextBox TextMode="DateTimeLocal" ID="txtdateapproved" runat="server" CssClass="form-control" placeholder="Enter DATE" ></asp:TextBox>
                <asp:RequiredFieldValidator Enabled="false" ID="rfvdateapproved" runat="server" ControlToValidate="txtdateapproved" ErrorMessage="Date is required." CssClass="text-danger" Display="Dynamic"  ValidationGroup="add"></asp:RequiredFieldValidator>
            </div>
              <div class="col-sm-12">
                <label class="form-label">Status</label>
              <asp:DropDownList ID="dpstatus" runat="server" CssClass="form-control" OnSelectedIndexChanged="dpstatus_SelectedIndexChanged" AutoPostBack="True">
                    <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                    <asp:ListItem Text="Approved" Value="Approved"></asp:ListItem>
                <asp:ListItem Text="Rejected" Value="Rejected"></asp:ListItem>
                </asp:DropDownList>
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
            title.innerHTML = "Manage Appointment";
           
            document.getElementById("<%= btnRegister.ClientID %>").value = "Update";
        } else {
            title.innerHTML = "Manage Appointment";
          
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


