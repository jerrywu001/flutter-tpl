const express = require('express');
const router = express.Router();
const orders = require('./data/orders.json');

// ========== 家长订单列表 ==========
router.get('/parent/list', (req, res) => {
  let result = [...orders];
  const { page = 1, size = 10, status, orderType } = req.query;

  // 筛选
  if (status) {
    result = result.filter((o) => o.status === status);
  }
  if (orderType) {
    result = result.filter((o) => o.orderType === orderType);
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
    data: {
      list,
      total,
      page: Number(page),
      size: Number(size),
      totalPages: Math.ceil(total / Number(size)),
    },
  });
});

// ========== 家长订单详情 ==========
router.get('/parent/:id', (req, res) => {
  const order = orders.find((o) => o.id === req.params.id);
  if (!order) {
    return res.status(404).json({
      code: 404,
      message: '订单不存在',
      data: null,
    });
  }
  res.json({
    code: 0,
    message: null,
    data: order,
  });
});

// ========== 取消订单 ==========
router.post('/parent/:id/cancel', (req, res) => {
  const index = orders.findIndex((o) => o.id === req.params.id);
  if (index === -1) {
    return res.status(404).json({
      code: 404,
      message: '订单不存在',
      data: null,
    });
  }
  const order = orders[index];
  if (!['PENDING_PAY', 'PAID'].includes(order.status)) {
    return res.status(400).json({
      code: 400,
      message: '当前状态不可取消',
      data: null,
    });
  }
  const { reason } = req.body || {};
  orders[index].status = 'CANCELLED';
  orders[index].cancelReason = reason || '用户取消';
  orders[index].cancelledAt = new Date().toISOString();

  res.json({
    code: 0,
    message: null,
    data: { message: '取消成功' },
  });
});

module.exports = router;
