const express = require('express');
const router = express.Router();
const reviews = require('./data/reviews.json');

/**
 * 创建服务评价
 */
router.post('/service', (req, res) => {
  const newId = `review-${Date.now()}`;

  res.json({
    code: 0,
    message: '评价提交成功',
    data: { id: newId },
  });
});

/**
 * 创建萌娃评价
 */
router.post('/child', (req, res) => {
  const newId = `review-${Date.now()}`;

  res.json({
    code: 0,
    message: '评价提交成功',
    data: { id: newId },
  });
});

/**
 * 获取评价详情
 */
router.get('/:id', (req, res) => {
  const { id } = req.params;
  const review = reviews.find(item => item.id === id);

  if (!review) {
    return res.json({
      code: 404,
      message: '评价不存在',
      data: null,
    });
  }

  res.json({
    code: 0,
    message: null,
    data: review,
  });
});

/**
 * 获取我的评价列表
 */
router.get('/my', (req, res) => {
  const { page = 1, size = 10 } = req.query;

  // 筛选服务评价（家长端发出的评价）
  const all = reviews.filter(item => item.reviewType === 'SERVICE');

  // 按时间倒序排序
  all.sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt));

  const total = all.length;
  const start = (Number(page) - 1) * Number(size);
  const end = start + Number(size);
  const list = all.slice(start, end);

  res.json({
    code: 0,
    message: null,
    data: {
      list,
      total,
      page: Number(page),
      size: Number(size),
    },
  });
});

/**
 * 检查订单是否可评价
 */
router.get('/check/:orderId', (req, res) => {
  const { orderId } = req.params;
  const existingReview = reviews.find(item => item.orderId === orderId && item.reviewType === 'SERVICE');

  res.json({
    code: 0,
    message: null,
    data: {
      canReview: !existingReview,
      reason: existingReview ? '该订单已评价' : undefined,
      reviewId: existingReview ? existingReview.id : undefined,
    },
  });
});

/**
 * 获取陪伴官评价列表
 */
router.get('/companion/:companionId', (req, res) => {
  const { companionId } = req.params;
  const { page = 1, size = 10 } = req.query;

  const all = reviews.filter(
    item => item.reviewType === 'SERVICE' && item.companion && item.companion.id === companionId
  );

  // 按时间倒序排序
  all.sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt));

  const total = all.length;
  const start = (Number(page) - 1) * Number(size);
  const end = start + Number(size);
  const list = all.slice(start, end);

  res.json({
    code: 0,
    message: null,
    data: {
      list,
      total,
      page: Number(page),
      size: Number(size),
    },
  });
});

/**
 * 获取陪伴官评价统计
 */
router.get('/companion/:companionId/stats', (req, res) => {
  const { companionId } = req.params;

  const companionReviews = reviews.filter(
    item => item.reviewType === 'SERVICE' && item.companion && item.companion.id === companionId
  );

  const totalReviews = companionReviews.length;
  const ratingSum = companionReviews.reduce((sum, item) => sum + item.rating, 0);
  const averageRating = totalReviews > 0 ? Number((ratingSum / totalReviews).toFixed(1)) : 0;

  const fiveStarCount = companionReviews.filter(item => item.rating === 5).length;
  const fourStarCount = companionReviews.filter(item => item.rating === 4).length;
  const threeStarCount = companionReviews.filter(item => item.rating === 3).length;
  const twoStarCount = companionReviews.filter(item => item.rating === 2).length;
  const oneStarCount = companionReviews.filter(item => item.rating === 1).length;

  const goodCount = fiveStarCount + fourStarCount;
  const goodRate = totalReviews > 0 ? Number(((goodCount / totalReviews) * 100).toFixed(1)) : 0;

  res.json({
    code: 0,
    message: null,
    data: {
      companionId,
      totalReviews,
      averageRating,
      goodRate,
      fiveStarCount,
      fourStarCount,
      threeStarCount,
      twoStarCount,
      oneStarCount,
      recentReviews: companionReviews.slice(0, 5),
    },
  });
});

/**
 * 获取萌娃评价列表
 */
router.get('/child/:childId', (req, res) => {
  const { childId } = req.params;
  const { page = 1, size = 10 } = req.query;

  const all = reviews.filter(
    item => item.reviewType === 'CHILD' && item.child && item.child.id === childId
  );

  // 按时间倒序排序
  all.sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt));

  const total = all.length;
  const start = (Number(page) - 1) * Number(size);
  const end = start + Number(size);
  const list = all.slice(start, end);

  res.json({
    code: 0,
    message: null,
    data: {
      list,
      total,
      page: Number(page),
      size: Number(size),
    },
  });
});

module.exports = router;
