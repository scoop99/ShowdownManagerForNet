<%@ Page Title="" Language="C#" MasterPageFile="~/Master/MasterPage.Master" AutoEventWireup="true" CodeBehind="LogList.aspx.cs" Inherits="LogList" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
<div id="divxtable" style ="display:none">
    <div id="paging_2_xtable" class="xtable" style="margin-top: 7px;">
        <table class="table classic small">
            <thead>
            <tr>
                <th style="width:25px">번호</th>
                <th>파일명</th>
                <th style="width:100px">크기</th>
                <th style="width:50px">삭제</th>
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
            <td><!= FILE_NAME !></td>
            <td><!= FILE_SIZE !></td>
            <td><a class="btn small" id="btnDelete<!= row.seq !>">삭제</a></td>
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
<br />
검색옵션 : 
<select id="ddlType">
    <option value="">전체</option>
    <option value="1">다운로드완료</option>
    <option value="2">방영일 지남</option>
</select>

<div id="detail_list" class="xtable" style="margin-top: 7px;">
    <table class="table simple headline">
        <thead>
        <tr>
            <th style="width:30px">번호</th>
            <th style="width:150px">날짜</th>
            <th>내용</th>
            <th style="width:100px">종류</th>
        </tr>
        </thead>
        <tbody></tbody>
    </table>
</div>

<script id="detail_list_row" type="text/template">
    <tr>
        <td><!= row.seq !></td>
        <td><!= DATE !></td>
        <td><!= CONTENT !></td>
        <td><!= TYPE !></td>
    </tr>
</script>


<script id="tpl_loading" type="text/template">
    <div class="loading"></div>
</script>


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
        var gFileName = "";
        // 메세지창 설정
        jui.ready(["ui.notify"], function (notify) {
            notify1 = notify("#paging_2_xtable:first", {
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
            var data = { title: "ERROR", message: mgs + " 실패 하였습니다.", color: color };
            var data1 = { title: "SUCCESS", message: mgs, color: color };
            if (type == 1) notify1.add(data);
            if (type == 2) notify1.add(data1);
        }

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
                fields: [null, "FILE_NAME", "FILE_SIZE",null],
                resize: true,
                sort: true,
                sortLoading: true,
                //buffer: "s-page",
                buffer: "page",
                bufferCount: 5,
                scrollHeight: 300,
                event: {
                    sortend: function (data, e) {
                        paging_2.first();
                    }
                    , click: function (row, e) {
                        //console.log(row);
                        //console.log(e);
                        //console.log(e.target.textContent);
                        var col = "";
                        col = e.target.textContent;
                        if (col != "undefined" && col != "") {
                            if (col.indexOf("ShowDown.log") == 0) {
                                LogRead(row.data.FILE_NAME); //data.FILE_NAME
                            }
                            else if (col == "삭제") {
                                Delete(row.data.FILE_NAME);
                            }
                        }
                    }
                }
                , tpl: {
                    row: $("#tpl_row").html(),
                    none: $("#tpl_none").html()
                }
            });
        });

        jui.ready(["grid.xtable"], function (xtable) {
            detail_list = xtable("#detail_list", {
                fields: [null, "DATE", "CONTENT", "TYPE"],
                sort: [1, 2, 3],
                sortLoading: true,
                resize: true,
                buffer: "s-page",
                bufferCount: 100,
                scrollHeight: 300,
                event: {
                    colmenu: function (column, e) {
                        this.showColumnMenu(e.pageX - 25);
                    }
                },
                tpl: {
                    row: $("#detail_list_row").html(),
                    none: $("#tpl_none").html(),
                    loading: $("#tpl_loading").html()
                }
            });
        });

        // (S) -------------------- Button Click Event Function Start --------------------
        // 버튼 이벤트 세팅 
        $("#btnLogIn").click(function () { LogIn(); return false; });

        // 이벤트 세팅
        //엔터키 
        // 검색 옵션
        $("#ddlType").change(function () {
            LogRead(gFileName);
        });

        // 검색
        // 조회BTN Click Event
        var Search = function () {
            var params = {};
            params["PROC_TYPE"] = "FILE";
            Common.Ajax(params, function (pResult) {
                //console.log(pResult);
                //return false;
                if (pResult.RESULT != "") {
                    var data = $.parseJSON(pResult.RESULT);
                    $("#divxtable").show();
                    paging_2_xtable.update(data.Table);
                    paging_2_xtable.resize();
                    paging_2.reload(paging_2_xtable.count());
                    return false;
                }
                else
                {
                    if (pResult.ERROR != "") {
                        ResultMessage(1, "danger", pResult.ERROR)
                    }
                    return false;
                }
            });
        }

        // 해당 로그 읽기
        var LogRead = function (Data) {
            if (Data == "") {
                ResultMessage(1, "danger", "선택된 파일이 없습니다.")
                return false;
            }
            
            var params = {};
            params["PROC_TYPE"] = "FILE_READ";
            params["FILE_NAME"] = Data;
            params["TYPE"] = $("#ddlType").val();
            Common.Ajax(params, function (pResult) {
                if (pResult.RESULT != "") {
                    var data = $.parseJSON(pResult.RESULT);
                    detail_list.update(data.Table);
                    detail_list.resize();
                    gFileName = Data;
                    return false;
                }
                else {
                    if (pResult.ERROR != "") {
                        ResultMessage(1, "danger", pResult.ERROR)
                    }
                    return false;
                }
            });

        }

        // 삭제
        var Delete = function (Data) {
            var deleteResult = confirm("삭제하시겠습니까?");
            if (deleteResult) {
                var params = {};
                params["PROC_TYPE"] = "FILE_DELETE";
                params["FILE_NAME"] = Data;
                //console.log(params);return false;
                Common.Ajax(params, function (pResult) {
                    if (pResult.RESULT != "") {
                        ResultMessage(2, 'success', pResult.RESULT);
                        Search();
                    }
                    else {
                        if (pResult.ERROR != "") {
                            ResultMessage(1, "danger", pResult.ERROR)
                        }
                    }
                }, false);
            }
        }
        domReady(function () {
            $("#divxtable").show();
            Search();
        });
    });
</script>
</asp:Content>
