
var jwt = require('jsonwebtoken');
const { v4: uuidv4 } = require('uuid');
const otpGenerator = require('otp-generator');
const OtpTable = require("../models/otp_model.js");
const User = require("../models/user_model.js");



exports.create = (req, res)  =>  {
  // Validate request
  if (!req.body.username || !req.body.email || !req.body.password) {
    res.status(202).send({ message: "Fields can not be empty!" });
    return;
  }
  /*
  ******ERR_HTTP_HEADERS_SENT: Cannot set headers after they are sent to the client**********
  That particular error occurs whenever you try to send more than one response to the same request and is 
  usually caused by improper asynchronous code.
  */
  // Check Existance of Email address

  User.findOne({email: req.body.email})
  .then(data => {
    if (!data)
      {
        // Create a User
        const Data = new User({
          username: req.body.username,
          email: req.body.email,
          password: req.body.password,
        });
        
        // Save User in the database
        Data
          .save()
          .then(data => {
            res.send(data);
          })
          .catch(err => {
            res.status(500).send({
              message:
                err.message || "Some error occurred while creating the User."
            });
          });
            }
          else res.status(201).send({
            
            message: "Email already in use!!"
          });
          console.log(data);
        })
        .catch(err => {
          res
            .status(500)
            .send({ message:err });
        });
};

// User Login Controller
exports.login = (req, res)  =>  {
  // Validate request
  if (!req.body.email || !req.body.password) {
    res.status(202).send({ message: "Fields can not be empty!" });
    return;
  }
  /*
  ******ERR_HTTP_HEADERS_SENT: Cannot set headers after they are sent to the client**********
  That particular error occurs whenever you try to send more than one response to the same request and is 
  usually caused by improper asynchronous code.
  */
  // Check Existance of Email address

  User.findOne({email: req.body.email, password: req.body.password})
  .then(data => {
   
    if (data)
      {
        var payload = {
          username: data.username,
        };
        
        var KEY = uuidv4();
        var token = jwt.sign(payload, KEY, {algorithm: 'HS256', expiresIn: "15d"});
        // send User Info: 
        res.json({
          "jwt": token,
          "username": data.username,
          "email": data.email,
        });
            }
          else res.status(201).send({
            message: "User not Found!!"
          });
        })
        .catch(err => {
          res
            .status(500)
            .send({ message:err });
        });
};


// Check Email Address and Send OTP to the client Server
exports.checkEmailSendOTP = (req, res)  =>  {
  // Validate request
  if (!req.body.email) {
    res.status(202).send({ message: "Fields can not be empty!" });
    return;
  }
  /*
  ******ERR_HTTP_HEADERS_SENT: Cannot set headers after they are sent to the client**********
  That particular error occurs whenever you try to send more than one response to the same request and is 
  usually caused by improper asynchronous code.
  */
  // Check Existance of Email address


  User.findOne({email: req.body.email})
  .then(data => {
    if (data)
      {
        const OTP = otpGenerator.generate(4, {lowerCaseAlphabets:false,upperCaseAlphabets:false,specialChars:false})
        const filter = { email: req.body.email};
        const update = { otp: OTP };
        OtpTable.findOneAndUpdate(filter,update,{new:true,upsert:true})
        .then(
          value=>{
            res.send(value)
          }
        )
        .catch(err => {
          res
            .status(500)
            .send({ message: err });
        }

        );
      }
      else res.status(201).send({
        message: "User not Found!!"
      });
    })
  .catch(err => {
    res
      .status(500)
      .send({ message:err });
  });
};



// OTP Verification Codes
exports.otpverification = (req, res)  =>  {
  // Validate request
  if (!req.body.otp) {
    res.status(202).send({ message: "OTP Fields can not be empty!" });
    return;
  }
  /*
  ******ERR_HTTP_HEADERS_SENT: Cannot set headers after they are sent to the client**********
  That particular error occurs whenever you try to send more than one response to the same request and is 
  usually caused by improper asynchronous code.
  */
  // Check Existance of Email address


  OtpTable.findOne({email: req.body.email})
  .then(data => {
    if (data)
      {
        const clientOtp = req.body.otp;
        const serverOtp = data.otp;
        if (clientOtp==serverOtp) {
          res.status(206).send({message: "OTP Successfully matched :) "});
        } else {
          res.status(207).send({message: "OTP Does not matche "});
        }

      }
      else res.status(201).send({
        message: "User not Found!!"
      });
    })
  .catch(err => {
    res
      .status(500)
      .send({ message:err });
  });
};






// Password Update Codes
exports.updatepass = (req, res)  =>  {
  // Validate request
  if (!req.body.password) {
    res.status(202).send({ message: "Password must not be empty" });
    return;
  }
  /*
  ******ERR_HTTP_HEADERS_SENT: Cannot set headers after they are sent to the client**********
  That particular error occurs whenever you try to send more than one response to the same request and is 
  usually caused by improper asynchronous code.
  */
  // Check Existance of Email address

  const filter = {email: req.body.email};
  const update = {password: req.body.password};

  User.findOneAndUpdate(filter,update,{new:true})
  .then(data => {
    if (data)
      {
        res.send({message: "Password Successfully Updated :) "});
      }
      else res.status(201).send({
        message: "Password Update Failded"
      });
    })
  .catch(err => {
    res
      .status(500)
      .send({ message:err });
  });
};


