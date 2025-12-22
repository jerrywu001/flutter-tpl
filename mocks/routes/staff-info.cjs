const express = require('express');
const router = express.Router();

// Import controllers
const staffInfoController = require('../controllers/staff-info.controller.cjs');

// Mini Program routes
router.use('/staff-info', staffInfoController);

module.exports = router;
