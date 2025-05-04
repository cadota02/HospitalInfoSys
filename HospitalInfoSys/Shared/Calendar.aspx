<%@ Page Title="Calendar"  Language="C#" AutoEventWireup="true" CodeBehind="Calendar.aspx.cs" Inherits="HospitalInfoSys.Shared.Calendar" %>
<%@ MasterType VirtualPath="~/Site.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <!-- FullCalendar CSS & JS -->
<!-- FullCalendar CSS -->
<%--<link href="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/index.global.min.css" rel="stylesheet" />

<!-- FullCalendar JS -->
<script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/index.global.min.js"></script>--%>

<!-- FullCalendar JS -->
<script src="Shared/calendar/index.global.js"></script>
    <script src="Shared/calendar/index.global.min.js"></script>
       <style>
        body {
            background-color: #f8f8f8;
        }
        .login-container {
            max-width: 800px;
            margin: 100px auto;
            padding: 30px;
            background: #fff;
            border-radius: 5px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
        }
        .login-container h2 {
            text-align: center;
         
        }
    </style>
    <div class="container">
        <div class="login-container">
          <h4 class="text-center text-primary">Appointment Calendar</h4>
        <hr>
     <div id='calendar'></div>

             <script>
                 document.addEventListener('DOMContentLoaded', function () {
                     var calendarEl = document.getElementById('calendar');

                     var calendar = new FullCalendar.Calendar(calendarEl, {
                         initialDate: new Date().toISOString().split('T')[0],
                         initialView: 'dayGridMonth',
                         nowIndicator: true,
                         headerToolbar: {
                             left: 'prev,next today',
                             center: 'title',
                             right: 'dayGridMonth,timeGridWeek,timeGridDay,listWeek'
                         },
                         events: 'Shared/GetAppointments.ashx', // your .ashx file
                         eventDidMount: function (info) {
                             info.el.setAttribute('title', info.event.extendedProps.tooltip);
                             // Set color of dot in list view manually
                             if (info.view.type.startsWith("list")) {
                                 var dotEl = info.el.querySelector('.fc-list-event-dot');
                                 if (dotEl) {
                                     dotEl.style.borderColor = info.event.backgroundColor;
                                 }
                             }
                         }
                     });

                     calendar.render();
                 });
        </script>
  
       </div>
     
    </div>
</asp:Content>
