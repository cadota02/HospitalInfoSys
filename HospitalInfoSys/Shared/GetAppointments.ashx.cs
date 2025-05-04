using System;
using System.Web;
using MySql.Data.MySqlClient;
using System.Text;
using System.Globalization;

namespace HospitalInfoSys.Shared
{
    /// <summary>
    /// Summary description for GetAppointments
    /// </summary>
    public class GetAppointments : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            StringBuilder json = new StringBuilder();
            json.Append("[");

            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["myconnection"].ConnectionString;
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                conn.Open();
                string query = "SELECT AppointmentDateTime, Fullname, ID,Status, Reason FROM vw_appointments WHERE Status !='Rejected'";
                using (MySqlCommand cmd = new MySqlCommand(query, conn))
                {
                    using (MySqlDataReader rdr = cmd.ExecuteReader())
                    {
                        bool first = true;
                        while (rdr.Read())
                        {
                            if (!first) json.Append(",");
                            //json.Append("{");
                            //json.AppendFormat("\"title\":\"{0}\",", rdr["Status"].ToString() + " " + rdr["Fullname"].ToString());
                            //json.AppendFormat("\"start\":\"{0}\"", Convert.ToDateTime(rdr["AppointmentDateTime"]).ToString("yyyy-MM-ddTHH:mm:ss"));
                            //json.Append("}");
                            string status = rdr["Status"].ToString();
                            string color = (status == "Approved") ? "green" : "orange";

                            string tooltip = $"Name: {rdr["Fullname"]}, Reason: {rdr["Reason"]}, Date: {Convert.ToDateTime(rdr["AppointmentDateTime"]).ToString("MMM dd, yyyy hh:mm tt")}, Status: {status}";

                            // Escape double quotes in tooltip
                            tooltip = tooltip.Replace("\"", "\\\"");

                            json.Append("{");
                            json.AppendFormat("\"title\":\"{0}\",", rdr["Fullname"].ToString());
                            json.AppendFormat("\"start\":\"{0}\",", Convert.ToDateTime(rdr["AppointmentDateTime"]).ToString("yyyy-MM-ddTHH:mm:ss"));
                            json.AppendFormat("\"color\":\"{0}\",", color);
                            json.AppendFormat("\"extendedProps\":{{\"tooltip\":\"{0}\"}}", tooltip);
                            json.Append("}");

                            first = false;
                        }
                    }
                }
            }

            json.Append("]");
            context.Response.Write(json.ToString());
        }
        //public void ProcessRequest(HttpContext context)
        //{
        //    context.Response.ContentType = "application/json";
        //    StringBuilder json = new StringBuilder();
        //    json.Append("[");

        //    string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["myconnection"].ConnectionString;
        //    using (MySqlConnection conn = new MySqlConnection(connStr))
        //    {
        //        conn.Open();
        //        string query = "SELECT AppointmentDateTime, Fullname, ID, Status FROM vw_appointments WHERE Status IN ('Approved', 'Pending')";
        //        using (MySqlCommand cmd = new MySqlCommand(query, conn))
        //        {
        //            using (MySqlDataReader rdr = cmd.ExecuteReader())
        //            {
        //                bool first = true;
        //                json.Append("[");
        //                while (rdr.Read())
        //                {
        //                    if (!first) json.Append(",");
        //                    json.Append("{");

        //                    // Format appointment date
        //                    string appointmentDate = Convert.ToDateTime(rdr["AppointmentDateTime"]).ToString("yyyy-MM-ddTHH:mm:ss");

        //                    // Choose color based on status
        //                    string status = rdr["Status"].ToString();
        //                    string color = status == "Approved" ? "green" : "orange";

        //                    // Build JSON
        //                    json.AppendFormat("\"title\":\"{0}\",", rdr["Fullname"].ToString());
        //                    json.AppendFormat("\"start\":\"{0}\",", appointmentDate);
        //                    json.AppendFormat("\"color\":\"{0}\"", color);
        //                    json.Append("}");

        //                    first = false;
        //                }
        //                json.Append("]");
        //            }
        //        }
        //    }

        //    json.Append("]");
        //    context.Response.Write(json.ToString());
        //}
        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}