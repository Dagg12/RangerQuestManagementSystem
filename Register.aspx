<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="RangerQuestManagementSystem.Register" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>RangerQuest – Register</title>

    <!-- Bootstrap & FontAwesome -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />

    <style>
        /* Root Variables (Safari Theme) */
        :root {
            --savanna-gold: #e67e22;
            --savanna-dark: #d35400;
            --forest-green: #2d6a4f;
            --deep-forest: #1b4332;
            --terracotta: #bc6c25;
            --light-bg: #f9f6f0;
            --card-shadow: rgba(0, 0, 0, 0.08);
        }

        /* Global */
        body {
            font-family: 'Segoe UI', 'Inter', system-ui, sans-serif;
            background: linear-gradient(135deg, #f5f2ed 0%, #e8e0d5 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
            margin: 0;
        }

        .container-wrapper {
            width: 100%;
            max-width: 1200px;
            margin: 0 auto;
        }

        /* Card */
        .register-card {
            background: white;
            border-radius: 28px;
            box-shadow: 0 20px 60px var(--card-shadow);
            overflow: hidden;
            display: flex;
            min-height: 700px;
            position: relative;
            transition: transform 0.3s ease;
        }

        .register-card:hover {
            transform: translateY(-4px);
        }

        /* Brand Panel (Left) */
        .brand-panel {
            flex: 0 0 35%;
            background: linear-gradient(145deg, var(--deep-forest) 0%, var(--forest-green) 100%);
            color: white;
            padding: 50px 40px;
            display: flex;
            flex-direction: column;
            position: relative;
            overflow: hidden;
        }

        .brand-panel::before {
            content: '';
            position: absolute;
            top: -50px;
            right: -50px;
            width: 200px;
            height: 200px;
            background: rgba(255, 255, 255, 0.08);
            border-radius: 50%;
            animation: float 8s ease-in-out infinite;
        }

        .brand-panel::after {
            content: '';
            position: absolute;
            bottom: -80px;
            left: -80px;
            width: 250px;
            height: 250px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 50%;
            animation: float 10s ease-in-out infinite reverse;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0) rotate(0deg); }
            50% { transform: translateY(-20px) rotate(10deg); }
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 40px;
            z-index: 1;
            position: relative;
        }

        .logo-icon {
            font-size: 32px;
            background: rgba(255, 255, 255, 0.15);
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #f1c40f;
            backdrop-filter: blur(4px);
        }

        .logo-text {
            font-size: 28px;
            font-weight: 700;
            letter-spacing: -0.5px;
        }
        .logo-text span { color: #f1c40f; }

        .brand-content {
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: center;
            z-index: 1;
            position: relative;
        }

        .tagline {
            font-size: 28px;
            font-weight: 700;
            line-height: 1.2;
            margin-bottom: 30px;
        }

        .features {
            list-style: none;
            padding: 0;
        }

        .features li {
            display: flex;
            align-items: flex-start;
            gap: 15px;
            margin-bottom: 20px;
            font-size: 15px;
            line-height: 1.5;
            opacity: 0.9;
        }

        .features i {
            color: #f1c40f;
            font-size: 18px;
            margin-top: 3px;
            flex-shrink: 0;
        }

        /* Form Panel (Right) */
        .form-panel {
            flex: 0 0 65%;
            padding: 50px 40px;
            overflow-y: auto;
            max-height: 700px;
        }

        .form-header {
            margin-bottom: 30px;
        }

        .form-title {
            font-size: 28px;
            font-weight: 700;
            color: #1e2a3a;
            margin-bottom: 8px;
        }

        .form-subtitle {
            color: #6b7a8f;
            font-size: 16px;
        }

        /* Alert Container – top messages */
        .alert-container {
            margin-bottom: 25px;
        }

        .alert {
            border-radius: 12px;
            border: none;
            padding: 16px 20px;
            display: flex;
            align-items: flex-start;
            gap: 12px;
            animation: slideDown 0.5s ease;
        }

        @keyframes slideDown {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .alert-success {
            background-color: rgba(45, 106, 79, 0.08);
            color: #1b4332;
            border-left: 4px solid var(--forest-green);
        }

        .alert-danger {
            background-color: rgba(220, 53, 69, 0.08);
            color: #721c24;
            border-left: 4px solid #dc3545;
        }

        .validation-summary {
            border-radius: 12px;
            border: none;
            padding: 16px 20px;
            background-color: rgba(220, 53, 69, 0.08);
            color: #721c24;
            border-left: 4px solid #dc3545;
            margin-bottom: 20px;
        }
        .validation-summary ul { margin: 0; padding-left: 20px; }

        /* User Type Selection */
        .user-type-section {
            margin-bottom: 30px;
        }

        .user-type-label {
            display: block;
            font-weight: 600;
            margin-bottom: 15px;
            color: #1e2a3a;
            font-size: 16px;
        }

        .user-type-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 12px;
        }

        .user-type-option {
            background: white;
            border: 2px solid #e2dcd5;
            border-radius: 16px;
            padding: 20px 15px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .user-type-option:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.08);
            border-color: var(--savanna-gold);
        }

        .user-type-option.active {
            border-color: var(--savanna-gold);
            background-color: rgba(230, 126, 34, 0.05);
            box-shadow: 0 8px 20px rgba(230, 126, 34, 0.12);
        }

        .user-type-icon {
            font-size: 28px;
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 15px;
        }

        .guest .user-type-icon {
            background-color: rgba(230, 126, 34, 0.1);
            color: var(--savanna-gold);
        }
        .staff .user-type-icon {
            background-color: rgba(45, 106, 79, 0.1);
            color: var(--forest-green);
        }

        .user-type-name {
            font-weight: 600;
            margin-bottom: 8px;
            font-size: 15px;
        }

        .user-type-desc {
            font-size: 12px;
            color: #6b7a8f;
            line-height: 1.4;
        }

        /* Form Sections */
        .form-section {
            margin-bottom: 30px;
        }

        .form-section-title {
            font-size: 18px;
            font-weight: 600;
            color: #1e2a3a;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #f0ece6;
        }

        .form-row {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
            margin-bottom: 20px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-label {
            display: block;
            font-weight: 600;
            margin-bottom: 8px;
            color: #1e2a3a;
            font-size: 14px;
        }

        .input-group {
            position: relative;
            display: flex;
            align-items: center;
            background: white;
            border: 2px solid #e2dcd5;
            border-radius: 12px;
            overflow: hidden;
            transition: border-color 0.3s ease;
        }

        .input-group:focus-within {
            border-color: var(--savanna-gold);
            box-shadow: 0 0 0 3px rgba(230, 126, 34, 0.1);
        }

        .input-group-text {
            background: #f8f6f2;
            border: none;
            padding: 0 18px;
            color: #6b7a8f;
            font-size: 16px;
            height: 100%;
            display: flex;
            align-items: center;
        }

        .form-control, .form-select {
            border: none;
            padding: 14px 16px;
            font-size: 15px;
            flex: 1;
            outline: none;
            background: transparent;
            color: #1e2a3a;
        }

        .form-select {
            cursor: pointer;
            background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3e%3cpath fill='none' stroke='%23343a40' stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='m2 5 6 6 6-6'/%3e%3c/svg%3e");
            background-repeat: no-repeat;
            background-position: right 16px center;
            background-size: 16px 12px;
            padding-right: 40px;
        }

        .password-toggle {
            position: absolute;
            right: 16px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: #6b7a8f;
            cursor: pointer;
            font-size: 16px;
            padding: 0;
            z-index: 10;
        }

        .password-strength {
            margin-top: 8px;
            height: 6px;
            border-radius: 3px;
            background: #e2dcd5;
            overflow: hidden;
        }

        .password-strength-bar {
            height: 100%;
            width: 0%;
            transition: width 0.3s ease;
        }
        .strength-weak { background-color: #dc3545; }
        .strength-medium { background-color: #ffc107; }
        .strength-strong { background-color: #28a745; }

        /* User-specific fields */
        .user-fields {
            display: none;
            animation: fadeIn 0.4s ease;
        }
        .user-fields.active {
            display: block;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Terms */
        .terms-section {
            margin: 30px 0;
            padding: 20px;
            background: #f8f6f2;
            border-radius: 12px;
        }

        .form-check {
            display: flex;
            align-items: flex-start;
            gap: 12px;
            margin: 0;
        }

        .form-check-input {
            width: 20px;
            height: 20px;
            margin-top: 3px;
            cursor: pointer;
        }

        .form-check-label {
            font-size: 14px;
            line-height: 1.5;
            color: #1e2a3a;
            cursor: pointer;
        }
        .form-check-label a {
            color: var(--savanna-gold);
            text-decoration: none;
            font-weight: 500;
        }
        .form-check-label a:hover { text-decoration: underline; }

        /* Submit Button */
        .btn-register {
            background: linear-gradient(to right, var(--savanna-gold), var(--terracotta));
            color: white;
            border: none;
            border-radius: 50px;
            padding: 16px 32px;
            font-size: 16px;
            font-weight: 600;
            width: 100%;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            box-shadow: 0 8px 24px rgba(230, 126, 34, 0.25);
        }

        .btn-register:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 32px rgba(230, 126, 34, 0.4);
        }
        .btn-register:active { transform: translateY(0); }

        /* Login Link */
        .login-link {
            text-align: center;
            margin-top: 30px;
            color: #6b7a8f;
            font-size: 15px;
        }
        .login-link a {
            color: var(--savanna-gold);
            text-decoration: none;
            font-weight: 600;
        }
        .login-link a:hover { text-decoration: underline; }

        /* Validation Errors */
        .validation-error {
            color: #dc3545;
            font-size: 13px;
            margin-top: 5px;
            display: flex;
            align-items: center;
            gap: 5px;
        }

        /* Responsive */
        @media (max-width: 992px) {
            .register-card {
                flex-direction: column;
                max-width: 700px;
            }
            .brand-panel, .form-panel {
                flex: 0 0 100%;
            }
            .brand-panel { padding: 40px 30px; }
            .form-panel { padding: 40px 30px; max-height: none; }
            .user-type-grid { grid-template-columns: repeat(2, 1fr); }
        }

        @media (max-width: 768px) {
            .form-row { grid-template-columns: 1fr; gap: 15px; }
            .tagline { font-size: 24px; }
            .form-title { font-size: 24px; }
            body { padding: 15px; }
            .user-type-grid { grid-template-columns: 1fr 1fr; }
        }

        @media (max-width: 576px) {
            .user-type-grid { grid-template-columns: 1fr; }
            .brand-panel { padding: 30px 20px; }
            .form-panel { padding: 30px 20px; }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container-wrapper">
            <div class="register-card">
                <!-- Brand Panel (Left) -->
                <div class="brand-panel">
                    <div class="logo">
                        <div class="logo-icon"><i class="fas fa-paw"></i></div>
                        <span class="logo-text">Ranger<span>Quest</span></span>
                    </div>
                    <div class="brand-content">
                        <h1 class="tagline">Start Your Safari Adventure</h1>
                        <ul class="features">
                            <li><i class="fas fa-binoculars"></i><span>Book unforgettable safari tours</span></li>
                            <li><i class="fas fa-campground"></i><span>Luxury lodges and wild camps</span></li>
                            <li><i class="fas fa-elephant"></i><span>Unique wildlife encounters</span></li>
                            <li><i class="fas fa-shield-alt"></i><span>Secure booking and payments</span></li>
                        </ul>
                    </div>
                </div>

                <!-- Form Panel (Right) -->
                <div class="form-panel">
                    <div class="form-header">
                        <h2 class="form-title">Create Your Account</h2>
                        <p class="form-subtitle">Join RangerQuest and explore the wild</p>
                    </div>

                    <!-- Alerts & Messages (Top) -->
                    <div class="alert-container">
                        <asp:Panel ID="pnlSuccess" runat="server" CssClass="alert alert-success" Visible="false" role="alert">
                            <i class="fas fa-check-circle"></i>
                            <asp:Label ID="lblSuccess" runat="server" Text=""></asp:Label>
                        </asp:Panel>
                        <asp:Panel ID="pnlError" runat="server" CssClass="alert alert-danger" Visible="false" role="alert">
                            <i class="fas fa-exclamation-triangle"></i>
                            <asp:Label ID="lblError" runat="server" Text=""></asp:Label>
                        </asp:Panel>
                        <asp:ValidationSummary ID="valSummary" runat="server" 
                            ValidationGroup="Register" 
                            ShowMessageBox="false" 
                            ShowSummary="true" 
                            DisplayMode="BulletList" 
                            CssClass="validation-summary"
                            HeaderText="Please fix the following errors:" />
                    </div>

                    <!-- Role Selection -->
                    <div class="user-type-section">
                        <label class="user-type-label">I am registering as <span style="color: #dc3545;">*</span></label>
                        <div class="user-type-grid">
                            <div class="user-type-option guest active" onclick="selectUserType('guest')">
                                <div class="user-type-icon"><i class="fas fa-user"></i></div>
                                <div class="user-type-name">Guest (Customer)</div>
                                <div class="user-type-desc">Book safaris, lodges, and tours</div>
                                <asp:RadioButton ID="rbGuest" runat="server" GroupName="UserType" CssClass="d-none" Checked="true" value="Guest" />
                            </div>
                            <div class="user-type-option staff" onclick="selectUserType('staff')">
                                <div class="user-type-icon"><i class="fas fa-user-tie"></i></div>
                                <div class="user-type-name">Staff (Employee)</div>
                                <div class="user-type-desc">Manage bookings, guests, and operations</div>
                                <asp:RadioButton ID="rbStaff" runat="server" GroupName="UserType" CssClass="d-none" value="Staff" />
                            </div>
                        </div>
                    </div>

                    <!-- Common Fields -->
                    <div class="form-section">
                        <h3 class="form-section-title">Personal Information</h3>
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">First Name <span style="color: #dc3545;">*</span></label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-user"></i></span>
                                    <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-control" placeholder="John" MaxLength="50"></asp:TextBox>
                                </div>
                                <asp:RequiredFieldValidator ID="rfvFirstName" runat="server" 
                                    ControlToValidate="txtFirstName" 
                                    ErrorMessage="First name is required" 
                                    Display="Dynamic" 
                                    ValidationGroup="Register"
                                    CssClass="validation-error">
                                    <i class="fas fa-exclamation-circle"></i> First name is required
                                </asp:RequiredFieldValidator>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Last Name <span style="color: #dc3545;">*</span></label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-user"></i></span>
                                    <asp:TextBox ID="txtLastName" runat="server" CssClass="form-control" placeholder="Doe" MaxLength="50"></asp:TextBox>
                                </div>
                                <asp:RequiredFieldValidator ID="rfvLastName" runat="server" 
                                    ControlToValidate="txtLastName" 
                                    ErrorMessage="Last name is required" 
                                    Display="Dynamic" 
                                    ValidationGroup="Register"
                                    CssClass="validation-error">
                                    <i class="fas fa-exclamation-circle"></i> Last name is required
                                </asp:RequiredFieldValidator>
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">Email <span style="color: #dc3545;">*</span></label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-envelope"></i></span>
                                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="you@example.com" TextMode="Email" MaxLength="100"></asp:TextBox>
                                </div>
                                <asp:RequiredFieldValidator ID="rfvEmail" runat="server" 
                                    ControlToValidate="txtEmail" 
                                    ErrorMessage="Email is required" 
                                    Display="Dynamic" 
                                    ValidationGroup="Register"
                                    CssClass="validation-error">
                                    <i class="fas fa-exclamation-circle"></i> Email is required
                                </asp:RequiredFieldValidator>
                                <asp:RegularExpressionValidator ID="revEmail" runat="server" 
                                    ControlToValidate="txtEmail" 
                                    ValidationExpression="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$" 
                                    ErrorMessage="Invalid email format" 
                                    Display="Dynamic" 
                                    ValidationGroup="Register"
                                    CssClass="validation-error">
                                    <i class="fas fa-exclamation-circle"></i> Invalid email
                                </asp:RegularExpressionValidator>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Phone <span style="color: #dc3545;">*</span></label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-phone"></i></span>
                                    <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" placeholder="+27 12 345 6789" MaxLength="20"></asp:TextBox>
                                </div>
                                <asp:RequiredFieldValidator ID="rfvPhone" runat="server" 
                                    ControlToValidate="txtPhone" 
                                    ErrorMessage="Phone number is required" 
                                    Display="Dynamic" 
                                    ValidationGroup="Register"
                                    CssClass="validation-error">
                                    <i class="fas fa-exclamation-circle"></i> Phone is required
                                </asp:RequiredFieldValidator>
                            </div>
                        </div>
                    </div>

                    <!-- Guest (Customer) specific fields -->
                    <div id="guestFields" class="user-fields active">
                        <div class="form-section">
                            <h3 class="form-section-title">Guest Details</h3>
                            <div class="form-row">
                                <div class="form-group">
                                    <label class="form-label">National ID <span style="color: #dc3545;">*</span></label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fas fa-id-card"></i></span>
                                        <asp:TextBox ID="txtNationalID" runat="server" CssClass="form-control" placeholder="SA ID or Passport" MaxLength="20"></asp:TextBox>
                                    </div>
                                    <asp:RequiredFieldValidator ID="rfvNationalID" runat="server" 
                                        ControlToValidate="txtNationalID" 
                                        ErrorMessage="National ID is required" 
                                        Display="Dynamic" 
                                        ValidationGroup="Register"
                                        CssClass="validation-error">
                                        <i class="fas fa-exclamation-circle"></i> National ID is required
                                    </asp:RequiredFieldValidator>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Date of Birth</label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fas fa-calendar-alt"></i></span>
                                        <asp:TextBox ID="txtDOB" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="form-group">
                                    <label class="form-label">Gender</label>
                                    <asp:DropDownList ID="ddlGender" runat="server" CssClass="form-select">
                                        <asp:ListItem Value="">Select</asp:ListItem>
                                        <asp:ListItem Value="Male">Male</asp:ListItem>
                                        <asp:ListItem Value="Female">Female</asp:ListItem>
                                        <asp:ListItem Value="Other">Other</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Address</label>
                                    <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control" placeholder="Street address"></asp:TextBox>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="form-group">
                                    <label class="form-label">City</label>
                                    <asp:TextBox ID="txtCity" runat="server" CssClass="form-control" placeholder="Cape Town"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Province</label>
                                    <asp:TextBox ID="txtProvince" runat="server" CssClass="form-control" placeholder="Western Cape"></asp:TextBox>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="form-group">
                                    <label class="form-label">Postal Code</label>
                                    <asp:TextBox ID="txtPostalCode" runat="server" CssClass="form-control" placeholder="8001"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Country</label>
                                    <asp:TextBox ID="txtCountry" runat="server" CssClass="form-control" placeholder="South Africa" ReadOnly="true"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Staff (Employee) specific fields -->
                    <div id="staffFields" class="user-fields">
                        <div class="form-section">
                            <h3 class="form-section-title">Employment Details</h3>
                            <div class="form-row">
                                <div class="form-group">
                                    <label class="form-label">Position</label>
                                    <asp:TextBox ID="txtPosition" runat="server" CssClass="form-control" placeholder="e.g., Safari Guide"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Hire Date</label>
                                    <asp:TextBox ID="txtHireDate" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="form-group">
                                    <label class="form-label">Salary (optional)</label>
                                    <asp:TextBox ID="txtSalary" runat="server" CssClass="form-control" placeholder="0.00"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Account Security -->
                    <div class="form-section">
                        <h3 class="form-section-title">Account Security</h3>
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">Username <span style="color: #dc3545;">*</span></label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-user-circle"></i></span>
                                    <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" placeholder="Choose a username" MaxLength="50"></asp:TextBox>
                                </div>
                                <asp:RequiredFieldValidator ID="rfvUsername" runat="server" 
                                    ControlToValidate="txtUsername" 
                                    ErrorMessage="Username is required" 
                                    Display="Dynamic" 
                                    ValidationGroup="Register"
                                    CssClass="validation-error">
                                    <i class="fas fa-exclamation-circle"></i> Username is required
                                </asp:RequiredFieldValidator>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Password <span style="color: #dc3545;">*</span></label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-lock"></i></span>
                                    <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" placeholder="Min 6 characters" TextMode="Password"></asp:TextBox>
                                    <button type="button" class="password-toggle" onclick="togglePassword('txtPassword', this)">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                </div>
                                <div class="password-strength">
                                    <div class="password-strength-bar" id="passwordStrengthBar"></div>
                                </div>
                                <asp:RequiredFieldValidator ID="rfvPassword" runat="server" 
                                    ControlToValidate="txtPassword" 
                                    ErrorMessage="Password is required" 
                                    Display="Dynamic" 
                                    ValidationGroup="Register"
                                    CssClass="validation-error">
                                    <i class="fas fa-exclamation-circle"></i> Password is required
                                </asp:RequiredFieldValidator>
                                <asp:RegularExpressionValidator ID="revPassword" runat="server" 
                                    ControlToValidate="txtPassword" 
                                    ValidationExpression="^.{6,}$" 
                                    ErrorMessage="Password must be at least 6 characters" 
                                    Display="Dynamic" 
                                    ValidationGroup="Register"
                                    CssClass="validation-error">
                                    <i class="fas fa-exclamation-circle"></i> Min 6 characters
                                </asp:RegularExpressionValidator>
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">Confirm Password <span style="color: #dc3545;">*</span></label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-check"></i></span>
                                    <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-control" placeholder="Re-enter password" TextMode="Password"></asp:TextBox>
                                    <button type="button" class="password-toggle" onclick="togglePassword('txtConfirmPassword', this)">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                </div>
                                <asp:RequiredFieldValidator ID="rfvConfirmPassword" runat="server" 
                                    ControlToValidate="txtConfirmPassword" 
                                    ErrorMessage="Confirm password is required" 
                                    Display="Dynamic" 
                                    ValidationGroup="Register"
                                    CssClass="validation-error">
                                    <i class="fas fa-exclamation-circle"></i> Confirm password
                                </asp:RequiredFieldValidator>
                                <asp:CompareValidator ID="cmpPassword" runat="server" 
                                    ControlToValidate="txtConfirmPassword" 
                                    ControlToCompare="txtPassword" 
                                    Operator="Equal" 
                                    ErrorMessage="Passwords do not match" 
                                    Display="Dynamic" 
                                    ValidationGroup="Register"
                                    CssClass="validation-error">
                                    <i class="fas fa-exclamation-circle"></i> Passwords do not match
                                </asp:CompareValidator>
                            </div>
                        </div>
                    </div>

                    <!-- Terms & Conditions -->
                    <div class="terms-section">
                        <div class="form-check">
                            <asp:CheckBox ID="chkTerms" runat="server" CssClass="form-check-input" />
                            <label class="form-check-label" for="chkTerms">
                                I agree to the <a href="#" onclick="showTerms(); return false;">Terms of Service</a> and <a href="#" onclick="showPrivacy(); return false;">Privacy Policy</a>.
                            </label>
                        </div>
                        <asp:CustomValidator ID="cvTerms" runat="server" 
                            ErrorMessage="You must agree to the terms" 
                            Display="Dynamic" 
                            ValidationGroup="Register"
                            ClientValidationFunction="validateTerms"
                            CssClass="validation-error"
                            OnServerValidate="cvTerms_ServerValidate">
                            <i class="fas fa-exclamation-circle"></i> You must agree to the terms
                        </asp:CustomValidator>
                    </div>

                    <!-- Register Button -->
                    <asp:Button ID="btnRegister" runat="server" Text="Create Account" 
                        CssClass="btn-register" 
                        OnClick="BtnRegister_Click" 
                        ValidationGroup="Register" 
                        CausesValidation="true" />

                    <!-- Login Link -->
                    <div class="login-link">
                        Already have an account? <a href="Login.aspx">Sign In</a>
                    </div>
                </div>
            </div>
        </div>
    </form>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script type="text/javascript">
        // User Type Selection
        function selectUserType(type) {
            // Remove active class from all options
            document.querySelectorAll('.user-type-option').forEach(el => el.classList.remove('active'));
            // Add active to selected
            var option = document.querySelector('.user-type-option.' + type);
            if (option) option.classList.add('active');

            // Update radio button
            if (type === 'guest') {
                document.getElementById('<%= rbGuest.ClientID %>').checked = true;
            } else if (type === 'staff') {
                document.getElementById('<%= rbStaff.ClientID %>').checked = true;
            }

            // Show/hide specific fields
            document.getElementById('guestFields').classList.toggle('active', type === 'guest');
            document.getElementById('staffFields').classList.toggle('active', type === 'staff');
        }

        // Toggle password visibility
        function togglePassword(fieldId, btn) {
            var field = document.getElementById(fieldId);
            var icon = btn.querySelector('i');
            if (field.type === 'password') {
                field.type = 'text';
                icon.classList.replace('fa-eye', 'fa-eye-slash');
            } else {
                field.type = 'password';
                icon.classList.replace('fa-eye-slash', 'fa-eye');
            }
        }

        // Password strength indicator
        document.addEventListener('DOMContentLoaded', function() {
            var pwd = document.getElementById('<%= txtPassword.ClientID %>');
            var bar = document.getElementById('passwordStrengthBar');
            if (pwd) {
                pwd.addEventListener('input', function() {
                    var val = this.value;
                    var strength = 0;
                    if (val.length >= 6) strength += 25;
                    if (/[A-Z]/.test(val)) strength += 25;
                    if (/[0-9]/.test(val)) strength += 25;
                    if (/[^A-Za-z0-9]/.test(val)) strength += 25;
                    bar.style.width = strength + '%';
                    bar.className = 'password-strength-bar';
                    if (strength < 50) bar.classList.add('strength-weak');
                    else if (strength < 75) bar.classList.add('strength-medium');
                    else bar.classList.add('strength-strong');
                });
            }
        });

        // Terms validation
        function validateTerms(source, args) {
            var cb = document.getElementById('<%= chkTerms.ClientID %>');
            args.IsValid = cb && cb.checked;
        }

        // Show Terms
        function showTerms() {
            alert('Terms of Service:\n\n1. You agree to provide accurate information.\n2. Your data will be protected.\n3. You are responsible for account security.\n4. The service is provided "as is".\n\nFor full terms, contact us.');
        }

        function showPrivacy() {
            alert('Privacy Policy:\n\n1. We collect only necessary personal data.\n2. Your information is encrypted and secure.\n3. We do not share your data without consent.\n\nFor full policy, contact us.');
        }
    </script>
</body>
</html>