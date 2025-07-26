
const express = require('express');
const http = require('http');
const socketIO = require('socket.io');
const cors = require('cors');

const { setupSocket } = require('./socket/socketHandlers');
const { emitPageChange } = require('./controllers/pageController');

const app = express();
app.use(cors());
app.use(express.json());

const server = http.createServer(app);
const io = socketIO(server, {
  cors: {
    origin: '*',
  },
});
app.get('/', (req, res) => {
  res.send('Hello from backend');
});
setupSocket(io);


// server.listen(8003, '0.0.0.0', () => {
//   console.log('🚀 Server running on http://192.168.43.119:8000');
//   emitPageChange(io);
// });
// Use dynamic PORT for Render
const PORT = process.env.PORT || 8003;
server.listen(PORT, () => {
  console.log(`🚀 Server running on http://localhost:${PORT}`);
  emitPageChange(io);
});


