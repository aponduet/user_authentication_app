const express = require('express');
const cors = require('cors');
const bodyParser = require("body-parser");
require('dotenv').config();
require('./db_config/db');
const routes = require('./routes/routes.js');

 

const app = express();
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true })); 


app.use(cors()); 


routes(app);
const port = process.env.PORT || 3000;
app.get('/', (req, res)=>{
res.send("Congratulation, You have succesfully Reached")
})

app.listen(port , ()=>{
    console.log(`Server Lintening on port ${port}`);
})


