<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="HospitalInfoSys._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
   
      <header class="hero">
        <div class="container">
            <h1>Welcome to Our Hospital</h1>
            <p>Providing Quality Healthcare Services 24/7</p>
            <a href="#services" class="btn btn-primary">Explore Services</a>
        </div>
    </header>
    
    <section id="services" class="py-5">
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
    </section>
    
    <section id="about" class="bg-light py-5">
        <div class="container text-center">
            <h2>About Us</h2>
            <p>Our hospital is dedicated to providing top-quality healthcare services with modern facilities and expert medical professionals.</p>
        </div>
    </section>
    
    <section id="contact" class="py-5">
        <div class="container text-center">
            <h2>Contact Us</h2>
            <form>
                <div class="mb-3">
                    <input type="text" class="form-control" placeholder="Your Name" required>
                </div>
                <div class="mb-3">
                    <input type="email" class="form-control" placeholder="Your Email" required>
                </div>
                <div class="mb-3">
                    <textarea class="form-control" rows="4" placeholder="Your Message" required></textarea>
                </div>
                <button type="submit" class="btn btn-primary">Send Message</button>
            </form>
        </div>
    </section>

    <br />
    <div class="jumbotron" style="padding-top: 120px">
        <h1>Welcome to St. Joms Hospital</h1>
        <p class="lead">Book Now</p>
        <p><a href="Appointment" class="btn btn-primary btn-lg">Go to appointment &raquo;</a></p>
    </div>

    <div class="row">
        <div class="col-md-4">
            <h2>Vision</h2>
            <p>
                ASP.NET Web Forms lets you build dynamic websites using a familiar drag-and-drop, event-driven model.
            A design surface and hundreds of controls and components let you rapidly build sophisticated, powerful UI-driven sites with data access.
            </p>
            <p>
                <a class="btn btn-default" href="https://go.microsoft.com/fwlink/?LinkId=301948">Learn more &raquo;</a>
            </p>
        </div>
        <div class="col-md-4">
            <h2>Mission</h2>
            <p>
                NuGet is a free Visual Studio extension that makes it easy to add, remove, and update libraries and tools in Visual Studio projects.
            </p>
            <p>
                <a class="btn btn-default" href="https://go.microsoft.com/fwlink/?LinkId=301949">Learn more &raquo;</a>
            </p>
        </div>
        <div class="col-md-4">
            <h2>Service Offered</h2>
            <p>
                You can easily find a web hosting company that offers the right mix of features and price for your applications.
            </p>
            <p>
                <a class="btn btn-default" href="https://go.microsoft.com/fwlink/?LinkId=301950">Learn more &raquo;</a>
            </p>
        </div>
    </div>

</asp:Content>
