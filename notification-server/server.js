const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const cors = require('cors');
const http = require('http');
const socketIo = require('socket.io');
const authRoutes = require('./routes/authRoutes'); // Import auth routes
const sinistreRoutes = require('./routes/sinistreRoutes');

const app = express();
app.use(cors());
app.use(bodyParser.json());

// Connect to MongoDB
mongoose.connect('mongodb://localhost:27017/yourdbname', { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => console.log('MongoDB connected'))
  .catch(err => console.log(err));

// Use routes
app.use('/api/auth', authRoutes);
app.use('/api/sinistres', sinistreRoutes);
// Create an HTTP server and bind it to the Express app
const server = http.createServer(app);

// Initialize Socket.io with the HTTP server
const io = socketIo(server, {
  cors: {
    origin: "*", // Allow all origins
    methods: ["GET", "POST"]
  }
});

// Serve a basic HTML file for testing
app.get('/', (req, res) => {
  res.send('<h1>Notification Server</h1>');
});

// Function to send notifications every 30 seconds
const sendNotifications = () => {
  setInterval(() => {
    io.emit('notification', { message: 'This is a notification from the server!' });
  }, 30000); // 30000 milliseconds = 30 seconds
};

// Start sending notifications when the server starts
sendNotifications();

// Handle socket connection
io.on('connection', (socket) => {
  console.log('A user connected');

  socket.on('disconnect', () => {
    console.log('User disconnected');
  });
});

// Start the server
const PORT = process.env.PORT || 3000;
server.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
