const express = require('express');
const http = require('http');
const socketIo = require('socket.io');

// Create a new Express application
const app = express();

// Create an HTTP server and bind it to the Express app
const server = http.createServer(app);

// Initialize Socket.io with the HTTP server
const io = socketIo(server);

// Serve a basic HTML file for testing
app.get('/', (req, res) => {
  res.send('<h1>Notification Server</h1>');
});

// Function to send notifications every 30 seconds
const sendNotifications = () => {
  setInterval(() => {
    io.emit('notification', { message: 'This is a notification from the server!' });
  }, 3000); // 30000 milliseconds = 30 seconds
};

// Start sending notifications when a client connects
io.on('connection', (socket) => {
  console.log('A user connected');
  sendNotifications();

  socket.on('disconnect', () => {
    console.log('User disconnected');
  });
});

// Start the server
const PORT = process.env.PORT || 3000;
server.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
