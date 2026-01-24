const express = require('express');
const router = express.Router();
const multer = require('multer');
const upload = multer({ storage: multer.memoryStorage() });

router.post('/id-no/front/pic', upload.single('file'), (req, res) => {
  const file = req.file;
  let base64 = '';

  if (file) {
    const mime = file.mimetype;
    base64 = `data:${mime};base64,${file.buffer.toString('base64')}`;
  } else {
    base64 = 'https://picx.zhimg.com/v2-1e843c3ffe61510b3137cbe65c8843be_1440w.jpg';
  }

  console.log(file)

  res.json({
    code: 0,
    message: null,
    data: {
      picResult: {
        picUrl: base64,
        picType: file.originalname.split('.').pop(),
        docId: file.size + '',
      },
      idNoFrontInfo: {
        name: '张三',
        identNo: '320124198902020818',
        address: '南京市玄武区长江路10号',
      },
    },
  });
});

router.post('/id-no/back/pic', upload.single('file'), (req, res) => {
  const file = req.file;
  let base64 = '';

  if (file) {
    const mime = file.mimetype;
    base64 = `data:${mime};base64,${file.buffer.toString('base64')}`;
  } else {
    base64 = 'https://picx.zhimg.com/v2-1e843c3ffe61510b3137cbe65c8843be_1440w.jpg';
  }

  res.json({
    code: 0,
    message: null,
    data: {
      picResult: {
        picUrl: base64,
        picType: file.originalname.split('.').pop(),
        docId: file.size + '',
      },
      idNoBackInfo: {
        startDate: '20190503',
        endDate: '20230503',
      },
    },
  });
});

module.exports = router;
