'use strict';

angular.module('schematicApp')
  .controller('CoopCtrl', [
    'coops',
    '$modal',
    'PaginateSvc',
    'SchematicSvc',
    function(coops, $modal, PaginateSvc, SchematicSvc){
      var ctrl = this;

      ctrl.coops = coops;
      ctrl.schematics = SchematicSvc.schematics;
      ctrl.count = coops.length;

      ctrl.perPage = [
        {label: 5, val: 5},
        {label: 10, val: 10},
        {label: 15, val: 15},
        {label: 20, val: 20},
        {label: 50, val: 50}
      ];

      ctrl.f = {
          release_date: {from: null, to: null},
              end_date: {from: null, to: null},
            updated_at: {from: null, to: null},
              currPage: schematics.meta.current_page,
               perPage: 20,
            totalCount: schematics.meta.total_count,
              numPages: null,
                search: '',
                isTest: false,
                status: [],
                  sort: 'id',
                   dir: true
      };

      ctrl.clearFilters = function(){
        ctrl.f.search       = '';
        ctrl.f.release_date = {from: null, to: null};
        ctrl.f.end_date     = {from: null, to: null};
        ctrl.f.updated_at   = {from: null, to: null};
        ctrl.f.status       = [];
        ctrl.f.isTest       = false;
      };


    }
  ]);
