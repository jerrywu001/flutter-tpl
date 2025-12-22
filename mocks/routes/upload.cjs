const express = require('express');
const router = express.Router();

const uploadController = require('../controllers/upload.controller.cjs');

router.use('/tool', uploadController);

module.exports = router;
