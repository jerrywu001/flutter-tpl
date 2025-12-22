const express = require('express');
const router = express.Router();

// Import controllers
const appletController = require('../controllers/applet.controller.cjs');

// Mini Program routes
router.use('/applet', appletController);

module.exports = router;
