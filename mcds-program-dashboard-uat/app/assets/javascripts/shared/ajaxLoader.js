angular
  .module('loadingOnAJAX', [])
  .config(['$httpProvider', function($httpProvider) {
      var numLoadings = 0;

      // AjaxLoaderProvider.addLoader();

    $httpProvider.interceptors.push(function($q, AjaxLoaderSvc) {
      return {
        // optional method
        'request': function(config) {
          numLoadings++;
          AjaxLoaderSvc.show();
          // $animate.removeClass(loadingScreen, 'hide');
          return config;
        },

        // optional method
       'requestError': function(rejection) {
          // do something on error
          return $q.reject(rejection);
        },

        // optional method
        'response': function(response) {
          if (!(--numLoadings)) {
            // $animate.addClass(loadingScreen, 'hide');
            AjaxLoaderSvc.hide();
          }
          return response;
        },

        // optional method
       'responseError': function(rejection) {
          if (!(--numLoadings)) {
            // $animate.addClass(loadingScreen, 'hide');
            AjaxLoaderSvc.hide();
          }
          return $q.reject(rejection);
        }
      };
    });

  }])
  .directive('ajaxLoader', function () {
    return {
      restrict: 'E',
      replace: true,
      template: '<div class="ajax-loader" ng-show="ajxLdr.isVisible()"><svg width="34px" height="34px" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" preserveAspectRatio="xMidYMid" class="uil-default"><rect x="0" y="0" width="100" height="100" fill="none" class="bk"></rect><rect  x="46.5" y="40" width="7" height="20" rx="5" ry="5" fill="#545759" transform="rotate(0 50 50) translate(0 -30)">  <animate attributeName="opacity" from="1" to="0" dur="1s" begin="0s" repeatCount="indefinite"/></rect><rect  x="46.5" y="40" width="7" height="20" rx="5" ry="5" fill="#545759" transform="rotate(25.714285714285715 50 50) translate(0 -30)">  <animate attributeName="opacity" from="1" to="0" dur="1s" begin="0.07142857142857142s" repeatCount="indefinite"/></rect><rect  x="46.5" y="40" width="7" height="20" rx="5" ry="5" fill="#545759" transform="rotate(51.42857142857143 50 50) translate(0 -30)">  <animate attributeName="opacity" from="1" to="0" dur="1s" begin="0.14285714285714285s" repeatCount="indefinite"/></rect><rect  x="46.5" y="40" width="7" height="20" rx="5" ry="5" fill="#545759" transform="rotate(77.14285714285714 50 50) translate(0 -30)">  <animate attributeName="opacity" from="1" to="0" dur="1s" begin="0.21428571428571427s" repeatCount="indefinite"/></rect><rect  x="46.5" y="40" width="7" height="20" rx="5" ry="5" fill="#545759" transform="rotate(102.85714285714286 50 50) translate(0 -30)">  <animate attributeName="opacity" from="1" to="0" dur="1s" begin="0.2857142857142857s" repeatCount="indefinite"/></rect><rect  x="46.5" y="40" width="7" height="20" rx="5" ry="5" fill="#545759" transform="rotate(128.57142857142858 50 50) translate(0 -30)">  <animate attributeName="opacity" from="1" to="0" dur="1s" begin="0.35714285714285715s" repeatCount="indefinite"/></rect><rect  x="46.5" y="40" width="7" height="20" rx="5" ry="5" fill="#545759" transform="rotate(154.28571428571428 50 50) translate(0 -30)">  <animate attributeName="opacity" from="1" to="0" dur="1s" begin="0.42857142857142855s" repeatCount="indefinite"/></rect><rect  x="46.5" y="40" width="7" height="20" rx="5" ry="5" fill="#545759" transform="rotate(180 50 50) translate(0 -30)">  <animate attributeName="opacity" from="1" to="0" dur="1s" begin="0.5s" repeatCount="indefinite"/></rect><rect  x="46.5" y="40" width="7" height="20" rx="5" ry="5" fill="#545759" transform="rotate(205.71428571428572 50 50) translate(0 -30)">  <animate attributeName="opacity" from="1" to="0" dur="1s" begin="0.5714285714285714s" repeatCount="indefinite"/></rect><rect  x="46.5" y="40" width="7" height="20" rx="5" ry="5" fill="#545759" transform="rotate(231.42857142857142 50 50) translate(0 -30)">  <animate attributeName="opacity" from="1" to="0" dur="1s" begin="0.6428571428571429s" repeatCount="indefinite"/></rect><rect  x="46.5" y="40" width="7" height="20" rx="5" ry="5" fill="#545759" transform="rotate(257.14285714285717 50 50) translate(0 -30)">  <animate attributeName="opacity" from="1" to="0" dur="1s" begin="0.7142857142857143s" repeatCount="indefinite"/></rect><rect  x="46.5" y="40" width="7" height="20" rx="5" ry="5" fill="#545759" transform="rotate(282.85714285714283 50 50) translate(0 -30)">  <animate attributeName="opacity" from="1" to="0" dur="1s" begin="0.7857142857142857s" repeatCount="indefinite"/></rect><rect  x="46.5" y="40" width="7" height="20" rx="5" ry="5" fill="#545759" transform="rotate(308.57142857142856 50 50) translate(0 -30)">  <animate attributeName="opacity" from="1" to="0" dur="1s" begin="0.8571428571428571s" repeatCount="indefinite"/></rect><rect  x="46.5" y="40" width="7" height="20" rx="5" ry="5" fill="#545759" transform="rotate(334.2857142857143 50 50) translate(0 -30)">  <animate attributeName="opacity" from="1" to="0" dur="1s" begin="0.9285714285714286s" repeatCount="indefinite"/></rect></svg><div class="base-circle"></div><div class="loading-text">This may take up to a minute</div></div>',
      controller: 'ajaxLoaderCtrl as ajxLdr',
      bindToController: true
    };
  })
  .controller('ajaxLoaderCtrl', ['AjaxLoaderSvc', function(AjaxLoaderSvc){
    var ajax = this;
    ajax.isVisible = AjaxLoaderSvc.isVisible;

  }])
  .service('AjaxLoaderSvc', ['$rootElement', function($rootElement){
    var _setShow, _setHide, _isVisible, visible = false;

    $rootElement.prepend('<ajax-loader></ajax-loader>');

    _setHide = function() {
      visible = false;
      return visible;
    }

    _setShow = function() {
      visible = true;
      return visible;
    }

    _isVisible = function() {
      return visible;
    }

    return {
      show:       _setShow,
      hide:       _setHide,
      isVisible:  _isVisible
    }

  }]);

