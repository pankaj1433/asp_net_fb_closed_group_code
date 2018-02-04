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
    public partial class generateToken : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            
        }

        protected void HiddenField1_ValueChanged(object sender, EventArgs e)
        {
            
        }
        

        protected void Button2_Click(object sender, EventArgs e)
        {

            Response.Write("Changed: " + HiddenField1.Value.ToString());

            string appId = "571998726469405";
            string appSecretKey = "c5adf6b68d1364a5232e0a14be6b5d13";
            //string callbackurl = "//localhost/generateToken";
            string requestUrl = "https://graph.facebook.com/oauth/access_token?";

            requestUrl = requestUrl + "&grant_type=fb_exchange_token";
            requestUrl = requestUrl + "&client_id=" + appId;
            requestUrl = requestUrl + "&client_secret=" + appSecretKey;
            requestUrl = requestUrl + "&fb_exchange_token=" + HiddenField1.Value.ToString();
            

            Response.Write("<br>request url:" + requestUrl + "<br>");
            try
            {
                WebRequest request = WebRequest.Create(requestUrl);

                WebResponse response = request.GetResponse();
                Stream dataStream = response.GetResponseStream();
                StreamReader reader = new StreamReader(dataStream);
                string responseFromServer = reader.ReadToEnd();
                String responseString = HttpUtility.UrlDecode(responseFromServer.Replace("|~*~|", "&").Replace("\\", ""));
                var jsonResponse = JObject.Parse(responseString);

                Response.Write(jsonResponse);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex);
            }
        }
    }
}