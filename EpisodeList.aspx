<%@ Page Title="" Language="C#" MasterPageFile="~/Master/MasterPage.Master" AutoEventWireup="true" CodeBehind="EpisodeList.aspx.cs" Inherits="EpisodeList" %>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">

<script type="text/javascript">
    require(['jquery', 'domReady', 'Common', 'juicore', 'juigrid', 'juiui'], function ($, domReady, Common, juicore, juigrid, juiui) {
        //전역변수
        var gType = "<%=gType%>";
        var gSid = "<%=gSid%>";
        var gQuality = "<%=gQuality%>";
        var gType2 = "<%=gType2%>";

        // 메세지창 설정
        jui.ready(["ui.notify"], function (notify) {
            notify1 = notify("#btnAddEpisode:first", {
                position: "bottom-left",
                showDuration: 1000,
                hideDuration: 1000,
                tpl: {
                    item: $("#tpl_alarm").html()
                }
            });

            notify2 = notify("#EpisodeList:first", {
                position: "bottom-left",
                showDuration: 1000,
                hideDuration: 1000,
                tpl: {
                    item: $("#tpl_alarm").html()
                }
            });
        });

        //메세지 설정
        function ResultMessage(type, color, mgs) {
            var data = { title: mgs + " 성공 하였습니다.", message: mgs + " 성공 하였습니다.", color: color };
            var data1 = { title: mgs + " 실패 하였습니다.", message: mgs + " 실패 하였습니다.", color: color };

            if (type == 3) notify1.add(data);
            if (type == 4) notify1.add(data1);
            if (type == 5) notify2.add(data);
            if (type == 6) notify2.add(data1);
        }

        // 모달창 설정
        jui.ready(["ui.modal"], function (modal) {
            $("#divAddEpisode").appendTo("body");

            AddEpisode = modal("#divAddEpisode", {
                color: "black"
            });
        });

        // 리스트 설정
        jui.ready(["ui.paging", "grid.xtable"], function (paging, xtable) {
            // 에피소드 쪽 페이징 처리 설정
            paging_2 = paging("#EpisodeListPaging", {
                pageCount: 20,
                event: {
                    page: function (pNo) {
                        paging_2_xtable.page(pNo);
                    }
                },
                tpl: {
                    pages: $("#EpisodeListPages").html()
                }
            });

            // 상단 프로그램 리스트 설정
            xtable_1 = xtable("#xtable_1", {
                fields: [null, "SID", "THUMB", "NAME", "SEASON", "AIR_DATE", "EPISODE", "COMPANY", "SCHEDULE", "STATUS", "GENRE", "COMMENT", "URL", "MONITOR_HD", "MONITOR_FHD", "TYPE"],
                colshow: [0, "NAME", "SEASON", "AIR_DATE", "EPISODE", "COMPANY", "SCHEDULE", "COMMENT", "URL", "THUMB", "MONITOR_HD", "MONITOR_FHD"],
                resize: true,
                sort: true,
                sortLoading: true,
                scrollHeight: 400
                , event: {
                    click: function (row, e) {
                        var col = "";
                        col = e.target.text;
                        //console.log(col);
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
                        }
                    }
                }
                , tpl: {
                    row: $("#tpl_row").html(),
                    none: $("#tpl_none").html()
                }
            });


            // 에피소드 리스트 설정
            paging_2_xtable = xtable("#EpisodeList", {
                fields: [null, "SID", "NAME", "EPISODE", "AIR_DATE", "MONITOR", "DOWNLOAD", "COMPLETE", null,"TYPE"],
                colshow: [0, "NAME", "EPISODE", "AIR_DATE", "MONITOR", "DOWNLOAD", "COMPLETE",8],
                resize: true,
                sort: true,
                sortLoading: true,
                buffer: "page",
                bufferCount: 20,
                scrollHeight: 400
                , event: {
                    sortend: function (data, e) {
                        paging_2.first();
                    }
                    , click: function (row, e) {
                        //console.log(row);
                        //console.log(e);
                        //console.log(e.target.id);
                        var col = "";
                        col = e.target.id;
                        if (col != "undefined" && col != "") {
                            if (col.indexOf("btnComplete") == 0) {
                                EpisodeUpdate("episode_update", row);
                            }
                            else if (col.indexOf("btnAirDate") == 0) {
                                if (e.target.text == "날짜변경") {
                                    SetColumn("episode_edit", row.seq);
                                }
                                else if (e.target.text == "날짜저장") {
                                    SetColumn("episode_edit", row.seq);
                                    EpisodeUpdate("episode_edit", row);
                                }
                            }
                        }
                    }
                }
                , tpl: {
                    row: $("#EpisodeListRow").html(),
                    none: $("#EpisodeListNone").html()
                }
            });
        });


        // (S) -------------------- Button Click Event Function Start --------------------
        // 버튼 이벤트 세팅 
        $("#btnPrvs").click(function () { Prvs(); return false; });
        $("#btnHD").click(function () { Quality(1); return false; });
        $("#btnFHD").click(function () { Quality(2); return false; });
        $("#btnSearchEpisode").click(function () { EpisodeSearch(); return false; });
        $("#btnMonitor").click(function () { EpisodeUpdate("monitor", ""); return false; });
        $("#btnAdd").click(function () { Add(true); return false; });
        $("#btnCancel").click(function () { Add(false); return false; });
        //에피소드 추가
        $("#btnAddEpisode").click(function () {
            $("#txtAddEpisode").val("");
            $("#txtAddAirDate").val("");
            AddEpisode.show();
            return false;
        });

        // 이벤트 세팅
        //버튼 활성화 비활성화
        var ButtonDisplay = function () {
            if (gQuality == "720P") {
                $("#btnHD").hide();
                $("#btnFHD").show();
            }
            else {
                $("#btnHD").show();
                $("#btnFHD").hide();
            }
            $("#spQuality").html(gQuality);
        }

        //화질에 따라서 세팅 및 에피소드 부분 검색
        var Quality = function (Data) {
            //console.log(Data);
            if (Data == 1) {
                gQuality = "720P";
            }
            else {
                gQuality = "1080P";
            }
            ButtonDisplay();
            EpisodeSearch();
        }

        // 이전 버튼 클릭
        var Prvs = function () {
            var $form = $("<form></form>");
            $form.attr("action", "Main.aspx");
            $form.attr('method', 'post');
            $form.appendTo('body');
            var Type = $("<input type='hidden' value='" + gType + "' name='Type'>");
            $form.append(Type);
            $form.submit();
        }


        // 컬럼 눌렀을때 컬렴 변경
        var SetColumn = function (Type, Seq) {
            if (Type == "episode_edit") {
                if ($("#btnAirDate" + Seq).html() == "날짜변경") {
                    $("#txtAirDate" + Seq).attr("readonly", false);
                    $("#txtAirDate" + Seq).focus();
                    $("#btnAirDate" + Seq).html("날짜저장");
                }
                else {
                    $("#txtAirDate" + Seq).attr("readonly", true);
                    $("#btnAirDate" + Seq).html("날짜변경");
                }
            }
            else if (Type == "rename") {
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

        // 검색
        // 조회BTN Click Event
        var Search = function () {
            var params = {};
            params["PROC_TYPE"] = "SQL";
            params["TYPE"] = gType;
            params["SID"] = gSid;
            //console.log(params);;
            Common.Ajax(params, function (pResult) {
                //console.log(pResult);
                var data = $.parseJSON(pResult.RESULT);
                $("#divxtable").show();
                xtable_1.update(data.Table);
                xtable_1.resize();
                EpisodeSearch();
            });
        }
        var EpisodeSearch = function () {
            var params = {};
            params["PROC_TYPE"] = "SQL";

            if (gType == "1" || gType == "2" || gType == "3") {
                params["TYPE"] = 10;
            }
            else if (gType == "4" || gType == "5" || gType == "6") {
                params["TYPE"] = 11;
            }
            else if (gType == "7" || gType == "8" || gType == "9") {
                params["TYPE"] = 1;
            }
            params["SID"] = gSid;
            params["QUALITY"] = gQuality;
            params["EPISODE"] = $("#txtSearchEpisode").val();
            //console.log(params);
            Common.Ajax(params, function (pResult) {
                //console.log(pResult);
                var data = $.parseJSON(pResult.RESULT);
                //console.log(data.Table);
                $("#divEpisodeList").show();
                paging_2_xtable.update(data.Table);
                paging_2_xtable.resize();
                paging_2.reload(paging_2_xtable.count());
                return false;
            }, false);
        };

        // 추가
        // 에피소드 추가
        var Add = function (Data) {
            if (Data) {
                if ($("#txtAddEpisode").val() == "") {
                    alert("에피소드를 입력 하셔야 합니다");
                    return false;
                }
                if ($("#txtAddAirDate").val() == "") {
                    alert("방영일을 입력 하셔야 합니다");
                    return false;
                }
                AddEpisode.hide();
                var params = {};
                params["PROC_TYPE"] = "SOCKET";
                params["REQUEST"] = "episode_add";
                params["TYPE"] = gType2;
                params["SID"] = gSid;
                params["EPISODE"] = "E" + $("#txtAddEpisode").val();
                params["AIR_DATE"] = "20" + $("#txtAddAirDate").val();
                params["NAME"] = $("#txtName1").val();
                //console.log(params);return false;
                Common.Ajax(params, function (pResult) {
                    //console.log(pResult);
                    if (pResult.RESULT != "") {
                        var data = $.parseJSON(pResult.RESULT);
                        if (data.result == "true") {
                            ResultMessage(5, 'success')
                        }
                        else {
                            ResultMessage(6, 'warning')
                        }
                    }
                    EpisodeSearch();
                }, false);
            }
            else {
                AddEpisode.hide();
            }
        };

        // 저장
        // 프로그램 업데이트
        var Update = function (Type, Data) {
            //제목 변경 및 시즌 변경
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
                //console.log(pResult);
                if (pResult.RESULT != "") {
                    var data = $.parseJSON(pResult.RESULT);
                    if (Type == "rename") {
                        if (data.result == "true" && data.sid == gSid && data.name == $("#txtName" + Data.seq).val()) {
                            ResultMessage(3, 'success', "제목변경");
                        }
                        else {
                            ResultMessage(4, 'warning', "제목변경");
                        }
                    }
                    else if (Type == "season") {
                        if (data.result == "true") {
                            ResultMessage(3, 'success', "시즌변경");
                        }
                        else {
                            ResultMessage(4, 'warning', "시즌변경");
                        }
                    }
                }
                else {
                    ResultMessage(4, 'warning', "수정");
                }
                Search();
            }, false);
        }

        // 에피소드 업데이트
        var EpisodeUpdate = function (Type, Data) {
            var params = {};
            params["PROC_TYPE"] = "SOCKET";
            params["REQUEST"] = Type;
            params["TYPE"] = gType2;
            params["SID"] = gSid;
            params["QUALITY"] = gQuality;
            if (Type == "episode_update") {
                params["EPISODE"] = Data.data.EPISODE;
                if (Data.data.COMPLETE == "Y") {
                    params["COMPLETE"] = "N";
                }
                else {
                    params["COMPLETE"] = "Y";
                }
            }
            else if (Type == "episode_edit") {
                params["AIR_DATE"] = $("#txtAirDate" + Data.seq).val();
                params["EPISODE"] = Data.data.EPISODE;
            }
            params["NAME"] = $("#txtName1").val();
            //console.log(params);return false;
            Common.Ajax(params, function (pResult) {
                //console.log(pResult);
                if (pResult.RESULT != "") {
                    var data = $.parseJSON(pResult.RESULT);
                    if (Type == "episode_update") {
                        if (data.result == "true" && data.sid == gSid) {
                            ResultMessage(5, 'success', "상태값 변경");
                        }
                        else {
                            ResultMessage(6, 'warning', "상태값 변경");
                        }
                    }
                    else if (Type == "monitor") {
                        if (data.result == "true" && data.sid == gSid) {
                            ResultMessage(5, 'success', "모니터링 변경");
                        }
                        else {
                            ResultMessage(6, 'warning', "모니터링 변경");
                        }
                    }
                    else if (Type == "episode_edit") {
                        if (data.result == "true") {
                            ResultMessage(5, 'success', "방영일");
                        }
                        else {
                            ResultMessage(6, 'warning', "방영일");
                        }
                    }
                }
                else {
                    ResultMessage(6, 'warning', "수정");
                }
                if (Type == "monitor") {
                    Search();
                }
                else {
                    EpisodeSearch();
                }
            }, false);
        }
        domReady(function () {
            ButtonDisplay();
            Search();
        });
    });
</script>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
<a class="btn large" id="btnPrvs">이전화면</a>
<a class="btn large" id="btnHD" style ="display:none">720P 설정</a>
<a class="btn large" id="btnFHD" style ="display:none">1080P 설정</a>
<br />
<br />

<div id="divxtable" style ="display:none">
    <div id="xtable_1" class="xtable" style="margin-top: 7px;">
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

    <script id="tpl_row" type="text/template">
        <tr>
            <td><!= row.seq !></td>
            <td><!= SID !></td>
            <td>
                <img src="<!= THUMB !>" style="width:100px; height:100px" alt="img" />
            </td>
            <td>
                <span style="float:left;">
                    <input type="text" id="txtName<!= row.seq !>" readonly="readonly" value="<!= NAME !>" class="input mini" />
                </span>
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
            <td colspan="3" class="none" style="text-align: center;">자료가 없습니다.</td>
        </tr>
    </script>
</div>
<br />
<span id="spQuality"></span> 에피소드 설정
<br />
<a class="btn large" id="btnAddEpisode">에피소드 추가</a>
<a class="btn large" id="btnMonitor">모니터링 상태 변경</a>
<br />
<br />
<input type="text" id="txtSearchEpisode" class="input mini" />
<button class="btn small" id="btnSearchEpisode">
     에피소드 검색
</button>


<div id="divEpisodeList" style ="display:none">
    <div id="EpisodeList" class="xtable" style="margin-top: 7px;">
        <table class="table classic small">
            <thead>
            <tr>
                <th style="width:25px">번호</th>
                <th>SID</th>
                <th style="width:300px">제목</th>
                <th style="width:150px">에피소드</th>
                <th style="width:150px">방영일</th>
                <th style="width:100px">모니터링</th>
                <th style="width:100px">다운로드</th>
                <th style="width:100px">다운완료</th>
                <th style="width:100px">상태값변경</th>
                <th>종류</th>
            </tr>
            </thead>
            <tbody></tbody>
        </table>
    </div>
    <div id="EpisodeListPaging" class="paging" style="margin-top: 3px;">
        <a href="#" class="prev">Previous</a>
        <div class="list"></div>
        <a href="#" class="next">Next</a>
    </div>
    <script id="EpisodeListRow" type="text/template">
        <tr>
            <td><!= row.seq !></td>
            <td><!= SID !></td>
            <td><!= NAME !></td>
            <td><!= EPISODE !></td>
            <td>
                <span style="float:left;">
                    <input type="text" id="txtAirDate<!= row.seq !>" readonly="readonly" value="<!= AIR_DATE !>" class="input mini"  />
                </span>
                <span style="float:right;margin-right:5px;"><a class="btn small" id="btnAirDate<!= row.seq !>">날짜변경</a></span>
            </td>
            <td><!= MONITOR !></td>
            <td><!= DOWNLOAD !></td>
            <td><!= COMPLETE !></td>
            <td><a class="btn small" id="btnComplete<!= row.seq !>">변경</a></td>
            <td><!= TYPE !></td>
        </tr>
    </script>

    <script id="EpisodeListNone" type="text/template">
        <tr>
            <td colspan="3" class="none" style="text-align: center;">자료가 없습니다.</td>
        </tr>
    </script>

    <script id="EpisodeListPages" type="text/template">
        <! for(var i = 0; i < pages.length; i++) { !>
        <a href="#" class="page"><!= pages[i] !></a>
        <! } !>
    </script>
</div>﻿


<script id="tpl_alarm" type="text/template">
	<div class="notify <!= color !>">
		<div class="title"><!= title !></div>
		<div class="message"><!= message !></div>
	</div>
</script>

<div id="divAddEpisode" class="msgbox" style="display: none;">
    <div class="head">
        에피소드 추가
    </div>
    <div class="body">
        에피소드 입력(예:01)> : <input type="text" id="txtAddEpisode" class="input mini" />
        <br/>
        방영일 입력(예:190315)> : <input type="text" id="txtAddAirDate" class="input mini" />
        <div style="text-align: center; margin-top: 45px;">
            <a class="btn focus small" id="btnAdd">추가</a>
            <a class="btn small" id="btnCancel">취소</a>
        </div>
    </div>
</div>

</asp:Content>

