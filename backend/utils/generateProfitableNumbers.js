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

  numberStats.sort((a, b) => a.count - b.count); // least frequent first

  const selectionPool = numberStats.slice(0, 80); // pick from least 40 numbers
  let selectedNumbers = [];

  const tryGenerateNumbers = () => {
    const numbers = new Set();
    while (numbers.size < totalDraws) {
      const rand = selectionPool[Math.floor(Math.random() * selectionPool.length)].number;
      numbers.add(rand);
    }
    return Array.from(numbers).sort((a, b) => a - b);
  };

  let attempt = 0;
  let winners = [];
  let drawnNumbers = [];

  const maxAttempts = 100;

  while (attempt < maxAttempts) {
    drawnNumbers = tryGenerateNumbers();

    // Match users with drawn numbers
    const potentialWinners = sanitizedUsers.map((user, index) => {
      const matches = user.numbers.filter(n => drawnNumbers.includes(n));
      return { userIndex: index, name: user.name, matches };
    }).filter(w => w.matches.length > 0);

    const userCount = userSelections.length;
    const minWinners = userCount >= 10 ? Math.max(2, Math.floor(userCount / 10)) : 1;

    if (potentialWinners.length >= minWinners) {
      winners = potentialWinners
        .sort((a, b) => b.matches.length - a.matches.length)
        .slice(0, minWinners); // select top matching users
      break;
    }

    attempt++;
  }

  return {
    drawnNumbers,
    winners,
  };
}

module.exports = { generateProfitableNumbers };
