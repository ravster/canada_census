var app = angular.module('app', ['ngResource']);

app.config(["$httpProvider", function($httpProvider) {
  var authToken = $("meta[name='csrf-token']").attr("content");
  return $httpProvider.defaults.headers.common["X-CSRF-TOKEN"] = authToken;
}]);

app.factory("Tract", [ "$resource", function($resource) {
  return $resource("/api/v1/census_tracts/:ctuid", {ctuid: '@ctuid'});
}]);

app.controller('MainCtrl', ["$scope", "Tract", function ($scope, Tract) {

  $scope.tracts = Tract.query()

}]);
