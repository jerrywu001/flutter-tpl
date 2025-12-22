const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');

const app = express();
const port = 6009;

// Middleware
app.use(cors());
app.use(bodyParser.json({ limit: '50mb' }));
app.use(bodyParser.urlencoded({ extended: true, limit: '50mb' }));

// 导入控制器
const authController = require('./controllers/auth.controller.cjs');
const parentController = require('./controllers/parent.controller.cjs');
const companionController = require('./controllers/companion.controller.cjs');
const demandController = require('./controllers/demand.controller.cjs');
const orderController = require('./controllers/order.controller.cjs');
const paymentController = require('./controllers/payment.controller.cjs');
const messageController = require('./controllers/message.controller.cjs');
const reviewController = require('./controllers/review.controller.cjs');
const adminController = require('./controllers/admin.controller.cjs');
const extensionController = require('./controllers/extension.controller.cjs');

// Routes - 旧路由（兼容）
app.use('/api/luxmall-infra', require('./routes/files.cjs'));
app.use('/api/luxmall-infra', require('./routes/upload.cjs'));
app.use('/api/luxmall-staff', require('./routes/applet.cjs'));
app.use('/api/luxmall-staff', require('./routes/auth.cjs'));

// Routes - 新 API 路由
app.use('/api/auth', authController);
app.use('/api/parent', parentController);
app.use('/api/companion', companionController);
app.use('/api/demand', demandController);
app.use('/api/order', orderController);
app.use('/api/payment', paymentController);
app.use('/api/message', messageController);
app.use('/api/review', reviewController);
app.use('/api/admin', adminController);
app.use('/api/extension', extensionController);

// 健康检查
app.get('/api/health', (req, res) => {
  res.json({
    status: 'ok',
    info: { database: { status: 'up' } },
    error: {},
    details: { database: { status: 'up' } },
  });
});

app.listen(port, () => {
  console.log(`Mock server is running on port ${port}`);
  console.log(`API endpoints:`);
  console.log(`  - GET  /api/health`);
  console.log(`  - POST /api/auth/wechat/parent`);
  console.log(`  - GET  /api/parent/profile`);
  console.log(`  - GET  /api/parent/children`);
  console.log(`  - GET  /api/parent/addresses`);
  console.log(`  - GET  /api/parent/companions`);
  console.log(`  - GET  /api/companion/list`);
  console.log(`  - GET  /api/companion/:id`);
  console.log(`  - POST /api/demand`);
  console.log(`  - GET  /api/demand/list`);
  console.log(`  - GET  /api/order/parent/list`);
  console.log(`  - GET  /api/payment/wallet`);
  console.log(`  - GET  /api/payment/packages`);
  console.log(`  - GET  /api/message/notifications`);
  console.log(`  - GET  /api/message/notifications/unread-count`);
  console.log(`  - POST /api/review/service`);
  console.log(`  - GET  /api/review/my`);
  console.log(`  - GET  /api/review/companion/:id/stats`);
  console.log(`  - GET  /api/admin/tags`);
  console.log(`  - POST /api/extension/parent/estimate`);
  console.log(`  - POST /api/extension/parent/create`);
  console.log(`  - GET  /api/extension/parent/list`);
  console.log(`  - GET  /api/extension/parent/:id`);
  console.log(`  - POST /api/extension/parent/:id/cancel`);
});
