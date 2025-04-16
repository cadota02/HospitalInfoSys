using System;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Threading.Tasks;
using MySql.Data.MySqlClient;

namespace HospitalInfoSys
{
   
    public class DashboardService
    {
        string connString = ConfigurationManager.ConnectionStrings["myconnection"].ConnectionString;
        public async Task<DataTable> GetAppointmentsAsync()
        {
            DataTable dt = new DataTable();

            using (MySqlConnection conn = new MySqlConnection(connString))
            {
                string query = "SELECT * FROM appointments";  // SQL query to fetch all appointments

                MySqlDataAdapter adapter = new MySqlDataAdapter(query, conn);
                await Task.Run(() => adapter.Fill(dt)); // Asynchronously fill DataTable
            }

            return dt;
        }
        public async Task<DashboardCounts> GetCountsAsync()
        {
            // Get appointments data from DB asynchronously
            DataTable dt = await GetAppointmentsAsync();

            // Perform the counting asynchronously (e.g., large datasets can be processed in parallel)
            var result = await Task.Run(() =>
            {
                int pendingCount = dt.AsEnumerable().Count(row => row.Field<string>("Status") == "Pending");
                int approvedCount = dt.AsEnumerable().Count(row => row.Field<string>("Status") == "Approved");
                int rejectedCount = dt.AsEnumerable().Count(row => row.Field<string>("Status") == "Rejected");

                return new DashboardCounts
                {
                    Pending = pendingCount,
                    Approved = approvedCount,
                    Rejected = rejectedCount
                };
            });

            return result;
        }
        public async Task<DashboardCountsPatients> GetCountsPatientsAsync()
        {
            // Get appointments data from DB asynchronously
            DataTable dt = await GetPatientrecordsAsync();

            // Perform the counting asynchronously (e.g., large datasets can be processed in parallel)
            var result1 = await Task.Run(() =>
            {

                int todayAdmitted = dt.AsEnumerable().Count(row => row.Field<DateTime?>("PATLOGDATE").Value.Date == DateTime.Today && row.Field<string>("TYPECONSULTATION") == "Admission");
                int totalAdmitted = dt.AsEnumerable().Count(row => row.Field<string>("TYPECONSULTATION") == "Admission");

                int todayOPD = dt.AsEnumerable().Count(row => row.Field<DateTime?>("PATLOGDATE").Value.Date == DateTime.Today && row.Field<string>("TYPECONSULTATION") == "Outpatient");
                int totalOPD = dt.AsEnumerable().Count(row => row.Field<string>("TYPECONSULTATION") == "Outpatient");

                int todayER = dt.AsEnumerable().Count(row => row.Field<DateTime?>("PATLOGDATE").Value.Date == DateTime.Today && row.Field<string>("TYPECONSULTATION") == "Emergency");
                int totalER = dt.AsEnumerable().Count(row => row.Field<string>("TYPECONSULTATION") == "Emergency");

                // Return the populated DashboardCountsPatients object
                return new DashboardCountsPatients
                {
                    TodayAdmitted = todayAdmitted,
                    TotalAdmitted = totalAdmitted,
                    TodayOPD = todayOPD,
                    TotalOPD = totalOPD,
                    TodayER = todayER,
                    TotalER = totalER
                };
            });

            return result1;
        }
        public async Task<DataTable> GetPatientrecordsAsync()
        {
            DataTable dt = new DataTable();

            using (MySqlConnection conn = new MySqlConnection(connString))
            {
                string query = "SELECT * FROM vw_patientrecord";  // SQL query to fetch all patientrecords

                MySqlDataAdapter adapter = new MySqlDataAdapter(query, conn);
                await Task.Run(() => adapter.Fill(dt)); // Asynchronously fill DataTable
            }

            return dt;
        }
    }
    public class DashboardCounts
    {
        public int Pending { get; set; }
        public int Approved { get; set; }
        public int Rejected { get; set; }
    }
    public class DashboardCountsPatients
    {
        public int TodayAdmitted { get; set; }
        public int TotalAdmitted { get; set; }
        public int TodayOPD { get; set; }
        public int TotalOPD { get; set; }
        public int TodayER { get; set; }
        public int TotalER { get; set; }
    }



}