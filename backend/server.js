// const express = require('express');
// const http = require('http');
// const socketIO = require('socket.io');
// const cors = require('cors');

// const app = express();
// app.use(cors());
// app.use(express.json()); // in case you want to accept JSON POSTs later

// const server = http.createServer(app);
// const io = socketIO(server, {
//   cors: {
//     origin: '*',
//   },
// });

// // Pages with duration in seconds
// const pages = [
//   { page: 1, duration: 60 },
//   { page: 2, duration: 10 },
//   { page: 3, duration: 10 },
// ];

// let currentPageIndex = 0;
// let timer = null;

// let registeredUsers = []; // { name: string, numbers: number[] }

// function generateDrawnNumbers() {
//   const numbers = new Set();
//   while (numbers.size < 20) {
//     numbers.add(Math.floor(Math.random() * 80) + 1);
//   }
//   return Array.from(numbers);
// }

// // function emitPageChange() {
// //   const currentPage = pages[currentPageIndex];
// //   console.log(`Switching to page ${currentPage.page} for ${currentPage.duration} seconds`);

// //   // For page 1, generate drawn numbers and send with event
// //   if (currentPage.page === 1) {
// //     const drawnNumbers = generateDrawnNumbers();
// //     // Clone currentPage to avoid mutating the original page object permanently
// //     const pageData = { ...currentPage, drawnNumbers };
// //     console.log('Drawn Numbers:', drawnNumbers);

// //     io.emit('pageChange', pageData);
// //   } else {
// //     io.emit('pageChange', currentPage);
// //   }

// //   // Clear registered users on page change (optional)
// //   registeredUsers = [];
// //   io.emit('registeredUsers', registeredUsers);

// //   timer = setTimeout(() => {
// //     currentPageIndex = (currentPageIndex + 1) % pages.length;
// //     emitPageChange();
// //   }, currentPage.duration * 1000);
// // }
// let drawnNumbers = [];

// function emitPageChange() {
//   const currentPage = pages[currentPageIndex];
//   console.log(`Switching to page ${currentPage.page} for ${currentPage.duration} seconds`);

//   const pageData = { ...currentPage };

//   if (currentPage.page === 1) {
//     drawnNumbers = generateDrawnNumbers();
//     pageData.drawnNumbers = drawnNumbers;
//     console.log('Drawn Numbers:', drawnNumbers);
//   } else {
//     pageData.drawnNumbers = drawnNumbers;
//   }

//   // ✅ Clear users ONLY at the START of Page 3
//   if (currentPage.page === 3) {
//     console.log('🧹 Clearing users before Page 3 begins');
//     registeredUsers = [];
//     io.emit('registeredUsers', registeredUsers);
//   }

//   // ✅ Emit page change
//   io.emit('pageChange', pageData);

//   timer = setTimeout(() => {
//     currentPageIndex = (currentPageIndex + 1) % pages.length;
//     emitPageChange();
//   }, currentPage.duration * 1000);
// }


// io.on('connection', (socket) => {
//   console.log('Client connected:', socket.id);

//   // Send current page immediately on connect
//   const currentPage = pages[currentPageIndex];
//   if (currentPage.page === 1) {
//     const drawnNumbers = generateDrawnNumbers();
//     socket.emit('pageChange', { ...currentPage, drawnNumbers });
//   } else {
//     socket.emit('pageChange', currentPage);
//   }

//   // Send current registered users
//   socket.emit('registeredUsers', registeredUsers);

//   // Handle user registration from client
//   socket.on('registerUser', (data) => {
//     // Validate data
//     if (
//       data &&
//       typeof data.name === 'string' &&
//       Array.isArray(data.numbers) &&
//       data.numbers.every(num => typeof num === 'number')
//     ) {
//       // Prevent duplicate by name (optional)
//       const exists = registeredUsers.find(u => u.name === data.name);
//       if (!exists) {
//         registeredUsers.push({
//           name: data.name,
//           numbers: data.numbers,
//         });
//         console.log(`User registered: ${data.name} with numbers: ${data.numbers.join(', ')}`);

//         // Broadcast updated registered users list to all clients
//         io.emit('registeredUsers', registeredUsers);
//       } else {
//         console.log(`Duplicate user registration attempt: ${data.name}`);
//       }
//     } else {
//       console.log('Invalid registration data received:', data);
//     }
//   });

//   socket.on('disconnect', () => {
//     console.log('Client disconnected:', socket.id);
//   });
// });

// server.listen(3001, () => {
//   console.log('Server running on port 3001');
//   emitPageChange();
// });


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


server.listen(8003, '0.0.0.0', () => {
  console.log('🚀 Server running on http://192.168.43.119:8000');
  emitPageChange(io);
});

