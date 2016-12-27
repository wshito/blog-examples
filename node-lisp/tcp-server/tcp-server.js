var net = require('net');

var server = net.createServer (function(socket) {
  var address = '[' + socket.remoteAddress + ' : ' + socket.remotePort + '] ';
  console.log("Client connected: " + address);
  socket.write("Send to server > ");

  socket.on ('data', function(data) {
    if (data == 'bye\r\n')
      socket.end();
    else {
      process.stdout.write(address + data);      // console.log() adds '\n'
      socket.write("Send to server > ");
    }
  });

  // in case the peer terminates the connection unexpectedly
  socket.on ('error', function () {
      socket.removeAllListeners();
      console.log ("Client disconnected: " + address);
  });

  // thrown when client sends 'bye'
  socket.on ('end', function() {
    console.log("Client disconnected: " + address);
  });
});

server.listen(8888); // connect with 'telnet localhost 8888'
