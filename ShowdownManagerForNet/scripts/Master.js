require([], function () {
    'use strict';

    // Require.js 설정
    require.config({
        baseUrl: '/scripts',
        paths: {
            'domReady': ['/scripts/bower_components/domReady'],
            //'datetimepicker': ['/scripts/bower_components/eonasdan-bootstrap-datetimepicker/src/js/bootstrap-datetimepicker'],
            'jquery': ['/scripts/bower_components/jquery'],
            'Common': ['/scripts/Common'],
            'moment': ['/scripts/bower_components/moment-with-locales'],
            'jquery-cookie': ['/scripts/bower_components/jquery.cookie'],
            //'bootstrap': ['/scripts/bower_components/bootstrap/js/bootstrap'],
            //'bootstrap-dialog': ['/scripts/bower_components/bootstrap3-dialog/dist/js/bootstrap-dialog'],

            //'fastclick': ['/bower_components/fastclick/lib/fastclick'],
            //'fullcalendar-lang-ko': ['/bower_components/fullcalendar/dist/lang/ko'],
            //'fullcalendar': ['/bower_components/fullcalendar/dist/fullcalendar.min'],
            //'jquery-ui': ['/bower_components/jquery-ui/jquery-ui'],
            //'jquery-validation': ['/bower_components/jquery-validation/dist/jquery.validate.min'],
            //'jquery': ['/bower_components/jquery/dist/jquery.min'],
            //'jstree': ['/bower_components/jstree/dist/jstree.min'],
            'toastr': ['/scripts/bower_components/toastr/toastr.min'],
            //'async': ['/bower_components/requirejs-plugins-master/src/async'],


            'juicore': ['/scripts/bower_components/dist/jui-core'],
            'juigrid': ['/scripts/bower_components/dist/jui-grid'],
            'juiui': ['/scripts/bower_components/dist/jui-ui'],

        },
        shim: {
            //'datetimepicker': {
            //    // deps: ['jquery', 'bootstrap', 'moment-timezone']
            //    deps: ['jquery', 'bootstrap']
            //},
            'jquery': {
                exports: '$'
            },
            'jquery-cookie': {
                deps: ['jquery']
            },
            'moment': {
                exports: 'moment'
            },
            'jquery-ui': {
                deps: ['jquery']
            },
            //'bootstrap': {
            //    deps: ['jquery']
            //},
            //'bootstrap-dialog': {
            //    deps: ['jquery', 'bootstrap'],
            //    exports: 'BootstrapDialog'
            //},

            'juiui': {
                deps: ['jquery','juicore']
            },
            'juigrid': {
                deps: ['jquery','juicore']
            },
            'juicore': {
                deps: ['jquery']
            },
            
        },
        priority: [
          'jquery'
        ],
        packages: [

        ]
    });


    //require(['jquery', 'domReady', 'bootstrap', 'moment', 'app', 'Common', 'modules/Modal', 'modules/navbar', 'PopUp'], function ($, domReady, bootstrap, moment, app, Common, Modal, navbar, PopUp) {
    require(['jquery', 'domReady'], function ($, domReady) {

        var InitControls = function () {
            
        }

        domReady(function () {
            InitControls();
        });
        

    });
});
 
/////////////////
