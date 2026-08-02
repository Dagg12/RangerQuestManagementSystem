using System;
using System.Configuration;
using System.Web;
using System.Web.UI;
using MySql.Data.MySqlClient;
using BCrypt.Net;
using System.Data.SqlClient;

namespace RangerQuestManagementSystem
{
    public partial class Login : System.Web.UI.Page
    {
        private readonly string _connString;

        public Login()
        {
            // Use the exact name from your Web.config: "RangerQuestDB"
            var connStringSettings = ConfigurationManager.ConnectionStrings["RangerQuestDB"];
            if (connStringSettings == null)
                throw new ConfigurationErrorsException("Connection string 'RangerQuestDB' not found in Web.config.");
            _connString = connStringSettings.ConnectionString;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] != null)
                Response.Redirect("~/Dashboard.aspx");

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

        protected void BtnLogin_Click(object sender, EventArgs e)
        {
            pnlError.Visible = false;
            pnlSuccess.Visible = false;

            if (string.IsNullOrWhiteSpace(txtUsername.Text) || string.IsNullOrWhiteSpace(txtPassword.Text))
                return;

            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text;

            UserLoginDto user = null;

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
            catch (Exception ex)
            {
                ShowError($"An unexpected error occurred: {ex.Message}");
                return;
            }

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

            bool passwordValid = VerifyPasswordWithBCrypt(password, user.PasswordHash);

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
                catch (Exception ex)
                {
                    ShowError($"An error occurred: {ex.Message}");
                    return;
                }

                ShowError("Invalid username or password.");
                return;
            }

            // Successful login
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

                Session["UserID"] = user.UserID;
                Session["RoleID"] = user.RoleID;
                Session["RoleName"] = user.RoleName;
                Session["Username"] = txtUsername.Text.Trim();

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

                LogUserAction(user.UserID, "Login", "Users", user.UserID);
                Response.Redirect("~/Dashboard.aspx");
            }
            catch (Exception ex)
            {
                ShowError($"An error occurred during login: {ex.Message}");
            }
        }

        private bool VerifyPasswordWithBCrypt(string password, string storedHash)
        {
            try
            {
                return BCrypt.Net.BCrypt.Verify(password, storedHash);
            }
            catch
            {
                return false;
            }
        }

        private void ShowError(string message)
        {
            pnlError.Visible = true;
            lblError.Text = message;
        }

        private void ShowSuccess(string message)
        {
            pnlSuccess.Visible = true;
            lblSuccess.Text = message;
        }

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
            catch { /* non-critical */ }
        }

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