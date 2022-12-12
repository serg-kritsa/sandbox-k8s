'use strict';

// [START all]
var http = require('http');
var handleRequest = function(request, response) {
    response.writeHead(200);
    response.end('Hello Kubernetes!');
};
var www = http.createServer(handleRequest);
www.listen(process.env.PORT || 8080);
// [END all]