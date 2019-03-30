// Function getJSON
var getJSON = function(url, callback) {
  var xhr = new XMLHttpRequest();
  xhr.open('GET', url, true);
  xhr.responseType = 'json';
  xhr.onload = function() {
    var status = xhr.status;
    if (status === 200) {
      callback(null, xhr.response);
    } else {
      callback(status, xhr.response);
    }
  };
  xhr.send();
};
//Variable for define time setInterval in miliseconds
let miliSecondsToScroll = 2000;

//setInterval for "auto scroll"
setInterval(function() {
  fullpage_api.moveSectionDown();
}, miliSecondsToScroll);

// Get images
getJSON('http://localhost:8080/getImages', function(err,data){
  if (err !== null) {
    console.log('Something went wrong: ' + err);
  } else {
    console.log('Response: ',  data);

    //TODO: Create element, put on html add style

  }
});  