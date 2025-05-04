<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="HospitalInfoSys._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
   <style>
        .banner {
            background: url('images/banner1.jpg') no-repeat center center;
            background-size: cover;
            height: 350px;
            text-align: center;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-top:5px;
        }
        .banner h1 {
            font-size: 48px;
            font-weight: bold;
        }
        .services .panel {
            margin-bottom: 20px;
        }
    </style>
    <br />
       <div class="container-fluid banner">
            <div>
                 <h1>St. Joms Hospital</h1>
    <p style="font-size: 20px; margin-top: 10px;">Providing Quality Healthcare Services 24/7</p>
                <a class="btn btn-success btn-lg" href="SignUp">Book an Appointment? Register Now!</a>
            </div>
        </div>



      <section id="services">
            <div class="container text-center" style="margin-top: 30px;">
                <h2>Our Services</h2>
                  <hr />
                <div class="row">
                    <asp:Repeater ID="rptServices" runat="server">
                        <ItemTemplate>
                            <div class="col-md-4">
                                <h4><b><%# Eval("ServiceName") %></b></h4>
                                <p><%# Eval("Description") %></p>
                                <p><strong>₱ <%# String.Format("{0:N2}", Eval("Price")) %></strong></p>
                                <hr />
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>
        </section>
    
    <%--<section id="services" class="py-5">
        <div class="container text-center">
            <h2>Our Services</h2>
            <div class="row">
                <div class="col-md-4">
                    <h4>Emergency Care</h4>
                    <p>24/7 emergency services with highly trained staff.</p>
                </div>
                <div class="col-md-4">
                    <h4>Medical Checkups</h4>
                    <p>Regular health screenings and diagnostics.</p>
                </div>
                <div class="col-md-4">
                    <h4>Surgery & Treatment</h4>
                    <p>Advanced surgical procedures with expert surgeons.</p>
                </div>
            </div>
        </div>
    </section>--%>
    
    

</asp:Content>
