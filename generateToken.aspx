<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="generateToken.aspx.cs" Inherits="WebApplication2.generateToken" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<title>Login from Facebook </title>

<script type="text/javascript" src="http://code.jquery.com/jquery-latest.js"></script>
</head>

<body>

<script>

// Load the SDK Asynchronously

    (function (d) {

        var js, id = 'facebook-jssdk', ref = d.getElementsByTagName('script')[0];

        if (d.getElementById(id)) { return; }

        js = d.createElement('script'); js.id = id; js.async = true;

        js.src = "//connect.facebook.net/en_US/all.js";

        ref.parentNode.insertBefore(js, ref);

    }(document));

// Init the SDK upon load

    window.fbAsyncInit = function () {

        FB.init({

            appId: '571998726469405', // App ID

            channelUrl: '//' + window.location.hostname + '/generateToken', // Path to your Channel File

            status: true, // check login status

            cookie: true, // enable cookies to allow the server to access the session

            xfbml: true  // parse XFBML

        });

// listen for and handle auth.statusChange events

        FB.Event.subscribe('auth.statusChange', function (response) {

            console.log('accessToken: ', response.authResponse.accessToken)
            if (response.authResponse) {

                // user has auth'd your app and is logged into Facebook

                FB.api('/me', function (me) {

                    if (me.name) {

                        document.getElementById('auth-displayname').innerHTML = me.name;
                        $('#<%= HiddenField1.ClientID %>').val(response.authResponse.accessToken);
                        _doPostBack('HiddenField1');
                    }

                })

                document.getElementById('auth-loggedout').style.display = 'none';

                document.getElementById('auth-loggedin').style.display = 'block';

            } else {

                // user has not auth'd your app, or is not logged into Facebook

                document.getElementById('auth-loggedout').style.display = 'block';

                document.getElementById('auth-loggedin').style.display = 'none';

            }

        });

        $("#auth-logoutlink").click(function () { FB.logout(function () { window.location.reload(); }); });

    }

</script>

<h1>

    Login from Facebook</h1>

<div id="auth-status">

<div id="auth-loggedout">

 

<div class="fb-login-button" autologoutlink="true" scope="email">Login with Facebook</div>

</div>

<div id="auth-loggedin" style="display: none">

Hi, <span id="auth-displayname"></span>(<a href="#" id="auth-logoutlink">logout</a>)

</div>

</div>
    <form id="form2" runat="server">
            <asp:HiddenField ID="HiddenField1" runat="server" OnValueChanged="HiddenField1_ValueChanged" Value="token" ClientIDMode="Static" />
            
            <asp:Button ID="Button2" runat="server" OnClick="Button2_Click" Text="Update Token" />
            
    </form>
</body>

</html>

