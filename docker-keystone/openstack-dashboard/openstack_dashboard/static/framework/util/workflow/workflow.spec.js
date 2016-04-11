(function () {
  'use strict';

  describe('horizon.framework.util.workflow module', function () {
    it('should have been defined', function () {
      expect(angular.module('horizon.framework.util.workflow')).toBeDefined();
    });
  });

  describe('workflow factory', function () {
    var workflow, spec;
    var decorators = [
      function (spec) {
        angular.forEach(spec.steps, function (step) {
          if (step.requireSomeServices) {
            step.checkReadiness = function () {};
          }
        });
      }
    ];

    beforeEach(module('horizon.framework.util.workflow'));

    beforeEach(inject(function ($injector) {
      workflow = $injector.get('horizon.framework.util.workflow.service');
      spec = {
        steps: [
          { requireSomeServices: true },
          { },
          { requireSomeServices: true }
        ]
      };
    }));

    it('workflow is defined', function () {
      expect(workflow).toBeDefined();
    });

    it('workflow is a function', function () {
      expect(angular.isFunction(workflow)).toBe(true);
    });

    it('can be decorated', function () {
      workflow(spec, decorators);
      var steps = spec.steps;

      expect(steps[0].checkReadiness).toBeDefined();
      expect(angular.isFunction(steps[0].checkReadiness)).toBe(true);

      expect(steps[1].checkReadiness).not.toBeDefined();

      expect(steps[2].checkReadiness).toBeDefined();
      expect(angular.isFunction(steps[2].checkReadiness)).toBe(true);
    });
  });
})();
