const express = require('express');
const jwt = require('jsonwebtoken');
const app = express();
app.use(express.json());
app.use(express.urlencoded({ extended: true }));


const JWT_KEY = 'm0bile2Simple';


// ================= Middleware ================
function verifyUser(req, res, next) {
    let token = req.headers['authorization'] || req.headers['x-access-token'];
    if (token == undefined || token == null) {
        // no token
        return res.status(400).send('No token');
    }


    // token found
    if (req.headers.authorization) {
        const tokenString = token.split(' ');
        if (tokenString[0] == 'Bearer') {
            token = tokenString[1];
        }
    }
    jwt.verify(token, JWT_KEY, (err, decoded) => {
        if (err) {
            res.status(401).send('Incorrect token');
        }
        else if(decoded.role != 'user') {
            res.status(403).send('Forbidden to access the data');
        }
        else {
            req.decoded = decoded;
            next();
        }
    });
}


app.post('/login', function (req, res) {
    const {username, password} = req.body;
    if(username == 'Lisa' && password == '1111') {
        const payload = { "username": username, "role": "user" };
        const token = jwt.sign(payload, JWT_KEY, { expiresIn: '1d' });
        return res.send(token);
    }
    else if(username == 'admin' && password == '0000') {
        const payload = { "username": username, "role": "admin" };
        const token = jwt.sign(payload, JWT_KEY, { expiresIn: '1d' });
        return res.send(token);
    }
    res.status(401).send('Wrong username or password');
});


app.get('/expenses', verifyUser, function(req, res) {
    // we can use req.decoded here from middleware
    // ex: we can extract userID and query database
    // expenses
    const expenses = [
        {"item": "lunch", "paid": 60},
        {"item": "coffee", "paid": 35},
        {"item": "laundry", "paid": 70},
    ];
    res.json(expenses);
});


const port = 3000;
app.listen(port, function () {
    console.log("Server is ready at " + port);
});

