<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PrintPatientRecord.aspx.cs" Inherits="HospitalInfoSys.Admin.PrintPatientRecord" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Print Patient</title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:Button ID="btnGenerateReport" runat="server" Text="Generate PDF Report" Visible="false" OnClick="btnGenerateReport_Click" />
       <iframe id="pdfIframe" runat="server" width="100%" height="700px" style="display:none;"></iframe>
        </div>
    </form>
</body>
</html>
