<%@ Page Title="Billing" Language="C#" MasterPageFile="~/SiteAdmin.Master"  EnableEventValidation="true" AutoEventWireup="true" CodeBehind="Billing.aspx.cs" Inherits="HospitalInfoSys.Admin.Billing" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        body {
            background-color: #f8f8f8;
        }
        .login-container {
            max-width:1600px;
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
     
 </style>
    <div class="container">
        <div class="login-container">
        <h4 class="text-center text-primary">Manage Billing</h4>
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
                                     OnClick="btn_add_Click">Add Bill</asp:LinkButton>
                                                </div>
                                             
                                                  </div>
                       <div class="table-responsive">
                           <asp:GridView ID="gv_masterlist" runat="server" 
                              CssClass="table  table-bordered table-sm  table-hover" 
                              AutoGenerateColumns="false" AllowPaging="true"
                              OnPageIndexChanging="OnPaging" PageSize="10" 
                            GridLines="None" PagerSettings-Mode="NumericFirstLast"
                              HeaderStyle-HorizontalAlign="Center" HeaderStyle-VerticalAlign="Middle" Font-Size="Small">
                                  <Columns>
                                     <asp:TemplateField ItemStyle-HorizontalAlign="Center">
                                       <HeaderTemplate> Invoice No. </HeaderTemplate>
                                        <ItemTemplate>
          <asp:HyperLink ID="HyperLink1" runat="server"   Text='<%# Eval("InvoiceNo") %>' Target="_blank"  NavigateUrl='<%# "~/PrintSOA?id=" + Eval("InvoiceID") %>'></asp:HyperLink>
                                         
                                         </ItemTemplate>
                                    </asp:TemplateField>
                                      
                                         <asp:BoundField DataField="PATLOGDATE" HeaderText="Date Encounter"   DataFormatString="{0:yyyy-MM-dd}" HtmlEncode="false" />
                                               <asp:BoundField DataField="FULLNAME" HeaderText="Patient Name"  />
                                                <asp:BoundField DataField="TYPECONSULTATION" HeaderText="Type"   />
                                        <asp:BoundField DataField="PaymentDate" HeaderText="Payment Date"   DataFormatString="{0:yyyy-MM-dd}" HtmlEncode="false" />
                                      <asp:BoundField DataField="totalamount" HeaderText="Amount"    ItemStyle-HorizontalAlign="Left" />
                                                  <asp:BoundField DataField="Discount" HeaderText="Discount"    ItemStyle-HorizontalAlign="Left" />
                                       <asp:BoundField DataField="NetTotal" HeaderText="Total Bill"    ItemStyle-HorizontalAlign="Left" />
                                                <asp:BoundField DataField="Status2" HeaderText="Status" ItemStyle-HorizontalAlign="Center" />

                                   <asp:TemplateField>
                                        <HeaderTemplate> Action </HeaderTemplate>
                                     <ItemTemplate>
                                      <asp:HiddenField ID="hd_id" Value='<%#Eval("InvoiceID") %>' runat="server"></asp:HiddenField>
                           <asp:HiddenField ID="hd_status" Value='<%#Eval("Status") %>' runat="server"></asp:HiddenField>
                                      <asp:HiddenField ID="hd_name" Value='<%#Eval("FULLNAME") %>' runat="server"></asp:HiddenField>
                                      <asp:LinkButton ID="btn_select" CssClass="btn btn-primary btn-xs "  CommandArgument='<%# Eval("InvoiceID") %>' onclick="btn_select_Click"  runat="server" >Edit</asp:LinkButton>
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
                                    <asp:BoundField DataField="PATLOGDATE" HeaderText="Date Encounter" />
                                <asp:BoundField DataField="TYPECONSULTATION" HeaderText="Type" />
                                <asp:BoundField DataField="FULLNAME" HeaderText="Fullname" />
                                   <asp:BoundField DataField="ADDRESS" HeaderText="Address" />
                                   <asp:BoundField DataField="AGE" HeaderText="Age" />
                              <asp:TemplateField>
                                        <HeaderTemplate> Action </HeaderTemplate>
                                     <ItemTemplate>
                                      <asp:HiddenField ID="hd_id" Value='<%#Eval("PRID") %>' runat="server"></asp:HiddenField>
                                       <asp:LinkButton ID="btn_selectpat" CssClass="btn btn-info btn-xs " onclick="btn_selectpat_Click" runat="server" >Add Bill</asp:LinkButton>
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
    <script  type="text/javascript">
        function showModal() {
            $('#myModal').modal('show'); //show search patient
        }
        function cleanModal() {
            $('#myModal').modal('hide');
            $('.modal-backdrop').remove();
            $('body').removeClass('modal-open');
        }
        function getConfirmation_verify() {
            return confirm("Are you sure you want to delete?");
        }
    </script>

</asp:Content>


