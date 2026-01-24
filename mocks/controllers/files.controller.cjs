const express = require('express');
const router = express.Router();
const multer = require('multer');
const upload = multer({ storage: multer.memoryStorage() });

router.post('/upload', upload.single('file'), (req, res) => {
  const file = req.file;
  let base64 = '';

  if (file) {
    const mime = file.mimetype || 'application/octet-stream';
    base64 = `data:${mime};base64,${file.buffer.toString('base64')}`;
  } else {
    base64 = 'https://picx.zhimg.com/v2-1e843c3ffe61510b3137cbe65c8843be_1440w.jpg';
  }

  res.json({
    code: 0,
    message: null,
    data: {
      id: 4233140456576,
      url: base64,
      fileName: file.originalname,
      picType: file.originalname.split('.').pop(),
    },
  });
});



module.exports = router;
