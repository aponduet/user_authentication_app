module.exports = (app) => {
    const controllers = require("../controllers/controllers.js");
  
    app.post("/create", controllers.create);
    app.post("/login", controllers.login);
    app.post("/account", controllers.checkEmailSendOTP);
    app.post("/otpverification", controllers.otpverification);
    app.post("/updatepass", controllers.updatepass);
    // app.get("/login", controllers.login);
    // app.get("/logout/:id", controllers.logout);

    // app.get("/update", controllers.findAll);
    // app.get("/delete", controllers.findAll);
  
    // app.get("/message/:messageId", controllers.findOne);
  
    // app.put("/message/:messageId", controllers.update);
  
    // app.delete("/message/:messageId", controllers.delete);
  };