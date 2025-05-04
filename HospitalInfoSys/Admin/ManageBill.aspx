<%@ Page Title="Manage Bill" Language="C#" MasterPageFile="~/SiteAdmin.Master" AutoEventWireup="true" CodeBehind="ManageBill.aspx.cs" Inherits="HospitalInfoSys.Admin.ManageBill" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
    .GridPager td {
        padding: 5px;
    }
    .GridPager a, .GridPager span {
        padding: 6px 12px;
        margin: 0 2px;
        border: 1px solid #ccc;
        text-decoration: none;
    }
    .GridPager span {
        background-color: #007bff;
        color: white;
        border-color: #007bff;
    }
</style>
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
           .custom-header {
               background-color: gray; /* Bootstrap 5.3 info color */
               color: white;
               padding: 5px;
               margin-bottom: 2px;
           }
        .text-end
            {  
            text-align:center;
            margin: 10px;
            }
    }
 </style>

       <div class="container">
        <div class="login-container">
        <h4 class="text-center text-primary">Invoice Billing</h4>
        <hr>
                 <asp:UpdatePanel ID="UpdatePanel1" runat="server" >
                    <ContentTemplate>
            <div class="row">
                <div class="col-md-12">
    <!-- Patient Information -->
    <div class="card mb-3">
        <div class="card-header bg-info text-white custom-header">Patient Information</div>
        <div class="card-body row">
            <div class="col-md-4"><strong>Full Name:</strong> <asp:Label ID="lblFullName" runat="server" Text="-"></asp:Label></div>
            <div class="col-md-2"><strong>Age:</strong> <asp:Label ID="lblAge" runat="server" Text="-"></asp:Label></div>
            <div class="col-md-2"><strong>Sex:</strong> <asp:Label ID="lblSex" runat="server" Text="-"></asp:Label></div>
            <div class="col-md-4"><strong>Date Entered:</strong> <asp:Label ID="lblDateAdmitted" runat="server" Text="-"></asp:Label></div>
            <div class="col-md-4 mt-2"><strong>Type of Visit:</strong> <asp:Label ID="lblRoom" runat="server" Text="-"></asp:Label></div>
            <div class="col-md-4 mt-2"><strong>Diagnosis: </strong> <asp:Label ID="lblDiagnosis" runat="server" Text="-"></asp:Label></div>
            <div class="col-md-4 mt-2"><strong>Doctor: </strong> <asp:Label ID="lbldoctor" runat="server" Text="-"></asp:Label></div>
        </div>
    </div>

        <!-- Invoice Details -->
<div class="card mb-3">
    <div class="card-header bg-info text-white custom-header">Invoice Details</div>
    <div class="card-body row">
        <div class="col-md-4 mb-2">
            <asp:HiddenField ID="hd_invoiceid" Value="" runat="server" />
            <label class="form-label">Invoice No</label>
            <asp:TextBox ID="txtInvoiceNo" ReadOnly="true" runat="server" CssClass="form-control" />
        </div>
        <div class="col-md-4 mb-2">
            <label class="form-label">Invoice Date
                <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ControlToValidate="txtInvoiceDate"
                                ErrorMessage="Required" ForeColor="Red" SetFocusOnError="true" ValidationGroup="submitbill" />
            </label>
            <asp:TextBox ID="txtInvoiceDate" runat="server" CssClass="form-control" TextMode="Date" />
        </div>
        <div class="col-md-4 mb-2">
            <label class="form-label">Payment Date
                   <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ControlToValidate="txtPaymentDate"
                                ErrorMessage="Required" ForeColor="Red" SetFocusOnError="true" ValidationGroup="submitbill" />
            </label>
            <asp:TextBox ID="txtPaymentDate" runat="server" CssClass="form-control" TextMode="Date" />
        </div>
       
    </div>
</div>

    <!-- Add Charges Button -->
    <div class="mb-3 text-end">

           <asp:LinkButton ID="btn_add"  CssClass="btn btn-primary" runat="server" 
                                     OnClick="btn_add_Click">Add Charge</asp:LinkButton>
    </div>

    <!-- Charges Table -->
    <div class="table-responsive">
      <asp:GridView ID="gvCharges" runat="server" PagerStyle-CssClass="GridPager"
    CssClass="table table-bordered table-striped"
    AutoGenerateColumns="False" 
    AllowPaging="True" 
    PageSize="10"
    OnPageIndexChanging="gvCharges_PageIndexChanging"
    OnRowCommand="gvCharges_RowCommand"
    DataKeyNames="ItemID">
    
    <Columns>
        <asp:BoundField DataField="Descriptions" HeaderText="Item Description" />
        <asp:BoundField DataField="Quantity" HeaderText="Quantity" />
        <asp:BoundField DataField="UnitPrice" HeaderText="Unit Price (₱)" DataFormatString="{0:N2}" />
        <asp:BoundField DataField="TotalPrice" HeaderText="Total (₱)" DataFormatString="{0:N2}" />

        <asp:TemplateField HeaderText="Action">
            <ItemTemplate>
                <asp:LinkButton ID="btnEdit" runat="server" CommandName="EditCharge" CommandArgument='<%# Eval("ItemID") %>' CssClass="btn btn-sm btn-warning">Edit</asp:LinkButton>
                <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteCharge" CommandArgument='<%# Eval("ItemID") %>' CssClass="btn btn-sm btn-danger" OnClientClick="return  getConfirmation_verify();">Delete</asp:LinkButton>
            </ItemTemplate>
        </asp:TemplateField>
    </Columns>
</asp:GridView>
    </div>

    <!-- Billing Summary -->
<div class="row justify-content-end">
    <div class="col-md-6">
        <table class="table">
            <tr>
                <th>Amount Pay (₱):</th>
                <td><asp:TextBox ID="txtCashTendered"  TextMode="Number" runat="server" CssClass="form-control" AutoPostBack="true" OnTextChanged="txtCashTendered_TextChanged" /></td>
            </tr>
            <tr>
                <th>Change:</th>
                <td><asp:TextBox ID="txtChange" runat="server" CssClass="form-control" TextMode="Number" ReadOnly="true" /></td>
            </tr>
            <tr>
                <th><strong>Remarks:</strong></th>
                <td><asp:TextBox ID="txtRemarks" runat="server" CssClass="form-control" /></td>
            </tr>
        </table>
    </div>

    <div class="col-md-6">
        <table class="table">
            <tr>
                <th>Subtotal:</th>
                <td><asp:Label ID="lblSubtotal" runat="server" Text="₱0.00" /></td>
            </tr>
            <tr>
                <th>Discount:</th>
                <td><asp:TextBox ID="txtDiscount" TextMode="Number" runat="server" CssClass="form-control" Text="0" AutoPostBack="true" OnTextChanged="txtDiscount_TextChanged" /></td>
            </tr>
            <tr>
                <th><strong>Net Total:</strong></th>
                <td><strong><asp:Label ID="lblNetTotal" runat="server" Text="₱0.00" /></strong></td>
            </tr>
             <tr>
                <th><strong>Status:</strong></th>
                <td><strong><asp:Label ID="lblStatus" runat="server" Text="" /></strong></td>
            </tr>
        </table>
    </div>
</div>

    <!-- Buttons -->
    <div class="text-end">
        <asp:Button ID="btnSubmit" runat="server" ValidationGroup="submitbill" Text="Submit Billing" CssClass="btn btn-success" OnClick="btnSubmit_Click" />
       <%-- <button class="btn btn-secondary" onclick="window.print(); return false;">Print</button>--%>
        <%--<button class="btn btn-secondary" onclick="showModalPrint(); return false;">Print</button>--%>
       <%--   <button type="button" class="btn btn-primary no-print" onclick="printModalContent('printModal')">🖨️ Print</button>--%>
           <asp:HyperLink ID="btnprint" runat="server"  class="btn btn-default" Target="_blank" >🖨️ Print SOA</asp:HyperLink>
    </div>
                    </div>
                </div>
                      
  
                    </ContentTemplate>
                     </asp:UpdatePanel>
            </div>
           </div>
   
    <!-- Add Charge Modal -->
        <div class="modal fade" id="chargeModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
        <div class="modal-dialog">
            <div class="modal-content">
                    <div class="modal-header">
                      
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                         <h4 class="modal-title" id="myModalLabel">Charges</h4>
                    </div>
                 <asp:UpdatePanel ID="UpdatePanelSearch" runat="server" >
                    <ContentTemplate>
                    <div class="modal-body">
                        <asp:HiddenField ID="hiddenItemID" runat="server" />
                        <div class="mb-2">
                            <label>Item Type
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="ddlItemType"
                                InitialValue="" ErrorMessage="* Required" ForeColor="Red" ValidationGroup="AddCharge" />
                            </label>
                            <asp:DropDownList ID="ddlItemType" runat="server" CssClass="form-control" AutoPostBack="true"
                                OnSelectedIndexChanged="ddlItemType_SelectedIndexChanged" ValidationGroup="AddCharge" />
                            
                        </div>

                        <div class="mb-2">
                            <label>Item Description
                                   <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="ddlItemDescription"
                                InitialValue="" ErrorMessage="Required" ForeColor="Red" ValidationGroup="AddCharge" />
                            </label>
                            <asp:DropDownList ID="ddlItemDescription" runat="server" CssClass="form-control" AutoPostBack="true"
                                OnSelectedIndexChanged="ddlItemDescription_SelectedIndexChanged" ValidationGroup="AddCharge" />
                         
                        </div>

                        <div class="mb-2">
                            <label>Quantity
                                 <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtQty"
                                ErrorMessage="Required" ForeColor="Red" ValidationGroup="AddCharge" />
                            </label>
                            <asp:TextBox ID="txtQty" runat="server" Text="1" TextMode="Number" CssClass="form-control" AutoPostBack="true"
                                OnTextChanged="ComputeTotal" />
                           
                        </div>

                        <div class="mb-2">
                            <label>Unit Price (₱)
                                 <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="txtUnitPrice"
                                ErrorMessage="Required" ForeColor="Red" ValidationGroup="AddCharge" />
                            </label>
                            <asp:TextBox ID="txtUnitPrice" runat="server" CssClass="form-control" ReadOnly="true" />
                        </div>

                        <div class="mb-2">
                            <label>Total Amount (₱)</label>
                            <asp:TextBox ID="txtTotalAmount" runat="server" CssClass="form-control" ReadOnly="true" />
                        </div>
                    </div>
                    <div class="modal-footer">
                        <asp:Button ID="btnAddCharge" runat="server" CssClass="btn btn-primary" Text="Submit"
                            OnClick="btnAddCharge_Click" ValidationGroup="AddCharge" />
                    </div>
                        </ContentTemplate>
                     </asp:UpdatePanel>
                </div>
        </div>
    </div>


                      
            
   
 <script  type="text/javascript">
     function showModal() {
         $('#chargeModal').modal('show'); //show search patient
     }
   
     function cleanModal() {
         $('#chargeModal').modal('hide');
         $('.modal-backdrop').remove();
         $('body').removeClass('modal-open');
     }
     function getConfirmation_verify() {
         return confirm("Are you sure you want to delete?");
     }

    </script>
<script>
    let subtotal = 0;

    function addCharge() {
        const item = document.getElementById("txtItem").value;
        const qty = parseFloat(document.getElementById("txtQty").value);
        const unitPrice = parseFloat(document.getElementById("txtUnitPrice").value);
        const total = qty * unitPrice;

        const tbody = document.querySelector("#chargesTable tbody");
        const row = tbody.insertRow();
        row.innerHTML = `
            <td>${item}</td>
            <td>${qty}</td>
            <td>₱${unitPrice.toFixed(2)}</td>
            <td>₱${total.toFixed(2)}</td>
            <td><button class='btn btn-sm btn-danger' onclick='removeRow(this, ${total})'>Remove</button></td>
        `;

        subtotal += total;
        updateTotals();
        document.querySelector("#txtItem").value = '';
        document.querySelector("#txtQty").value = 1;
        document.querySelector("#txtUnitPrice").value = 0.00;

        const modal = bootstrap.Modal.getInstance(document.getElementById('chargeModal'));
        modal.hide();
    }

    function removeRow(button, amount) {
        const row = button.parentElement.parentElement;
        row.remove();
        subtotal -= amount;
        updateTotals();
    }

    document.getElementById("txtDiscount").addEventListener("input", updateTotals);

    function updateTotals() {
        const discount = parseFloat(document.getElementById("txtDiscount").value) || 0;
        const netTotal = subtotal - discount;

        document.getElementById("lblSubtotal").textContent = `₱${subtotal.toFixed(2)}`;
        document.getElementById("lblNetTotal").textContent = `₱${netTotal.toFixed(2)}`;
    }
</script>
   
</asp:Content>
