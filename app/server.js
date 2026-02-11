const http = require('http');
const os = require('os');
const PORT = process.env.PORT || 8080;

http.createServer((req, res) => {
  res.writeHead(200, { 'Content-Type': 'text/html' });
  res.end(`
    <html>
      <body style="font-family: Arial, sans-serif; text-align: center; padding: 50px;">
        <h1>🚀 Hello from GKE!</h1>
        <p>Served by pod: ${os.hostname()}</p>
        <p>Timestamp: ${new Date().toISOString()}</p>
        <p>Version: ${process.env.IMAGE_TAG || 'unknown'}</p>
      </body>
    </html>
  `);
}).listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
