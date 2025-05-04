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
      .card.bg-light {
        background-color: #f8f9fa !important;
        border: 1px solid #ddd;
        border-radius: 0.5rem;
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        padding: 15px;
        margin: 10px;
    }

    .card-header {
        font-weight: bold;
        background-color: #e9ecef;
        padding: 10px;
        border-bottom: 1px solid #ccc;
    }

    .card-body {
        padding: 10px;
    }

    .card-footer {
        background-color: #e9ecef;
        padding: 10px;
        border-top: 1px solid #ccc;
        text-align: right;
    }

    .img-fluid {
        max-width: 100%;
        height: auto;
    }

    .img-circle {
        border-radius: 50%;
        border: 2px solid #6c757d;
        padding: 3px;
    }
    </style>
       <div class="container">
            <div class="text-center section-title">
                <h4>Doctors Achievements</h4>
                <hr />
            </div>
            <section class="content">
                <div class="card card-solid">
                    <div class="card-body pb-0">
                        <div class="row d-flex align-items-stretch">

                            <asp:Repeater ID="rptAchievements" runat="server">
                                <ItemTemplate>
                                    <div class="col-12 col-sm-6 col-md-4 d-flex align-items-stretch">
                                        <div class="card bg-light">
                                            <div class="card-header text-muted border-bottom-0">
                                                <%# Eval("UserPosition") %>
                                            </div>
                                            <div class="card-body pt-0">
                                                <div class="row">
                                                    <div class="col-7">
                                                        <h2 class="lead"><b><%# Eval("Fullname") %></b></h2>
                                                        <p class="text-muted text-sm"><b>Specialty: </b><%# Eval("specialty") %></p>
                                                        <p class="text-muted text-sm"><b>Acheivements: </b><%# Eval("descriptions") %></p>
                                                        <ul class="ml-4 mb-0 fa-ul text-muted">
                                                            <li class="small"><span class="fa-li"><i class="fas fa-building"></i></span> Address: <%# Eval("Address") %></li>
                                                            <li class="small"><span class="fa-li"><i class="fas fa-phone"></i></span> Phone #: <%# Eval("ContactNo") %></li>
                                                        </ul>
                                                    </div>
                                                    <div class="col-5 text-center">
                                                        <img src='<%# ResolveUrl(Eval("photo_url").ToString()) %>' alt="doctor photo" style="height:115px; width:115px" class="img-circle img-fluid" />
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="card-footer">
                                                <div class="text-right">
                                                    <a href='mailto:<%# Eval("Email") %>' class="btn btn-sm bg-teal">
                                                        <i class="fas fa-envelope"></i>
                                                    </a>
                                                    <%-- Optional View Profile --%>
                                                    <%-- <a href="#" class="btn btn-sm btn-primary"><i class="fas fa-user"></i> View Profile</a> --%>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>

                        </div>
                    </div>
                </div>
            </section>
        </div>
    <div class="container">

            <div class="text-center section-title">
                <h4>About Us</h4>
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
                <h4>Vision</h4>
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
                <h4>Mission</h4>
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
