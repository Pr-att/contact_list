const mongoose = require("mongoose");

const userSchema = mongoose.Schema({
    email: {
        type: String,
        required: true,
        trim: true
    },
    password: {
        type: String,
        required: true,
        trim: true
    }
});

const userContactSchema = mongoose.Schema({
    email: {
            type: String,
            required: true,
            trim: true
        },
    contact: [
        {
            name: {
                type: String,
                required: true,
                trim: true
            },
            phone: {
                type: Number,
                required: true,
                trim: true
            }
        }
    ]
});

const User = mongoose.model("User", userSchema);
const UserContact = mongoose.model("UserContact", userContactSchema);

module.exports = User;
module.exports = UserContact;