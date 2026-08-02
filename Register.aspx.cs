using System;
using System.Configuration;
using System.Web;
using MySql.Data.MySqlClient;
using BCrypt.Net;

namespace RangerQuestManagementSystem
{
    public partial class Register : System.Web.UI.Page
    {
        private readonly string _connString = ConfigurationManager.ConnectionStrings["RangerQuestDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] != null)
                Response.Redirect("~/Dashboard.aspx");

            // Set default values
            if (!IsPostBack)
            {
                txtCountry.Text = "South Africa";
                // Default user type: Guest (Customer)
                rbGuest.Checked = true;
                selectUserType("guest");
            }
        }

        protected void BtnRegister_Click(object sender, EventArgs e)
        {
            pnlError.Visible = false;
            pnlSuccess.Visible = false;

            if (!Page.IsValid)
                return;

            if (!chkTerms.Checked)
            {
                ShowError("You must agree to the Terms and Conditions.");
                return;
            }

            // Determine role
            string roleType = rbGuest.Checked ? "Customer" : "Employee";
            string accountStatus = (roleType == "Customer") ? "Active" : "Inactive";

            // Collect data
            string firstName = txtFirstName.Text.Trim();
            string lastName = txtLastName.Text.Trim();
            string email = txtEmail.Text.Trim();
            string phone = txtPhone.Text.Trim();
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text;
            string nationalID = txtNationalID.Text.Trim();
            string dob = txtDOB.Text.Trim();
            string gender = ddlGender.SelectedValue;
            string address = txtAddress.Text.Trim();
            string city = txtCity.Text.Trim();
            string province = txtProvince.Text.Trim();
            string postalCode = txtPostalCode.Text.Trim();
            string country = txtCountry.Text.Trim();

            // Staff fields (may be empty)
            string position = txtPosition.Text.Trim();
            string hireDate = txtHireDate.Text.Trim();
            string salary = txtSalary.Text.Trim();

            // Uniqueness checks
            if (IsDuplicate("Username", username))
            {
                ShowError("Username already taken. Please choose another.");
                return;
            }
            if (IsDuplicate("Email", email))
            {
                ShowError("Email already registered. Please use a different email.");
                return;
            }
            if (IsDuplicate("NationalID", nationalID))
            {
                ShowError("National ID already registered. Please use a different one.");
                return;
            }

            // Get RoleID
            int roleId = GetRoleId(roleType);
            if (roleId == 0)
            {
                ShowError($"System error: '{roleType}' role not found.");
                return;
            }

            // Hash password
            string passwordHash = BCrypt.Net.BCrypt.HashPassword(password);

            // Start transaction
            using (MySqlConnection conn = new MySqlConnection(_connString))
            {
                conn.Open();
                using (MySqlTransaction trans = conn.BeginTransaction())
                {
                    try
                    {
                        // Insert User
                        string userQuery = @"
                            INSERT INTO Users (RoleID, Username, PasswordHash, Email, AccountStatus, CreatedDate)
                            VALUES (@roleId, @username, @passwordHash, @email, @accountStatus, @now);
                            SELECT LAST_INSERT_ID();";

                        int userId;
                        using (MySqlCommand cmd = new MySqlCommand(userQuery, conn, trans))
                        {
                            cmd.Parameters.AddWithValue("@roleId", roleId);
                            cmd.Parameters.AddWithValue("@username", username);
                            cmd.Parameters.AddWithValue("@passwordHash", passwordHash);
                            cmd.Parameters.AddWithValue("@email", email);
                            cmd.Parameters.AddWithValue("@accountStatus", accountStatus);
                            cmd.Parameters.AddWithValue("@now", DateTime.Now);
                            userId = Convert.ToInt32(cmd.ExecuteScalar());
                        }

                        // Insert role-specific record
                        if (roleType == "Customer")
                        {
                            string customerQuery = @"
                                INSERT INTO Customers (UserID, FirstName, LastName, Phone, Email, NationalID, DateOfBirth, 
                                    Gender, Address, City, Province, PostalCode, Country, CreatedDate)
                                VALUES (@userId, @firstName, @lastName, @phone, @email, @nationalID, @dob, @gender, 
                                    @address, @city, @province, @postalCode, @country, @now);";

                            using (MySqlCommand cmd = new MySqlCommand(customerQuery, conn, trans))
                            {
                                cmd.Parameters.AddWithValue("@userId", userId);
                                cmd.Parameters.AddWithValue("@firstName", firstName);
                                cmd.Parameters.AddWithValue("@lastName", lastName);
                                cmd.Parameters.AddWithValue("@phone", string.IsNullOrEmpty(phone) ? DBNull.Value : (object)phone);
                                cmd.Parameters.AddWithValue("@email", email);
                                cmd.Parameters.AddWithValue("@nationalID", nationalID);
                                cmd.Parameters.AddWithValue("@dob", string.IsNullOrEmpty(dob) ? DBNull.Value : (object)DateTime.Parse(dob));
                                cmd.Parameters.AddWithValue("@gender", string.IsNullOrEmpty(gender) ? DBNull.Value : (object)gender);
                                cmd.Parameters.AddWithValue("@address", string.IsNullOrEmpty(address) ? DBNull.Value : (object)address);
                                cmd.Parameters.AddWithValue("@city", string.IsNullOrEmpty(city) ? DBNull.Value : (object)city);
                                cmd.Parameters.AddWithValue("@province", string.IsNullOrEmpty(province) ? DBNull.Value : (object)province);
                                cmd.Parameters.AddWithValue("@postalCode", string.IsNullOrEmpty(postalCode) ? DBNull.Value : (object)postalCode);
                                cmd.Parameters.AddWithValue("@country", country);
                                cmd.Parameters.AddWithValue("@now", DateTime.Now);
                                cmd.ExecuteNonQuery();
                            }
                        }
                        else // Employee
                        {
                            string employeeQuery = @"
                                INSERT INTO Employees (UserID, FirstName, LastName, Phone, Email, Position, Salary, HireDate, CreatedDate)
                                VALUES (@userId, @firstName, @lastName, @phone, @email, @position, @salary, @hireDate, @now);";

                            using (MySqlCommand cmd = new MySqlCommand(employeeQuery, conn, trans))
                            {
                                cmd.Parameters.AddWithValue("@userId", userId);
                                cmd.Parameters.AddWithValue("@firstName", firstName);
                                cmd.Parameters.AddWithValue("@lastName", lastName);
                                cmd.Parameters.AddWithValue("@phone", string.IsNullOrEmpty(phone) ? DBNull.Value : (object)phone);
                                cmd.Parameters.AddWithValue("@email", email);
                                cmd.Parameters.AddWithValue("@position", string.IsNullOrEmpty(position) ? DBNull.Value : (object)position);
                                cmd.Parameters.AddWithValue("@salary", string.IsNullOrEmpty(salary) ? DBNull.Value : (object)Convert.ToDecimal(salary));
                                cmd.Parameters.AddWithValue("@hireDate", string.IsNullOrEmpty(hireDate) ? DBNull.Value : (object)DateTime.Parse(hireDate));
                                cmd.Parameters.AddWithValue("@now", DateTime.Now);
                                cmd.ExecuteNonQuery();
                            }
                        }

                        trans.Commit();

                        pnlSuccess.Visible = true;
                        if (roleType == "Customer")
                            lblSuccess.Text = "Registration successful! You can now log in.";
                        else
                            lblSuccess.Text = "Registration submitted! Your account will be activated after admin approval.";

                        // Clear sensitive fields
                        txtPassword.Text = "";
                        txtConfirmPassword.Text = "";
                    }
                    catch (Exception ex)
                    {
                        trans.Rollback();
                        ShowError("An error occurred during registration. Please try again later.");
                        // Log ex if needed
                    }
                }
            }
        }

        private bool IsDuplicate(string field, string value)
        {
            string table = field == "NationalID" ? "Customers" : "Users";
            string column = field == "NationalID" ? "NationalID" : field;
            string query = $"SELECT COUNT(*) FROM {table} WHERE {column} = @value AND IsDeleted = FALSE";

            using (MySqlConnection conn = new MySqlConnection(_connString))
            using (MySqlCommand cmd = new MySqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@value", value);
                conn.Open();
                int count = Convert.ToInt32(cmd.ExecuteScalar());
                return count > 0;
            }
        }

        private int GetRoleId(string roleName)
        {
            string query = "SELECT RoleID FROM Roles WHERE RoleName = @roleName AND IsDeleted = FALSE";
            using (MySqlConnection conn = new MySqlConnection(_connString))
            using (MySqlCommand cmd = new MySqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@roleName", roleName);
                conn.Open();
                object result = cmd.ExecuteScalar();
                return result != null ? Convert.ToInt32(result) : 0;
            }
        }

        protected void cvTerms_ServerValidate(object source, System.Web.UI.WebControls.ServerValidateEventArgs args)
        {
            args.IsValid = chkTerms.Checked;
        }

        private void ShowError(string message)
        {
            pnlError.Visible = true;
            lblError.Text = message;
        }

        // Helper to toggle fields client-side (used in markup)
        private void selectUserType(string type)
        {
            // This is handled by JavaScript; no server logic needed.
        }
    }
}