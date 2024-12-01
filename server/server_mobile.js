const express = require('express');
const app = express();
const bcrypt = require('bcrypt');
const con = require('./db'); // Database connection


const jwt = require('jsonwebtoken');
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


// app.post('/login', function (req, res) {
//     const {username, password} = req.body;
//     if(username == 'Lisa' && password == '1111') {
//         const payload = { "username": username, "role": "user" };
//         const token = jwt.sign(payload, JWT_KEY, { expiresIn: '1d' });
//         return res.send(token);
//     }
//     else if(username == 'admin' && password == '0000') {
//         const payload = { "username": username, "role": "admin" };
//         const token = jwt.sign(payload, JWT_KEY, { expiresIn: '1d' });
//         return res.send(token);
//     }
//     res.status(401).send('Wrong username or password');
// });


// app.get('/expenses', verifyUser, function(req, res) {
//     // we can use req.decoded here from middleware
//     // ex: we can extract userID and query database
//     // expenses
//     const expenses = [
//         {"item": "lunch", "paid": 60},
//         {"item": "coffee", "paid": 35},
//         {"item": "laundry", "paid": 70},
//     ];
//     res.json(expenses);
// });

// // Login route
app.post('/login', (req, res) => {
    const { username, password, rememberMe } = req.body;
    const sql = "SELECT user_id, password, role FROM users WHERE username = ?";

    console.log("Received login request:", { username, password });

    con.query(sql, [username], function (err, results) {
        if (err) {
            console.error("Database query error:", err);
            return res.status(500).json({ message: 'Server error' });
        }
        if (results.length === 0) {
            return res.status(400).json({ message: 'Wrong username' });
        }

        const hash = results[0].password;
        const role = results[0].role;

        bcrypt.compare(password, hash, function (err, same) {
            if (err) {
                console.error("Password comparison error:", err);
                return res.status(500).json({ message: 'Hash error' });
            }
            if (!same) {
                return res.status(401).json({ message: 'Login fail' });
            }

            // ถ้าผู้ใช้เลือก "Remember Me"
            if (rememberMe) {
                // ตั้งค่าคุกกี้
                res.cookie('userInfo', JSON.stringify({ user_id: results[0].user_id, role: role }), { 
                    maxAge: 1000 * 60 * 60 * 24 * 30, // เก็บคุกกี้ไว้ 30 วัน
                    httpOnly: true // ทำให้คุกกี้ไม่สามารถเข้าถึงจาก JavaScript ได้
                });
            }

            res.json({ message: 'Login ok', user_id: results[0].user_id, role: role });
        });
    });
});


// Registration route
app.post('/register', (req, res) => {
    const { username, password, email } = req.body;
    console.log("Received registration request:", { username, email });

    if (!username || !password || !email) {
        console.error("Registration error: Username, email, and password are required");
        return res.status(400).json({ message: 'Username, email, and password are required' });
    }

    bcrypt.hash(password, 10, (err, hash) => {
        if (err) {
            console.error("Error hashing password:", err);
            return res.status(500).json({ message: 'Error hashing password' });
        }

        const sql = "INSERT INTO users (username, password, email, role) VALUES (?, ?, ?, 'Student')";
        con.query(sql, [username, hash, email], (err, result) => {
            if (err) {
                console.error("Database error during registration:", err);
                return res.status(500).json({ message: 'Database error' });
            }

            console.log("User registered successfully:", { username, email });
            res.status(201).json({ message: 'User registered successfully!' });
        });
    });
});

// Logout route
app.post('/logout', (req, res) => {
    // ลบคุกกี้เมื่อออกจากระบบ
    res.clearCookie('userInfo');
    res.json({ message: 'Logout successful' });
});

// Profile route to check cookie
app.get('/profile', (req, res) => {
    if (req.cookies.userInfo) {
        const userInfo = JSON.parse(req.cookies.userInfo);
        res.json({ message: 'Welcome to your profile', user: userInfo });
    } else {
        res.status(401).json({ message: 'Unauthorized' });
    }
});

app.use('/images', express.static('public/images'));

app.get('/assets', (req, res) => {
    const sql = 'SELECT * FROM assets';
    con.query(sql, (err, results) => {
        if (err) {
            console.error('Error fetching data:', err);
            res.status(500).json({ error: 'Failed to retrieve data' });
            return;
        }
        res.json(results);
    });
});
// Home route
app.get('/', (req, res) => {
    if (req.cookies.userInfo) {
        const userInfo = JSON.parse(req.cookies.userInfo);
        res.send(`Welcome back, user ${userInfo.user_id}`);
    } else {
        res.send('Hello! Please log in.');
    }
});

app.post('/add/assets', (req, res) => {
    const { asset_id, asset_name, status, asset_image, assets_description } = req.body;

    console.log('Request body:', req.body);

   
    const sql = 'INSERT INTO assets (asset_id, asset_name, status, asset_image, assets_description) VALUES (?, ?, ?, ?, ?)';
    
    con.query(sql, [asset_id, asset_name, status, asset_image, assets_description], (err, result) => {
        if (err) {
            
            console.error('Error during SQL query:', err);
            return res.status(500).json({ message: 'Error adding asset' });
        }
        
        console.log('Insert result:', result);
        res.status(201).json({ message: 'Asset added successfully', assetId: result.insertId });
    });
});



app.put('/edit/assets/:asset_id', (req, res) => {
    const assetId = req.params.asset_id; 
    const { asset_name, asset_image, assets_description } = req.body;

 
    console.log('Request body:', req.body);
    console.log('Asset ID to edit:', assetId);

    const sql = 'UPDATE assets SET asset_name = ?,  asset_image = ?, assets_description = ? WHERE asset_id = ?';
    
    con.query(sql, [asset_name,  asset_image, assets_description, assetId], (err, result) => {
        if (err) {
           
            console.error('Error during SQL query:', err);
            return res.status(500).json({ message: 'Error updating asset' });
        }

        if (result.affectedRows === 0) {
            return res.status(404).json({ message: 'Asset not found' });
        }

        console.log('Update result:', result);
        res.status(200).json({ message: 'Asset updated successfully' });
    });
});

app.post('/borrow', (req, res) => {
    const { asset_id, borrow_date, return_date } = req.body;
    
    if (!req.cookies.userInfo) {
        return res.status(401).json({ message: 'Unauthorized' });
    }

    const userInfo = JSON.parse(req.cookies.userInfo);
    const borrower_id = userInfo.user_id;

    if (!asset_id || !borrow_date || !return_date) {
        console.error("Borrow request error: Asset ID, borrow date, and return date are required");
        return res.status(400).json({ message: 'Asset ID, borrow date, and return date are required' });
    }

    const checkAssetSql = "SELECT status FROM assets WHERE asset_id = ?";
    con.query(checkAssetSql, [asset_id], (checkErr, checkResult) => {
        if (checkErr) {
            console.error("Database error during asset status check:", checkErr);
            return res.status(500).json({ message: 'Database error' });
        }

        if (checkResult.length === 0 || checkResult[0].status !== 'Available') {
            return res.status(400).json({ message: 'Asset is not available for borrowing' });
        }

        const sql = "INSERT INTO borrowrequests (borrower_id, asset_id, borrow_date, return_date) VALUES (?, ?, ?, ?)";
        con.query(sql, [borrower_id, asset_id, borrow_date, return_date], (err, result) => {
            if (err) {
                console.error("Database error during borrow request:", err);
                return res.status(500).json({ message: 'Database error' });
            }

            // Update asset status to 'Pending'
            const updateAssetStatusSql = "UPDATE assets SET status = 'Pending' WHERE asset_id = ?";
            con.query(updateAssetStatusSql, [asset_id], (updateErr) => {
                if (updateErr) {
                    console.error("Database error during asset status update:", updateErr);
                    return res.status(500).json({ message: 'Database error' });
                }

                console.log("Borrow request submitted successfully:", { borrower_id, asset_id, borrow_date, return_date });
                res.status(201).json({ message: 'Borrow request submitted successfully!' });
            });
        });
    });
});


app.post('/approve/:request_id', (req, res) => {
    const requestId = req.params.request_id;

    if (!req.cookies.userInfo) {
        return res.status(401).json({ message: 'Unauthorized' });
    }

    const userInfo = JSON.parse(req.cookies.userInfo);
    const lender_id = userInfo.user_id;

    const sql = "UPDATE borrowrequests SET status = 'Approved', approved_by = ? WHERE request_id = ?";

    con.query(sql, [lender_id, requestId], (err, result) => {
        if (err) {
            console.error("Database error during approval:", err);
            return res.status(500).json({ message: 'Database error' });
        }

        if (result.affectedRows === 0) {
            return res.status(404).json({ message: 'Request not found' });
        }

        const updateAssetSql = "UPDATE assets SET status = 'Borrowed' WHERE asset_id = (SELECT asset_id FROM borrowrequests WHERE request_id = ?)";
        con.query(updateAssetSql, [requestId], (updateErr, updateResult) => {
            if (updateErr) {
                console.error("Database error during asset status update:", updateErr);
                return res.status(500).json({ message: 'Database error' });
            }

            console.log(`Borrow request ${requestId} approved successfully.`);
            res.json({ message: 'Borrow request approved successfully!' });
        });
    });
});


// // Delete borrowing request route
// app.delete('/cancle/:request_id', (req, res) => {
//     const requestId = req.params.request_id;

//     // SQL query to delete the borrowing request
//     const sql = "DELETE FROM borrowrequests WHERE request_id = ?";

//     con.query(sql, [requestId], (err, result) => {
//         if (err) {
//             console.error("Database error during deletion:", err);
//             return res.status(500).json({ message: 'Database error' });
//         }

//         if (result.affectedRows === 0) {
//             return res.status(404).json({ message: 'Request not found' });
//         }

//         console.log(`Borrow request ${requestId} deleted successfully.`);
//         res.json({ message: 'Borrow request deleted successfully!' });
//     });
// });

// const updateAssetSql = "UPDATE assets SET status = 'Available' WHERE asset_id = ?";


// Delete borrowing request and update asset status route
app.delete('/cancle/:request_id', (req, res) => {
    const requestId = req.params.request_id;

    // Start a transaction
    con.beginTransaction((err) => {
        if (err) {
            console.error("Transaction start error:", err);
            return res.status(500).json({ message: 'Transaction error' });
        }

        // SQL query to delete the borrowing request
        const updateSql = "UPDATE assets SET status = 'Available' WHERE asset_id = (SELECT asset_id FROM borrowrequests WHERE request_id = ?)";
        
        con.query(updateSql, [requestId], (err, result) => {
            if (err) {
                return con.rollback(() => {
                    console.error("Error updating borrow request:", err);
                    return res.status(500).json({ message: 'Database error during updating' });
                });
            }

            if (result.affectedRows === 0) {
                return con.rollback(() => {
                    return res.status(404).json({ message: 'Request not found' });
                });
            }

            console.log('Borrow request ${requestId} updated successfully.');

            // SQL query to update the asset status to 'Available'
            const deleteSql = "DELETE FROM borrowrequests WHERE request_id = ?";

            con.query(deleteSql, [requestId], (err, updateResult) => {
                if (err) {
                    return con.rollback(() => {
                        console.error("Error deleting asset status:", err);
                        return res.status(500).json({ message: 'Error deleting asset status' });
                    });
                }

                // Commit the transaction if both queries were successful
                con.commit((err) => {
                    if (err) {
                        return con.rollback(() => {
                            console.error("Transaction commit error:", err);
                            return res.status(500).json({ message: 'Error committing transaction' });
                        });
                    }

                    console.log("Asset status updated to 'Available' successfully.");
                    res.json({ message: 'Borrow request deleted and asset status updated successfully!' });
                });
            });
        });
    });
});

// Endpoint to get borrowing requests
app.get('/borrowrequests',verifyUser, (req, res) => {
    const sql = "SELECT * FROM borrowrequests";

    con.query(sql, (err, results) => {
        if (err) {
            console.error("Error fetching borrowing requests:", err);
            return res.status(500).json({ message: 'Failed to retrieve borrowing requests' });
        }

        res.json(results);
    });
});


// Get Student History API Endpoint
app.get('/api/history/student/:userId', (req, res) => {
    const { userId } = req.params;
    const query = `
        SELECT br.request_id, a.asset_name, br.borrow_date, br.return_date, br.status, a.asset_image, a.status AS asset_status
        FROM borrowrequests br
        JOIN assets a ON br.asset_id = a.asset_id
        WHERE br.borrower_id = ?;
    `;

    con.query(query, [userId], (err, results) => {
        if (err) {
            console.error('Error fetching student history:', err);
            return res.status(500).json({ error: 'Failed to fetch history' });
        }
        res.json(results);
    });
});

// Get Lender History API Endpoint
app.get('/api/history/lender/:userId', (req, res) => {
    const { userId } = req.params;
    const query = `
        SELECT br.request_id, a.asset_name, u.username AS borrower, br.borrow_date, br.return_date, br.status, a.asset_image, a.status AS asset_status
        FROM borrowrequests br
        JOIN assets a ON br.asset_id = a.asset_id
        JOIN users u ON br.borrower_id = u.user_id
        WHERE br.approved_by = ?;
    `;

    con.query(query, [userId], (err, results) => {
        if (err) {
            console.error('Error fetching lender history:', err);
            return res.status(500).json({ error: 'Failed to fetch history' });
        }
        res.json(results);
    });
});

// Get Staff History API Endpoint
app.get('/api/history/staff', (req, res) => {
    const query = `
        SELECT br.request_id, a.asset_name, borrower.username AS borrower, approver.username AS approvedBy, br.borrow_date, br.return_date, br.status, a.asset_image, a.status AS asset_status
        FROM borrowrequests br
        JOIN assets a ON br.asset_id = a.asset_id
        JOIN users borrower ON br.borrower_id = borrower.user_id
        LEFT JOIN users approver ON br.approved_by = approver.user_id;
    `;

    con.query(query, (err, results) => {
        if (err) {
            console.error('Error fetching staff history:', err);
            return res.status(500).json({ error: 'Failed to fetch history' });
        }
        res.json(results);
    });
});

// Get Returning Assets API Endpoint
app.get('/api/assets/returning', (req, res) => {
    const query = `
        SELECT a.asset_id, a.asset_name, borrower.username AS borrower, br.borrow_date, approver.username AS approvedBy, a.asset_image, br.return_date, br.status
        FROM borrowrequests br
        JOIN assets a ON br.asset_id = a.asset_id
        JOIN users borrower ON br.borrower_id = borrower.user_id
        LEFT JOIN users approver ON br.approved_by = approver.user_id
        WHERE br.status = 'Approved';
    `;

    con.query(query, (err, results) => {
        if (err) {
            console.error('Error fetching returning assets:', err);
            return res.status(500).json({ error: 'Failed to fetch returning assets' });
        }
        res.json(results);
    });
});

// Update Asset Status to Available (Staff Returning Asset)
app.put('/api/assets/return/:assetId', (req, res) => {
    const assetId = req.params.assetId;

    const updateAssetSql = "UPDATE assets SET status = 'Available' WHERE asset_id = ?";

    con.query(updateAssetSql, [assetId], (err, result) => {
        if (err) {
            console.error("Database error during asset status update:", err);
            return res.status(500).json({ message: 'Database error' });
        }

        if (result.affectedRows === 0) {
            return res.status(404).json({ message: 'Asset not found' });
        }

        console.log(`Asset ${assetId} returned successfully.`);
        res.json({ message: 'Asset returned successfully!' });
    });
});

// Dashboard Data API Endpoint
app.get('/api/dashboard', (req, res) => {
    const query = `
        SELECT 
            SUM(CASE WHEN status = 'Available' THEN 1 ELSE 0 END) AS available_assets,
            SUM(CASE WHEN status = 'Pending' THEN 1 ELSE 0 END) AS pending_assets,
            SUM(CASE WHEN status = 'Borrowed' THEN 1 ELSE 0 END) AS borrowed_assets,
            SUM(CASE WHEN status = 'Disabled' THEN 1 ELSE 0 END) AS disabled_assets
        FROM assets;
    `;

    con.query(query, (err, results) => {
        if (err) {
            console.error('Error fetching dashboard data:', err);
            return res.status(500).json({ error: 'Failed to fetch dashboard data' });
        }
        res.json(results[0]);
    });
});


// ---------- Server starts here ---------
const PORT = 3000;
app.listen(PORT, () => {
    console.log('Server is running at http://localhost:' + PORT);
});