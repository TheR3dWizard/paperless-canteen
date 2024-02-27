const express = require("express");
const router = express.Router();
const {
  getFoodItems,
  postFoodItems,
  getUserBills,
  addBill,
} = require("../controllers/Controller");

router.get("/getItems", getFoodItems);
router.get("/getBills/:user", getUserBills);
router.post("/addBill", addBill);
router.post("/", postFoodItems);

// router.put("/:id", putReq);

// router.delete("/:id", deleteReq);

module.exports = router;
