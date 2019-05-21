'use strict';

describe('Directive: DatePicker', function () {

  // load the directive's module
  beforeEach(module('schematicsApp'));

  var element,
    scope;

  beforeEach(inject(function ($rootScope) {
    scope = $rootScope.$new();
  }));

  it('should make hidden element visible', inject(function ($compile) {
    element = angular.element('<-date-picker></-date-picker>');
    element = $compile(element)(scope);
    expect(element.text()).toBe('this is the DatePicker directive');
  }));
});
