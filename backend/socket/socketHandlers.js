// const { addUser, getUsers,getUserNumbers } = require('../services/userService');
// const pages = require('../config/pageConfig');
// const { generateDrawnNumbers } = require('../utils/drawUtils');

// function setupSocket(io) {
//   io.on('connection', (socket) => {
//     console.log('✅ Client connected:', socket.id);

//     const currentPage = pages[0];
//     const numbers=getUsers();
//     console.log(numbers);
//     const drawnNumbers = generateDrawnNumbers();

//     if (currentPage.page === 1) {
//         console.log(numbers);
//       socket.emit('pageChange', { ...currentPage, drawnNumbers });
//     } else {
//       socket.emit('pageChange', currentPage);
//     }

//     socket.emit('registeredUsers', getUsers());

//     socket.on('registerUser', (data) => {
//       if (
//         data &&
//         typeof data.name === 'string' &&
//         Array.isArray(data.numbers) &&
//         data.numbers.every(num => typeof num === 'number')
//       ) {
//         const success = addUser({ name: data.name, numbers: data.numbers });
//         if (success) {
//           console.log(`📥 Registered: ${data.name}`);
//           io.emit('registeredUsers', getUsers());
//         } else {
//           console.log(`⚠️ Duplicate user: ${data.name}`);
//         }
//       } else {
//         console.log('❌ Invalid registration:', data);
//       }
//     });

//     socket.on('disconnect', () => {
//       console.log('❎ Disconnected:', socket.id);
//     });
//   });
// }

// module.exports = { setupSocket };


const { addUser, getUsers, getUserNumbers } = require('../services/userService');
const pages = require('../config/pageConfig');
const { generateProfitableNumbers } = require('../utils/generateProfitableNumbers');

function setupSocket(io) {
  io.on('connection', (socket) => {
    console.log('✅ Client connected:', socket.id);

    const currentPage = pages[0];
    const users = getUsers();
    const userSelections = getUserNumbers();

    let drawnNumbers = [];
    let winners = [];

    if (currentPage.page === 1) {
      const result = generateProfitableNumbers(userSelections);
      drawnNumbers = result.drawnNumbers;
      winners = result.winners;

      console.log('🎯 Drawn Numbers:', drawnNumbers);
      console.log('🏆 Winners:', winners);

      socket.emit('pageChange', { ...currentPage, drawnNumbers, winners });
    } else {
      socket.emit('pageChange', currentPage);
    }

    socket.emit('registeredUsers', users);

    socket.on('registerUser', (data) => {
      if (
        data &&
        typeof data.name === 'string' &&
        Array.isArray(data.numbers) &&
        data.numbers.every(num => typeof num === 'number')
      ) {
        const success = addUser({ name: data.name, numbers: data.numbers });
        if (success) {
          console.log(`📥 Registered: ${data.name}`);
          io.emit('registeredUsers', getUsers());
        } else {
          console.log(`⚠️ Duplicate user: ${data.name}`);
        }
      } else {
        console.log('❌ Invalid registration:', data);
      }
    });

    socket.on('disconnect', () => {
      console.log('❎ Disconnected:', socket.id);
    });
  });
}

module.exports = { setupSocket };
