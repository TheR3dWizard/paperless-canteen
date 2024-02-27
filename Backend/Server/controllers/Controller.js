const sql = require("mssql");
const config = {
  user: "sa",
  password: "12345",
  server: "MANU-ZENBOOK",
  database: "Canteen",
  options: {
    trustedConnection: true,
    trustServerCertificate: true,
  },
};

const getFoodItems = async (req, res) => {
  try {
    const pool = await sql.connect(config);
    const result = await pool.request().query("SELECT * FROM food_items");
    res.send(result.recordset);
  } catch (err) {
    console.error(err);
    res.status(500).send("Server error");
  }
};

const postFoodItems = async (req, res) => {
  try {
    const { name, tamilName, category, counterId, price, stock } = req.body;
    const pool = await sql.connect(config);
    const result = await pool
      .request()
      .input("name", sql.VarChar(50), name)
      .input("tamilName", sql.VarChar(50), tamilName)
      .input("category", sql.VarChar(50), category)
      .input("counterId", sql.Int, counterId)
      .input("price", sql.Decimal(18, 2), price)
      .input("stock", sql.Int, stock)
      .query(
        "INSERT INTO food_items (name, tamilName, category, counterId, price, stock) VALUES (@name, @tamilName, @category, @counterId, @price, @stock); SELECT SCOPE_IDENTITY() AS id;"
      );
    res.send({
      id: result.recordset[0].id,
      name,
      tamilName,
      category,
      counterId,
      price,
      stock,
    });
  } catch (err) {
    console.error(err);
    res.status(500).send("Server error");
  }
};

const getUserBills = async (req, res) => {
  try {
    const { user } = req.params;
    const pool = await sql.connect(config);
    const result = await pool
      .request()
      .input("user", sql.VarChar(50), user)
      .query("SELECT * FROM bill WHERE userId = @user");
    res.send(result.recordset);
  } catch (err) {
    console.error(err);
    res.status(500).send("Server error");
  }
};

const addBill = async (req, res) => {
  const { userId, items, total, claimed, time } = req.body;

  // Connect to the database
  sql.connect(config, async (err) => {
    if (err) {
      console.log("Failed to connect to the database");
      res.status(500).json({ message: "Failed to connect to the database" });
      return;
    }

    // Create a new request object
    const request = new sql.Request();

    // Check the stock of each item before inserting the bill into the database
    for (const [itemId, quantity] of Object.entries(items)) {
      const itemRequest = new sql.Request();
      const itemQuery = `SELECT stock FROM food_items WHERE id = ${itemId};`;
      const itemResult = await itemRequest.query(itemQuery);
      const stock = itemResult.recordset[0].stock;
      if (stock < quantity) {
        console.log(`Insufficient stock for item ${itemId}`);
        res
          .status(400)
          .json({ message: `Insufficient stock for item ${itemId}` });
        return;
      }
    }

    // Define the SQL query to insert the bill into the database
    const query = `INSERT INTO bill (userId, items, total, claimed, time)
                   VALUES (${userId}, '${JSON.stringify(
      items
    )}', ${total}, ${claimed}, '${time}');`;

    // Execute the SQL query
    request.query(query, (err, result) => {
      if (err) {
        console.log("Failed to insert bill into database");
        console.log(err.message);
        res
          .status(500)
          .json({ message: "Failed to insert bill into database" });
        return;
      }

      console.log("Bill inserted successfully");

      // Update the stock of each item
      for (const [itemId, quantity] of Object.entries(items)) {
        const updateRequest = new sql.Request();
        const updateQuery = `UPDATE food_items SET stock = stock - ${quantity} WHERE id = ${itemId};`;
        updateRequest.query(updateQuery, (err, result) => {
          if (err) {
            console.log(`Failed to update stock for item ${itemId}`);
            console.log(err.message);
          } else {
            console.log(`Stock updated for item ${itemId}`);
          }
        });
      }

      res
        .status(201)
        .json({ message: "Bill added successfully", bill_id: result.insertId });
    });
  });
};

module.exports = {
  getFoodItems,
  postFoodItems,
  getUserBills,
  addBill,
};
