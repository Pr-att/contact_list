const express = require('express'); // Import express
const PORT = process.env.PORT || 3000; // Set port
const app = express(); // Create express app
const mongoose = require('mongoose'); // Import mongoose
const authRouter = require('./router/auth'); // Import auth router

// npm run dev to start server
app.use(express.json()); // Use express json , middleware
app.use(authRouter);

const DB = "mongodb+srv://Yellow-Class-User-Name:V7fj9Tp5rRZS8cpd@yellow-class-cluster.zralhma.mongodb.net/test?retryWrites=true&w=majority";
mongoose.connect(DB)
.then(() => console.log("MongoDB connected"))
.catch((err) => console.log(err));


app.listen(PORT, () => console.log(`Server started on port ${PORT}`)); // Listen on port