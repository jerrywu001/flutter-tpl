const express = require('express');
const router = express.Router();

// Import controllers
const filesController = require('../controllers/files.controller.cjs');

// Mini Program routes
router.use('/files', filesController);

module.exports = router;
