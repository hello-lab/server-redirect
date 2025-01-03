const express = require('express');
const bodyParser = require('body-parser');

const app = express();
const PORT = 3000;

let tunnelUrl = ''; // Variable to store the received URL

// Middleware
app.use(bodyParser.json());


app.get('/', (req, res) => { 

    res.redirect(tunnelUrl)
   })

// Endpoint to receive Cloudflare Tunnel URL
app.post('/tunnel-url', (req, res) => {
    var { url } = req.body;
logLine=String(url);
console.log(logLine);
// Regular expression to match a URL
const urlRegex = /(https?:\/\/[^\s]+)/;

// Extract the URL
const match = logLine.match(urlRegex);

if (match) {
    const url = match[0];
    
    console.log(`Received Cloudflare Tunnel URL: ${url}`);
    tunnelUrl = url; // Store the URL
} else {
    console.log("No URL found in the string.");
}
    res.status(200).send('URL received successfully.');
});



// Start the server
app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});
