<%@ Page Title="My Records" Language="C#" MasterPageFile="~/SitePatient.Master" AutoEventWireup="true" CodeBehind="MyRecord.aspx.cs" Inherits="HospitalInfoSys.Patient.MyRecord" %>

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
  
    </style>
    <div class="container">
       

        <div class="login-container">
               <h4 class="text-center text-primary">My Medical Record</h4>
        <hr>
            <div class="row">
                <div class="col-md-12">
                   <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                    <ContentTemplate>
                                             <div class="form-group row">
                               
                                                <div class="col-sm-4">
                                       
                                                 <asp:TextBox ID="txt_search" CssClass="form-control form-control-sm" placeholder="Enter keyword" runat="server"></asp:TextBox>
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
                                        <HeaderTemplate>Health No </HeaderTemplate>
                                     <ItemTemplate>
                                         <asp:HyperLink ID="HyperLink1" runat="server"   Text='<%# Eval("HEALTHNO") %>' Target="_blank"  NavigateUrl='<%# "~/PatientPrint?prid=" + Eval("PRID") %>'></asp:HyperLink>
                                           <asp:HiddenField ID="hd_id" Value='<%#Eval("PRID") %>' runat="server"></asp:HiddenField>
                                           <asp:HiddenField ID="hd_profid" Value='<%#Eval("PID") %>' runat="server"></asp:HiddenField>
                           <asp:HiddenField ID="hd_status" Value='<%#Eval("PRID") %>' runat="server"></asp:HiddenField>
                                      <asp:HiddenField ID="hd_name" Value='<%#Eval("FULLNAME") %>' runat="server"></asp:HiddenField>
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
                                        <HeaderTemplate>Bill </HeaderTemplate>
                                     <ItemTemplate>
                                        <asp:HyperLink ID="HyperLink1" runat="server"   Text="Print SOA" Target="_blank"  NavigateUrl='<%# "~/PrintSOA?id=" + Eval("InvoiceID") %>' Visible='<%# Convert.ToInt32(Eval("InvoiceID")) != 0 %>'></asp:HyperLink>
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

       
    </div>
</div>

<script type="text/javascript">
  
    
    
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


