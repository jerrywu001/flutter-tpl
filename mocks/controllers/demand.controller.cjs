const express = require('express');
const router = express.Router();
const demands = require('./data/demands.json');
const companions = require('./data/companions.json');

// ========== 发布需求 ==========
router.post('/', (req, res) => {
  const newId = `demand-${String(demands.length + 1).padStart(3, '0')}`;
  const taskNo = `TASK${new Date().toISOString().slice(0, 10).replace(/-/g, '')}${String(demands.length + 1).padStart(3, '0')}`;

  const newDemand = {
    id: newId,
    taskNo,
    parentId: 'parent-001',
    ...req.body,
    status: 'PENDING_ASSIGN',
    companionName: null,
    createdAt: new Date().toISOString(),
  };
  demands.push(newDemand);

  res.json({
    code: 0,
    message: null,
    data: {
      id: newId,
      taskNo,
      message: '需求发布成功',
    },
  });
});

// ========== 智能匹配陪伴官 ==========
router.get('/match', (req, res) => {
  let result = [...companions];
  const {
    page = 1,
    size = 10,
    serviceType,
    _tagIds,
    maxDistance,
  } = req.query;

  // 筛选
  if (serviceType) {
    result = result.filter((c) => c.serviceTypes?.includes(serviceType));
  }
  if (maxDistance) {
    result = result.filter((c) => c.distance <= Number(maxDistance));
  }

  // 添加匹配分数
  result = result.map((c) => ({
    ...c,
    matchScore: Math.round(c.creditScore * 0.4 + c.goodRate * 0.4 + (10 - c.distance) * 2),
  }));

  // 按匹配分数排序
  result.sort((a, b) => b.matchScore - a.matchScore);

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

// ========== 需求列表 ==========
router.get('/list', (req, res) => {
  let result = [...demands];
  const { page = 1, size = 10, status } = req.query;

  // 筛选
  if (status) {
    result = result.filter((d) => d.status === status);
  }

  // 按创建时间倒序
  result.sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt));

  const total = result.length;
  const start = (Number(page) - 1) * Number(size);
  const end = start + Number(size);
  const list = result.slice(start, end).map((demand) => ({
    id: demand.id,
    taskNo: demand.taskNo,
    matchStatus: demand.matchStatus,
    serviceItemsSummary: demand.serviceItems?.map((item) => item.name).join('、') || '',
    childrenNames: demand.children?.map((c) => c.childName).join('、') || '',
    area: demand.addressDetail?.split('市')[1]?.split('区')[0] + '区' || '',
    createdAt: demand.createdAt,
    createdAtDesc: getTimeDesc(demand.createdAt),
    recommendCount: demand.matchStatus === 'MATCHED' ? Math.floor(Math.random() * 5) + 1 : 0,
    recommendAvatars: demand.matchStatus === 'MATCHED'
      ? ['https://api.dicebear.com/7.x/avataaars/svg?seed=1', 'https://api.dicebear.com/7.x/avataaars/svg?seed=2']
      : [],
  }));

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

// 获取时间描述
function getTimeDesc(dateStr) {
  const now = new Date();
  const date = new Date(dateStr);
  const diff = now - date;
  const minutes = Math.floor(diff / 60000);
  const hours = Math.floor(diff / 3600000);
  const days = Math.floor(diff / 86400000);

  if (minutes < 1) return '刚刚发布';
  if (minutes < 60) return `${minutes}分钟前发布`;
  if (hours < 24) return `${hours}小时前发布`;
  if (days < 7) return `${days}天前发布`;
  return date.toLocaleDateString('zh-CN');
}

// ========== 需求详情 ==========
router.get('/:id', (req, res) => {
  const demand = demands.find((d) => d.id === req.params.id);
  if (!demand) {
    return res.status(404).json({
      code: 404,
      message: '需求不存在',
      data: null,
    });
  }
  res.json({
    code: 0,
    message: null,
    data: demand,
  });
});

// ========== 取消需求 ==========
router.delete('/:id', (req, res) => {
  const index = demands.findIndex((d) => d.id === req.params.id);
  if (index === -1) {
    return res.status(404).json({
      code: 404,
      message: '需求不存在',
      data: null,
    });
  }
  const demand = demands[index];
  if (!['PENDING_ASSIGN', 'PENDING_ACCEPT'].includes(demand.status)) {
    return res.status(400).json({
      code: 400,
      message: '当前状态不可取消',
      data: null,
    });
  }
  demands[index].status = 'CANCELLED';
  res.json({
    code: 0,
    message: null,
    data: { message: '取消成功' },
  });
});

module.exports = router;
