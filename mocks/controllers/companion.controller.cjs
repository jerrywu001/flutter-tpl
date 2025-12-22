const express = require('express');
const router = express.Router();
const companions = require('./data/companions.json');

/**
 * 陪伴官列表（用于推荐列表页面）
 * GET /api/companion/list
 */
router.get('/list', (req, res) => {
  let result = [...companions];
  const { page = 1, size = 10, tags, serviceTypes, demandId } = req.query;

  // 按标签筛选
  if (tags) {
    const tagList = Array.isArray(tags) ? tags : [tags];
    result = result.filter((c) => c.tags.some((t) => tagList.includes(t)));
  }

  // 按服务类型筛选
  if (serviceTypes) {
    const typeList = Array.isArray(serviceTypes) ? serviceTypes : [serviceTypes];
    result = result.filter((c) =>
      c.serviceTypes?.some((t) => typeList.includes(t))
    );
  }

  // 如果有需求ID，可以根据需求匹配陪伴官（模拟智能匹配）
  if (demandId) {
    // 模拟：按信用分和好评率排序，取前20个作为推荐
    result = result
      .sort((a, b) => {
        const scoreA = a.creditScore * 0.5 + a.goodRate * 0.5;
        const scoreB = b.creditScore * 0.5 + b.goodRate * 0.5;
        return scoreB - scoreA;
      })
      .slice(0, 20);
  }

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
    },
  });
});

/**
 * 陪伴官详情
 * GET /api/companion/:id
 */
router.get('/:id', (req, res) => {
  const companion = companions.find((c) => c.id === req.params.id);
  if (!companion) {
    return res.status(404).json({
      code: 404,
      message: '陪伴官不存在',
      context: null,
    });
  }

  // 详情增加额外字段
  const detail = {
    ...companion,
    tags: companion.tags.map((name, idx) => ({
      id: `tag-${idx + 1}`,
      name,
    })),
    services: [
      { title: '作业辅导', description: '专业辅导各科作业', icon: 'homework' },
      { title: '日常陪伴', description: '陪伴玩耍、阅读等', icon: 'accompany' },
    ],
    guarantees: [
      { title: '岗前培训', description: '通过平台专业培训', iconType: 'training' },
      { title: '服务保险', description: '全程服务保障', iconType: 'insurance' },
    ],
    experiences: [
      {
        id: 'exp-1',
        title: '家教老师',
        description: '辅导小学生作业',
        startDate: '2023-09',
        endDate: '2024-06',
      },
    ],
    reviews: [
      {
        id: 'review-1',
        nickname: '用户A',
        avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=user1',
        rating: 5,
        content: '非常认真负责，孩子很喜欢',
        createTime: '2025-01-05T10:00:00.000Z',
      },
    ],
  };

  res.json({
    code: 0,
    message: null,
    context: detail,
  });
});

/**
 * 服务类型列表
 * GET /api/companion/service-types
 */
router.get('/service-types', (req, res) => {
  const serviceTypes = [
    { id: 'HOMEWORK', name: '作业辅导', icon: 'homework' },
    { id: 'ACCOMPANY', name: '日常陪伴', icon: 'accompany' },
    { id: 'TUTORING', name: '学科辅导', icon: 'tutoring' },
    { id: 'INTEREST', name: '兴趣培养', icon: 'interest' },
    { id: 'PICKUP', name: '接送服务', icon: 'pickup' },
  ];

  res.json({
    code: 0,
    message: null,
    context: {
      list: serviceTypes,
    },
  });
});

module.exports = router;
