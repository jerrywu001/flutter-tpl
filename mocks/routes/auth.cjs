const express = require('express');
const router = express.Router();

// Import controllers
const authController = require('../controllers/auth.controller.cjs');

// Mini Program routes
router.use('/auth', authController);

module.exports = router;
