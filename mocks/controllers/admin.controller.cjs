const express = require('express');
const router = express.Router();
const tags = require('./data/tags.json');

// ========== 标签管理 ==========

/**
 * 获取标签列表
 * GET /api/admin/tags
 */
router.get('/tags', (req, res) => {
  let result = [...tags];
  const { page = 1, size = 50, category, isActive, keyword } = req.query;

  // 按分类筛选
  if (category) {
    result = result.filter((t) => t.category === category);
  }

  // 按启用状态筛选
  if (isActive !== undefined && isActive !== '') {
    const activeValue = isActive === 'true' || isActive === true;
    result = result.filter((t) => t.isActive === activeValue);
  }

  // 关键词搜索
  if (keyword) {
    result = result.filter((t) =>
      t.name.toLowerCase().includes(keyword.toLowerCase())
    );
  }

  // 按排序字段排序
  result.sort((a, b) => (a.sortOrder || 0) - (b.sortOrder || 0));

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
 * 获取标签详情
 * GET /api/admin/tags/:id
 */
router.get('/tags/:id', (req, res) => {
  const tag = tags.find((t) => t.id === req.params.id);
  if (!tag) {
    return res.status(404).json({
      code: 404,
      message: '标签不存在',
      context: null,
    });
  }
  res.json({
    code: 0,
    message: null,
    context: tag,
  });
});

module.exports = router;
