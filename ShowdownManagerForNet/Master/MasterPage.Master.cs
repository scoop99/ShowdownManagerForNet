using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ShowdownManagerForNet.Master
{
    public partial class MasterPage : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string strUrl = Request.Url.AbsolutePath;

            if (strUrl != "/Login.aspx")
            {
                if (HttpContext.Current.Session["id"] == null)
                {
                    string error = @"
                            <script type='text/javascript'>
                                     window.alert('로그인 정보가 없습니다.');
                                       location.href='Login.aspx';
                            </script>
                        ";
                    Response.Write(error);
                }
                else
                {
                    if (HttpContext.Current.Session["id"].ToString() != "admin")
                    {
                        string error = @"
                            <script type='text/javascript'>
                                     window.alert('로그인 정보가 없습니다.');
                                       location.href='Login.aspx';
                            </script>
                        ";
                        Response.Write(error);
                    }
                }
            }
        }
    }
}
   