const bodyParser = require('body-parser');
const express = require('express');
const http = require('http');
const {v4: uuidv4} = require('uuid');
const redis = require('redis')

const globalDataStore = {}

const server = express();

server.use(bodyParser.raw({inflate: true}))

// for security purpose, remove x-powered-by header
server.disable('x-powered-by');

// endpoint routing configuration

server.get('/', (req, res) => {
  res.writeHead(200, { "Content-Type": "application/json"});
  const headersData = JSON.stringify(res.getHeaders());
  res.write(headersData);
  res.end();
});

function stubbedprocessfn (res, benchmarkline) {
  if (Math.random() * 100 > benchmarkline) {
    res.status(200);
    res.write('ok');
  } else {
    res.status(500);
    res.write('not ok');
  }
}

server.get('/stubbed-process-1', (req, res) => {
  stubbedprocessfn(res, 20)
  res.end();
});

server.get('/stubbed-process-2', (req, res) => {
  stubbedprocessfn(res, 40)
  res.end();
});

server.get('/stubbed-process-3', (req, res) => {
  stubbedprocessfn(res, 60)
  res.end();
});

server.get('/stubbed-process-4', (req, res) => {
  stubbedprocessfn(res, 80)
  res.end();
});

server.post('/save', (req, res) => {
  let chunks = '';
  // TODO: check input data to avoid any possible bad characters or linebreaks?
  req.on('data', (data) => (data != undefined) ? chunks += data : null);
  req.on('end', () => {
    const requestId = uuidv4();
    // TODO: change to use shared redis to store data, to support horizontal scaling?
    // saving to memory only works till max allowed memory..
    globalDataStore[requestId] = String(chunks);
    res.send(requestId);
  });
});

// add extra endpoint to handle case where no uuid is passed
server.get('/load', (req, res) => {
  res.status(404);
  res.write('not found');
  res.end();
});

server.get('/load/:uuid', (req, res) => {
  const requestId = req.params.uuid;
  const globalDataInstance = globalDataStore[requestId];
  if (globalDataInstance !== undefined && globalDataInstance !== null) {
    res.status(200);
    res.write(globalDataInstance);
    res.end();
    return;
  }
  res.status(404);
  res.write('not found');
  res.end();
});

// healthcheck function
// moving self healthcheck to docker healthcheck
// optionally use healthcheck function when env var HEALTHCHECK_TARGET_URL is defined

process.env.HEALTHCHECK_TARGET_URL && (function check() {
  const targetServce = process.env.HEALTHCHECK_TARGET_URL;
  console.log(`pinging ${targetServce}...`)
  http.get(targetServce, (res) => {
    let chunks = '';
    res.on('data', (data) => (data != undefined) ? chunks += data : null);
    res.on('end', () => {
      const data = String(chunks);
      console.log(`body data: ${data}`);
    })
  })
  setTimeout(check, (process.env.HEALTHCHECK_TARGET_INTERVAL||1000));
})();

// start the server
// allow override of listening port with some env var NODE_PORT?

server.listen(3000);
