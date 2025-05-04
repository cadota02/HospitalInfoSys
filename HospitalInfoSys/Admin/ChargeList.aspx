<%@ Page Title="Charges" Language="C#" MasterPageFile="~/SiteAdmin.Master" AutoEventWireup="true" CodeBehind="ChargeList.aspx.cs" Inherits="HospitalInfoSys.Admin.ChargeList" %>
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
    </style>
    <div class="container">
        <div class="login-container">
        <h4 class="text-center text-primary">Manage Charges</h4>
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
                                     OnClick="btn_add_Click">Add Charge Item</asp:LinkButton>
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
                                       <HeaderTemplate> # </HeaderTemplate>
                                        <ItemTemplate>
       
                                            <asp:Label ID="lbl_no" runat="server" Text="<%# Container.DataItemIndex + 1 %>  "></asp:Label>
                                         </ItemTemplate>
                                    </asp:TemplateField>
                                          <asp:BoundField DataField="ItemType" HeaderText="Type of Charge"   />
                                               <asp:BoundField DataField="Name" HeaderText="Charge Item Name"  />
                                                <asp:BoundField DataField="fulldetails" HeaderText="Details"   />
                                      <asp:BoundField DataField="Price" HeaderText="Price"    ItemStyle-HorizontalAlign="Left" />
                                               
                                                <asp:BoundField DataField="Status" HeaderText="Status" ItemStyle-HorizontalAlign="Center" />

                                   <asp:TemplateField>
                                        <HeaderTemplate> Action </HeaderTemplate>
                                     <ItemTemplate>
                                      <asp:HiddenField ID="hd_id" Value='<%#Eval("ChargeID") %>' runat="server"></asp:HiddenField>
                           <asp:HiddenField ID="hd_status" Value='<%#Eval("IsActive") %>' runat="server"></asp:HiddenField>
                                      <asp:HiddenField ID="hd_name" Value='<%#Eval("Name") %>' runat="server"></asp:HiddenField>
                                      <asp:LinkButton ID="btn_select" CssClass="btn btn-primary btn-xs "  CommandArgument='<%# Eval("ChargeID") %>' onclick="btn_select_Click"  runat="server" >Edit</asp:LinkButton>
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
                <asp:HiddenField ID="hd_chargeitemid" Value="0" runat="server" />
                <h4 id="modalTitle" style="text-align: center">Add Charge Item</h4>
                <hr />

                <div class="form-group">
                    <div class="col-sm-12">
                        <label >Item Type
                             <asp:RequiredFieldValidator ID="rfvItemType" runat="server" 
                         ControlToValidate="ddlItemType" InitialValue=""
                            ErrorMessage="*" CssClass="text-danger" Display="Dynamic" ValidationGroup="add" />

                        </label>
                        <asp:DropDownList ID="ddlItemType" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlItemType_SelectedIndexChanged">
                            <asp:ListItem Text="Select Type" Value="" />
                            <asp:ListItem Text="Medicine" Value="Medicine" />
                            <asp:ListItem Text="Medical Supply" Value="Medical Supply" />
                            <asp:ListItem Text="Examination" Value="Examination" />
                            <asp:ListItem Text="Miscellaneuos" Value="Miscellaneous" />
                            <asp:ListItem Text="Room" Value="Room" />
                        </asp:DropDownList>
                    </div>

                    <div class="col-sm-12">
                        <label>Name
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtName" 
            ErrorMessage="*" CssClass="text-danger" Display="Dynamic" ValidationGroup="add" />

                        </label>
                        <asp:TextBox ID="txtName" runat="server" CssClass="form-control" placeholder="Enter item name"></asp:TextBox>
                    
                    </div>

                    <div class="col-sm-12">
                        <label >Price
                             <asp:RequiredFieldValidator ID="rfvPrice" runat="server" ControlToValidate="txtPrice" 
            ErrorMessage="*" CssClass="text-danger" Display="Dynamic" ValidationGroup="add" />
        <asp:RegularExpressionValidator ID="revPrice" runat="server" ControlToValidate="txtPrice" 
            ValidationExpression="^\d+(\.\d{1,2})?$" 
            ErrorMessage="*" CssClass="text-danger" Display="Dynamic" ValidationGroup="add" />

                        </label>
                        <asp:TextBox TextMode="Number" step="any" ID="txtPrice" runat="server" CssClass="form-control" placeholder="Enter Price"></asp:TextBox>
                    </div>

                    <!-- Optional Fields: Show/Hide in CodeBehind -->
                    <asp:Panel ID="panelBrand" runat="server" Visible="false" CssClass="col-sm-12">
                        <label>Brand</label>
                        <asp:TextBox ID="txtBrand" runat="server" CssClass="form-control" placeholder="Enter brand (for medicine)"></asp:TextBox>
                    </asp:Panel>

                    <asp:Panel ID="panelUnit" runat="server" Visible="false" CssClass="col-sm-12">
                        <label >Unit</label>
                        <asp:TextBox ID="txtUnit" runat="server" CssClass="form-control" placeholder="e.g. tablet, vial"></asp:TextBox>
                    </asp:Panel>

                    <asp:Panel ID="panelDescription" runat="server" Visible="false" CssClass="col-sm-12">
                        <label >Description</label>
                        <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" TextMode="MultiLine" placeholder="Enter description (for supplies)"></asp:TextBox>
                    </asp:Panel>

                    <asp:Panel ID="panelCategory" runat="server" Visible="false" CssClass="col-sm-12">
                        <label >Category</label>
                      <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-control" >
                            <asp:ListItem Text="Select Type" Value="" />
                            <asp:ListItem Text="Laboratory" Value="Laboratory" />
                            <asp:ListItem Text="Imaging" Value="Imaging" />
                            
                        </asp:DropDownList>
                    </asp:Panel>

                    <asp:Panel ID="panelRoomType" runat="server" Visible="false" CssClass="col-sm-12">
                        <label >Room Type</label>
                        <asp:TextBox ID="txtRoomType" runat="server" CssClass="form-control" placeholder="e.g. Ward, Private"></asp:TextBox>
                    </asp:Panel>

                    <div class="col-sm-12">
                        <label class="form-label">Status</label>
                        <asp:DropDownList ID="dpstatus" runat="server" CssClass="form-control">
                            <asp:ListItem Text="Active" Value="1" />
                            <asp:ListItem Text="Inactive" Value="0" />
                        </asp:DropDownList>
                    </div>
                </div>

                <div style="text-align: center; margin-top: 10px;">
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
            title.innerHTML = "Edit Charges";
           
            document.getElementById("<%= btnRegister.ClientID %>").value = "Update";
        } else {
            title.innerHTML = "Add Charges";
          
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

