let registeredUsers = [];

function addUser(user) {
  const exists = registeredUsers.find(u => u.name === user.name);
  if (!exists) {
    registeredUsers.push(user);
    return true;
  }
  return false;
}

function getUsers() {
  return registeredUsers;
}

function clearUsers() {
  registeredUsers = [];
}

module.exports = {
  addUser,
  getUsers,
  clearUsers,
};
