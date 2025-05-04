<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PrintSOA.aspx.cs" Inherits="HospitalInfoSys.PrintSOA" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Print SOA</title>
      <style>
                    @page { size: letter; margin: 1in; }
                    body { font-family: 'Segoe UI', sans-serif; font-size: 14px; margin: 0; padding: 0; }
                    .container { width: 7.5in; margin: auto; padding: 20px; }
                    .text-center { text-align: center; }
                    .info-label { font-weight: bold; display: inline-block; width: 150px; }
                    .section-title { font-size: 18px; font-weight: bold; text-align: center; margin: 10px 0 10px; }
                    table { width: 100%; border-collapse: collapse; }
                    th, td { border: 1px solid #000; padding: 6px; text-align: left; }
                    .text-right { text-align: right; }
                    hr { margin: 20px 0; }
                    @media print {
        .no-print {
            display: none !important;
        }
    }
                </style>
    <script type="text/javascript">
        window.onload = function () {
            printCurrentContent();
        };
        function printCurrentContent() {
            // Hide all non-printable content temporarily
            const originalBody = document.body.innerHTML;
            const printContent = document.getElementById("printModalBody").innerHTML;

            document.body.innerHTML = `<div class="print-container">${printContent}</div>`;
            window.print();
            document.body.innerHTML = originalBody;
        }
</script>
</head>
<body>
    <form id="form1" runat="server">
        <div style="text-align:center; padding:10px;">
                  <button type="button" class="btn btn-primary no-print" onclick="printCurrentContent()">🖨️ Print</button>
            <asp:HiddenField ID="hd_invoiceid" runat="server" />
        </div>
        <div>

             <div  id="printModalBody">
        <div class="container">
          <div class="text-center mb-2">
            <h3 class="mb-0">St. Joms Hospital</h3>
            <small>Cotabato City | 09554509324</small>
          </div>
            <div class="section-title">Statement of Account</div>
          <hr />

          <div class="info-label">Patient Information</div>
          <div><span class="info-label">Full Name:</span> <asp:Label ID="lblpFullName" runat="server" /></div>
          <div><span class="info-label">Age:</span> <asp:Label ID="lblpAge" runat="server" /></div>
          <div><span class="info-label">Sex:</span> <asp:Label ID="lblpSex" runat="server" /></div>
          <div><span class="info-label">Date Visit:</span> <asp:Label ID="lblpDateAdmitted" runat="server" /></div>
          <div><span class="info-label">Type of Visit:</span> <asp:Label ID="lblpVisitType" runat="server" /></div>
          <div><span class="info-label">Invoice No:</span> <asp:Label ID="lblpInvoiceNo" runat="server" /></div>
          <div><span class="info-label">Invoice Date:</span> <asp:Label ID="lblpInvoiceDate" runat="server" /></div>

          <hr />

          <div class="section-title">Hospital Charges</div>
           <div class="table-responsive">
                       <asp:GridView ID="gvInvoiceItems" runat="server" AutoGenerateColumns="False" ShowHeader="true"
                CssClass="table table-bordered" GridLines="Both">
                <Columns>
                    <asp:TemplateField ItemStyle-HorizontalAlign="Center"  ItemStyle-Width="10px"  HeaderStyle-CssClass="text-center" ItemStyle-CssClass="text-center">
                                       <HeaderTemplate > # </HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:Label ID="lbl_no" runat="server" Text="<%# Container.DataItemIndex + 1 %>  "></asp:Label>
                                         </ItemTemplate>
                                    </asp:TemplateField>
                        <asp:BoundField DataField="ItemType"  ItemStyle-Width="70px" HeaderText="Type" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" />
                    <asp:BoundField DataField="Descriptions" ItemStyle-Width="100px" HeaderText="Description" />
                    <asp:BoundField DataField="Quantity"  ItemStyle-Width="20px" HeaderText="Qty"  ItemStyle-HorizontalAlign="Center" HeaderStyle-CssClass="text-center"  ItemStyle-CssClass="text-center"/>
                    <asp:BoundField DataField="UnitPrice" ItemStyle-Width="70px" HeaderText="Unit Price" DataFormatString="{0:N2}"  HeaderStyle-CssClass="text-center" ItemStyle-CssClass="text-right" />
                    <asp:BoundField DataField="TotalPrice"  ItemStyle-Width="70px" HeaderText="Total" DataFormatString="{0:N2}"  HeaderStyle-CssClass="text-center" ItemStyle-CssClass="text-right" />
                </Columns>
            </asp:GridView>
       </div>

          <hr />

          <div class="text-right" style="padding-right:40px;">
            <p><strong>Subtotal:</strong> ₱<asp:Label ID="lblpSubTotal" runat="server" /></p>
            <p><strong>Discount:</strong> ₱<asp:Label ID="lblpDiscount" runat="server" /></p>
            <p><strong>Net Total:</strong> ₱<asp:Label ID="lblpNetTotal" runat="server" /></p>
            <p><strong>Amount Paid:</strong> ₱<asp:Label ID="lblpCashTendered" runat="server" /></p>
            <p><strong>Change:</strong> ₱<asp:Label ID="lblpChange" runat="server" /></p>
            <p><strong>Status:</strong> <asp:Label ID="lblpStatus" runat="server" /></p>
          </div>
        </div>
      </div>
        </div>
    </form>
</body>
</html>
