const express = require("express");
const sql = require("mssql");
const routes = require("./routes/Routes");
const bodyParser = require("body-parser");
const app = express();
app.use(express.json());
app.use(bodyParser.json());
app.use("/api", routes);

const port = process.env.PORT || 6000;
app.listen(port, () => console.log(`Server running on port ${port}`));
