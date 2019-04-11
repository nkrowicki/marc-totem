let express = require("express"),
  path = require("path"),
  fs = require("fs"),
  app = express(),
  // getting port this way
  port = process.env.PORT || process.argv[2] || 8080;

let publicDirectory = "/home/pi/marc-totem/frontend/public",
  publicImgDirectory = "imgs",
  imgDirectory = path.join(publicDirectory, publicImgDirectory),
  arrayWithPublicPathImgs = [];

// using app.use to use static files in my public
// folder for the root level of the site
app.use("/", express.static(publicDirectory));

// Return array with public path images
app.get("/getImages", (req, res) => {
  // Filter the results to only return the files, and exclude the folders
  const isFile = fileName => {
    return fs.lstatSync(fileName).isFile();
  };

  // Filter the results to only return files jpg and png
  const isImg = fileName =>
    [".jpg", ".png"].includes(path.extname(fileName).toLowerCase());

  // Push all images in array
  arrayWithPublicPathImgs = fs
    // Read the contents of a directory
    .readdirSync(imgDirectory)
    // Join imgDirectory with fileName
    .map(fileName => path.join(imgDirectory, fileName))
    // Filter only files (not folders)
    .filter(isFile)
    // Filter only jpg or png files
    .filter(isImg)
    // Join publicImgDirectory with fileName
    .map(relativePath =>
      path.join(publicImgDirectory, path.basename(relativePath))
    );

  // Send array with
  res.send(arrayWithPublicPathImgs);
});

app.listen(port, function() {
  console.log("app up on port: " + port);
});
