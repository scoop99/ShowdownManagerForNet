using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;


public partial class EpisodeList : System.Web.UI.Page
{
    public string gSid = "";
    public string gQuality = "";
    public string gType = "";
    public string gType2 = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (!IsPostBack)
            {
                gSid = Request["sid"];
                gQuality = Request["quality"];
                gType = Request["Type"];
                gType2 = Request["Type2"];
            }
        }
        catch (Exception ex)
        {

            throw;
        }

    }
}
