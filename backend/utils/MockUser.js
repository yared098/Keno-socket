const { generateProfitableNumbers } = require('./generateProfitableNumbers');

function generateMockUsers(userCount = 100, numberRange = 80, picksPerUser = 10) {
  const users = [];
  for (let i = 1; i <= userCount; i++) {
    const numbers = new Set();
    while (numbers.size < picksPerUser) {
      numbers.add(Math.floor(Math.random() * numberRange) + 1);
    }
    users.push({
      name: `User${i}`,
      numbers: Array.from(numbers),
    });
  }
  return users;
}

// Generate 100 mock users
const mockUsers = generateMockUsers(100);

// Run the function
const result = generateProfitableNumbers(mockUsers);

// Output the result
console.log('🎯 Drawn Numbers:', result.drawnNumbers);
console.log('🏆 Winners:', result.winners.map(w => ({
  name: w.name,
  matchCount: w.matches.length,
  matches: w.matches,
})));
