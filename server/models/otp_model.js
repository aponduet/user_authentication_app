const mongoose = require("mongoose");
const Schema = mongoose.Schema;
const otpSchema = new Schema(
  {
    
    
    email: { type: String, required: true, unique: true },
    otp: { type: String, required: true, trim: true,unique: true },
    
    
  },
  {
    timestamps: {
      createdAt: "createdAt",
      updatedAt: "updatedAt",
    },
  }
);
const OtpTable = mongoose.model("otp", otpSchema);
module.exports = OtpTable;