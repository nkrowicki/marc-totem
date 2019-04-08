// Array for images
let images = [];
// Create our stylesheet
let style = document.createElement("style");
// Default image
let defaultImage = "default-image.png";
// Host
let host = window.location.hostname;

// Function getJSON
var getJSON = function(url, callback) {
  var xhr = new XMLHttpRequest();
  xhr.open("GET", url, true);
  xhr.responseType = "json";
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

var showDefaultImage = function(){
        // Add styles for default element
        style.innerHTML +=
        "\n " +
        "#default-element" + " {" +
        "background-image: url(\""+ defaultImage +"\");" +
        "}";
}



// Get images

// getJSON("http://localhost:8080/getImages", function(err, data) {
let getImages = host.concat('/getImages')
getJSON(getImages, function(err, data) {
  if (err !== null) {
    console.log("Something went wrong: " + err);

    // TODO: Open image default
    
    showDefaultImage();

  } else {
    
    images = data;
        
    // Check if array is not empty
    if (typeof images !== 'undefined' && images.length > 0) {

     images.map((img, index) => {
           
      // Create a <div> node
      var node = document.createElement("div");

      // Set attributes class, id, data-fp-styles and style
      node.setAttribute("id", "section" + index);
      node.setAttribute("class", "section fp-section");
      if(index===0) node.setAttribute("class", "section fp-section active fp-completely");
      node.setAttribute("data-fp-styles", "null");
      node.style.height = "100%";
      
      // Append <div> to <div> with id="fullpage"
      document.getElementById("fullpage").appendChild(node);
      
      
      // Add styles for this element
      style.innerHTML +=
      "\n " +
      "#section"+ index +" {" +
      "background-image: url(\""+ img +"\");" +
      "}";
      
   
    });
      
    document.querySelector("#default-element").remove()

  } else{
      // Array is empty
      showDefaultImage();
  }

  }

    // Add styles
    // Get the first script tag
    var ref = document.querySelector("head");
    // Insert our new styles before the first script tag
    ref.parentNode.insertBefore(style, ref);
});
