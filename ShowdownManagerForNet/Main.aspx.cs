using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;


public partial class Main : System.Web.UI.Page
{
    public string gType = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (!IsPostBack)
            {
                gType = Request["Type"];
                if (gType == "" || gType == null)
                {
                    gType = "2";
                }


            }
        }
        catch (Exception ex)
        {

            throw;
        }

    }
}
