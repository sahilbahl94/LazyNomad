// $(document).ready(function(){


//  L.mapbox.accessToken = 'pk.eyJ1IjoiemFwYXRyYW4iLCJhIjoiY2loYzEyemF3MDA3bHY0a2xmemNuZDRqaiJ9.R6VwuibM7_KiMEG5HlMMFA';
//  var map = null;

//  if ("geolocation" in navigator){
//    navigator.geolocation.getCurrentPosition(onLocation, onError);
//  } else {
//    // TODO find geolocation based not on geolocation
//  }

//  function onLocation(position){
//    map = L.mapbox.map('map', 'mapbox.streets').setView([position.coords.latitude, position.coords.longitude], 17);
//    var marker = L.marker(new L.LatLng(position.coords.latitude,position.coords.longitude), {
//        icon: L.mapbox.marker.icon({
//            'marker-symbol': 'parking',
//            'marker-color': '#45A800 '
//        }),
//        draggable: true
//    });

//    marker.bindPopup('This marker is draggable! Move it around.');
//    marker.addTo(map);

//    marker.on('dragend', function(e){
//      // console.log(e);
//      // console.log(marker);
//      $('.lat').val(e.target._latlng.lat);
//      $('.lng').val(e.target._latlng.lng);
//      requestReverseGeo(e.target._latlng.lng, e.target._latlng.lat);
//    });
//  }

//  function onError(err){
//    console.log("We couldn't get position onLocation", err);
//  }

//  function requestReverseGeo(lng, lat){
//    var URL = 'https://api.mapbox.com/geocoding/v5/mapbox.places/' + lng + ',' + lat + '.json?access_token=pk.eyJ1IjoiemFwYXRyYW4iLCJhIjoiY2loYzEyemF3MDA3bHY0a2xmemNuZDRqaiJ9.R6VwuibM7_KiMEG5HlMMFA'
//    $.ajax({
//      url: URL,
//      success: handleReverseGeo,
//      error: function(){ console.log("error requesting ReverseGeo")},
//      dataType: "json"
//    });
//  }

//  function handleReverseGeo(result){
//    $('.address').val(result.features[0].place_name);
//  }

// });