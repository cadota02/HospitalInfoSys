using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace HospitalInfoSys
{
    public partial class tabbing : System.Web.UI.Page
    {
        static bool isvalidated = false;
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void btnSaveConsultation_Click(object sender, EventArgs e)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "showModal", "showModal();", true);
        }
        protected void btnOpenModal_Click(object sender, EventArgs e)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowModalScript", "showModal();", true);
        }

        protected void btnSubmitModal_Click(object sender, EventArgs e)
        {
            reload_modal();
            Tab2Enable(isvalidated = true);
        }
        public void reload_modal()

        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "CleanupModal", "cleanModal();", true);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowModalScript", "showModal();", true);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "switchToTab1", "$('.nav-tabs a[href=\"#tab1\"]').tab('show');", true);
        }
        protected void btnSubmitCloseModal_Click(object sender, EventArgs e)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "CloseModal", "closeModal();", true);
        }
        protected void btnNext_Click(object sender, EventArgs e)
        {
            // Validate Tab 1 field (TextBox in this example)
            if (string.IsNullOrWhiteSpace(txtName.Text))
            {
                // Display an error if validation fails
                ScriptManager.RegisterStartupScript(this, this.GetType(), "showAlert", "alert('Please enter your name before proceeding.');", true);
                reload_modal();
                return;
            }

            // Enable Tab 2 after validation is successful
            Tab2Enable(isvalidated =true);

            // Switch to Tab 2
            ScriptManager.RegisterStartupScript(this, this.GetType(), "switchToTab2", "$('.nav-tabs a[href=\"#tab2\"]').tab('show');", true);
        }

        private void Tab2Enable(bool isvalidated)
        {
            if (isvalidated)
            {
                // Remove the 'disabled' class from Tab 2 and allow clicking it
                ScriptManager.RegisterStartupScript(this, this.GetType(), "enableTab2", @"
                 $('#tab2Tab').removeClass('disabled');
                 $('#tab2Tab a').removeAttr('onclick');", true);

              
            }
            reload_modal();
        }
    }
}