
const mongoose = require("mongoose");
mongoose.Promise = global.Promise;
require('dotenv').config();

const database_connection = mongoose.connect(process.env.MONGODB_URI, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  })
  .then(() => {
    console.log("Database connection Success.");
  })
  .catch((err) => {
    console.error("Mongo Connection Error", err);
  });

  module.exports = database_connection;