<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="RangerQuestManagementSystem.Login" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>RangerQuest – Login</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <!-- Font Awesome 6 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />

    <style>
        /* ---------- Root Variables (Safari Theme) ---------- */
        :root {
            --savanna-gold: #e67e22;
            --savanna-dark: #d35400;
            --forest-green: #2d6a4f;
            --deep-forest: #1b4332;
            --terracotta: #bc6c25;
            --cream: #fefae0;
            --light-bg: #f9f6f0;
            --card-shadow: rgba(0, 0, 0, 0.15);
            --gradient-start: #2d6a4f;
            --gradient-end: #1b4332;
        }

        /* ---------- Global Reset ---------- */
        html, body {
            height: 100%;
            margin: 0;
            padding: 0;
            background: var(--light-bg);
            font-family: 'Segoe UI', 'Inter', system-ui, sans-serif;
            overflow-x: hidden;
        }

        /* ---------- Container ---------- */
        .login-container {
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 0;
        }

        .login-card {
            background: white;
            border-radius: 0;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.2);
            overflow: hidden;
            border: none;
            height: 100vh;
            width: 100%;
        }

        /* ---------- Brand Section (Left) ---------- */
        .brand-section {
            background: linear-gradient(135deg, var(--gradient-start) 0%, var(--gradient-end) 50%, #0a3d2e 100%);
            color: white;
            padding: 3rem 2.5rem;
            text-align: center;
            position: relative;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            justify-content: center;
            height: 100%;
        }

        .brand-section::before {
            content: '';
            position: absolute;
            inset: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 200 200" fill="rgba(255,255,255,0.04)"><path d="M40,40 Q70,10 100,40 T160,40 T180,100 T160,160 T100,180 T40,160 T20,100 T40,40 Z"/></svg>');
            background-size: 300px 300px;
            pointer-events: none;
        }

        .brand-logo {
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 1.5rem;
            position: relative;
            z-index: 2;
        }

        .logo-icon {
            font-size: 3.2rem;
            margin-right: 15px;
            color: #f1c40f;
            filter: drop-shadow(0 2px 8px rgba(0,0,0,0.3));
        }

        .logo-text {
            font-size: 2.4rem;
            font-weight: 800;
            letter-spacing: -0.5px;
            color: #fff;
            text-shadow: 0 2px 8px rgba(0,0,0,0.2);
        }

        .logo-text span {
            color: #f1c40f;
        }

        .brand-tagline {
            font-size: 1.1rem;
            opacity: 0.9;
            margin-bottom: 2.5rem;
            position: relative;
            z-index: 2;
            font-weight: 300;
        }

        .feature-icons {
            display: flex;
            justify-content: center;
            gap: 1.5rem;
            margin-top: 1rem;
            position: relative;
            z-index: 2;
        }

        .feature-icon {
            background: rgba(255, 255, 255, 0.12);
            border-radius: 50%;
            width: 70px;
            height: 70px;
            display: flex;
            align-items: center;
            justify-content: center;
            backdrop-filter: blur(4px);
            border: 1px solid rgba(255, 255, 255, 0.15);
            transition: all 0.3s ease;
        }

        .feature-icon:hover {
            transform: translateY(-6px) scale(1.05);
            background: rgba(255, 255, 255, 0.2);
        }

        .feature-icon i {
            font-size: 2rem;
            color: #f1c40f;
        }

        .stats {
            margin-top: 2.5rem;
            display: flex;
            justify-content: space-around;
            position: relative;
            z-index: 2;
        }

        .stat-item h4 {
            font-size: 1.6rem;
            font-weight: 700;
            margin-bottom: 0;
            color: #f1c40f;
        }

        .stat-item small {
            font-size: 0.9rem;
            opacity: 0.8;
        }

        /* ---------- Form Section (Right) ---------- */
        .form-section {
            padding: 3rem 2.8rem;
            display: flex;
            flex-direction: column;
            justify-content: center;
            height: 100%;
            background: #fff;
            overflow-y: auto;
        }

        .form-title {
            color: #1e2a3a;
            font-weight: 700;
            margin-bottom: 1.8rem;
            font-size: 2rem;
            position: relative;
        }

        .form-title::after {
            content: '';
            position: absolute;
            bottom: -10px;
            left: 0;
            width: 60px;
            height: 4px;
            background: linear-gradient(to right, var(--savanna-gold), var(--terracotta));
            border-radius: 2px;
        }

        .input-group-text {
            background-color: #f8f6f2;
            border: 2px solid #e2dcd5;
            border-right: none;
            border-radius: 12px 0 0 12px !important;
            color: var(--savanna-gold);
            font-size: 1rem;
        }

        .form-control {
            padding: 0.85rem 1rem;
            border-radius: 0 12px 12px 0;
            border: 2px solid #e2dcd5;
            transition: all 0.3s;
            font-size: 1rem;
            background: #fcfaf7;
        }

        .form-control:focus {
            border-color: var(--savanna-gold);
            box-shadow: 0 0 0 0.25rem rgba(230, 126, 34, 0.2);
            transform: translateY(-2px);
            background: #fff;
        }

        .form-label {
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 0.4rem;
        }

        .form-check-input {
            border-radius: 4px;
            border: 2px solid #cbd5e1;
        }

        .form-check-input:checked {
            background-color: var(--savanna-gold);
            border-color: var(--savanna-gold);
        }

        .btn-login {
            background: linear-gradient(135deg, var(--savanna-gold), var(--terracotta));
            border: none;
            border-radius: 50px;
            padding: 0.9rem 1.5rem;
            font-weight: 700;
            font-size: 1.15rem;
            transition: all 0.3s ease;
            color: white !important;
            box-shadow: 0 8px 24px rgba(230, 126, 34, 0.35);
            width: 100%;
            margin-top: 0.5rem;
            letter-spacing: 0.5px;
        }

        .btn-login:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 32px rgba(230, 126, 34, 0.5);
            background: linear-gradient(135deg, #f39c12, #e67e22);
            color: white !important;
        }

        .btn-login:active {
            transform: scale(0.97);
        }

        .btn-login i {
            margin-right: 10px;
        }

        .register-link, .forgot-link {
            color: var(--savanna-gold);
            font-weight: 600;
            text-decoration: none;
            transition: color 0.2s;
        }

        .register-link:hover, .forgot-link:hover {
            color: var(--savanna-dark);
            text-decoration: underline;
        }

        .alert {
            border-radius: 12px;
            border: none;
            padding: 0.8rem 1.2rem;
            font-size: 0.95rem;
        }

        .alert-success {
            background: rgba(45, 106, 79, 0.08);
            color: #1b4332;
            border-left: 4px solid var(--forest-green);
        }

        .alert-danger {
            background: rgba(220, 53, 69, 0.08);
            color: #721c24;
            border-left: 4px solid #dc3545;
        }

        .login-instructions {
            background: rgba(230, 126, 34, 0.06);
            border-radius: 12px;
            padding: 1rem 1.2rem;
            margin-bottom: 1.8rem;
            border-left: 4px solid var(--savanna-gold);
        }

        .instruction-item {
            display: flex;
            align-items: center;
            margin-bottom: 0.4rem;
            font-size: 0.9rem;
            color: #2c3e50;
        }

        .instruction-item:last-child {
            margin-bottom: 0;
        }

        .instruction-item i {
            color: var(--savanna-gold);
            margin-right: 0.7rem;
            width: 18px;
        }

        /* ---------- Responsive ---------- */
        @media (min-width: 768px) {
            .login-container {
                padding: 1rem;
            }

            .login-card {
                border-radius: 28px;
                height: 92vh;
                max-height: 850px;
                width: 94%;
                max-width: 1200px;
                margin: 0 auto;
            }
        }

        @media (max-width: 767.98px) {
            .login-container {
                height: auto;
                min-height: 100vh;
                padding: 0;
            }

            .login-card {
                height: auto;
                min-height: 100vh;
                border-radius: 0;
            }

            .brand-section {
                min-height: 40vh;
                padding: 2rem 1.5rem;
            }

            .form-section {
                padding: 2rem 1.5rem;
                min-height: 60vh;
            }

            .feature-icon {
                width: 60px;
                height: 60px;
            }

            .feature-icon i {
                font-size: 1.5rem;
            }

            .stats {
                gap: 1rem;
            }

            .stat-item h4 {
                font-size: 1.3rem;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="login-container">
            <div class="container-fluid p-0 h-100">
                <div class="login-card">
                    <div class="row g-0 h-100">
                        <!-- Brand Section (Left) -->
                        <div class="col-md-6">
                            <div class="brand-section">
                                <div class="brand-logo">
                                    <i class="fas fa-paw logo-icon"></i>
                                    <span class="logo-text">Ranger<span>Quest</span></span>
                                </div>
                                <p class="brand-tagline">Where the Wild Meets Luxury</p>

                                <div class="feature-icons">
                                    <div class="feature-icon" title="Safari Tours">
                                        <i class="fas fa-binoculars"></i>
                                    </div>
                                    <div class="feature-icon" title="Luxury Lodges">
                                        <i class="fas fa-campground"></i>
                                    </div>
                                    <div class="feature-icon" title="Wildlife Encounters">
                                        <i class="fas fa-elephant"></i>
                                    </div>
                                </div>

                                <div class="stats">
                                    <div class="stat-item">
                                        <h4>150+</h4>
                                        <small>Adventures</small>
                                    </div>
                                    <div class="stat-item">
                                        <h4>4.9★</h4>
                                        <small>Guest Rating</small>
                                    </div>
                                    <div class="stat-item">
                                        <h4>12K+</h4>
                                        <small>Happy Travelers</small>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Form Section (Right) -->
                        <div class="col-md-6">
                            <div class="form-section">
                                <h2 class="form-title">Welcome Back</h2>

                                <div class="login-instructions">
                                    <div class="instruction-item">
                                        <i class="fas fa-user"></i>
                                        <span><strong>Guests:</strong> Use your Email or National ID</span>
                                    </div>
                                    <div class="instruction-item">
                                        <i class="fas fa-user-tie"></i>
                                        <span><strong>Staff:</strong> Use your Employee Email</span>
                                    </div>
                                </div>

                                <!-- Success Panel -->
                                <asp:Panel ID="pnlSuccess" runat="server" CssClass="alert alert-success mb-3" Visible="false" role="alert">
                                    <i class="fas fa-check-circle me-2"></i>
                                    <asp:Label ID="lblSuccess" runat="server" Text="Account created successfully! Please log in." />
                                </asp:Panel>

                                <!-- Error Panel -->
                                <asp:Panel ID="pnlError" runat="server" CssClass="alert alert-danger mb-3" Visible="false" role="alert">
                                    <i class="fas fa-exclamation-triangle me-2"></i>
                                    <asp:Label ID="lblError" runat="server" Text="" />
                                </asp:Panel>

                                <!-- Username / Email -->
                                <div class="mb-3">
                                    <label for="txtUsername" class="form-label">Username or Email</label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fas fa-user"></i></span>
                                        <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" placeholder="Enter your username or email" />
                                    </div>
                                    <asp:RequiredFieldValidator ID="rfvUsername" runat="server"
                                        ControlToValidate="txtUsername"
                                        ErrorMessage="Username or Email is required"
                                        Display="Dynamic" CssClass="text-danger small mt-1" />
                                </div>

                                <!-- Password -->
                                <div class="mb-3">
                                    <label for="txtPassword" class="form-label">Password</label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fas fa-lock"></i></span>
                                        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" placeholder="Enter your password" />
                                    </div>
                                    <asp:RequiredFieldValidator ID="rfvPassword" runat="server"
                                        ControlToValidate="txtPassword"
                                        ErrorMessage="Password is required"
                                        Display="Dynamic" CssClass="text-danger small mt-1" />
                                </div>

                                <!-- Remember Me & Forgot -->
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <div class="form-check">
                                        <asp:CheckBox ID="chkRememberMe" runat="server" CssClass="form-check-input" />
                                        <label class="form-check-label" for="chkRememberMe">Remember Me</label>
                                    </div>
                                    <a href="ForgotPassword.aspx" class="forgot-link">Forgot Password?</a>
                                </div>

                                <!-- Sign In Button -->
                                <asp:Button ID="btnLogin" runat="server" Text="Sign In" 
                                    CssClass="btn btn-login" 
                                    OnClick="BtnLogin_Click" UseSubmitBehavior="true" />

                                <!-- Register Link -->
                                <div class="text-center mt-3">
                                    <p class="mb-0">Don't have an account? <a href="Register.aspx" class="register-link">Create Account</a></p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>

    <!-- Bootstrap & FontAwesome JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Inject icon into button -->
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            var btn = document.getElementById('<%= btnLogin.ClientID %>');
            if (btn) {
                btn.innerHTML = '<i class="fas fa-sign-in-alt"></i> Sign In';
            }
        });
    </script>
</body>
</html>