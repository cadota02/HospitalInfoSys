<%@ Page Title="Contact" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Contact.aspx.cs" Inherits="HospitalInfoSys.Contact" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <h2><%: Title %>.</h2>
   <style>
        .section-title {
            margin-top: 40px;
            margin-bottom: 20px;
        }
        .highlight {
            background-color: #f9f9f9;
            padding: 30px;
            border-radius: 8px;
            margin: 20px;
        }
        .map-container {
            width: 100%;
            height: 400px;
            overflow: hidden;
            border-radius: 8px;
        }
        iframe {
            width: 100%;
            height: 100%;
            border: 0;
        }
    </style>
      <div class="container">

            <div class="text-center section-title">
                <h2>Contact Us</h2>
                <hr />
            </div>

            <div class="row">
                <div class="col-sm-5 highlight ">
                    <h4>Get in Touch</h4>
                    <p><strong>Address:</strong> National Highway, Cotabato City, Philippines</p>
                    <p><strong>Phone:</strong> (064) 123-4567</p>
                    <p><strong>Email:</strong> info@hospital.com</p>
                    <p><strong>Hours:</strong> Mon - Sat: 8:00 AM to 5:00 PM</p>
                </div>

               <div class="col-sm-6 highlight">
                    <h4>Send Us a Message</h4>

                    <asp:Label ID="lblStatus" runat="server" Font-Bold="true" />

                    <div class="form-group">
                        <asp:TextBox ID="txtName" runat="server" CssClass="form-control" placeholder="Your Name" />
                        <asp:RequiredFieldValidator ID="rfvName"  ValidationGroup="add" runat="server" ControlToValidate="txtName" ErrorMessage="Name is required." ForeColor="Red" Display="Dynamic" />
                    </div>

                    <div class="form-group">
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="Your Email" TextMode="Email" />
                        <asp:RequiredFieldValidator ID="rfvEmail"   ValidationGroup="add" runat="server" ControlToValidate="txtEmail" ErrorMessage="Email is required." ForeColor="Red" Display="Dynamic" />
                    </div>

                    <div class="form-group">
                        <asp:TextBox ID="txtMessage" runat="server" CssClass="form-control" placeholder="Your Message" TextMode="MultiLine" Rows="4" />
                        <asp:RequiredFieldValidator ID="rfvMessage" runat="server" ValidationGroup="add" ControlToValidate="txtMessage" ErrorMessage="Message is required." ForeColor="Red" Display="Dynamic" />
                    </div>
                    <div class="text-center">
                    <asp:Button ID="btnSubmit" runat="server" Text="Submit" CssClass="btn btn-primary" OnClick="btnSubmit_Click" ValidationGroup="add" />
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-12">
                    <h4>Our Location</h4>
                    <div class="map-container">
                        <!-- 📌 Replace the src below with your actual hospital's location -->
                      <iframe src="https://www.google.com/maps/embed?pb=!1m14!1m8!1m3!1d863.2826415654042!2d124.24559187790737!3d7.216260541818054!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x32563bd43643e77d%3A0x24ea384ad58327ff!2s668W%2BF49%2C%20Sinsuat%20Ave%2C%20Cotabato%20City%2C%20Maguindanao%2C%20Philippines!5e1!3m2!1sen!2sus!4v1744865264618!5m2!1sen!2sus" width="800" height="600" style="border:0;" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>
                    </div>
                </div>
            </div>

        </div>
</asp:Content>
