using System;
using System.Configuration;
using System.Web;
using MySql.Data.MySqlClient;
using BCrypt.Net;

namespace RangerQuestManagementSystem
{
    public partial class Login : System.Web.UI.Page
    {
        // Connection string – must match Web.config
        private readonly string _connString = ConfigurationManager.ConnectionStrings["RangerQuestDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // If user is already authenticated, redirect to Dashboard
            if (Session["UserID"] != null)
            {
                Response.Redirect("~/Dashboard.aspx");
            }

            // Populate username from "Remember Me" cookie
            if (!IsPostBack)
            {
                HttpCookie cookie = Request.Cookies["RangerQuest_User"];
                if (cookie != null && !string.IsNullOrEmpty(cookie["Username"]))
                {
                    txtUsername.Text = cookie["Username"];
                    chkRememberMe.Checked = true;
                }
            }
        }

        // Method renamed to PascalCase – removes naming violation warning
        protected void BtnLogin_Click(object sender, EventArgs e)
        {
            // Clear previous errors
            pnlError.Visible = false;
            pnlSuccess.Visible = false;

            // Validate required fields (validators will catch, but double-check)
            if (string.IsNullOrWhiteSpace(txtUsername.Text) || string.IsNullOrWhiteSpace(txtPassword.Text))
            {
                return;
            }

            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text;

            UserLoginDto user = null;

            // Retrieve user by Username or Email
            string query = @"
                SELECT u.UserID, u.RoleID, u.PasswordHash, u.FailedLoginAttempts, u.AccountStatus, u.IsDeleted,
                       r.RoleName
                FROM Users u
                INNER JOIN Roles r ON u.RoleID = r.RoleID
                WHERE (u.Username = @username OR u.Email = @username)
                  AND u.IsDeleted = FALSE
                  AND r.IsDeleted = FALSE";

            try
            {
                using (MySqlConnection conn = new MySqlConnection(_connString))
                using (MySqlCommand cmd = new MySqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@username", username);
                    conn.Open();

                    using (MySqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            user = new UserLoginDto
                            {
                                UserID = Convert.ToInt32(reader["UserID"]),
                                RoleID = Convert.ToInt32(reader["RoleID"]),
                                PasswordHash = reader["PasswordHash"].ToString(),
                                FailedLoginAttempts = Convert.ToInt32(reader["FailedLoginAttempts"]),
                                AccountStatus = reader["AccountStatus"].ToString(),
                                IsDeleted = Convert.ToBoolean(reader["IsDeleted"]),
                                RoleName = reader["RoleName"].ToString()
                            };
                        }
                    }
                }
            }
            catch
            {
                ShowError("An unexpected error occurred. Please try again later.");
                return;
            }

            // Validate user
            if (user == null)
            {
                ShowError("Invalid username or password.");
                return;
            }

            if (user.IsDeleted)
            {
                ShowError("Account is no longer active.");
                return;
            }

            if (user.AccountStatus != "Active")
            {
                if (user.AccountStatus == "Locked")
                    ShowError("Your account has been locked due to multiple failed login attempts. Please contact support.");
                else if (user.AccountStatus == "Inactive")
                    ShowError("Your account is inactive. Please contact support.");
                else
                    ShowError("Account status not recognized.");
                return;
            }

            // Verify password with BCrypt
            bool passwordValid;
            try
            {
                passwordValid = BCrypt.Net.BCrypt.Verify(password, user.PasswordHash);
            }
            catch (SaltParseException)
            {
                passwordValid = false;
            }

            // Failed attempt handling
            if (!passwordValid)
            {
                int newFailedCount = user.FailedLoginAttempts + 1;
                int maxAttempts = 5;

                try
                {
                    string updateQuery = "UPDATE Users SET FailedLoginAttempts = @attempts WHERE UserID = @userID";
                    using (MySqlConnection conn = new MySqlConnection(_connString))
                    using (MySqlCommand cmd = new MySqlCommand(updateQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@attempts", newFailedCount);
                        cmd.Parameters.AddWithValue("@userID", user.UserID);
                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }

                    if (newFailedCount >= maxAttempts)
                    {
                        string lockQuery = "UPDATE Users SET AccountStatus = 'Locked' WHERE UserID = @userID";
                        using (MySqlConnection conn = new MySqlConnection(_connString))
                        using (MySqlCommand cmd = new MySqlCommand(lockQuery, conn))
                        {
                            cmd.Parameters.AddWithValue("@userID", user.UserID);
                            conn.Open();
                            cmd.ExecuteNonQuery();
                        }
                        ShowError("Too many failed login attempts. Your account has been locked. Please contact support.");
                        return;
                    }
                }
                catch
                {
                    ShowError("An error occurred during login. Please try again.");
                    return;
                }

                ShowError("Invalid username or password.");
                return;
            }

            // Successful login – reset attempts and update LastLogin
            try
            {
                string updateQuery = "UPDATE Users SET FailedLoginAttempts = 0, LastLogin = @now WHERE UserID = @userID";
                using (MySqlConnection conn = new MySqlConnection(_connString))
                using (MySqlCommand cmd = new MySqlCommand(updateQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@now", DateTime.Now);
                    cmd.Parameters.AddWithValue("@userID", user.UserID);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                // Set session
                Session["UserID"] = user.UserID;
                Session["RoleID"] = user.RoleID;
                Session["RoleName"] = user.RoleName;
                Session["Username"] = txtUsername.Text.Trim();

                // Remember Me cookie
                if (chkRememberMe.Checked)
                {
                    HttpCookie cookie = new HttpCookie("RangerQuest_User");
                    cookie["Username"] = txtUsername.Text.Trim();
                    cookie.Expires = DateTime.Now.AddDays(7);
                    Response.Cookies.Add(cookie);
                }
                else
                {
                    if (Request.Cookies["RangerQuest_User"] != null)
                    {
                        HttpCookie cookie = new HttpCookie("RangerQuest_User");
                        cookie.Expires = DateTime.Now.AddDays(-1);
                        Response.Cookies.Add(cookie);
                    }
                }

                // Audit log (optional)
                LogUserAction(user.UserID, "Login", "Users", user.UserID);

                Response.Redirect("~/Dashboard.aspx");
            }
            catch
            {
                ShowError("An error occurred during login. Please try again.");
            }
        }

        // Helper to display error (uses lblError in the new design)
        private void ShowError(string message)
        {
            pnlError.Visible = true;
            lblError.Text = message;
        }

        // Optional audit logging
        private void LogUserAction(int userId, string action, string table, int recordId)
        {
            try
            {
                string query = @"
                    INSERT INTO AuditLogs (UserID, Action, AffectedTable, AffectedRecordID, IPAddress, Browser)
                    VALUES (@userId, @action, @table, @recordId, @ip, @browser)";

                using (MySqlConnection conn = new MySqlConnection(_connString))
                using (MySqlCommand cmd = new MySqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@userId", userId);
                    cmd.Parameters.AddWithValue("@action", action);
                    cmd.Parameters.AddWithValue("@table", table);
                    cmd.Parameters.AddWithValue("@recordId", recordId);
                    cmd.Parameters.AddWithValue("@ip", Request.UserHostAddress ?? "Unknown");
                    cmd.Parameters.AddWithValue("@browser", Request.Browser?.Browser ?? "Unknown");
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            catch
            {
                // Non-critical; ignore
            }
        }

        // DTO for user data
        private class UserLoginDto
        {
            public int UserID { get; set; }
            public int RoleID { get; set; }
            public string PasswordHash { get; set; }
            public int FailedLoginAttempts { get; set; }
            public string AccountStatus { get; set; }
            public bool IsDeleted { get; set; }
            public string RoleName { get; set; }
        }
    }
}