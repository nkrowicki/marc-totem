//Variable for define time setInterval in miliseconds
let miliSecondsToScroll = 2000;

//setInterval for "auto scroll"
setInterval(function() {
  fullpage_api.moveSectionDown();
}, miliSecondsToScroll);
