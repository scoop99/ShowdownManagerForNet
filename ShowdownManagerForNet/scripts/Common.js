// 공통 Module
//define(['jquery', 'jquery-cookie', 'modules/Modal', 'datetimepicker', 'moment'], function ($, jCookie, Modal, DateTimePicker, Moment) {
define(['jquery', 'jquery-cookie', 'moment'], function ($, jCookie, Moment) {
    'use strict';

    var ShowLoading = function (pTargetDiv) {
        
        if (pTargetDiv) {
            //console.log("ShowLoading - " + pTargetDiv);
            $("#" + pTargetDiv).width("100%");
            $("#" + pTargetDiv).height("100%");
            $("#" + pTargetDiv).css("position", "absolute").css("z-index", 99999).css("background-color", "rgba( 0, 0, 0, .1 )");
            $("#" + pTargetDiv).css("background-image", "url('/images/Loading.gif')").css("background-position", "50% 50%").css("background-repeat", "no-repeat");
            $("#" + pTargetDiv).show();
        } else {
            //console.log("ShowLoading - " + $("#divLoading").length);
            $("#divLoading").width("100%");
            $("#divLoading").height("100%");
            $("#divLoading").css("position", "absolute").css("z-index", 99999).css("background-color", "rgba( 0, 0, 0, .1 )");
            $("#divLoading").css("background-image", "url('/images/Loading.gif')").css("background-position", "50% 50%").css("background-repeat", "no-repeat");
            $("#divLoading").show();
        }
    }
    var HideLoading = function (pTargetDiv) {
        //console.log("HideLoading");  
        if (pTargetDiv) {
            $("#" + pTargetDiv).width("0");
            $("#" + pTargetDiv).height("0");
            $("#" + pTargetDiv).hide();
        } else {
            $("#divLoading").width("0");
            $("#divLoading").height("0");
            $("#divLoading").hide();
        }
    }

    //// Common - Start  
    var Ajax = function (pParams, pCallBackFunction, pAsync) {
        //CheckActionTime();

        //if (console) console.log("Ajax ACT - " + JSON.stringify(pParams)); 
        ShowLoading();
        
        if (pParams == null) return;
        if (pAsync) {            
            pAsync = pAsync;
        } else {
            if (pAsync == false) {
                pAsync = false;
            } else {
                pAsync = true;
            }
        }
        $.ajax({
            type: 'POST'
                , url: "/Ajax/AjaxProc.aspx"
                , data: JSON.stringify(pParams)
                , contentType: 'application/json; charset=utf-8'
                , dataType: 'json'
                , async: pAsync
                , success: function (res) {
                    if (pCallBackFunction != null) {
                        if (res) {
                            pCallBackFunction(res);
                        }                        
                    }
                    HideLoading();
                }
                , error: function (request, status, error) {
                    HideLoading();
                    if (request.responseText == "SESSION_OUT") {
                        //Toast("Session이(가) 끊겼습니다.");
                        location.href = "/";
                        $("#hdnSessionState").val("SESSION_OUT");
                    } else {
                        //Toast(request.responseText);
                        if (error) {
                            pCallBackFunction(error);
                        }
                    }
                }
        });
    }


    return {
        Ajax: Ajax        
    };

});


var stringConstructor = "test".constructor;
var arrayConstructor = [].constructor;
var objectConstructor = {}.constructor;
var cout = function (pValue) {
    if (pValue === null) {
        return "null";
    } else if (pValue === undefined) {
        return "undefined";
    } else if (pValue.constructor === stringConstructor) {
        if(console) console.log(pValue);
    } else if (pValue.constructor === arrayConstructor) {
        if (console) console.log(JSON.stringify(pValue));
    } else if (pValue.constructor === objectConstructor) {
        if (console) console.log(JSON.stringify(pValue));
    } else if (typeof (pValue) === typeof (10)) {
        if (console) console.log(pValue);
    } else {
        return "don't know";
    }


}

