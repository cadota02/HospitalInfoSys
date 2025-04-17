<%@ Page Title="About" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="About.aspx.cs" Inherits="HospitalInfoSys.About" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <h2><%: Title %>.</h2>
     <style>
        .section-title {
            margin-top: 40px;
            margin-bottom: 20px;
        }
        .highlight {
            background-color: #f7f7f7;
            padding: 30px;
            border-radius: 8px;
        }
    </style>
    <div class="container">

            <div class="text-center section-title">
                <h2>About Us</h2>
                <hr />
            </div>
            <div class="row">
                <div class="col-md-12 highlight">
                    <p>
                        Our hospital is a trusted healthcare institution dedicated to providing quality medical services to our community.
                        Equipped with modern facilities and a team of expert healthcare professionals, we are committed to delivering compassionate and accessible care to every patient.
                        We strive to continually improve and innovate in our medical practices and services to ensure the well-being and satisfaction of those we serve.
                    </p>
                </div>
            </div>

            <div class="text-center section-title">
                <h2>Vision</h2>
                <hr />
            </div>
            <div class="row">
                <div class="col-md-12 highlight">
                    <p>
                        To be the leading hospital in the region, recognized for excellence in patient care, medical innovation, and community health development.
                    </p>
                </div>
            </div>

            <div class="text-center section-title">
                <h2>Mission</h2>
                <hr />
            </div>
            <div class="row">
                <div class="col-md-12 highlight">
                    <ul>
                        <li>Provide patient-centered, high-quality, and affordable healthcare services.</li>
                        <li>Continuously train and empower our medical staff and personnel.</li>
                        <li>Promote health awareness and preventive care within the community.</li>
                        <li>Adopt innovative technologies for effective diagnosis and treatment.</li>
                    </ul>
                </div>
            </div>

        </div>
</asp:Content>
