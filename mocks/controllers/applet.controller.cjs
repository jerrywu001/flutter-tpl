const express = require('express');
const router = express.Router();

const apps = require('./data/apps.json');

router.post('/login', (req, res) => {
  res.json({
    code: 0,
    message: null,
    context: {
      token: '1234567890',
      tenantName: '上海吉舰嘉科技服务有限公司',
      shopName: '吉嘉名品汇浦东新区店',
      shopId: 1002,
      staffName: '闻晨佳',
      msg: '请联系管理员通过下面链接在电脑浏览器打开并创建店铺！',
      redirectUri: 'https://cn.bing.com/',
    },
  });
});

router.post('/get-login-clients', (req, res) => {
  res.json({
    code: 0,
    message: null,
    context: apps,
  });
});

module.exports = router;
