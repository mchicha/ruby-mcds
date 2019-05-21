'use strict';

angular.module('schematicApp')
    .controller('PreviewCtrl', [
        'schematic',
        'canvas',
        'assets',
        'ProgramSvc',
        '$filter',
        '$timeout',
        function(schematic, canvas, assets, ProgramSvc, $filter, $timeout) {
          var prevCtrl = this;

          prevCtrl.schematic    = schematic;
          prevCtrl.documents    = canvas.documents;
          prevCtrl.elements     = canvas.elements;
          prevCtrl.assets       = assets;
          prevCtrl.doc_layouts  = []


          prevCtrl.applyExistingAssets = function(){
            angular.forEach(prevCtrl.elements, function(element, idx){
              if(element.primary_dam_asset_id){
                var asset = $filter('filter')(prevCtrl.assets, {id: element.primary_dam_asset_id}, true)[0];
                prevCtrl.elements[idx].asset = asset;
              }
            });
          }

          prevCtrl.processIndicies = function() {
            angular.forEach(prevCtrl.documents, function(doc, idx) {
                prevCtrl.documents[idx].idx = idx;
                if (prevCtrl.documents[idx].type_of === 'page') {
                  prevCtrl.doc_layouts.push(prevCtrl.documents[idx]);
                  prevCtrl.documents[idx].programDisplay = prevCtrl.documents[idx].programs
                }
            });
          }

          prevCtrl.legendFilter = function(program){
            // duplicated from schematicCtrl
            var popInstallRange = $filter('filter')(program.pop_start_dates, {date_type: {id: 2}})[0]
            if(popInstallRange){
              if(popInstallRange.start_date && popInstallRange.end_date){
                return new Date(popInstallRange.start_date) <= prevCtrl.schematic.end_date && new Date(popInstallRange.end_date) >= prevCtrl.schematic.release_date
              }
            }
          }

          // These are the numbers attached to each main document. It saves a ton of time by hardcoding them here, but if the files names change these could change.
          // That cannot happen until base document feature is completed. So if you are reading this and that feature exists or they changed the filenames
          // without that feature...this is probably your problem

          var documentNumberKey = {
            1: "Exterior Zone.svg",
            19: "DT FP43 COD.svg",
            18: "DT OPO Lunch Dinner.svg",
            17: "DT OPO Breakfast.svg",
            16: "DT FP43.svg",
            6: "IS MB2K.svg",
            12: "IS MB2K Dual Point.svg",
            10: "IS SEEQ.svg",
            13: "IDMB Breakfast - Vertical.svg",
            8: "IDMB Lunch Dinner - Vertical.svg",
            7: "IDMB Breakfast - Horizontal.svg",
            8: "IDMB Lunch Dinner - Horizontal.svg",
            11: "Lobby Zone - Dining Room.svg"
          }

          // This pushes the layout programs into the page document's programs for display on the page
          prevCtrl.combinePrograms = function() {
            angular.forEach(prevCtrl.documents, function(i){
              if(i.type_of == 'layout'){
                if(documentNumberKey[i.name.replace(/\.\d+/, '')]){
                  var nameFromKey = documentNumberKey[i.name.replace(/\.\d+/, '')];

                  var filteredDocument = $filter('filter')(prevCtrl.documents, {filename: nameFromKey})[0];

                  angular.forEach(filteredDocument.programDisplay, function(prog){
                    if(filteredDocument.programDisplay.indexOf(prog) === -1){
                      filteredDocument.programDisplay.push(prog)
                    }
                  })
                }
              }
              else if(i.type_of == 'page'){
                i.htmlClassName = 'doc-container-' + i.zone.name.replace(/\s/g, '-').toLowerCase()
              }
            })
          }


          prevCtrl.applyExistingAssets();
          prevCtrl.processIndicies();
          prevCtrl.combinePrograms();


          $('header, .page-header, .well, .col-md-3, footer').hide();

          // This is here to prevent WKHTMLTOPDF from hanging
          $timeout(function(){
            window.status = 'ready_to_print';
          }, 90000)

        }
    ]).filter('cut', function () {
      // This has logic for having a cutoff if string too long.
      return function (value, max, tail) {
        if (!value) {
          return '';
        }

        tail  = tail || '…';

        max = parseInt(max, 10);

        if (!max || value.length <= max) {
          return value;
        }

        value = value.substr(0, max);

        var lastspace = value.lastIndexOf(' ');
        if (lastspace != -1) {
          value = value.substr(0, lastspace);
        }

        return value + tail;
      };
    }).filter('popStartDate', ['$filter', function ($filter) {
      return function (program, popDateTypeName) {
        var install = $filter('filter')(program.pop_start_dates, {date_type: {name: popDateTypeName}})[0];

        return install ? $filter('date')(install.start_date, 'M/d') : '';
      };
    }]);
