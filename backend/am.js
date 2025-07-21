// function generateProfitableNumbers(userSelections, totalDraws = 20, numberRange = 80) {
//   // Step 1: Sanitize user input to keep numbers in [1–80]
//   const sanitizedUsers = userSelections.map(numbers =>
//     numbers.filter(num => num >= 1 && num <= numberRange)
//   );

//   // Step 2: Count frequency of each number across users
//   const numberFrequency = Array(numberRange + 1).fill(0); // index 0 unused

//   sanitizedUsers.forEach(numbers => {
//     numbers.forEach(num => {
//       numberFrequency[num]++;
//     });
//   });

//   // Step 3: Create frequency list [number, frequency]
//   const numberStats = [];
//   for (let i = 1; i <= numberRange; i++) {
//     numberStats.push({ number: i, count: numberFrequency[i] });
//   }

//   // Step 4: Sort least picked first (for profit)
//   numberStats.sort((a, b) => a.count - b.count);

//   // Step 5: Randomly pick from top 40 least-used numbers
//   const selectionPool = numberStats.slice(0, 40);
//   const selectedNumbers = [];

//   while (selectedNumbers.length < totalDraws) {
//     const rand = selectionPool[Math.floor(Math.random() * selectionPool.length)].number;
//     if (!selectedNumbers.includes(rand)) {
//       selectedNumbers.push(rand);
//     }
//   }

//   selectedNumbers.sort((a, b) => a - b);

//   // Step 6: Determine winners
//   const potentialWinners = sanitizedUsers.map((userNumbers, index) => {
//     const matched = userNumbers.filter(num => selectedNumbers.includes(num));
//     return { userIndex: index, matches: matched };
//   }).filter(winner => winner.matches.length > 0);

//   // Step 7: Return only top 2 winners with highest match count
//   const winners = potentialWinners
//     .sort((a, b) => b.matches.length - a.matches.length)
//     .slice(0, 2); // most likely 2 users to win

//   return {
//     drawnNumbers: selectedNumbers,
//     winners,
//   };
// }
// const users = [
//   [1, 4, 6], 
//   [67, 54, 2],
//   [1, 3, 5, 7],
//   [10, 20, 30],
//   [81, 82, 83], // will be ignored
//   [12, 18, 19],
//   [2, 3, 5],
//   [60, 61, 62],
//   [70, 71, 72]
// ];

// const result = generateProfitableNumbers(users);
// console.log("🎯 Drawn Numbers:", result.drawnNumbers);
// console.log("🏆 Top 2 Likely Winners:");
// result.winners.forEach(winner => {
//   console.log(`- User #${winner.userIndex + 1} matched: [${winner.matches.join(', ')}]`);
// });


function generateProfitableNumbers(userSelections, totalDraws = 20, numberRange = 80) {
  const sanitizedUsers = userSelections.map(user => ({
    name: user.name,
    numbers: user.numbers.filter(num => num >= 1 && num <= numberRange),
  }));

  const numberFrequency = Array(numberRange + 1).fill(0);

  sanitizedUsers.forEach(user => {
    user.numbers.forEach(num => {
      numberFrequency[num]++;
    });
  });

  const numberStats = [];
  for (let i = 1; i <= numberRange; i++) {
    numberStats.push({ number: i, count: numberFrequency[i] });
  }

  numberStats.sort((a, b) => a.count - b.count);

  const selectionPool = numberStats.slice(0, 40);
  const selectedNumbers = [];

  while (selectedNumbers.length < totalDraws) {
    const rand = selectionPool[Math.floor(Math.random() * selectionPool.length)].number;
    if (!selectedNumbers.includes(rand)) {
      selectedNumbers.push(rand);
    }
  }

  selectedNumbers.sort((a, b) => a - b);

  const potentialWinners = sanitizedUsers.map((user, index) => {
    const matched = user.numbers.filter(num => selectedNumbers.includes(num));
    return { userIndex: index, name: user.name, matches: matched };
  }).filter(w => w.matches.length > 0);

  // Calculate number of winners: 1 winner for every 10 users (rounded down)
  const winnersCount = Math.floor(userSelections.length / 10);
  const winners = potentialWinners
    .sort((a, b) => b.matches.length - a.matches.length)
    .slice(0, winnersCount > 0 ? winnersCount : 1); // minimum 1 winner if any match

  return {
    drawnNumbers: selectedNumbers,
    winners,
  };
}

module.exports={generateProfitableNumbers}