const express = require('express');
const authRouter = express.Router();
const bcryptjs = require('bcryptjs');
const User = require('../models/user');
module.exports = authRouter;

// SignUp
authRouter.post('/signup', async (req, res) => {
    try {
        const { email, password }  = req.body;
        const existingUser = await User.findOne({ email });
        if (existingUser) {
            return res.status(400).json({ msg: "User already exists, Please sign in."});
        }
        else {        
            const hashPassword = await bcryptjs.hash(password, 8);
            let user = User({
                email: email,
                password: hashPassword,
            });

            user = await user.save();
            res.json(user);
        }

    } catch (e) {
        res.status(500).json({ msg: e.message });
    }
});

// SignIn
authRouter.post('/signin', async (req, res) => {
    try {
        const { email, password } = req.body;
        const user = await User.findOne({ email });
        if (!user) {
            res.status(400).json({ msg: "User does not exist, Please sign up."});
            return;
        }
        else {
            const isMatch = await bcryptjs.compare(password, user.password);
            if (!isMatch) {
                res.status(400).json({ msg: "Invalid credentials, Please try again."});
            }
            else {
                res.send("User signed in successfully");
            }

        return;
        }

    } catch (e) {
        res.status(500).json({ msg: e.message });
    }
});


// Post Contacts
authRouter.put('/contacts', async (req, res) => {
    try {
        const { email, name, phone } = req.body;
        const user = await UserContact.findOne({ email });

        if (user) {
            let userContact = UserContact({
                email: email,
                contact: {
                    name: name,
                    phone: phone
                }
            });
            userContact = await userContact.updateOne({ email: email }, { $push: { contact: { name: name, phone: phone } } });
            res.json(userContact);
        } else {
            res.status(400).json({ msg: "User does not exist, please sign up." });
        }
    } catch (e) {
        res.status(500).json({ msg: "Server error." });
    }
});


//authRouter.delete('/contacts', async (req, res) => {
//    try {
//        const { email } = req.body;
//        const user = await User.findOne({ email });
//
//        if (user) {
//            await User.deleteOne({ email });
//        }
//    } catch (e) {
//
//    }
//
//});
