'use strict';

angular.module('schematicApp')
    .directive('adjustable', [
        '$document',
        function($document) {
            return {
                restrict: 'E',
                transclude: 'true',
                replace: true,
                template: '<div class="adjustable"><a class="move"><i class="fa fa-fw fa-arrows fa-2x"></i></a><div ng-transclude></div></div>',
                scope: {
                    note:     "=note",
                    doc:      "=doc",
                    editable: "=edit"
                },
                bindToController: true,
                controller: function() {
                    var adjCtrl = this;
                },
                controllerAs: "adjCtrl",
                require: '^noteCollection',
                link: function link(scope, element, attrs, ctrls) {
                    var maxLeft, maxTop,
                        startX      = 0,
                        startY      = 0,
                        moveIcon    = $(element).children('a'),
                        wrapperElem = element.parent().parent(),
                        bounds      = {};


                    element.css({
                        top:  scope.adjCtrl.note.y + 'px',
                        left: scope.adjCtrl.note.x + 'px'
                    });

                    // ********************************************************
                    //                    Event Watchers
                    // ********************************************************

                    scope.$watch('adjCtrl.editable', function(newValue, oldValue) {
                        if (newValue === true) {
                            moveIcon.on('mousedown', dragging);

                            moveIcon.on('dragover dragend dragdrop dragexit', function(event) {
                                event.preventDefault();
                            });
                        } else {
                            moveIcon.on('dragover dragend dragdrop dragexit mousedown');
                        }
                    });

                    // ********************************************************
                    //                    Scope Functions
                    // ********************************************************

                    function renderDimensions() {
                      bounds  = wrapperElem[0].getBoundingClientRect();
                      startY  = wrapperElem.offset().top + 26;
                      startX  = wrapperElem.offset().left + 26;
                      maxLeft = startX + bounds.width;
                      maxTop  = startY + bounds.height;
                    };

                    function dragging(event) {
                        renderDimensions();
                        moveIcon.addClass('active');
                        $document.on('mousemove', mousemove);
                        $document.on('mouseup', mouseup);

                        event.preventDefault();
                    };

                    function left(x) {
                        if (x < startX) {
                            return startX;
                        } else if (x > maxLeft) {
                            return maxLeft;
                        } else {
                            return x
                        }
                    };

                    function top(y) {
                        if (y < startY) {
                            return startY;
                        } else if (y > maxTop) {
                            return maxTop;
                        } else {
                            return y
                        }
                    };

                    function mousemove(event) {
                        scope.adjCtrl.note.y = ((top(event.pageY) - startY + 10) / scope.adjCtrl.doc.config.scale);
                        scope.adjCtrl.note.x = ((left(event.pageX) - startX + 10) / scope.adjCtrl.doc.config.scale);

                        element.css({
                            top: scope.adjCtrl.note.y + 'px',
                            left: scope.adjCtrl.note.x + 'px'
                        });
                    }

                    function mouseup(event) {
                        moveIcon.removeClass('active');
                        $document.off('mousemove', mousemove);
                        $document.off('mouseup', mouseup);
                    };


                }
            };
        }
    ]);
