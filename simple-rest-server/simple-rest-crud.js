'use strict'

/*
 * Simple REST server with CRUD.
 * See 'Node.JS in Action', 1st ed, Sec 4.2
 */

let http = require('http');
let url = require ('url');

// in memory database
let database = [];

let POST = function(req, res) {
  let item = '';
  req.setEncoding('utf8');
  req.on('data', function(chunk){item += chunk;});
  req.on('end', function(){
  database.push(item);
  res.end('OK\n');});
};

let GET = function(req, res) {
  res.setHeader('Content-Type', 'text/plain; charset="utf-8"');
  if (database.length == 0) {
    res.end('No data found.\n');
  } else {
    let body = database.map(function(item, index) {
      return `[${index}] ${item}`;
    }).join('\n') + '\n';
    res.setHeader('Content-Length', Buffer.byteLength(body));
    res.end(body);
  }
};

let DELETE = function (req, res) {
  let path = url.parse(req.url).pathname; //  '/1?/api-key=foobar' => '/1' => '1'
  let i = parseInt (path.slice(1), 10);

  if (isNaN(i)) {
    res.statusCode = 400;
    res.end('Invalid item id');
  } else if (!database[i]) {
    res.statusCode = 404;
    res.end('Item not found');
  } else {
    database.splice(i, 1);
    res.end('OK\n');
  }
};

let PUT = function(req, res) {
  let path = url.parse(req.url).pathname; //  '/1?/api-key=foobar' => '/1' => '1'
  let i = parseInt (path.slice(1), 10);

  if (isNaN(i)) {
    res.statusCode = 400;
    res.end('Invalid item id');
  } else if (!database[i]) {
    res.statusCode = 404;
    res.end('Item not found');
  } else {
    let item = ''
    req.setEncoding('utf8');
    req.on('data', function(chunk){item += chunk;});
    req.on('end', function(){
    database[i] = item;
    res.end('OK\n');});
  }
}

let server = http.createServer(function(req, res) {
  // the callback with the key matched with the request method is invoked.
  ({ 'POST': POST,
     'GET': GET,
     'DELETE': DELETE,
     'PUT': PUT
  }[req.method])(req, res);
});

server.listen(8888);
