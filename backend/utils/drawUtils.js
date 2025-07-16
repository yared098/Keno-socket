function generateDrawnNumbers() {
  const numbers = new Set();
  while (numbers.size < 20) {
    numbers.add(Math.floor(Math.random() * 80) + 1);
  }
  return Array.from(numbers);
}

module.exports = { generateDrawnNumbers };
