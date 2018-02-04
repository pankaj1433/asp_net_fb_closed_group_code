using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Net;
using System.IO;
using Newtonsoft.Json.Linq;

namespace WebApplication2
{
    public partial class WebForm1 : System.Web.UI.Page
    {

        protected void Page_Load(object sender, EventArgs e)
        {
            string token = "EAAIIOtTnNx0BAHnZB8u61kL3ZBQcPe4v8fbKWHQCVgBX5ofHkt2l5xv8C5PZBZAsARG2qDYzyimuf7BrqICOZCxMGBEb6a2npdUPEZCdOgXr7JTDyIbAlvs1a0ZAuoetxHXnyjMP8BYD7nEQLY69Vm6bApqkPLtyCYZD";
            string group_id = "143498529659602";
            try
            {
                WebRequest request = WebRequest.Create("https://graph.facebook.com/v2.12/"+group_id+"/feed?limit=2&access_token="+token+ "&fields=created_time,story,from{name,picture,link},id,permalink_url,message,comments.summary(1).order(reverse_chronological).limit(4){message,from{name,picture,link}},likes{total_count},picture,attachments");
                
                WebResponse response = request.GetResponse();
                Stream dataStream = response.GetResponseStream();
                StreamReader reader = new StreamReader(dataStream);
                string responseFromServer = reader.ReadToEnd();
                String responseString = HttpUtility.UrlDecode(responseFromServer.Replace("|~*~|", "&").Replace("\\", ""));
                var jsonResponse = JObject.Parse(responseString);

                //Response.Write(jsonResponse["data"]);



                LiteralControl feed = new LiteralControl("");
                string feedHtml = "";
                foreach (var element in jsonResponse["data"])
                {
                    //Response.Write(element["created_time"].ToString());
                    //String timestamp = DateTime.Parse("2018-01-22T16:44:56 0000");
                    //Response.Write(timestamp);
                    feedHtml = feedHtml + "<div class= 'feed'>";
                    feedHtml = feedHtml+"<div class = 'feed-card'>";
                    feedHtml = feedHtml + "<div>";
                    feedHtml = feedHtml + "<img class='profile-thumb' src='" + element["from"]["picture"]["data"]["url"] + "' /><div>";
                    feedHtml = feedHtml + "<a class='profile-name' href='" + element["from"]["link"] + "' >" + element["from"]["name"] + "</a>";
                    feedHtml = feedHtml + "<span class = 'created-time'>" + element["created_time"] + "</span>";
                    feedHtml = feedHtml + "</div></div><div class='feed-msg-wrapper'>";
                    if (element["message"] != null)
                    {
                        feedHtml = feedHtml + "<p class='feed-msg'>" + element["message"]+ "</p>";
                    }
                    else
                    {
                        feedHtml = feedHtml + "<p class='feed-story'>" + element["story"]+ "</p>";
                    }
                    feedHtml = feedHtml + "</div>";

                    feedHtml = feedHtml + "<div class='like-cmnt-wrapper'><i class='fb-icon far fa-thumbs-up'></i><span class='icon-count'>";

                    if (element["likes"] != null) {feedHtml = feedHtml + element["likes"]["data"].Count(); } else { feedHtml = feedHtml + "0"; }
                    feedHtml = feedHtml + "</span><i class='fb-icon far fa-comment'></i><span class='icon-count'>";

                    if (element["comments"] != null) { feedHtml = feedHtml + element["comments"]["summary"]["total_count"]; } else { feedHtml = feedHtml + "0"; }

                    feedHtml = feedHtml+ "</span></div>";

                    feedHtml = feedHtml + "</div>";
                    //comments wrapper start
                    
                    if (element["comments"] != null)
                    {
                        feedHtml = feedHtml + "<div class='comments-wrapper' id='" + element["id"].ToString() + "'>";
                        if (Int32.Parse(element["comments"]["summary"]["total_count"].ToString()) > 4)
                        {
                            string viewMoreUrl = element["comments"]["paging"]["next"].ToString();
                            string appendId = element["id"].ToString();
                            feedHtml = feedHtml + "<a redirectUrl='"+ viewMoreUrl + "' onClick='viewMoreComments(this); return false;' id='" + appendId+"' class='view-all'>View more comments</a>";
                     
                        }
                        foreach (var comment in element["comments"]["data"])
                        {
                            feedHtml = feedHtml + "<div class='comment-wrapper' >";
                                feedHtml = feedHtml + "<img class='comment-profile-thumb' src='" + comment["from"]["picture"]["data"]["url"] + "' />";
                                feedHtml = feedHtml + "<div class='comment'>";
                                    feedHtml = feedHtml + "<a class='profile-name-comments' href='" + comment["from"]["link"] + "' >" + comment["from"]["name"] + "</a>";
                                    feedHtml = feedHtml + "<span class='comment-body'  >" + comment["message"] + "</span>";
                            feedHtml = feedHtml + "</div>";
                            feedHtml = feedHtml + "</div>";
                        }
                        feedHtml = feedHtml + "</div>";
                    }
                    feedHtml = feedHtml + "</div>";

                    //comments wrapper end
                }
                feed.Text = feedHtml;
                PlaceHolder1.Controls.Add(feed);
                HiddenField1.Value = jsonResponse["paging"]["next"].ToString();
            }
            catch (Exception ex)
            {
                Response.Write(ex);
            }
        }
    }
}