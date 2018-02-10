using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Net;
using System.IO;
using Newtonsoft.Json.Linq;
using System.Data.SqlClient;
using System.Data;

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

            //Response.Write("Changed: " + HiddenField1.Value.ToString());

            string appId = "571998726469405";
            string appSecretKey = "c5adf6b68d1364a5232e0a14be6b5d13";
            //string callbackurl = "//localhost/generateToken";
            string requestUrl = "https://graph.facebook.com/oauth/access_token?";

            requestUrl = requestUrl + "&grant_type=fb_exchange_token";
            requestUrl = requestUrl + "&client_id=" + appId;
            requestUrl = requestUrl + "&client_secret=" + appSecretKey;
            requestUrl = requestUrl + "&fb_exchange_token=" + HiddenField1.Value.ToString();

            string token = "";

           // Response.Write("<br>request url:" + requestUrl + "<br>");
            try
            {
                WebRequest request = WebRequest.Create(requestUrl);

                WebResponse response = request.GetResponse();
                Stream dataStream = response.GetResponseStream();
                StreamReader reader = new StreamReader(dataStream);
                string responseFromServer = reader.ReadToEnd();
                String responseString = HttpUtility.UrlDecode(responseFromServer.Replace("|~*~|", "&").Replace("\\", ""));
                var jsonResponse = JObject.Parse(responseString);
                token = jsonResponse["access_token"].ToString();

                
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex);
            }
            //insert  token into database
            try
            {
                if(token != null)
                {
                    Response.Write("TOKEN: " + token);
                    SqlConnection con = new SqlConnection("user id=PANKAJ;" +
                                       "password='';server=localhost;" +
                                       "Trusted_Connection=yes;" +
                                       "database=dbo; " +
                                       "connection timeout=30");
                    SqlCommand com = new SqlCommand();
                    con.Open();
                    com.Connection = con; //Pass the connection object to Command
                    com.CommandType = CommandType.StoredProcedure; // We will use stored procedure.
                    com.CommandText = "spInsertUser"; //Stored Procedure Name


                }
            }
            catch (Exception ex)
            {
                Response.Write(ex);

            }
        }
    }
}