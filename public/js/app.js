/**
 * Created by curtis on 9/5/14.
 */

angular.module('Veato', [])
    .controller('flickr', function ($scope, $http) {
        $scope.flickUrl = null;
        $http.get("https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=3c5164fc23695f213d4f048904312e1c&tags=Food&sort=interestingness-desc&format=json&nojsoncallback=1&auth_token=72157646875635030-94f0d0cfff1e563f&api_sig=de75fa2b7b86f8440023df925e02c50b")
            .success(function (returnData) {
                var pic = returnData.photos.photo;
                var index = Math.floor((Math.random() * pic.length));
                pic = pic[index];
                $scope.flickUrl = $scope.getFlick(pic.farm, pic.server, pic.id, pic.secret)
            });

        $scope.getFlick = function (farmId, serverId, id, secret) {
            return "https://farm" + farmId + ".staticflickr.com/" + serverId + "/" + id + "_" + secret + ".jpg"
        };
    })
    .controller('sock', function ($scope, $http, $window, $rootScope) {
        $scope.suggestion = '';
        $scope.currSugg = '';
        $rootScope.gameId = '';
        $window.socket.on('gameLoad', function (returnData) {
            $scope.currSugg = returnData.choice;
            $rootScope.$apply($rootScope.gameId = returnData.gameId);
            console.log(returnData);
        });
        $scope.initGame = function () {
            console.log('rottentomatoes');
            $window.socket.emit('newGame', $scope.suggestion);
        }
    })
    .controller('viewCtrl', function($scope) {
        $scope.landing = true;
        $scope.joinGameView = false;
        $scope.startGameView = false;
        $scope.veto = false;
        $scope.changeView = function (view) {
            switch(view) {
                case 'landing':
                    $scope.landing = true;
                    $scope.joinGameView = false;
                    $scope.startGameView = false;
                    $scope.veto = false;
                    break;
                case 'joinGame':
                    $scope.landing = false;
                    $scope.joinGameView = true;
                    $scope.startGameView = false;
                    $scope.veto = false;
                    break;
                case 'startGame':
                    $scope.landing = false;
                    $scope.joinGameView = false;
                    $scope.startGameView = true;
                    $scope.veto = false;
                    break;
                case 'veto':
                    $scope.landing = false;
                    $scope.joinGameView = false;
                    $scope.startGameView = false;
                    $scope.veto = true;
                    break;
            }

        }
    })
    .directive('backImg', function(){
        return function(scope, element, attrs){
            attrs.$observe('backImg', function(value) {
                element.css({
                    'background-image': 'url("' + value +'")',
                    'background-size' : '100%',
                    'min-height' : '60%',
                    'max-height' : '60%',
                    'min-width' : '100%',
                    '-webkit-filter': 'brightness(50%) blur(7.5px)'
                });
            });
        };
    });