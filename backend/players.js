// players.js
let players = [];

function addPlayer(id, name, phone) {
  const player = { id, name, phone };
  players.push(player);
  return player;
}

function removePlayer(id) {
  players = players.filter((p) => p.id !== id);
}

function getPlayers() {
  return players;
}

module.exports = {
  addPlayer,
  removePlayer,
  getPlayers,
};
