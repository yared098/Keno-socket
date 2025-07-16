const express = require('express');
const http = require('http');
const cors = require('cors');
const fs = require('fs');
const path = require('path');
const { Server } = require('socket.io');

const app = express();
const server = http.createServer(app);
app.use(cors());

const io = new Server(server, {
  cors: { origin: '*' },
});

let players = [];
let numberSequence = [];
let currentIndex = 0;
let currentNumber = null;
let interval = null;
const USERS_FILE = path.join(__dirname, 'users.json');

// Utils
function getUsers() {
  if (!fs.existsSync(USERS_FILE)) {
    fs.writeFileSync(USERS_FILE, JSON.stringify([]));
  }
  return JSON.parse(fs.readFileSync(USERS_FILE));
}

function saveUsers(users) {
  fs.writeFileSync(USERS_FILE, JSON.stringify(users, null, 2));
}

function handleRegister({ name, phone, id }) {
  let users = getUsers();
  let existing = users.find(u => u.phone === phone);

  if (!existing) {
    const newUser = {
      id,
      name,
      phone,
      balance: 10,
      board: generateBingoBoard(),
    };
    users.push(newUser);
    saveUsers(users);
    console.log(`✅ New user ${name} added with 10 ETB`);
  } else {
    console.log(`🔄 Existing user ${name} logged in`);
  }
}

function generateBingoBoard() {
  let numbers = Array.from({ length: 75 }, (_, i) => i + 1);
  numbers.sort(() => Math.random() - 0.5);
  return numbers.slice(0, 25);
}

function rewardWinner(name, reward = 5) {
  let users = getUsers();
  let user = users.find(u => u.name === name);
  if (user) {
    user.balance += reward;
    saveUsers(users);
    console.log(`🎉 ${name} wins! New balance: ${user.balance} ETB`);
    // Notify all clients about updated balance of this user
    io.emit('balance_update', { name: user.name, balance: user.balance });
  }
}

function generateNumberSequence() {
  const nums = Array.from({ length: 75 }, (_, i) => i + 1);
  return nums.sort(() => Math.random() - 0.5).slice(0, 25);
}

// SOCKET LOGIC
io.on('connection', (socket) => {
  console.log(`🔌 User connected: ${socket.id}`);
         
  socket.on('register', ({ name, phone }) => {
    handleRegister({ name, phone, id: socket.id });
    players.push({ id: socket.id, name, phone });
    io.emit('players', players);

    // Also send the user's current balance to them individually
    let users = getUsers();
    let user = users.find(u => u.name === name);
    if (user) {
      socket.emit('balance_update', { name: user.name, balance: user.balance });
    }
  });

  socket.on('start_game', () => {
    numberSequence = generateNumberSequence();
    currentIndex = 0;

    io.emit('number_list', numberSequence); // send full list to all
    console.log("🎮 Game started. Sending numbers...");

    if (interval) clearInterval(interval);
    interval = setInterval(() => {
      if (currentIndex < numberSequence.length) {
        currentNumber = numberSequence[currentIndex];
        io.emit('new_number', currentNumber);
        console.log(`🎲 Drawn: ${currentNumber}`);
        currentIndex++;
      } else {
        clearInterval(interval);
        console.log("🛑 All numbers sent.");
        io.emit('game_ended');  // Notify clients game ended

        // Reset for next game
        numberSequence = [];
        currentIndex = 0;
        currentNumber = null;
      }
    }, 5000); // every 5 seconds
  });

  socket.on('bingo', (playerName) => {
    rewardWinner(playerName);
    io.emit('winner', playerName);

    // Also end the game immediately when bingo is called
    if (interval) clearInterval(interval);
    io.emit('game_ended');

    // Reset for next game
    numberSequence = [];
    currentIndex = 0;
    currentNumber = null;
  });

  socket.on('disconnect', () => {
    players = players.filter((p) => p.id !== socket.id);
    io.emit('players', players);
    console.log(`❌ Disconnected: ${socket.id}`);
  });
});

server.listen(3000, () => console.log('🟢 Bingo server running on port 3000'));
