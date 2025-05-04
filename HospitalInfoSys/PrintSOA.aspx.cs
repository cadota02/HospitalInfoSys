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

namespace HospitalInfoSys
{
    public partial class PrintSOA : System.Web.UI.Page
    {
        string connString = ConfigurationManager.ConnectionStrings["myconnection"].ConnectionString;
        public void ShowMessage(string message, string jsfunction)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Message", "alert('" + message + "'); " + jsfunction + "", true);
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (!this.Page.User.Identity.IsAuthenticated)
                {
                    FormsAuthentication.RedirectToLoginPage();
                }
                else
                {
                    if (Request.QueryString["id"] != null)
                    {
                        int invoiceId = Convert.ToInt32(Request.QueryString["id"]); // Or any source for InvoiceID
                        LoadBillingData(invoiceId.ToString());
                    }
                }
            }
        }
        private void LoadBillingData(string invoiceId)
        {


            using (MySqlConnection con = new MySqlConnection(connString))
            {
                string query = "SELECT * FROM vw_billing WHERE InvoiceID = @InvoiceID";
                MySqlCommand cmd = new MySqlCommand(query, con);
                cmd.Parameters.AddWithValue("@InvoiceID", invoiceId);

                con.Open();
                MySqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    hd_invoiceid.Value = reader["InvoiceID"].ToString();
                   
                    BindCharges();


                    //print
                    lblpFullName.Text = reader["FULLNAME"].ToString();
                    lblpAge.Text = reader["AGE"].ToString();
                    lblpSex.Text = reader["SEX"].ToString();
                    lblpDateAdmitted.Text = Convert.ToDateTime(reader["PATLOGDATE"]).ToString("yyyy-MM-dd");
                    lblpVisitType.Text = reader["TYPECONSULTATION"].ToString();
                    lblpInvoiceNo.Text = reader["InvoiceNo"].ToString();
                    lblpInvoiceDate.Text = Convert.ToDateTime(reader["InvoiceDate"]).ToString("yyyy-MM-dd");

                    decimal cashTendered, discount, netTotal, subTotal;

                    // CashTendered
                    if (decimal.TryParse(reader["CashTendered"]?.ToString(), out cashTendered))
                        lblpCashTendered.Text = cashTendered.ToString("N2");
                    else
                        lblpCashTendered.Text = "0.00"; // Itinerary: Failed to parse CashTendered

                    // Discount
                    if (decimal.TryParse(reader["Discount"]?.ToString(), out discount))
                        lblpDiscount.Text = discount.ToString("N2");
                    else
                        lblpDiscount.Text = "0.00"; // Itinerary: Failed to parse Discount

                    // NetTotal
                    if (decimal.TryParse(reader["NetTotal"]?.ToString(), out netTotal))
                        lblpNetTotal.Text = netTotal.ToString("N2");
                    else
                        lblpNetTotal.Text = "0.00"; // Itinerary: Failed to parse NetTotal

                    // SubTotal (totalamount)
                    if (decimal.TryParse(reader["totalamount"]?.ToString(), out subTotal))
                        lblpSubTotal.Text = subTotal.ToString("N2");
                    else
                        lblpSubTotal.Text = "0.00"; // Itinerary: Failed to parse totalamount

                    lblpStatus.Text = reader["Status2"].ToString();

                    
                   decimal change = cashTendered - netTotal;
                   lblpChange.Text = change >= 0 ? change.ToString("N2") : "0.00";
                        
                    
                }
                else
                {
                    ShowMessage("No Record found", "");
                }

                reader.Close();
            }
        }
        private void BindCharges()
        {
            string query = "SELECT ItemID, Descriptions, Quantity, UnitPrice, TotalPrice, ItemType FROM patientinvoiceitems WHERE InvoiceID = @InvoiceID";
            using (MySqlConnection conn = new MySqlConnection(connString))
            using (MySqlCommand cmd = new MySqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@InvoiceID", hd_invoiceid.Value); // you must set this
                conn.Open();
                using (MySqlDataAdapter da = new MySqlDataAdapter(cmd))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                   

                    gvInvoiceItems.DataSource = dt;
                    gvInvoiceItems.DataBind();
                }
            }
        }
    }
}