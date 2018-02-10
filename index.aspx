<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="index.aspx.cs" Inherits="WebApplication2.WebForm2" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>WFHA</title>
    <link href="https://use.fontawesome.com/releases/v5.0.6/css/all.css" rel="stylesheet" />
    <link rel="stylesheet" href="fb.css" />
    <script type="text/javascript" src="http://code.jquery.com/jquery-latest.js"></script>
</head>
<body>
    <form id="form1" runat="server">
        <div class="top-bar">
            <img src='Content/facebook-logo.png' height="30",width="30" />
        </div>
        <div class = "content">
            <asp:HiddenField ID="HiddenField1" runat="server" />
            <input type="hidden" id="loadmorehidden" value="" />
            <img class="initital-loader" src="Content/spinner.gif" />
            <div class="load-more-wrapper">
                <img class="spinner" src ="Content/spinner.gif" />
                <div id="load-more" >Load More</div>
            </div>
        </div>
    </form>
</body>
    <script type="text/javascript" src="fb-group.js" ></script>
</html>
