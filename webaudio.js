var app = Elm.Main.fullscreen();

var audioCtx = new (window.AudioContext || window.webkitAudioContext)();

var audioBuffers = {};

app.ports.loadSound.subscribe(function(url) {
  var request = new XMLHttpRequest();
  request.open('GET', url, true);
  request.responseType = 'arraybuffer';

  request.onload = function() {
    audioCtx.decodeAudioData(request.response, function(buffer) {
      console.log("Loaded sound", url);
      audioBuffers[url] = buffer;
    }, function(err) {
      console.log("Failed to load " + url, err);
    });
  }
  request.send();
});


app.ports.playSound.subscribe(function(url) {
  console.log("Playing sound", url);
  var source = audioCtx.createBufferSource();
  var buffer = audioBuffers[url];
  if (buffer) {
    console.log("Playing buffer", url);
    source.buffer = buffer;
    source.connect(audioCtx.destination);
    source.start(0);
  }
});

