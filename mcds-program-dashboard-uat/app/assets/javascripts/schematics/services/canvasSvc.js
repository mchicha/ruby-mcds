'use strict';

angular.module('schematicApp')
    .service('CanvasSvc', [ '$filter', function CanvasSvc($filter) {
        var canvas = this;

        canvas.patternMap       = [];
        canvas.patterns         = [];
        canvas.pendingImages    = 0;
        canvas.processedImages  = 0;


        // ***************************************************************************
        //                                Initializer
        // ***************************************************************************

        // This helps build the configuration settings that will be used to build
        // out the canvas.
        canvas.initialize = function(scope, attrs, ctrl, doc) {
            if(!doc) {
              scope.doc = ctrl.documents[ctrl.currDoc];
            }
            scope.doc.config = {};
            scope.doc.config.elemId = attrs.id;
            scope.doc.config.width  = canvas.getCanvasWidth(attrs.id);
            scope.doc.config.scale  = canvas.getImageScale(scope.doc.width, scope.doc.config.width);
            scope.doc.config.height = scope.doc.height * scope.doc.config.scale;
        }

        // ***************************************************************************
        //                                Builders
        // ***************************************************************************

        // Iterates through all layers of the directives configuration being
        // passed in. Then it returns the layers to the function that called it.
        canvas.buildLayers = function(config) {
            var layers = []
            angular.forEach(config.layers, function(layer) {
                this.push(canvas.buildLayer({
                    name: layer.name
                }))
            }, layers);

            return layers;
        };

        canvas.buildPatterns = function(scope){
          var dom     = document.createElement('div');
              dom.id  = "pattern";
              document.body.appendChild(dom);

          angular.forEach(scope.patterns, function(pattern){
            canvas.patternMap.push(pattern.title);
            var viewBox = pattern.view_box.split(/\s/).map(parseFloat),
                stage   = canvas.buildStage({
                  elemId: 'pattern',
                  width: pattern.width,
                  height: pattern.height,
                  offsetX: viewBox[0],
                  offsetY: viewBox[1],
                  scaleX: Math.abs( pattern.width / ( viewBox[2] - viewBox[0] ) ),
                  scaleY: Math.abs( pattern.height / ( viewBox[3] - viewBox[1] ) )
                }),
                layer = canvas.builder({layers: [{
                      name: 'pattern',
                      mouseEvents: null,
                      builder: function(element) {
                          var obj = angular.copy(element.values);
                          obj.type = 'pattern';
                          return [obj];
                      }
                  }],
                  mouseEvents: {}
                }, pattern.elements)[0];
                stage.add(layer).draw().toDataURL({
                  callback: function(dataUrl){
                    canvas.addPattern(scope, pattern.title, dataUrl);
                  }
                });

          });
        };

        canvas.addPattern = function(scope, name, dataUrl){
          var img = new Image();
              img.crossOrigin = 'anonymous'

              img.onload = function(){
                var affectedElements = [];

                canvas.patterns.push(img);
                angular.forEach(scope.elements, function(element){
                  angular.forEach(element.canvasElements, function(canvasElement){
                    if(canvasElement.attrs.fill && (canvasElement.attrs.fill == "url(#" + name + ")") ){
                      canvasElement.setFill('').fillPatternImage(img);
                      affectedElements.push(canvasElement);
                    }
                  });
                });

                if(affectedElements.length > 0){
                  affectedElements[0].parent.parent.draw();
                }
              }

              img.src = dataUrl;

        }

        // This is the main function of the service. This takes the
        // configuration with its builders and mouse events and creates Kinetic
        // canvas elements for each layer that was built out. Then once
        // all elements are built out and attached to there respective layer it
        // returns the array of layers
        canvas.builder = function(scope, ctrl) {
            var baseLayers = canvas.buildLayers(scope.config);
            scope.doc.assetIds = []; // Set cache for taken assets for filtering later

            angular.forEach(baseLayers, function(layer, idx){
              var layerConfig = scope.config.layers[idx],
                  elements;

              if (layerConfig.unscoped && layerConfig.unscoped === true) {
                elements = ctrl.elements;
              } else {
                elements = $filter('filter')(ctrl.elements, {layer_name: layerConfig.name});
              }

              angular.forEach(elements, function(element, edx){
                if (scope.doc.element_ids.indexOf(element.id) > -1){
                  var elementConfig = layerConfig.builder(element),
                      canvasElement = canvas.getElement(elementConfig, element);

                  canvasElement.element = element;
                  element.canvasElement = canvasElement;

                  if (element.primary_dam_asset_path) {
                    canvas.applyImage(canvasElement, element.primary_dam_asset_path, false);
                    scope.doc.assetIds.push(element.primary_dam_asset_id)
                  }

                  if (layerConfig.mouseEvents) {
                      scope.config.mouseEvents[layerConfig.mouseEvents](canvasElement);
                  }

                  layer.add(canvasElement);

                  if(element.layout_id){
                    var group;

                    if(canvasElement.nodeType === 'Group') {
                      group = canvasElement;
                    } else {
                      group = new Kinetic.Group({x: canvasElement.element.values.x, y: canvasElement.element.values.y});
                      group.wrapperElement  = canvasElement;
                      canvasElement.group   = group;
                      layer.add(group);
                    }

                    group.doc = $filter('filter')(ctrl.documents, {id: element.layout_id}, true)[0];

                    angular.forEach(ctrl.elements, function(groupElement){
                      if(group.doc.element_ids.indexOf(groupElement.id) > -1){
                        var elementConfig           = layerConfig.builder(groupElement),
                            groupCanvasElement      = canvas.getElement(elementConfig, groupElement);
                        groupCanvasElement.element  = groupElement;
                        element.canvasElement       = groupCanvasElement;

                        if (layerConfig.mouseEvents) {
                          scope.config.mouseEvents[layerConfig.mouseEvents](groupCanvasElement);
                        }

                        if (groupElement.primary_dam_asset_path) {
                          scope.doc.assetIds.push(groupElement.primary_dam_asset_id)
                          canvas.applyImage(groupCanvasElement, groupElement.primary_dam_asset_path);
                        }

                        group.add(groupCanvasElement);
                      }
                    });

                  }


                }
              });
            });

            if (canvas.pendingImages === 0) {
              window.status = 'ready_to_print';
            };

            return baseLayers;
        };

        // Builds and initial stage for the canvas based on the criteria passed in
        canvas.buildStage = function(config) {
            return new Kinetic.Stage({
                container: config.elemId,
                width: config.width,
                height: config.height
            });
        }

        // Instantiates a new Kinetic layer with configuration information
        canvas.buildLayer = function(config) {
            var config = typeof config !== 'undefined' ? config : {};
            var layer = new Kinetic.Layer(config);
            return layer;
        }

        // ***************************************************************************
        //                     Getter Functions For Configuration
        // ***************************************************************************

        // This is used to shrink and canvas image from its full resolution
        //  down to a size that will fit into the element the canvas is
        //  bound to on the DOM.
        canvas.scaleStage = function(config, stage) {
            config.scale = angular.isUndefined(config.scale) ? 1 : config.scale;

            stage.setScaleX(config.scale  * canvas.pixalRatio(stage));
            stage.setScaleY(config.scale  * canvas.pixalRatio(stage));
            stage.setWidth(config.width   * canvas.pixalRatio(stage));
            stage.setHeight(config.height * canvas.pixalRatio(stage));

            return stage;
        }

        // Helps determine if screen has high pixal density.
        canvas.isRetina = function(stage) {
          var ratio = canvas.pixalRatio(stage);

          return ratio === 2;
        }

        canvas.pixalRatio = function(stage) {
          var context = stage.children[0].getContext();
          var devicePixelRatio = window.devicePixelRatio || 1,
              backingStoreRatio = context.webkitBackingStorePixelRatio ||
                          context.mozBackingStorePixelRatio ||
                          context.msBackingStorePixelRatio ||
                          context.oBackingStorePixelRatio ||
                          context.backingStorePixelRatio || 1,

          ratio = devicePixelRatio / backingStoreRatio;
          return 2;
        }

        canvas.applyRetina = function(stage, element) {
            if (canvas.isRetina(stage)){
                element.addClass('retina');
            } else {
                element.removeClass('retina');
            }
        }

        // Determines all the unique layers of the document
        canvas.getIndices = function(elements) {
            var indices = []
            angular.forEach(elements, function(element, idx) {
                if (indices.indexOf(element.zindex) === -1) {
                    indices.push(element.zindex);
                }
            });

            return indices.sort();
        }

        // Determines the width of the DOM element used for the Canvas
        canvas.getCanvasWidth = function(elemId) {
            var stage = document.getElementById(elemId);
            return stage.offsetWidth;
        }

        // Determines the scale percentage based on the original image with
        // and its target canvas where it will be drawn out
        canvas.getImageScale = function(imageWidth, canvasWidth) {
            return canvasWidth / imageWidth;
        }

        // Method used to call the correct Kinetic build and format the data
        // Also notifies the console if the element being called is not defined
        canvas.getElement = function(elementConfig, element) {
            var values = elementConfig || element.values,
                canvasElement;
            // values.scale = {
            //     x: 1,
            //     y: 1
            // };
            if (angular.isString(values.dash)) {
                values.dash = values.dash.split(/\s|,/).map(parseFloat);
            }

            if (angular.isString(values.points)) {
                values.points = values.points.split(/\s|,/).map(parseFloat);
                values.closed = true;
            }

            if (angular.isArray(values.fillLinearGradientColorStops)) {
                values.fillLinearGradientColorStops.map(function(val, idx){
                   if(!(idx%2)){
                      values.fillLinearGradientColorStops[idx] = parseFloat(val);
                    }
                });
            }

            switch (elementConfig.name || element.name) {
                case 'path':
                    return canvas.Path(values);

                case 'g':
                    return canvas.Group(values);

                case 'ellipse':
                    canvasElement = canvas.Ellipse(values);
                    return canvasElement;

                case 'rect':
                    canvasElement = canvas.Rect(values);
                    return canvasElement;

                case 'circle':
                    return canvas.Circle(values);

                case 'image':
                    canvasElement = canvas.Image(values);
                    return canvasElement;

                case 'line':
                    return canvas.Line(values);

                case 'polygon':
                    return canvas.Polygon(values);

                case 'polyline':
                    return canvas.Line(values);

                case 'text':
                    return canvas.Text(values);

                default:
                    return element.name + ' is not defined in parser.'
            }
        }

       function RectAccum(){
           this.left=0;
           this.top=0;
           this.right=0;
           this.bottom=0;
           this.startX=true;
           this.startY=true;
        }

        RectAccum.prototype={
            width:function(){
                return this.right-this.left
            },
            height:function(){
                return this.bottom-this.top
            },
            addX:function(x){
                this.left=(this.startX) ? x : Math.min(x,this.left);
                this.right=(this.startX) ? x : Math.max(x,this.right);
                this.startX=false;
            },
            addY:function(y){
                this.top=(this.startY) ? y : Math.min(y,this.top);
                this.bottom=(this.startY) ? y : Math.max(y,this.bottom);
                this.startY=false;
            },
            addXY:function(x,y){
                this.addX(x); this.addY(y);
            }
        }

        canvas.getPathDimensions = function(path){
          var data = path.dataArray,
              ra   = new RectAccum();

          for(var i=0;i<data.length;i++){
           switch(data[i].command){
            case "L":
             ra.addXY(data[i].start.x,data[i].start.y);
             ra.addXY(data[i].points[0],data[i].points[1]);
             break;
           }
          }
          return {left:ra.left,top:ra.top,width:ra.width(),height:ra.height()}
        }

        canvas.getLineDimensions = function(path){
          var data = path.attrs.points,
              ra   = new RectAccum();

          for(var i=0;i<data.length;i++){
              if(i % 2 === 0) { // index is even
                  ra.addX(data[i]);
              } else {
                  ra.addY(data[i]);
              }
          }
          return {left:ra.left,top:ra.top,width:ra.width(),height:ra.height()}
        }

        canvas.applyImage = function(canvasElement, href, clearFilters) {
          // If grayscale and certain classes special pre-step needed:
          if(href && canvasElement.element.grayscale){
            // A path/polyon/line cannot have a filter applied like normal. The image does not exist to get the cache() yet
            // We make the image in a different canvas, grayscale it, get a dataUrl
            // Then #sideCanvasGrayscaleDataUrl will loadImageOnPage, but replace href with the dataUrl.
            // NOTE: Modify the funciton if ever need something besides grayscale
            return canvas.sideCanvasGrayscaleDataUrl(canvasElement, href, clearFilters)
          }
          else{
            return canvas.loadImageOnPage(canvasElement, href, clearFilters)
          }
        }

        canvas.loadImageOnPage = function(canvasElement, href, clearFilters){
          canvas.pendingImages += 1;
          if(href){
            var img = new Image();

            img.setAttribute('crossOrigin','anonymous');
            img.crossOrigin = 'anonymous';
            img.onload = function() {
              canvas.processedImages += 1;

              if (canvasElement.className === 'Path'){
                var dimensions = canvas.getPathDimensions(canvasElement),
                    width      = dimensions.width,
                    height     = dimensions.height;
              }

              if (canvasElement.className === 'Line'){
                var dimensions = canvas.getLineDimensions(canvasElement),
                    width      = dimensions.width,
                    height     = dimensions.height;
              }

              var scale;

              // Check if user has already defined scaling
              if(canvasElement.element.values && (canvasElement.element.values.fillPatternScaleX || canvasElement.element.values.fillPatternScaleY)){
                scale = (canvasElement.element.values.fillPatternScaleX || canvasElement.element.values.fillPatternScaleY)
              }

              // If not defined, do the whole calculation to fit it to size
              if(!scale){
                var scaleX = parseFloat(width || canvasElement.width()) / parseFloat(img.width),
                    scaleY = parseFloat(height || canvasElement.height()) / parseFloat(img.height)
                scale  = scaleX < scaleY ? scaleY : scaleX;

                // Put on the element values so the sliders properly show. This will not save automatically, if nothing is altered and it does not save
                // this formula just fires again. This not only prevents an extra save call, but also keeps the image autoscaling, which if the user
                // makes no edits, is assumed functionality
                canvasElement.element.values.fillPatternScaleX = scale;
                canvasElement.element.values.fillPatternScaleY = scale;
              }

              // Set href on the element
              canvasElement.attrs.href = href;

              // Set the scale based on what was found above
              canvasElement.fillPriority('pattern').fillPatternRepeat('no-repeat').fillPatternImage(img).fillPatternScale({
                  x: scale,
                  y: scale
              });

              if(dimensions){
                // Do not reset X Offset if user has already defined it
                if(!canvasElement.element.values.fillPatternX){
                  canvasElement.fillPatternX(dimensions.left);
                  canvasElement.element.values.fillPatternX = dimensions.left;
                }

                // Do not reset Y Offset if user has already defined it
                if(!canvasElement.element.values.fillPatternY){
                  canvasElement.fillPatternY(dimensions.top);
                  canvasElement.element.values.fillPatternY = dimensions.top;
                }
              }

              canvasElement.parent.draw();

              if(canvas.pendingImages === canvas.processedImages) {
                window.status = 'ready_to_print';
              }
            };

            if(href.indexOf('data:image/png;base64') > -1) {
              img.src = href;
            } else {
              img.src = href + '?' + new Date().getTime()
            }

          } else {
            canvasElement.setStroke('black').
              setStrokeWidth(0).setOpacity(1).
              setFill(canvasElement.element.values.fill).
              setFillPatternImage('');

            canvasElement.parent.draw();
          }

          return canvasElement;
        }


        canvas.sideCanvasGrayscaleDataUrl = function(canvasElement, href, clearFilters){
          // Create temporary canvas that is hidden so user is oblivious to the dark magic at work...
          var tempCanvas = document.createElement('div');

          // Set id that stage needs to be assigned to
          tempCanvas.id  = "tempContainer";

          // Get height and width from the canvasElement
          tempCanvas.height = canvasElement.attrs.height;
          tempCanvas.width = canvasElement.attrs.width;

          // Make hidden before
          tempCanvas.hidden = true;
          document.body.appendChild(tempCanvas);

          // Create stage
          var tempStage = new Kinetic.Stage({
            container: 'tempContainer',
            width: canvasElement.attrs.height,
            height: canvasElement.attrs.width
          });

          // Create layer, add to stage
          var tempLayer = new Kinetic.Layer();
          tempStage.add(tempLayer);

          // Create DOM image
          var temporaryImage = new Image();
          temporaryImage.crossOrigin = "anonymous";

          // The onload function
          var createCopyDestroyTempImage = function (){

            // Create Kinetic JS image with proper attrs
            var tempKineticImage = new Kinetic.Image({
              image:temporaryImage,
              width:temporaryImage.width,
              height:temporaryImage.height,
            });

            // Add Image to the Layer
            tempLayer.add(tempKineticImage);

            // Add the grayscale filter
            // NOTE If this function one day needs to do more than grayscale...these next two lines are your problem
            tempKineticImage.cache();
            tempKineticImage.filters([Kinetic.Filters.Grayscale]);

            // Get the dataUrl via KineticJs, will look something like: "data:image/png;base64#{TONS OF CHARACTERS}"
            var dataUrl = tempKineticImage.toDataURL();

            // Now call loadImageOnPage with the dataUrl instead of the href
            canvas.loadImageOnPage(canvasElement, dataUrl, clearFilters);

            // Remove the temporary canvas
            tempCanvas.remove();
          }

          // Assign onload function to onload on the image
          temporaryImage.onload = createCopyDestroyTempImage;

          // Set href so that you don't get a tainted canvas error. (The serialized time addition makes a unique name)
          temporaryImage.src = href + '?' + new Date().getTime();
        }


        canvas.removeImage = function(canvasElement) {
          // TODO: need to build this function
        }

        canvas.applyLayout = function(wrapperElement, elements, mouseEvents, ids){
          if(!wrapperElement.group){
            wrapperElement.group = new Kinetic.Group();
            wrapperElement.group.wrapperElement = wrapperElement;
            wrapperElement.parent.add(wrapperElement.group)
          } else if (ids){
            // if id(s) are given, then we are only applying those elements with changes to the layout,
            // no need to clear the others, which can result in bad data being presented to user
            wrapperElement.group.children.forEach(function(child){
              if(ids.indexOf(child.element.id) > -1){
                child.remove();
              }
            })
          }
          else {
            wrapperElement.group.removeChildren();
          }

          angular.forEach(elements, function(element){
            var obj = angular.copy(element.values),
            canvasElement = canvas.getElement(obj, element);

            canvasElement.element = element;
            element.canvasElement = canvasElement;

            if (element.dam_asset_path) {
                canvas.applyImage(canvasElement, element.dam_asset_path);
            }

            if(mouseEvents){
                mouseEvents(canvasElement);
            }

            wrapperElement.group.add(canvasElement);
          });

          wrapperElement.setFill('#828487');
          wrapperElement.group.setPosition({x: wrapperElement.element.values.x, y: wrapperElement.element.values.y});
          wrapperElement.group.parent.draw();
        };

        canvas.applyBorder = function(canvasElement, strokeWidth, color) {
            canvasElement.setStroke(color || 'white').setStrokeWidth(strokeWidth);
            return canvasElement;
        };

        canvas.setLayerVisibillity = function(layer, visible) {
            if (visible) {
                layer.setOpacity(1);
            } else {
                layer.setOpacity(0);
            }
        };

        // ***************************************************************************
        //                              Kinetic Elements
        // ***************************************************************************

        canvas.Group = function(values) {
            return new Kinetic.Group(values);
        }
        canvas.Circle = function(values) {
            return new Kinetic.Circle(values);
        }

        canvas.Ellipse = function(values) {
            return new Kinetic.Ellipse(values);
        }

        canvas.Path = function(values) {
            return new Kinetic.Path(values);
        }

        canvas.Polygon = function(values) {
            return new Kinetic.Line(values);
        }

        canvas.Rect = function(values) {
            return new Kinetic.Rect(values);
        }

        canvas.Text = function(values) {
            return new Kinetic.Text(values);
        }

        canvas.Line = function(values) {
            return new Kinetic.Line(values);
        }

        canvas.Image = function(values) {
          values['imageSmoothingQuality '] = 'high';
            return new Kinetic.Image(values);
        }

    }]);
