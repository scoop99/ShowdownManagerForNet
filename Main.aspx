<%@ Page Title="" Language="C#" MasterPageFile="~/Master/MasterPage.Master" AutoEventWireup="true" CodeBehind="Main.aspx.cs" Inherits="Main" %>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
<script type="text/javascript">
    //require(['jquery', 'domReady', 'Common'], function ($, domReady, Common) {
    require(['jquery', 'domReady', 'Common', 'juicore', 'juigrid', 'juiui'], function ($, domReady, Common, juicore, juigrid, juiui) {
        //전역변수
        var gType = "<%=gType%>";
        var gTempType = "";

        // 메세지창 설정
        jui.ready(["ui.notify"], function (notify) {
            notify3 = notify("#paging_2_xtable:first", {
                position: "bottom-left",
                showDuration: 1000,
                hideDuration: 1000,
                tpl: {
                    item: $("#tpl_alarm").html()
                }
            });
        });
        // 메세지 설정
        function ResultMessage(type, color, mgs) {
            var data = { title: mgs + " 성공 하였습니다.", message: mgs + " 성공 하였습니다.", color: color };
            var data1 = { title: mgs + " 실패 하였습니다.", message: mgs + " 실패 하였습니다.", color: color };

            if (type == 1) notify3.add(data);
            if (type == 2) notify3.add(data1);
        }

        // 모달창 설정
        jui.ready(["ui.modal"], function (modal) {
            $("#divPopAdd").appendTo("body");
            PopAdd = modal("#divPopAdd", {
                color: "black"
            });
        });
       

        // 리스트 설정
        jui.ready(["ui.paging", "grid.xtable"], function (paging, xtable) {
            // 페이징 처리 설정
            paging_2 = paging("#paging_2", {
                pageCount: 5,
                event: {
                    page: function (pNo) {
                        paging_2_xtable.page(pNo);
                    }
                },
                tpl: {
                    pages: $("#tpl_pages").html()
                }
            });

            // 리스트 설정
            paging_2_xtable = xtable("#paging_2_xtable", {
                fields: [null, "SID", "THUMB", "NAME", "SEASON", "AIR_DATE", "EPISODE", "COMPANY", "SCHEDULE", "STATUS", "GENRE", "COMMENT", "URL",  "MONITOR_HD", "MONITOR_FHD","TYPE"],
                colshow: [0,"NAME", "SEASON", "AIR_DATE", "EPISODE", "COMPANY", "SCHEDULE", "COMMENT", "URL", "THUMB", "MONITOR_HD", "MONITOR_FHD"],
                resize: true,
                sort: true,
                sortLoading: true,
                //buffer: "s-page",
                buffer: "page",
                bufferCount: 5,
                scrollHeight: 400,
                event: {
                    sortend: function (data, e) {
                        paging_2.first();
                    }
                    , click: function (row, e) {
                        //console.log(row);
                        //console.log(e);
                        //console.log(e.target.text);
                        var col = "";
                        col = e.target.text;
                        if (col == undefined || col == "") {
                            col = e.target.localName;
                        }
                        if (col != "undefined" && col != "") {
                            if (col == "제목변경") {
                                // 제목 변경을 위하여 클릭한 로우의 제목 텍스트 박스를 활성화 시키고, 제목변경 버튼은 제목 저장으로 변경한다.
                                SetColumn("rename", row.seq);
                            }
                            else if (col == "제목저장") {
                                Update("rename", row);
                                SetColumn("rename", row.seq);
                            }
                            else if (col == "시즌변경") {
                                SetColumn("season", row.seq);
                            }
                            else if (col == "시즌저장") {
                                Update("season", row);
                                SetColumn("season", row.seq);
                            }
                            else if (col == "바로가기") {
                                window.open(row.data.URL, "", "width=1024,height=700");
                            }
                            else if (col == "img") {
                                Page(row)
                            }
                            else if (col == "X") {
                                Delete(row)
                            }
                        }
                    }
                }
                ,tpl: {
                    row: $("#tpl_row").html(),
                    none: $("#tpl_none").html()
                }
            });
        });
        // (S) -------------------- Button Click Event Function Start --------------------
        // 버튼 이벤트 세팅 
        $("#btnSearch").click(function () { Search(); return false; });
        $("#btnAirScheduleDrama").click(function () { SetgType(1); return false; });
        $("#btnAirIngDrama").click(function () { SetgType(2); return false; });
        $("#btnAirEndDrama").click(function () { SetgType(3); return false; });
        $("#btnAirScheduleEnter").click(function () { SetgType(4); return false; });
        $("#btnAirIngEnter").click(function () { SetgType(5); return false; });
        $("#btnAirEndEnter").click(function () { SetgType(6); return false; });
        $("#btnAirScheduleTv").click(function () { SetgType(7); return false; });
        $("#btnAirIngTv").click(function () { SetgType(8); return false; });
        $("#btnAirEndTv").click(function () { SetgType(9); return false; });

        
        $("#btnDelete").click(function () { Delete(1); return false; });
        $("#btnCancel").click(function () { Delete(2); return false; });

        //프로그램 팝업 추가
        $("#btnPopAdd").click(function () {
            $("#txtAddSearch").val("");
            $("#divAddSearch").html("");
            PopAdd.show();
            $("#txtAddSearch").focus();
            return false;
        });
        $("#btnAddSearch").click(function () { AddSearch(); return false; });
        $("#btnAdd").click(function () { Add(true); return false; });
        $("#btnAddCancel").click(function () { Add(false); return false; });
        $("#btnLogList").click(function () {
            var x = window.screen.width - 820; //팝업창의 가로위치
            var y = window.screen.height  - 620; //팝업창의 세로위치 (상단에 띄우려면 0)
            window.open("LogList.aspx", "", "width=800,height=620,left=" + x +",top=50");
            return false;
        });

        // 이벤트 세팅
        // 컬럼 눌렀을때 컬렴 변경
        var SetColumn = function (Type, Seq) {
            if (Type == "rename") {
                if ($("#btnName" + Seq).html() == "제목변경") {
                    $("#txtName" + Seq).attr("readonly", false);
                    $("#txtName" + Seq).focus();
                    $("#btnName" + Seq).html("제목저장");
                }
                else {
                    $("#txtName" + Seq).attr("readonly", true);
                    $("#btnName" + Seq).html("제목변경");
                }
            }
            else if (Type == "season") {
                if ($("#btnSeason" + Seq).html() == "시즌변경") {
                    $("#txtSeason" + Seq).attr("readonly", false);
                    $("#txtSeason" + Seq).focus();
                    $("#btnSeason" + Seq).html("시즌저장");
                }
                else {
                    $("#txtSeason" + Seq).attr("readonly", true);
                    $("#btnSeason" + Seq).html("시즌변경");
                }
            }
        }

        // 페이지 이동
        var Page = function (Data) {
            var $form = $("<form></form>");
            $form.attr("action", "EpisodeList.aspx");
            $form.attr('method', 'post');
            $form.appendTo('body');
            var Type = $("<input type='hidden' value='" + gType + "' name='Type'>");
            var Sid = $("<input type='hidden' value='" + Data.data.SID + "' name='Sid'>");
            var Quality = "";
            if (Data.data.MONITOR_FHD == "Y") {
                Quality = $("<input type='hidden' value='1080P' name='Quality'>");
            }
            else {
                Quality = $("<input type='hidden' value='720P' name='Quality'>");
            }
            var Type2 = $("<input type='hidden' value='" + Data.data.TYPE + "' name='Type2'>");
            $form.append(Type).append(Sid).append(Quality).append(Type2);
            $form.submit();
        };

        // type 설정후 검색
        var SetgType = function (Type) {
            gType = Type;
            $("#txtSearchName").val("");
            Search();
        }
        $(".addSearch").keypress(function (e) {
            //console.log(e);
            if (e.keyCode == 13) {
                AddSearch();
            }
        });

        //이미지에 마우스 오버시 이미지 새창에 이미지 크게 보기
        $('.img').mouseenter(function () {
            console.log(this);
        });
        $('.img').mouseleave(function () {
            console.log(this);
        });

        // 조회
        var Search = function () {
            var params = {};
            params["PROC_TYPE"] = "SQL";
            params["TYPE"] = gType;
            params["NAME"] = $("#txtSearchName").val();
            Common.Ajax(params, function (pResult) {
                //console.log(pResult);
                if (pResult.RESULT != "") {
                    var data = $.parseJSON(pResult.RESULT);
                    $("#divxtable").show();
                    //var result = [];
                    //for (var ii = 0; ii < 1000; ii++) {
                    //    for (var i = 0; i < data.Table.length; i++) {
                    //        result.push({
                    //            SID: data.Table[i].SID, NAME: data.Table[i].NAME, SEASON: data.Table[i].SEASON, AIR_DATE: data.Table[i].AIR_DATE, EPISODE: data.Table[i].EPISODE, COMPANY: data.Table[i].COMPANY
                    //            , SCHEDULE: data.Table[i].SCHEDULE, STATUS: data.Table[i].STATUS, GENRE: data.Table[i].GENRE, COMMENT: data.Table[i].COMMENT, URL: data.Table[i].URL
                    //            , THUMB: "<img src=" + data.Table[i].THUMB + " width='100px' height='100px' />", MONITOR_HD: data.Table[i].MONITOR_HD, MONITOR_FHD: data.Table[i].MONITOR_FHD
                    //        });
                    //    }
                    //}
                    //paging_2_xtable.update(result);
                    paging_2_xtable.update(data.Table);
                    paging_2_xtable.resize();
                    paging_2.reload(paging_2_xtable.count());
                    return false;
                }
            });
        }

        // 프로그램 검색
        var AddSearch = function () {
            if ($("#txtAddSearch").val() == "") {
                alert("제목을 입력하세여 합니다.");
                return false;
            }
            var params = {};
            params["PROC_TYPE"] = "SOCKET";
            params["REQUEST"] = "search";
            params["TYPE"] = $("#ddlAddType").val();
            params["KEYWORD"] = $("#txtAddSearch").val();
            Common.Ajax(params, function (pResult) {
                //console.log(pResult);
                if (pResult.RESULT != "") {
                    var data = $.parseJSON(pResult.RESULT);
                    if (data.result == "true") {
                        $("#divAddSearch").html("제목 : " + data.name
                            + "<br>종류 : " + data.genre
                            + "<br>방영일 : " + data.schedule
                            + "<br>소개 : " + data.comment
                            + "<br>포스트<br><img src=" + data.thumb + " style='width:200px; height:200px' alt='img' /> "
                        );
                        // 검색 완료후 추가된 타입 저장
                        if ($("#ddlAddType").val() == "DRAMA") {
                            if (data.status == "1") {
                                gTempType = 1;
                            }
                            else if (data.status == "2") {
                                gTempType = 2;
                            }
                            else if (data.status == "3") {
                                gTempType = 3;
                            }
                        }
                        else if ($("#ddlAddType").val() == "ENTER") {
                            if (data.status == "1") {
                                gTempType = 4;
                            }
                            else if (data.status == "2") {
                                gTempType = 5;
                            }
                            else if (data.status == "3") {
                                gTempType = 6;
                            }
                        }
                        else if ($("#ddlAddType").val() == "TV") {
                            if (data.status == "1") {
                                gTempType = 7;
                            }
                            else if (data.status == "2") {
                                gTempType = 8;
                            }
                            else if (data.status == "3") {
                                gTempType = 9;
                            }
                        }
                    }
                    else {
                        alert("검색된 결과가 없습니다.");
                    }
                }
            }, false);
        };

        // 추가
        // 프로그램 추가
        var Add = function (data) {
            if (data) {
                if ($("#divAddSearch").html() == "") {
                    alert("검색된 결과가 없습니다.");
                    return false;
                }
                var params = {};
                params["PROC_TYPE"] = "SOCKET";
                params["REQUEST"] = "add";
                params["TYPE"] = $("#ddlAddType").val();
                params["KEYWORD"] = $("#txtAddSearch").val();
                //console.log(params);return false;
                Common.Ajax(params, function (pResult) {
                    //console.log(pResult); add_name
                    if (pResult.RESULT != "") {
                        var data = $.parseJSON(pResult.RESULT);
                        if (data.result == "true") {
                            ResultMessage(1, 'success', "추가");
                            gType = gTempType;
                            $("#txtSearchName").val(data.add_name);
                            PopAdd.hide();
                        }
                        else {
                            ResultMessage(2, 'warning', "추가");
                        }
                    }
                    else {
                        ResultMessage(2, 'warning', "추가");
                    }
                    Search();
                }, false);
            }
            else {
                PopAdd.hide();
            }

        };
        // 저장
        // 프로그램 업데이트
        var Update = function (Type, Data) {
            var params = {};
            params["PROC_TYPE"] = "SOCKET";
            params["REQUEST"] = Type;
            params["TYPE"] = Data.data.TYPE;
            params["SID"] = Data.data.SID;
            if (Type == "season") {
                params["NEW_SEASON"] = $("#txtSeason" + Data.seq).val();
            }
            else if (Type == "rename") {
                params["NEW_NAME"] = $("#txtName" + Data.seq).val();
            }
            params["NAME"] = $("#txtName" + Data.seq).val();
            //console.log(params);return false;
            Common.Ajax(params, function (pResult) {
                if (pResult.RESULT != "") {
                    var data = $.parseJSON(pResult.RESULT);
                    //console.log(data);
                    if (Type == "rename") {
                        if (data.result == "true" && data.sid == Data.data.SID && data.name == $("#txtName" + Data.seq).val()) {
                            ResultMessage(1, 'success', "제목변경");
                        }
                        else {
                            ResultMessage(2, 'warning', "제목변경");
                        }
                    }
                    else if (Type == "season") {
                        if (data.result == "true") {
                            ResultMessage(1, 'success', "시즌변경");
                        }
                        else {
                            ResultMessage(2, 'warning', "시즌변경");
                        }
                    }
                }
                else {
                    ResultMessage(2, 'warning', "수정");
                }
                Search();
            }, false);
        }

        //삭제
        var Delete = function (Data) {
            var deleteResult = confirm("삭제하시겠습니까?");
            if (deleteResult) {
                var params = {};
                params["PROC_TYPE"] = "SOCKET";
                params["REQUEST"] = "delete";
                params["TYPE"] = Data.data.TYPE;
                params["SID"] = Data.data.SID;
                params["NAME"] = $("#txtName" + Data.seq).val();
                //console.log(params);return false;
                Common.Ajax(params, function (pResult) {
                    if (pResult.RESULT != "") {
                        var data = $.parseJSON(pResult.RESULT);
                        //console.log(data);
                        if (data.result == "true" && data.sid == Data.data.SID) {
                            ResultMessage(1, 'success', "삭제");
                            $("#txtSearchName").val("");
                            Search();
                        }
                        else {
                            ResultMessage(2, 'warning', "삭제");
                        }
                    }
                    else {
                        ResultMessage(2, 'warning', "삭제");
                    }
                }, false);
            }
        }
        domReady(function () {
            Search();
        });
    });
</script>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
<a class="btn large" id="btnAirScheduleDrama">방영예정 드라마</a>
<a class="btn large" id="btnAirIngDrama">방영중 드라마</a>
<a class="btn large" id="btnAirEndDrama">종영 드라마</a>
<a class="btn large" id="btnAirScheduleEnter">방영예정 예능</a>
<a class="btn large" id="btnAirIngEnter">방영중 예능</a>
<a class="btn large" id="btnAirEndEnter">종영 예능</a>
<a class="btn large" id="btnAirScheduleTv">방영예정 TV</a>
<a class="btn large" id="btnAirIngTv">방영중 TV</a>
<a class="btn large" id="btnAirEndTv">종영 TV</a>
<a class="btn large" id="btnLogList">로그파일 확인</a>
<br />
<br />
<a class="btn large" id="btnPopAdd">프로그램 추가</a>
<br />
<br />
<input type="text" id="txtSearchName" class="input mini" />
<button class="btn small" id="btnSearch">
     제목 검색
</button>

<div id="divxtable" style ="display:none">
    <div id="paging_2_xtable" class="xtable" style="margin-top: 7px;">
        <table class="table classic small">
            <thead>
            <tr>
                <th style="width:25px">번호</th>
                <th>SID</th>
                <th style="width:100px">포스트</th>
                <th style="width:300px">제목</th>
                <th style="width:150px">시즌</th>
                <th style="width:100px">최초방영일</th>
                <th style="width:80px">에피소드</th>
                <th style="width:80px">방송사</th>
                <th style="width:150px">방영일</th>
                <th>상태값</th>
                <th>종류</th>
                <th>소개</th>
                <th style="width:80px">에피소드<br />링크</th>
                <th style="width:80px">모니터링<br />상태(HD)</th>
                <th style="width:80px">모니터링<br />상태(FHD)</th>
                <th>종류</th>
            </tr>
            </thead>
            <tbody></tbody>
        </table>
    </div>
    <div id="paging_2" class="paging" style="margin-top: 3px;">
        <a href="#" class="prev">Previous</a>
        <div class="list"></div>
        <a href="#" class="next">Next</a>
    </div>

    <script id="tpl_row" type="text/template">
        <tr>
            <td><!= row.seq !></td>
            <td><!= SID !></td>
            <td>
                <img src="<!= THUMB !>" style="width:100px; height:100px;cursor:pointer" alt="img" class="img"/>
            </td>
            <td>
                <span style="float:left;">
                    <input type="text" id="txtName<!= row.seq !>" readonly="readonly" value="<!= NAME !>" class="input mini" />
                </span>
                <span style="float:right;margin-right:5px;"><a class="btn small" id="btnDelete<!= row.seq !>">X</a></span>
                <span style="float:right;margin-right:5px;"><a class="btn small" id="btnName<!= row.seq !>">제목변경</a></span>
            </td>
            <td>
                <span style="float:left;">
                    <input type="text" id="txtSeason<!= row.seq !>" readonly="readonly" value="<!= SEASON !>" style="width:50px" class="input mini"/>
                </span>
                <span style="float:right;margin-right:5px;"><a class="btn small" id="btnSeason<!= row.seq !>" >시즌변경</a></span>
            </td>
            <td><!= AIR_DATE !></td>
            <td><!= EPISODE !></td>
            <td><!= COMPANY !></td>
            <td><!= SCHEDULE !></td>
            <td><!= STATUS !></td>
            <td><!= GENRE !></td>
            <td><!= COMMENT !></td>
            <td>
                <a class="btn small" id="btnUrl<!= row.seq !>" >바로가기</a>
            </td>
            <td><!= MONITOR_HD !></td>
            <td><!= MONITOR_FHD !></td>
            <td><!= TYPE !></td>
        </tr>
    </script>

    <script id="tpl_none" type="text/template">
        <tr>
            <td colspan="3" class="none" style="text-align: center;">데이터가 없습니다.</td>
        </tr>
    </script>

    <script id="tpl_pages" type="text/template">
        <! for(var i = 0; i < pages.length; i++) { !>
        <a href="#" class="page"><!= pages[i] !></a>
        <! } !>
    </script>
</div>

<script id="tpl_alarm" type="text/template">
	<div class="notify <!= color !>">
		<div class="title"><!= title !></div>
		<div class="message"><!= message !></div>
	</div>
</script>

<div id="divPopAdd" class="msgbox" style="display: none;">
    <div class="head">
        프로그램 추가
    </div>
    <div class="body">
        타입 : <select id="ddlAddType">
                    <option value="DRAMA">드라마</option>
                    <option value="ENTER">예능</option>
                    <option value="TV">TV</option>
             </select>
        <br/>
        제목 : <input type="text" id="txtAddSearch" class="input mini addSearch" /> 
        <a class="btn focus small" id="btnAddSearch">검색</a>
        <div id="divAddSearch" style="white-space: normal; width:300px"></div>
        <div style="text-align: center; margin-top: 25px;">
            <a class="btn focus small" id="btnAdd">추가</a>
            <a class="btn small" id="btnAddCancel">취소</a>
        </div>
    </div>
</div>
</asp:Content>

