const pages = require('../config/pageConfig');
const { generateDrawnNumbers } = require('../utils/drawUtils');
const { getUsers, clearUsers } = require('../services/userService');

let currentPageIndex = 0;
let timer = null;
let drawnNumbers = [];

function emitPageChange(io) {
  const currentPage = pages[currentPageIndex];
  const pageData = { ...currentPage };

  console.log(`🔄 Switching to page ${currentPage.page} for ${currentPage.duration} seconds`);

  if (currentPage.page === 1) {
    drawnNumbers = generateDrawnNumbers();
    pageData.drawnNumbers = drawnNumbers;
    console.log('🎯 Drawn Numbers:', drawnNumbers);
  } else {
    pageData.drawnNumbers = drawnNumbers;
  }

  if (currentPage.page === 3) {
    console.log('🧹 Clearing users before Page 3 begins');
    clearUsers();
    io.emit('registeredUsers', []);
  }

  io.emit('pageChange', pageData);

  timer = setTimeout(() => {
    currentPageIndex = (currentPageIndex + 1) % pages.length;
    emitPageChange(io);
  }, currentPage.duration * 1000);
}

module.exports = { emitPageChange };
