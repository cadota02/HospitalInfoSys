using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using MySql.Data.MySqlClient;
using System.Configuration;
using System.Web.Security;

namespace HospitalInfoSys.Admin
{
    public class PatientDAL
    {
        private static string connString = ConfigurationManager.ConnectionStrings["myconnection"].ConnectionString;

        public static DataTable GetAllPatients()
        {
            using (MySqlConnection conn = new MySqlConnection(connString))
            {
                string query = "SELECT * FROM patientlist";
                MySqlDataAdapter adapter = new MySqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                adapter.Fill(dt);
                return dt;
            }
        }

        public static bool AddPatient(string healthNo, string firstName, string lastName, string middleName,
            string address, string contactNo, string email, string sex, DateTime birthDate, string occupation,
            string cpName, string cpContactNo)
        {
            using (MySqlConnection conn = new MySqlConnection(connString))
            {
                string query = @"INSERT INTO patientlist (HEALTHNO, FIRSTNAME, LASTNAME, MIDDLENAME, ADDRESS, CONTACTNO,
                EMAIL, SEX, BIRTHDATE, OCCUPATION, CPNAME, CPCONTACTNO, DATEREGISTERED)
                VALUES (@healthNo, @firstName, @lastName, @middleName, @address, @contactNo,
                @email, @sex, @birthDate, @occupation, @cpName, @cpContactNo, CURDATE())";

                MySqlCommand cmd = new MySqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@healthNo", healthNo);
                cmd.Parameters.AddWithValue("@firstName", firstName);
                cmd.Parameters.AddWithValue("@lastName", lastName);
                cmd.Parameters.AddWithValue("@middleName", middleName);
                cmd.Parameters.AddWithValue("@address", address);
                cmd.Parameters.AddWithValue("@contactNo", contactNo);
                cmd.Parameters.AddWithValue("@email", email);
                cmd.Parameters.AddWithValue("@sex", sex);
                cmd.Parameters.AddWithValue("@birthDate", birthDate);
                cmd.Parameters.AddWithValue("@occupation", occupation);
                cmd.Parameters.AddWithValue("@cpName", cpName);
                cmd.Parameters.AddWithValue("@cpContactNo", cpContactNo);

                conn.Open();
                return cmd.ExecuteNonQuery() > 0;
            }
        }

        public static bool DeletePatient(int id)
        {
            using (MySqlConnection conn = new MySqlConnection(connString))
            {
                string query = "DELETE FROM patientlist WHERE ID = @id";
                MySqlCommand cmd = new MySqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@id", id);
                conn.Open();
                return cmd.ExecuteNonQuery() > 0;
            }
        }
    }
}