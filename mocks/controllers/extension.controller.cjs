const express = require('express');
const router = express.Router();
const extensions = require('./data/extensions.json');

// ========== 延时费用预估 (家长端) ==========
router.post('/parent/estimate', (req, res) => {
  const { orderId, extensionHours } = req.body;

  if (!orderId || !extensionHours) {
    return res.status(400).json({
      code: 400,
      message: '参数错误',
      data: null,
    });
  }

  // 模拟时薪
  const hourlyRate = 45;
  const extensionFee = hourlyRate * extensionHours;

  res.json({
    code: 0,
    message: null,
    data: {
      orderId,
      extensionHours,
      hourlyRate,
      extensionFee,
      originalEndTime: '2024-05-15 11:00',
      newEndTime: `2024-05-15 ${11 + extensionHours}:00`,
    },
  });
});

// ========== 申请延时 (家长端) ==========
router.post('/parent/create', (req, res) => {
  const { orderId, extensionHours, remark } = req.body;

  if (!orderId || !extensionHours) {
    return res.status(400).json({
      code: 400,
      message: '参数错误',
      data: null,
    });
  }

  const hourlyRate = 45;
  const extensionFee = hourlyRate * extensionHours;
  const newId = `ext-${Date.now()}`;

  const newExtension = {
    id: newId,
    orderId,
    extensionHours,
    extensionFee,
    status: 'PENDING',
    remark: remark || '',
    createdAt: new Date().toISOString(),
  };

  extensions.push(newExtension);

  res.json({
    code: 0,
    message: null,
    data: newExtension,
  });
});

// ========== 我的延时申请列表 (家长端) ==========
router.get('/parent/list', (req, res) => {
  let result = [...extensions];
  const { page = 1, size = 10, orderId, status, startDate, endDate } = req.query;

  // 筛选
  if (orderId) {
    result = result.filter((e) => e.orderId === orderId);
  }
  if (status) {
    result = result.filter((e) => e.status === status);
  }
  if (startDate) {
    result = result.filter((e) => e.serviceDate >= startDate);
  }
  if (endDate) {
    result = result.filter((e) => e.serviceDate <= endDate);
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

// ========== 延时申请详情 (家长端) ==========
router.get('/parent/:id', (req, res) => {
  const extension = extensions.find((e) => e.id === req.params.id);

  if (!extension) {
    return res.status(404).json({
      code: 404,
      message: '延时申请不存在',
      data: null,
    });
  }

  res.json({
    code: 0,
    message: null,
    data: extension,
  });
});

// ========== 取消延时申请 (家长端) ==========
router.post('/parent/:id/cancel', (req, res) => {
  const index = extensions.findIndex((e) => e.id === req.params.id);

  if (index === -1) {
    return res.status(404).json({
      code: 404,
      message: '延时申请不存在',
      data: null,
    });
  }

  const extension = extensions[index];
  if (extension.status !== 'PENDING') {
    return res.status(400).json({
      code: 400,
      message: '当前状态不可取消',
      data: null,
    });
  }

  const { cancelReason } = req.body || {};
  extensions[index].status = 'CANCELLED';
  extensions[index].cancelReason = cancelReason || '用户取消';
  extensions[index].cancelledAt = new Date().toISOString();

  res.json({
    code: 0,
    message: null,
    data: { message: '取消成功' },
  });
});

// ========== 待处理延时申请列表 (陪伴官端) ==========
router.get('/companion/pending', (req, res) => {
  const result = extensions.filter((e) => e.status === 'PENDING');

  res.json({
    code: 0,
    message: null,
    data: {
      list: result,
      total: result.length,
      page: 1,
      size: result.length,
      totalPages: 1,
    },
  });
});

// ========== 待处理延时申请数 (陪伴官端) ==========
router.get('/companion/pending-count', (req, res) => {
  const count = extensions.filter((e) => e.status === 'PENDING').length;

  res.json({
    code: 0,
    message: null,
    data: { count },
  });
});

// ========== 延时申请列表 (陪伴官端) ==========
router.get('/companion/list', (req, res) => {
  let result = [...extensions];
  const { page = 1, size = 10, orderId, status, startDate, endDate } = req.query;

  // 筛选
  if (orderId) {
    result = result.filter((e) => e.orderId === orderId);
  }
  if (status) {
    result = result.filter((e) => e.status === status);
  }
  if (startDate) {
    result = result.filter((e) => e.serviceDate >= startDate);
  }
  if (endDate) {
    result = result.filter((e) => e.serviceDate <= endDate);
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

// ========== 延时申请详情 (陪伴官端) ==========
router.get('/companion/:id', (req, res) => {
  const extension = extensions.find((e) => e.id === req.params.id);

  if (!extension) {
    return res.status(404).json({
      code: 404,
      message: '延时申请不存在',
      data: null,
    });
  }

  res.json({
    code: 0,
    message: null,
    data: extension,
  });
});

// ========== 确认延时 (陪伴官端) ==========
router.post('/companion/:id/confirm', (req, res) => {
  const index = extensions.findIndex((e) => e.id === req.params.id);

  if (index === -1) {
    return res.status(404).json({
      code: 404,
      message: '延时申请不存在',
      data: null,
    });
  }

  const extension = extensions[index];
  if (extension.status !== 'PENDING') {
    return res.status(400).json({
      code: 400,
      message: '当前状态不可确认',
      data: null,
    });
  }

  extensions[index].status = 'CONFIRMED';
  extensions[index].confirmedAt = new Date().toISOString();

  res.json({
    code: 0,
    message: null,
    data: { message: '确认成功' },
  });
});

// ========== 拒绝延时 (陪伴官端) ==========
router.post('/companion/:id/reject', (req, res) => {
  const index = extensions.findIndex((e) => e.id === req.params.id);

  if (index === -1) {
    return res.status(404).json({
      code: 404,
      message: '延时申请不存在',
      data: null,
    });
  }

  const extension = extensions[index];
  if (extension.status !== 'PENDING') {
    return res.status(400).json({
      code: 400,
      message: '当前状态不可拒绝',
      data: null,
    });
  }

  const { rejectReason } = req.body || {};
  extensions[index].status = 'REJECTED';
  extensions[index].rejectReason = rejectReason || '陪伴官拒绝';
  extensions[index].rejectedAt = new Date().toISOString();

  res.json({
    code: 0,
    message: null,
    data: { message: '拒绝成功' },
  });
});

module.exports = router;
