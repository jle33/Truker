<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Maps.aspx.cs" Inherits="cecs521_website.maps" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript" src="http://maps.googleapis.com/maps/api/js?sensor=false"></script>
    <script type="text/javascript">
        $(function () {
            navigator.geolocation.getCurrentPosition(showPosition, positionError);
            function showPosition(position) {
                var coordinates = position.coords;
                $("#lat").val(coordinates.latitude);
                $("#lon").val(coordinates.longitude);
            }

            function positionError(position) {
                alert("Opps! Error: " + position.code);
            }
        });
    </script>

    <script type="text/javascript">
 
        $(function () {
           /* $("#autolocation").hide();
            $("#manloc").hide();
            $("#nbd").hide();
            $("#tbleid").hide();
            $("#showDriverDiv").hide();
            $("#driverListView").attr("visibility", "hide");*/
            $("#hidebut").hide();

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
                var lat = $("#<%=lat.ClientID%>");
                var lon = $("#<%=lon.ClientID%>");
                lat.val(coordinates.latitude);
                lon.val(coordinates.longitude);
                setLocation(coordinates.latitude, coordinates.longitude);
                
                $("#nbd").show();
                $("#tbleid").show();
                $("#showDriverDiv").show();
                $("#driverListView").attr("visibility", "visible");
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

        $(function () {
            $("#submitZip").click(function () {
                var zip = $("#zip").val();
                codeZip(zip);
            });

            $("#submitAddress").click(function () {
                var address = $("#address").val();
                codeAddress(address);

                
            });

            $("#RefreshMap").click(function () {
                var lat = $("#<%=lat.ClientID%>");
                var lon = $("#<%=lon.ClientID%>");
                setLocation(lat.val(), lon.val());
                addTruckDrivers();

            });
        });


    </script>

    <script type="text/javascript">
    <!--Google Map Functions -->
    var map;
    var markers = [];
    var geocoder;
    var infoWindow_glo = [];

    function InitializeMap() {
        geocoder = new google.maps.Geocoder();
        var latlng = new google.maps.LatLng(34.080026, -118.071875);
        var myOptions = {
            zoom: 12,
            center: latlng,
            mapTypeId: google.maps.MapTypeId.ROADMAP
        };
        map = new google.maps.Map(document.getElementById("map"), myOptions);
    }
    window.onload = InitializeMap;
    function setLocation(lat, lng) {
        var latlng = new google.maps.LatLng(lat, lng);
        map.setCenter(latlng);
        map.setZoom(15);
        addSelfMarker("Your Location",latlng);
    }
    function codeZip(zipCode) {
        deleteMarkers();
        geocoder.geocode({ 'address': zipCode, 'region': 'us' }, function (results, status) {
            if (status == google.maps.GeocoderStatus.OK) {
                map.setCenter(results[0].geometry.location);
                addMarker("",results[0].geometry.location);
            }
            else {
                alert("Geocode was no successful: error " + status);
            }
        });
    }

    function codeAddress(addr) {
        var loc = [];
        deleteMarkers();
        geocoder.geocode({ 'address': addr, 'region': 'us' }, function (results, status) {
            if (status == google.maps.GeocoderStatus.OK) {
                map.setCenter(results[0].geometry.location);
                addMarker("Your Location", results[0].geometry.location);
                loc[0] = results[0].geometry.location.lat();
                loc[1] = results[0].geometry.location.lng();
                var lat = $("#<%=lat.ClientID%>");
                var lon = $("#<%=lon.ClientID%>");
                lat.val(loc[0]);
                lon.val(loc[1]);
                
            }
            else {
                alert("Geocode was no successful: error " + status);
            }
        });
    }
     function getlatlng(addr) {
        var loc = [];
        geocoder.geocode({ 'address': addr, 'region': 'us' }, function (results, status) {
            if (status == google.maps.GeocoderStatus.OK) {
                loc[0] = results[0].geometry.location.lat();
                loc[1] = results[0].geometry.location.lng();
                $.post('createxml.php', { plat: loc[0], plng: loc[1] });
                alert("Request to destination " + addr+ " has been sent.");
            }
            else {
                alert("Geocode was no successful: error " + status);
            }
        });
    }


    function addTruckDrivers() {
        var xmlURL = "locations.xml";
        downloadUrl(xmlURL, function (data) {
            var markers = data.documentElement.getElementsByTagName("location");
            for (var i = 0; i < markers.length; i++) {
                var latlng = new google.maps.LatLng(parseFloat(markers[i].getAttribute("lat")), parseFloat(markers[i].getAttribute("lng")));
                var contentString = '<div id="content" style="font-size: large; font-style: normal; color: black">' +
                                    '<h2>' + markers[i].getAttribute("name") + '</h2>'
                                    +'<p><b>' + markers[i].getAttribute("phone") + '</b> <br>'+
                "<table>" +
                "<tr><td>Your Name:</td> <td><input type='text' id='gname'/> </td> </tr>" +
                "<tr><td>Phone: </td> <td><input type='text' id='gphone'/></td> </tr>" +
                "<tr><td>Dest: Address</td> <td><input type='text' id='gaddress' /></td> </tr>" +
                "<tr><td></td><td><input id='spbutn' type='button' value='Request & Close' onclick='saveData()'/></td></tr>" + '</p> </div>';
                addMarker(contentString, latlng);
            }
        });
        map.setZoom(12);
    }
    
    function addMarker(name, location) {
        var contentname = name;
        
        var infowindow;
        var marker = new google.maps.Marker({
            position: location,
            map: map
        });
        google.maps.event.addListener(marker, "click", function () {
            if (infowindow) infowindow.close();
            infowindow = new google.maps.InfoWindow({ content: contentname });
            infowindow.open(map, marker);
            infoWindow_glo.push(infowindow);
        });
        markers.push(marker);

    }
    
    function addSelfMarker(name, location) {
        var contentname = document.createElement("div");
        contentname.innerHTML = '<font size="4" color="black" >' + name + '</font>';
        var infowindow;
        var marker = new google.maps.Marker({
            position: location,
            map: map
        });
        
        if (infowindow) infowindow.close();
        infowindow = new google.maps.InfoWindow({ content: contentname });
        infowindow.open(map, marker);
       
        markers.push(marker);

    }

    function setMapOnAll(map) {
        for (var i = 0; i < markers.length; i++) {
            markers[i].setMap(map);
        }
    }

    function clearMarkers() {
        setMapOnAll(null);
    }

    function showMarkers() {
        setMapOnAll(map);
    }
    function deleteMarkers() {
        clearMarkers();
        markers = [];
    }
    function saveData() {
        var name = document.getElementById("gname").value;
        var phone = document.getElementById("gphone").value;
        var address = document.getElementById("gaddress").value;
        getlatlng(address);
        for (var i = 0; i < infoWindow_glo.length; i++) {
            infoWindow_glo[i].close();
        }
        /*
        var url = "phpsqlinfo_addrow.php?cusID=" + 1 + "&dest_latitude=" + loc[0] +
           "&dest_longitude=" + loc[1];
        downloadUrl(url, function (data, responseCode) {
            if (responseCode == 200 && data.length >= 1) {
                infoWindow_glo.close();
            }
        });*/
        
        /*
        var v = new XMLWriter();

        
        v.writeStartDocument(true);
        v.writeElementString('Contact', '');
        v.writeAttributeString('name', name);
        v.writeAttributeString('phone', phone);
        v.writeAttributeString('address', address);
        v.writeEndDocument();

        alert("Request Sent Driver On The Ways");*/
    }


    </script>
    
    <script type="text/javascript">
        <!--XML Functions -->
       

        function createXmlHttpRequest() {
            try {
                if (typeof ActiveXObject != 'undefined') {
                    return new ActiveXObject('Microsoft.XMLHTTP');
                } else if (window["XMLHttpRequest"]) {
                    return new XMLHttpRequest();
                }
            } catch (e) {
                changeStatus(e);
            }
            return null;
        };
        
        function downloadUrl(url, callback) {
            var status = -1;
            var request = createXmlHttpRequest();
            if (!request) {
                return false;
            }

            request.onreadystatechange = function () {
                if (request.readyState == 4) {
                    try {
                        status = request.status;
                    } catch (e) {

                    }
                    if (status == 200) {
                        callback(request.responseXML, request.status);
                        request.onreadystatechange = function () { };
                    }
                }
            }
            request.open('GET', url, true);
            try {
                request.send(null);
            } catch (e) {
                changeStatus(e);
            }
        };
        
        function xmlParse(str) {
            if (typeof ActiveXObject != 'undefined' && typeof GetObject != 'undefined') {
                var doc = new ActiveXObject('Microsoft.XMLDOM');
                doc.loadXML(str);
                return doc;
            }

            if (typeof DOMParser != 'undefined') {
                return (new DOMParser()).parseFromString(str, 'text/xml');
            }

            return createElement('div', null);
        }
    </script>

    <h2>Trucks that are currently near you:</h2>
    <div id="accessLocation">
        We would like to access your current location. (Click no to provide address or zip code manually below)
        <input id="yesLocation" type="button" value="Yes" />
        <!--<input id="noLocation" type="button" value="No" /> -->
    </div>
    <p>Your current location:</p>
    <div id="autolocation">
        <ul>
            <li>
                <div style="float: left; width: 106px">
                    Latitude
                </div>
                <input id="lat" type="text" runat="server"/>
            </li>
            <li>
                <div style="float: left; width: 106px">
                    Longitude
                </div>
                <input id="lon" type="text" runat="server"/>
            </li>
                <p><br /> Not your location? Enter an address to be picked up from. </p>
            <li>
                <input id="address" type="text"/>
                <input id="submitAddress" type="button" value="Get Location" />
            </li>
                 
        </ul>
    </div><!---
    <div id="manloc">
        Enter the address or zip of your current location:
        <input id="zip" type="text" />
        <input id="submitZip" type="button" value="Get Location" />
    </div> -->
    <div id="map" style="height: 447px">
    </div>
    <div  id="showDriverDiv" style="height: 44px">
        <asp:Button ID="refreshDriver" Text="Lookup trucks within" runat="server" AutoPostBack="false" OnClick="refreshDriver_Click"/>
        <asp:TextBox ID="distanceBox" Text="30" runat="server" />
        Miles&nbsp;
        <input id="RefreshMap" type="button" value="Show Map Markers" />
        </div>
        
    <h3 id="nbd">Nearby Drivers</h3>
    <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:cecs521_dbConnectionString %>" ProviderName="<%$ ConnectionStrings:cecs521_dbConnectionString.ProviderName %>" SelectCommand="SELECT driverID, firstname,  lastname, email, phone, truck_size, driverID as distance, latitude, longitude FROM truck_driver AS td INNER JOIN person AS p ON td.p_id = p.id ORDER BY firstname LIMIT 0, 0"></asp:SqlDataSource>
    <table id="tbleid" class="table table-striped table-hover " >
        <thead>
            <tr style="font-size: large; font-style: normal; text-align: left">
                <th>Name</th>
                <th>Phone
                </th>
                <th>Email
                </th>
                <th>Truck Size
                </th>
                <th>Distance
                </th>
                <th> Latitude Longitude
                </th>
            </tr>
        </thead>
        <tbody>
            <asp:ListView ID="driverListView" runat="server" DataSourceID="SqlDataSource1">
                <ItemTemplate>
                    <tr style="font-size: large; font-style: normal; text-align: left">
                        <td>
                            <a style="font-size: large; font-style: normal; text-align: left"<!--href="/About.aspx"-->>
                                <%# Eval("firstname").Equals(null) ? "NA" : Eval("firstname") %>  <%# Eval("lastname").Equals(null) ? "NA" : Eval("lastname") %>
                            </a>
                        </td>
                        <td>
                            <b style="font-size: large; font-style: normal; text-align: left">
                                <a>
                                    <%# Eval("phone") == null ? "NA" : Eval("phone") %> 
                                </a>
                            </b>
                        </td>
                        <td>
                            <%# Eval("email").Equals(null) ? "NA" : Eval("email") %>  
                        </td>
                        <td>
                            <%# Eval("truck_size").Equals(null) ? "NA" : Eval("truck_size") %>
                        </td>
                        <td>
                            <%# Eval("distance") == null ? "NA" : Eval("distance") %>
                        </td>
                        <td>
                                 <%# Eval("latitude").Equals(null) ? "NA" : Eval("latitude")  %> <%# Eval("longitude").Equals(null) ? "NA" : Eval("longitude") %>
                        </td>
                    </tr>
                </ItemTemplate>
            </asp:ListView>
        </tbody>
    </table>

</asp:Content>
