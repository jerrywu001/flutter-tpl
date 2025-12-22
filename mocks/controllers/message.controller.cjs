const express = require('express');
const router = express.Router();
const notifications = require('./data/notifications.json');

/**
 * 获取通知列表
 */
router.get('/notifications', (req, res) => {
  const { type, page = 1, size = 10 } = req.query;

  let all = JSON.parse(JSON.stringify(notifications));

  // 按类型筛选
  if (type) {
    all = all.filter(item => item.notificationType === type);
  }

  // 按时间倒序排序
  all.sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt));

  const total = all.length;
  const start = (Number(page) - 1) * Number(size);
  const end = start + Number(size);
  const list = all.slice(start, end);

  res.json({
    code: 0,
    message: null,
    context: {
      list,
      total,
      page: Number(page),
      size: Number(size),
    },
  });
});

/**
 * 获取通知详情
 */
router.get('/notifications/:id', (req, res) => {
  const { id } = req.params;
  const notification = notifications.find(item => item.id === id);

  if (!notification) {
    return res.json({
      code: 404,
      message: '通知不存在',
      context: null,
    });
  }

  res.json({
    code: 0,
    message: null,
    context: notification,
  });
});

/**
 * 获取未读消息统计
 */
router.get('/notifications/unread-count', (req, res) => {
  const all = JSON.parse(JSON.stringify(notifications));
  const unread = all.filter(item => !item.isRead);

  const system = unread.filter(item => item.notificationType === 'SYSTEM').length;
  const task = unread.filter(item => item.notificationType === 'TASK').length;
  const order = unread.filter(item => item.notificationType === 'ORDER').length;
  const finance = unread.filter(item => item.notificationType === 'FINANCE').length;

  res.json({
    code: 0,
    message: null,
    context: {
      total: unread.length,
      system,
      task,
      order,
      finance,
    },
  });
});

/**
 * 标记单个通知为已读
 */
router.post('/notifications/:id/read', (req, res) => {
  res.json({
    code: 0,
    message: '标记已读成功',
    context: null,
  });
});

/**
 * 标记所有通知为已读
 */
router.post('/notifications/read-all', (req, res) => {
  res.json({
    code: 0,
    message: '全部标记已读成功',
    context: null,
  });
});

/**
 * 按类型标记通知为已读
 */
router.post('/notifications/read-by-type', (req, res) => {
  res.json({
    code: 0,
    message: '标记已读成功',
    context: null,
  });
});

/**
 * 清除已读消息
 */
router.post('/notifications/clear-read', (req, res) => {
  res.json({
    code: 0,
    message: '清除成功',
    context: null,
  });
});

/**
 * 处理邀请通知
 */
router.post('/notifications/:id/handle-invite', (req, res) => {
  const { action } = req.body;

  res.json({
    code: 0,
    message: action === 'ACCEPT' ? '已接受邀请' : '已拒绝邀请',
    context: null,
  });
});

module.exports = router;
