<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebForm1.aspx.cs" Inherits="WebApplication2.WebForm1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="https://use.fontawesome.com/releases/v5.0.6/css/all.css" rel="stylesheet" />
</head>
    <script type="text/javascript" src="http://code.jquery.com/jquery-latest.js"></script>
   
<body>
    <form id="form1" runat="server">
        <div class="top-bar">
            <img src='Content/facebook-logo.png' height="30",width="30" />
        </div>
        <div class = "content">
                
                    <asp:PlaceHolder ID="PlaceHolder1" runat="server"></asp:PlaceHolder>
                    <div class="load-more-wrapper"><div id="load-more" >Load More</div></div>
                    <asp:HiddenField ID="HiddenField1" runat="server" />
        </div>
    </form>
</body>
     <script>
         function renderMoreComments(data, element_id) {
             feedHtml = "";
             console.log(data);
             data.forEach(function (comment) {
                 feedHtml = feedHtml + "<div class='comment-wrapper'>";
                 feedHtml = feedHtml + "<img class='comment-profile-thumb' src='" + comment["from"]["picture"]["data"]["url"] + "' />";
                 feedHtml = feedHtml + "<div class='comment'>";
                 feedHtml = feedHtml + "<a class='profile-name-comments' href='" + comment["from"]["link"] + "' >" + comment["from"]["name"] + "</a>";
                 feedHtml = feedHtml + "<span class='comment-body'  >" + comment["message"] + "</span>";
                 feedHtml = feedHtml + "</div>";
                 feedHtml = feedHtml + "</div>";
             }
             )
             $("div#" + element_id + " .comment-wrapper").first().before(feedHtml);
         }

         function viewMoreComments(element) {
             var loadMoreUrl = $('#' + element.id + " a").attr('redirecturl');
             if (loadMoreUrl !== '') {
                 console.log(loadMoreUrl);
                 loadMoreUrl = loadMoreUrl.replace(/u00257B/g, '{').replace(/u00257D/g, '}')
                 loadMoreUrl = loadMoreUrl.replace(/u002528/g, '(').replace(/u002529/g, ')')

                $.ajax({
                    dataType: 'jsonp',
                    type: 'GET',
                    url: loadMoreUrl +"&fields=message,from{name,picture,link}",
                    success: function (result) {
                        console.log(result, 'results??????????????????????')
                        if (result['data'].length > 0) {
                            renderMoreComments(result['data'], element.id);
                            //set load more for next data
                            if (result['paging']['next'])
                                $('#' + element.id + ".view-all").attr('redirecturl', result['paging']['next']);
                            else
                                $('#' + element.id +".view-all").remove()
                        }
                    }
                });
             }
         }
         function renderMoreContent(data) {
             console.log('rendermorecontent', data);
             var feedHtml = '';
             data.forEach(function (element) {
                 feedHtml = feedHtml + "<div class= 'feed'>";
                 feedHtml = feedHtml + "<div class = 'feed-card'>";
                 feedHtml = feedHtml + "<div>";
                 feedHtml = feedHtml + "<img class='profile-thumb' src='" + element["from"]["picture"]["data"]["url"] + "' /><div>";
                 feedHtml = feedHtml + "<a class='profile-name' href='" + element["from"]["link"] + "' >" + element["from"]["name"] + "</a>";
                 feedHtml = feedHtml + "<span class = 'created-time'>" + element["created_time"] + "</span>";
                 feedHtml = feedHtml + "</div></div><div class='feed-msg-wrapper'>";
                 if (element["message"] != null) {
                     feedHtml = feedHtml + "<p class='feed-msg'>" + element["message"] + "</p>";
                 }
                 else {
                     feedHtml = feedHtml + "<p class='feed-story'>" + element["story"] + "</p>";
                 }
                 feedHtml = feedHtml + "</div>";

                 feedHtml = feedHtml + "<div class='like-cmnt-wrapper'><i class='fb-icon far fa-thumbs-up'></i><span class='icon-count'>";

                 if (element["likes"] != null) { feedHtml = feedHtml + element["likes"]["data"].length } else { feedHtml = feedHtml + "0"; }
                 feedHtml = feedHtml + "</span><i class='fb-icon far fa-comment'></i><span class='icon-count'>";
                 
                 if (element["comments"]["data"].length > 0) { feedHtml = feedHtml + element["comments"]["summary"]["total_count"] } else { feedHtml = feedHtml + "0"; }

                 feedHtml = feedHtml + "</span></div>";
                 feedHtml = feedHtml + "</div>";
                 //comments wrapper start
                 
                 if (element["comments"]["data"].length > 0) {
                     feedHtml = feedHtml + "<div class='comments-wrapper' id='" + element["id"] + "'>";
                     if (element["comments"]["summary"]["total_count"] > 4) {
                         var viewMoreUrl = element["comments"]["paging"]["next"];
                         var appendId = element["id"];
                         feedHtml = feedHtml + "<a redirectUrl='" + viewMoreUrl + "' onClick='viewMoreComments(this); return false;' id='" + appendId + "' class='view-all'>View more comments</a>";

                     }
                     element["comments"]["data"].forEach(function (comment) {
                         feedHtml = feedHtml + "<div class='comment-wrapper'>";
                         feedHtml = feedHtml + "<img class='comment-profile-thumb' src='" + comment["from"]["picture"]["data"]["url"] + "' />";
                         feedHtml = feedHtml + "<div class='comment'>";
                         feedHtml = feedHtml + "<a class='profile-name-comments' href='" + comment["from"]["link"] + "' >" + comment["from"]["name"] + "</a>";
                         feedHtml = feedHtml + "<span class='comment-body'  >" + comment["message"] + "</span>";
                         feedHtml = feedHtml + "</div>";
                         feedHtml = feedHtml + "</div>";
                     });
                     feedHtml = feedHtml + "</div>";
                    }

                    feedHtml = feedHtml + "</div>";
                    //comments wrapper end
             });
             console.log("html to append", feedHtml);
             $('.feed:last').after(feedHtml)
         }

         $('#load-more').click(function () {
             var loadMoreUrl = document.getElementById('HiddenField1').value;
             loadMoreUrl = loadMoreUrl.replace(/u00257B/g, '{').replace(/u00257D/g, '}')
             loadMoreUrl = loadMoreUrl.replace(/u002528/g, '(').replace(/u002529/g,')')
             console.log(loadMoreUrl);
             $.ajax({
                 dataType: 'jsonp',
                 type: 'GET',
                 url: loadMoreUrl,
                 success: function (result) {
                     console.log(result,'results')
                     if (result['data'].length > 0) {
                         renderMoreContent(result['data']);
                         //set load more for next data
                         $('#<%= HiddenField1.ClientID %>').val(result['paging']['next']);
                     }
                     else {
                         //console.log("no data after this");
                         $('#load-more').remove()
                     }
                 }
             });
         })

    </script>
    <style>
        #load-more {
            cursor: pointer;
            width: 100px;
            text-align: center;
            padding: 5px;
            background-color: #3b579c;
            color: #fff;
            font-size: 12px;
            border-radius: 20px;
            margin: 5px;
            font-family: sans-serif;
            display: inline-block;
        }
        .comments-wrapper {
            background-color: #f2f3f5;
            margin: 0 5px 5px;
            overflow: hidden;
            padding: 8px;
        }
        .comment-wrapper {
            padding-top: 8px;
            margin: 0 12px;
            padding: 4px 0;
            clear: both;
        }
        .comment {
            word-wrap: break-word;
            color: #1d2129;
            background-color: #fff;
            font-size: 13px;
            padding: 8px 10px;
            border-radius: 18px;
            display: block;
            line-height: 16px;
            float: left;
            width: calc(100% - 60px);
        }
        .comment-profile-thumb {
            border-radius:50%;
            height:32px;
            width:32px;
            overflow:hidden;
            margin-right: 8px;
            float: left;
            display: block;
        }
        .load-more-wrapper {
            text-align: center;
        }
        .feed {
            border-radius: 20px;
            overflow: hidden;
             margin-bottom: 10px;
        }
    #form1 {
        width: 60%;
    }
    .top-bar {
        background-color: #3b579c;
        padding:5px;
    }
    .content {
        background-color: #f6f7f9;
        padding:5px;
        height: 300px;
        overflow-y: auto;
        overflow-x: hidden;
    }
    .feed-card {
        margin: 5px;
        margin-bottom: 0;
        padding:12px 12px 0;
        background-color: #ffffff;
        overflow: hidden;   
        clear: both;
    }
    .feed-card>div {
        clear: both
    }
    .profile-thumb {
        border-radius:50%;
        height:40px;
        width:40px;
        overflow:hidden;
        margin-right: 8px;
        float: left;
        display: block;
    }
    .profile-name {
        font-family: sans-serif;
        text-decoration: none;
        color: #365899;
        cursor: pointer;
        font-weight: bold;
        font-size: 14px;
        line-height: 1.38;
        margin-bottom: 2px;
    }
    .profile-name-comments {
        font-family: sans-serif;
        text-decoration: none;
        color: #365899;
        cursor: pointer;
        font-weight: bold;
        font-size: 13px;
        line-height: 16px;
        margin-bottom: 2px;
        margin-right: 8px;
    }
    .comment-body {
        font-family: sans-serif;
        text-decoration: none;
        color: #1d2129;
        font-size: 13px;
        line-height: 16px;
        margin-bottom: 2px;
    }
    .created-time {
        font-family: sans-serif;
        display: block;
        color: #90949c;
        font-size: 12px;
        font-weight: normal;    
    }
    .feed-msg {
        font-family: sans-serif;
        font-size: 24px;
        font-weight: 300;
        letter-spacing: 0;
        line-height: 28px;
        margin: 14px 0 7px 0;
    }
    .feed-story {
        font-family: sans-serif;
        color: #90949c;
        font-weight: normal;
        font-size: 14px;
        line-height: 1.38;
    }
    .feed-msg-wrapper {
       border-bottom: 1px solid #f0f0f0;
    }
    .like-cmnt-wrapper {
        padding: 12px 12px;
    }
    .fb-icon {
        color: #90949c;
        margin-right: 4px;
        font-size: 12px;
    }
    .icon-count {
        font-size: 12px;
        font-weight: bold;
        line-height: 16px;
        font-family: sans-serif;
        color: #90949c;
        margin-right: 16px;
    }
    .view-all {
        color: #365899;
        cursor: pointer;
        text-decoration: none;
        font-family: sans-serif;
        line-height: 1.34;
        font-size: 12px;
        color: #365899;
        cursor: pointer;
        text-decoration: none;
        font-family: sans-serif;
        line-height: 1.34;
        font-size: 12px;
    }
</style>
</html>
