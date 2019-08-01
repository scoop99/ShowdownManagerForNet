using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Net.Json;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;


public partial class Ajax_AjaxProc : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        JsonObjectCollection rtnJsonCol = new JsonObjectCollection();
        try
        {
            JsonTextParser parser = new JsonTextParser();
            StringBuilder sb = new StringBuilder();
            JsonObject jo = null;
            JsonObjectCollection joc = new JsonObjectCollection();
            Dictionary<string, string> paramsDic = new Dictionary<string, string>();
            if (Request.ContentLength > 0 && Request.ContentType.Contains("json"))
            {
                using (StreamReader sr = new StreamReader(Request.InputStream))
                {
                    jo = parser.Parse(sr.ReadToEnd());
                    joc = jo as JsonObjectCollection;

                    foreach (var param in joc)
                    {
                        if (param != null)
                        {
                            if (param.GetValue() != null)
                            {
                                paramsDic.Add(param.Name, param.GetValue().ToString());
                            }
                        }
                        else
                        {

                        }
                    }
                }
            }

            //상황에 따라서 DB에 접속할것인지(검색), 소켓통신(추가, 저장, 삭제)을 할것인지 판단 하여 진행
            if (paramsDic.ContainsKey("PROC_TYPE"))
            {
                if (paramsDic["PROC_TYPE"] == "SQL")
                {
                    rtnJsonCol = DbProcess.Select_Adapter(paramsDic);
                }
                else if (paramsDic["PROC_TYPE"] == "SOCKET")
                {
                    rtnJsonCol = DbProcess.Socket_Adapter(paramsDic);
                }
                else if (paramsDic["PROC_TYPE"] == "LOGIN")
                {
                    if (DbProcess.LogIn(paramsDic))
                    {
                        rtnJsonCol.Add(new JsonStringValue("RESULT", "{\"result\":\"true\"}"));
                        Session["id"] = paramsDic["ID"];
                    }
                    else
                    {
                        rtnJsonCol.Add(new JsonStringValue("RESULT", "{\"result\":\"false\"}"));
                        Session["id"] = null;
                    }
                }
                else if (paramsDic["PROC_TYPE"] == "FILE")
                {
                    rtnJsonCol = DbProcess.FileList(paramsDic);
                }
                else if (paramsDic["PROC_TYPE"] == "FILE_READ")
                {
                    rtnJsonCol = DbProcess.FileRead(paramsDic);
                }
                else if (paramsDic["PROC_TYPE"] == "FILE_DELETE")
                {
                    rtnJsonCol = DbProcess.FileDelete(paramsDic);
                }
            }
        }
        catch (Exception ex)
        {
            string strErrorMessage = "";

            strErrorMessage += ex.Message;
            if (ex.InnerException != null)
                strErrorMessage += string.Format("<br/>({0})", ex.InnerException.Message);
            Response.Write(strErrorMessage);
        }
        finally
        {
            if (rtnJsonCol.Count > 0)
            {
                Response.Write(rtnJsonCol.ToString());
            }
            Response.End();
        }
    }
}

