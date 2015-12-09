
$(function () {
    $("#autolocation").hide();
    $("#manloc").hide();

    $("#yesLocation").click(function () {
        $("#accessLocation").hide();
        $("#autolocation").show();
        $("#manloc").hide();
        var options = {
            enableHighAccuracy: true,
            timeout: 20000,
            MaximumAge: 2000
        };
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(showPosition, positionError, options);
        }
        else {
            showNoLocation();
        }
    });
    $("#noLocation").click(function () {
        showNoLocation();
    });

    function showNoLocation() {
        $("#accessLocation").hide();
        $("#autolocation").hide();
        $("#manloc").show();
    }

    function showPosition(position) {
        var coordinates = position.coords;
        $("#autolocation").show();
        $("#lat").val(coordinates.latitude);
        $("#lon").val(coordinates.longitude);
    }

    function positionError(position) {
        switch (position.code) {
            case 0:
                showNoLocation();
                break;
            case 1:
                showNoLocation();
                break;
            case 2:
                showNoLocation();
                break;
            default:
                break;
        }

    }
});