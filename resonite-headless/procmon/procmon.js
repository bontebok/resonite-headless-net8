const subProcess = require("child_process");
const WebSocketServer = require('ws');

const wss = new WebSocketServer.Server({ port: 8080 });

const timeout = 100; // 100ms timeout to process buffer
const lines = 12;
const columns=180;

//const cmd = "top -bi -H -p 12206";
const cmd = "top";
const args = ["-b","-wi","-H","-p 1"];

let timer;
let buffer = Buffer.alloc(0);

const sendProc = () => {
  const str = buffer.toString();
  const lines = str.split('\n');

  buffer = Buffer.alloc(0);

  while (lines[0] == '') lines.splice(0,1); // Remove leading spaces

  wss.clients.forEach((client) => {
    client.send(lines.join('\n'));
  });
}

const topProcess = subProcess.spawn(cmd,args, {env: {LINES:lines, COLUMNS:columns}}); // Spawn top

//topProcess.on("exit", () => console.log("the top command finished"));

topProcess.stdout.on("data", (data) => {
  // Data came in, set a timer to process it
  buffer = Buffer.concat([buffer,data]);
  clearTimeout(timer);
  timer = setTimeout(sendProc,timeout);
});
