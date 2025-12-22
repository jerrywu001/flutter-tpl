const express = require('express');
const router = express.Router();
const coursePackages = require('./data/coursePackages.json');
const paymentRecords = require('./data/paymentRecords.json');

// 钱包信息
const walletInfo = {
  balance: 820,
  remainingHours: 15,
  totalRecharge: 3180,
  totalConsume: 860,
};

// ========== 钱包信息 ==========
router.get('/wallet', (req, res) => {
  res.json({
    code: 0,
    message: null,
    context: walletInfo,
  });
});

// ========== 钱包充值 ==========
router.post('/recharge', (req, res) => {
  const { amount } = req.body || {};
  if (!amount || amount <= 0) {
    return res.status(400).json({
      code: 400,
      message: '充值金额无效',
      context: null,
    });
  }

  const paymentNo = `PAY${Date.now()}`;
  res.json({
    code: 0,
    message: null,
    context: {
      message: '充值订单创建成功',
      paymentNo,
      payParams: {
        timeStamp: String(Math.floor(Date.now() / 1000)),
        nonceStr: 'mock_nonce_str_' + Math.random().toString(36).slice(2),
        package: 'prepay_id=mock_prepay_id',
        signType: 'RSA',
        paySign: 'mock_pay_sign',
      },
    },
  });
});

// ========== 订单支付 ==========
router.post('/order', (req, res) => {
  const { orderId, paymentMethod } = req.body || {};
  if (!orderId) {
    return res.status(400).json({
      code: 400,
      message: '订单ID不能为空',
      context: null,
    });
  }

  const paymentNo = `PAY${Date.now()}`;

  if (paymentMethod === 'WALLET') {
    // 余额支付直接成功
    res.json({
      code: 0,
      message: null,
      context: {
        message: '支付成功',
        paymentNo,
      },
    });
  } else {
    // 微信支付返回支付参数
    res.json({
      code: 0,
      message: null,
      context: {
        message: '支付订单创建成功',
        paymentNo,
        payParams: {
          timeStamp: String(Math.floor(Date.now() / 1000)),
          nonceStr: 'mock_nonce_str_' + Math.random().toString(36).slice(2),
          package: 'prepay_id=mock_prepay_id',
          signType: 'RSA',
          paySign: 'mock_pay_sign',
        },
      },
    });
  }
});

// ========== 课时包列表 ==========
router.get('/packages', (req, res) => {
  const activePackages = coursePackages.filter((p) => p.status === 'ACTIVE');
  res.json({
    code: 0,
    message: null,
    context: {
      list: activePackages,
    },
  });
});

// ========== 课时包详情 ==========
router.get('/packages/:id', (req, res) => {
  const pkg = coursePackages.find((p) => p.id === req.params.id);
  if (!pkg) {
    return res.status(404).json({
      code: 404,
      message: '课时包不存在',
      context: null,
    });
  }
  res.json({
    code: 0,
    message: null,
    context: pkg,
  });
});

// ========== 购买课时包 ==========
router.post('/purchase', (req, res) => {
  const { coursePackageId, paymentMethod } = req.body || {};
  if (!coursePackageId) {
    return res.status(400).json({
      code: 400,
      message: '课时包ID不能为空',
      context: null,
    });
  }

  const pkg = coursePackages.find((p) => p.id === coursePackageId);
  if (!pkg) {
    return res.status(404).json({
      code: 404,
      message: '课时包不存在',
      context: null,
    });
  }

  const paymentNo = `PAY${Date.now()}`;

  if (paymentMethod === 'WALLET') {
    // 余额支付
    if (walletInfo.balance < pkg.salePrice) {
      return res.status(400).json({
        code: 400,
        message: '余额不足',
        context: null,
      });
    }
    res.json({
      code: 0,
      message: null,
      context: {
        message: '购买成功',
        paymentNo,
      },
    });
  } else {
    // 微信支付
    res.json({
      code: 0,
      message: null,
      context: {
        message: '支付订单创建成功',
        paymentNo,
        payParams: {
          timeStamp: String(Math.floor(Date.now() / 1000)),
          nonceStr: 'mock_nonce_str_' + Math.random().toString(36).slice(2),
          package: 'prepay_id=mock_prepay_id',
          signType: 'RSA',
          paySign: 'mock_pay_sign',
        },
      },
    });
  }
});

// ========== 支付记录列表 ==========
router.get('/records', (req, res) => {
  let result = [...paymentRecords];
  const { page = 1, size = 10, paymentType, status } = req.query;

  // 筛选
  if (paymentType) {
    result = result.filter((r) => r.paymentType === paymentType);
  }
  if (status) {
    result = result.filter((r) => r.status === status);
  }

  // 按创建时间倒序
  result.sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt));

  const total = result.length;
  const start = (Number(page) - 1) * Number(size);
  const end = start + Number(size);
  const list = result.slice(start, end);

  res.json({
    code: 0,
    message: null,
    context: {
      list,
      total,
      page: Number(page),
      size: Number(size),
      totalPages: Math.ceil(total / Number(size)),
    },
  });
});

// ========== 支付记录详情 ==========
router.get('/records/:id', (req, res) => {
  const record = paymentRecords.find((r) => r.id === req.params.id);
  if (!record) {
    return res.status(404).json({
      code: 404,
      message: '支付记录不存在',
      context: null,
    });
  }
  res.json({
    code: 0,
    message: null,
    context: record,
  });
});

module.exports = router;
