<%@ Page Title="" Language="C#" MasterPageFile="~/Master/MasterPage.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Login" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    
<div id="divSearchInfo" class="msgbox">
    <div class="head">
        로그인
    </div>
    <div class="body">
        아이디 : <input type="text" id="txtId" class="input mini search" />
        비밀번호 : <input type="password" id="txtPass" class="input mini search" />
        <div style="text-align: center; margin-top: 25px;">
            <a class="btn focus small" id="btnLogIn">로그인</a>
        </div>
    </div>
</div>
<script id="tpl_alarm" type="text/template">
	<div class="notify <!= color !>">
		<div class="title"><!= title !></div>
		<div class="message"><!= message !></div>
	</div>
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
    <script type="text/javascript">
    require(['jquery', 'domReady', 'Common', 'juicore', 'juigrid', 'juiui'], function ($, domReady, Common, juicore, juigrid, juiui) {
        //전역변수
        $("#txtId").focus();
        // 메세지창 설정
        jui.ready(["ui.notify"], function (notify) {
            notify1 = notify("#divSearchInfo:first", {
                //position: "bottom-left",
                position: "top",
                tpl: {
                    item: $("#tpl_alarm").html()
                }
            });
            notify2 = notify("#divSearchInfo:first", {
                position: "bottom-left",
                //position: "top-left",
                padding: {
                    bottom: -40
                },
                tpl: {
                    item: $("#tpl_alarm").html()
                }
            });
        });
        // 메세지 설정
        function ResultMessage(type, color, mgs) {
            var data = { title: mgs + " ERROR", message: mgs + " 실패 하였습니다.", color: color };
            var data2 = { title: "ERROR", message: mgs + " 입력하세요.", color: color };
            if (type == 1) notify1.add(data);
            if (type == 2) notify2.add(data2);
        }

        // (S) -------------------- Button Click Event Function Start --------------------
        // 버튼 이벤트 세팅 
        $("#btnLogIn").click(function () { LogIn(); return false; });

        // 이벤트 세팅
        //엔터키 
        $(".search").keypress(function (e) {
            //console.log(e);
            if (e.keyCode == 13) {
                LogIn();
            }
        });

        // 검색
        // 조회BTN Click Event
        var LogIn = function () {
            if ($("#txtId").val() == "") {
                ResultMessage(2, "danger", "아이디를");
                return false;
            }
            if ($("#txtPass").val() == "") {
                ResultMessage(2, "danger", "비밀번호를");
                return false;
            }

            var params = {};
            params["PROC_TYPE"] = "LOGIN";
            params["ID"] = $("#txtId").val();
            params["PASS"] = $("#txtPass").val();
            //console.log(params);;
            Common.Ajax(params, function (pResult) {
                //console.log(pResult);
                var data = $.parseJSON(pResult.RESULT);
                if (data.result =="false") {
                    ResultMessage(1, "danger", "로그인");
                }
                else {
                    window.location.replace("Main.aspx");
                }
            });
        }
        domReady(function () {
        });
    });
</script>
</asp:Content>
