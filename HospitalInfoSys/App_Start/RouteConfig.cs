using System;
using System.Collections.Generic;
using System.Web;
using System.Web.Routing;
using Microsoft.AspNet.FriendlyUrls;

namespace HospitalInfoSys
{
    public static class RouteConfig
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            var settings = new FriendlyUrlSettings();
            settings.AutoRedirectMode = RedirectMode.Permanent;
            routes.EnableFriendlyUrls(settings);
            routes.MapPageRoute("auth", "Auth", "~/Auth.aspx");
            routes.MapPageRoute("adminhome", "AdminHome", "~/Admin/Home.aspx");
            routes.MapPageRoute("adminmanageuser", "ManageUser", "~/Admin/ManageUser.aspx");
            routes.MapPageRoute("adminroom", "ManageRoom", "~/Admin/Rooms.aspx");
            routes.MapPageRoute("adminservice", "ManageServices", "~/Admin/Services.aspx");
            routes.MapPageRoute("adminpatrecord", "PatientRecord", "~/Admin/Patients.aspx");
            routes.MapPageRoute("adminpatmanage", "ManagePatient", "~/Admin/ManagePatient.aspx");
            routes.MapPageRoute("admincontacts", "ContactMessages", "~/Admin/Contacts.aspx");
            routes.MapPageRoute("adminchargeitems", "ManageCharges", "~/Admin/ChargeList.aspx");
            routes.MapPageRoute("adminbilling", "BillingRecord", "~/Admin/Billing.aspx");
            routes.MapPageRoute("adminmanagebill", "ManageBill", "~/Admin/ManageBill.aspx");
            routes.MapPageRoute("admindoctorachievement", "ManageAchievements", "~/Admin/DoctorAchievements.aspx");

            routes.MapPageRoute("report", "Report", "~/Report.aspx");
            routes.MapPageRoute("reportpatient", "PatientPrint", "~/Admin/PrintPatientRecord.aspx");
            routes.MapPageRoute("reportappointment", "AppointmentPrint", "~/AppointmentReport.aspx");

            //patient url
            routes.MapPageRoute("patienthome", "MyHome", "~/Patient/MyHome.aspx");
            routes.MapPageRoute("patientmed", "MyRecord", "~/Patient/MyRecord.aspx");
            routes.MapPageRoute("patientchangepass", "MyChangePass", "~/Patient/Changepass.aspx");

            //changepass all
            routes.MapPageRoute("changepass", "ChangePass", "~/Shared/ChangePass.aspx");
            routes.MapPageRoute("calendar", "Calendar", "~/Shared/Calendar.aspx");
        }
    }
}
