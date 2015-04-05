var app = angular.module('app', ['ngResource']);

app.config(["$httpProvider", function($httpProvider) {
  var authToken = $("meta[name='csrf-token']").attr("content");
  return $httpProvider.defaults.headers.common["X-CSRF-TOKEN"] = authToken;
}]);

app.factory("Tract", [ "$resource", function($resource) {
  return $resource("/api/v1/census_tracts/:ctuid", {ctuid: '@ctuid'});
}]);

app.controller('MainCtrl', ["$scope", "Tract", function ($scope, Tract) {

  $scope.search = {
    maxIndivMedianIncomeCombined: 120000,
    minIndivMedianIncomeCombined: 0
  };
  $scope.tracts = Tract.query(function() {
    $scope.tracts.forEach(function(element) {
      element.ableToAddToMap = true;
    });
  });

  $scope.map = L.map("map").fitBounds([[40,-140], [60, -52]]);
  // add an OpenStreetMap tile layer
  L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {
    attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
  }).addTo($scope.map);
  $scope.geojsonLayer = L.geoJson();
  $scope.geojsonLayer.addTo($scope.map);

  $scope.viewOnMap = function(index) {
    $scope.map.panTo([].concat.apply([], JSON.parse($scope.tracts[index].geom).coordinates)[0].reverse());
    $scope.map.setZoom(14);
  };

  $scope.addToMap = function(index) {
    $scope.geojsonLayer.addData(JSON.parse($scope.tracts[index].geom));
    $scope.tracts[index].ableToAddToMap = false;
    $scope.viewOnMap(index);
  };

  $scope.criteriaMatch = function(search) {
    return function(item) {
      cmaNameRe = new RegExp(search.cmaname, 'i');
      provinceNameRe = new RegExp(search.prname, 'i');
      return(
        cmaNameRe.test(item.cmaname)
	  && provinceNameRe.test(item.prname)
	  && Math.floor(search.maxIndivMedianIncomeCombined) > item.data['Individual Median Income'].combined
	  && Math.floor(search.minIndivMedianIncomeCombined) < item.data['Individual Median Income'].combined
      )
    }
  };
}]);
