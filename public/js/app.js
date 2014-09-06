/**
 * Created by curtis on 9/5/14.
 */

angular.module('Veato', [])
    .controller('flickr', function ($scope, $http) {
        $scope.flickUrl = null;
        $scope.getFlickJson = function () {
            $http.get("https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=48139a498b863dbe306f9eeb3732e4e5&tags=cincinnati+city&format=json&nojsoncallback=1&api_sig=bde0d04325609ae7ae666cc7920dc719")
                .success(function (returnData) {
                    var pic = returnData.photos.photo[0];
                    $scope.flickUrl = $scope.getFlick(pic.farm, pic.server, pic.id, pic.secret)
                })
        };

        $scope.getFlick = function (farmId, serverId, id, secret) {
            return "https://farm" + farmId + ".staticflickr.com/" + serverId + "/" + id + "_" + secret + ".jpg"
        };
    })
    .controller('sock', function ($scope, $http, $window) {
        $scope.suggestion = '';
        $scope.initGame = function (initPlace) {
            console.log('rottentomatoes');
            $window.socket.emit('newGame', $scope.suggestion);
        }
    });