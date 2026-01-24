const express = require('express');
const router = express.Router();

// 模拟用户数据
const mockUser = {
  userId: 'parent-001',
  userType: 'parent',
  phone: '13800138001',
  nickname: '张妈妈',
  avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=parent1',
  isNewUser: false,
};

// ========== 家长端微信登录 ==========
router.post('/wechat/parent', (req, res) => {
  const { code } = req.body || {};
  if (!code) {
    return res.status(400).json({
      code: 400,
      message: '缺少code参数',
      data: null,
    });
  }

  res.json({
    code: 0,
    message: null,
    data: {
      accessToken: 'mock_access_token_' + Date.now(),
      refreshToken: 'mock_refresh_token_' + Date.now(),
      expiresIn: 604800,
      userInfo: mockUser,
    },
  });
});

// ========== 发送短信验证码 ==========
router.post('/sms/send', (req, res) => {
  const { phone } = req.body || {};
  if (!phone) {
    return res.status(400).json({
      code: 400,
      message: '手机号不能为空',
      data: null,
    });
  }

  res.json({
    code: 0,
    message: null,
    data: { message: '验证码发送成功' },
  });
});

// ========== 绑定手机号（短信验证码方式） ==========
router.post('/phone/bind', (req, res) => {
  const { phone, code } = req.body || {};
  if (!phone || !code) {
    return res.status(400).json({
      code: 400,
      message: '参数不完整',
      data: null,
    });
  }

  // 模拟验证码校验
  if (code !== '123456') {
    return res.status(400).json({
      code: 400,
      message: '验证码错误',
      data: null,
    });
  }

  mockUser.phone = phone;
  res.json({
    code: 0,
    message: null,
    data: { message: '绑定成功' },
  });
});

// ========== 绑定手机号（微信授权方式） ==========
router.post('/phone/bind-wechat', (req, res) => {
  const { code } = req.body || {};
  if (!code) {
    return res.status(400).json({
      code: 400,
      message: '缺少code参数',
      data: null,
    });
  }

  mockUser.phone = '13800138001';
  res.json({
    code: 0,
    message: null,
    data: { message: '绑定成功' },
  });
});

// ========== 家长实名认证 ==========
router.post('/identity/parent', (req, res) => {
  const { realName, idCard, phone } = req.body || {};
  if (!realName || !idCard || !phone) {
    return res.status(400).json({
      code: 400,
      message: '参数不完整',
      data: null,
    });
  }

  res.json({
    code: 0,
    message: null,
    data: { message: '认证成功' },
  });
});

// ========== 刷新Token ==========
router.post('/token/refresh', (req, res) => {
  const { refreshToken } = req.body || {};
  if (!refreshToken) {
    return res.status(400).json({
      code: 400,
      message: '缺少refreshToken',
      data: null,
    });
  }

  res.json({
    code: 0,
    message: null,
    data: {
      accessToken: 'mock_new_access_token_' + Date.now(),
      refreshToken: 'mock_new_refresh_token_' + Date.now(),
      expiresIn: 604800,
    },
  });
});

// ========== 登出 ==========
router.post('/logout', (req, res) => {
  res.json({
    code: 0,
    message: null,
    data: { message: '登出成功' },
  });
});

// ========== 获取当前用户信息 ==========
router.get('/me', (req, res) => {
  res.json({
    code: 0,
    message: null,
    data: {
      userId: mockUser.userId,
      userType: mockUser.userType,
      openId: 'mock_open_id',
    },
  });
});

module.exports = router;
