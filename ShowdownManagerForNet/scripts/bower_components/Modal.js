define(['bootstrap-dialog', 'toastr'], function (BootstrapDialog, Toast) {
    'use strict';
    var types = [BootstrapDialog.TYPE_DEFAULT,
                     BootstrapDialog.TYPE_INFO,
                     BootstrapDialog.TYPE_PRIMARY,
                     BootstrapDialog.TYPE_SUCCESS,
                     BootstrapDialog.TYPE_WARNING,
                     BootstrapDialog.TYPE_DANGER];
    // size-wide 처럼 소문자
    var sizes = [BootstrapDialog.SIZE_NORMAL
        , BootstrapDialog.SIZE_SMALL
        , BootstrapDialog.SIZE_WIDE
        , BootstrapDialog.SIZE_LARGE];

    var Open = function (pType, pTitle, pUrl, pButtons, pModalDialogSize, pClosable, pCssClass, pCloseEventFunction) {
        if (pClosable) {
            pClosable = pClosable;
        } else {
            if (pClosable == false) {
                pClosable = false;
            } else {
                pClosable = true;
            }
        }

        pType = types.filter(function (element, index, types) {
            return element.indexOf((pType)?pType.toLowerCase():"") > -1;
        });
        if (pType.length > 0) {
            pType = pType[0];
        } else {
            pType = "";
        }
        pModalDialogSize = sizes.filter(function (element, index, sizes) {
            return element.indexOf((pModalDialogSize)?pModalDialogSize.toLowerCase():"") > -1;
        });
        if (pModalDialogSize.length > 0) {
            pModalDialogSize = pModalDialogSize[0];
        } else {
            pModalDialogSize = BootstrapDialog.SIZE_NORMAL;
        }

        var dialog = null;
        //if (pModalType == "ALERT") {
        //    dialog = new BootstrapDialog.alert({
        //        size: pModalDialogSize
        //        , type: pType
        //        , title: pTitle
        //        , message: $("<span></span>").load(pUrl) //'Click buttons below.',
        //        , buttons: pButtons
        //        , draggable: true
        //    });
        //}

        dialog = new BootstrapDialog.show({
            size: pModalDialogSize
            , type: pType
            , title: pTitle
            , message: $("<span></span>").load(pUrl) //'Click buttons below.',
            , buttons: pButtons
            , draggable: true
            , closable: true
            , closeByBackdrop: pClosable
            , cssClass: pCssClass
            , onshown: function () {
                
                var inputCount = $('.modal-body').find(".light-grey").find("input").length;
                if (inputCount > 0) {
                    $('.modal-body').find(".light-grey").find("input").eq(inputCount - 1).focus();
                }
                //console.log($('.modal-body').find(".light-grey").find("input").length);
            }
            , onhidden: function () {
                //console.log("close");
                if (pCloseEventFunction) {
                    pCloseEventFunction();
                }
            }
        });
        //dialog.setSize(BootstrapDialog.SIZE_NORMAL);
        dialog.getModalHeader().addClass("text-center");

        return dialog;
    }
      

    var Show = function (pType, pTitle, pMessage, pButtons, pClosable, pModalDialogSize) {
        if (pClosable) {
            pClosable = pClosable;
        } else {
            if (pClosable == false) {
                pClosable = false;
            } else {
                pClosable = true;
            }
        }

        pType = types.filter(function (element, index, types) {
            return element.indexOf(pType.toLowerCase()) > -1;
        });
        if (pType.length > 0) {
            pType = pType[0];
        } else {
            pType = "";
        }

        pModalDialogSize = sizes.filter(function (element, index, sizes) {
            return element.indexOf((pModalDialogSize) ? pModalDialogSize.toLowerCase() : "") > -1;
        });
        if (pModalDialogSize.length > 0) {
            pModalDialogSize = pModalDialogSize[0];
        } else {
            pModalDialogSize = BootstrapDialog.SIZE_NORMAL;
        }

        var dialog = BootstrapDialog.show({
            size: pModalDialogSize
            , type: pType
            , title: pTitle
            , message: pMessage //'Click buttons below.',
            , buttons: pButtons
            , draggable: true
            , closable: pClosable
        });
        dialog.getModalHeader().addClass("text-center");
        return dialog;
    }

    var Dialogs = {};
    var Display = function (pTargetID) {        
        var dialog = BootstrapDialog.show({
            message: $("#" + pTargetID) //'Click buttons below.',
        });
        //Dialogs[pTargetID] = dialog;
        //$("#" + pTargetID).modal("show");
    }
    var Hide = function (pTargetID) {
        $("#" + pTargetID).modal("hide");
    }

    var BookmarkHandler = function () {
        BootstrapDialog.show({
            title: '즐겨찾기'
            , message: 'Hi Apple!'
            , buttons: [{
                label: '에러 테스트',
                action: function (pDialog) {
                    pDialog.setTitle('Title 1');
                    Toast.error('에러 테스트');
                }
            }]
            , draggable: true
        });
    }

    var ReportBugsHandler = function () {
        BootstrapDialog.show({
            title: '프로그램오류 신고하기'
            , message: $("<span></span>").load("/Partials/PopUp/PopBug.aspx") //'Click buttons below.',
            , buttons: [{
                label: 'Title 1',
                action: function (pDialog) {
                    pDialog.setTitle('Title 1');
                    Toast.warning('경고 테스트');
                }
            }, {
                label: 'Title 2',
                action: function (pDialog) {
                    pDialog.setTitle('Title 2');
                    Toast.success('성공 테스트');
                }
            }]
            , draggable: true
        });
    }



    var HelpHandler = function () {
        BootstrapDialog.show({
            title: '도움말'
            , message: 'Hello World!'
            , buttons: [{
                label: '닫기',
                action: function (pDialog) {
                    pDialog.close();
                    Toast.info('닫기 완료');
                }
            }]
            , draggable: true
        });
    }

    // Toast 설정
    Toast.options = {
        "closeButton": false,
        "debug": false,
        "newestOnTop": false,
        "progressBar": false,
        "positionClass": "toast-bottom-right",
        "preventDuplicates": false,
        "onclick": null,
        "showDuration": "300",
        "hideDuration": "1000",
        "timeOut": "10000",
        "extendedTimeOut": "1000",
        "showEasing": "swing",
        "hideEasing": "linear",
        "showMethod": "fadeIn",
        "hideMethod": "fadeOut"
    }

    return {
        Open: Open
        , Show: Show
        , Toast: Toast
        , Display: Display
        , Hide: Hide

        , ReportBugsHandler: ReportBugsHandler
        , BookmarkHandler: BookmarkHandler
        , HelpHandler: HelpHandler

        
    }
});
