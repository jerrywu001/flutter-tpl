const express = require('express');
const router = express.Router();
const children = require('./data/children.json');
const addresses = require('./data/addresses.json');
const companions = require('./data/companions.json');

// 家长个人信息
const parentProfile = {
  userId: 'parent-001',
  realName: '张三',
  idCard: '110101********1234',
  certificationStatus: 'CERTIFIED',
  phone: '13800138001',
  nickname: '张妈妈',
  avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=parent1',
};

// 钱包信息
const walletInfo = {
  balance: 820,
  pendingAmount: 0,
  totalIncome: 0,
  totalWithdraw: 0,
};

// ========== 家长个人信息 ==========
router.get('/profile', (req, res) => {
  res.json({
    code: 0,
    message: null,
    context: parentProfile,
  });
});

router.put('/profile', (req, res) => {
  const { avatarUrl, nickname } = req.body || {};
  if (avatarUrl) parentProfile.avatar = avatarUrl;
  if (nickname) parentProfile.nickname = nickname;
  res.json({
    code: 0,
    message: null,
    context: { message: '更新成功' },
  });
});

// ========== 萌娃管理 ==========
router.get('/children', (req, res) => {
  res.json({
    code: 0,
    message: null,
    context: children,
  });
});

router.get('/children/:id', (req, res) => {
  const child = children.find((c) => c.id === req.params.id);
  if (!child) {
    return res.status(404).json({
      code: 404,
      message: '萌娃不存在',
      context: null,
    });
  }
  res.json({
    code: 0,
    message: null,
    context: child,
  });
});

router.post('/children', (req, res) => {
  const newId = `child-${String(children.length + 1).padStart(3, '0')}`;
  const newChild = {
    id: newId,
    ...req.body,
    age: req.body.birthday
      ? new Date().getFullYear() - new Date(req.body.birthday).getFullYear()
      : null,
  };
  children.push(newChild);
  res.json({
    code: 0,
    message: null,
    context: { id: newId },
  });
});

router.put('/children/:id', (req, res) => {
  const index = children.findIndex((c) => c.id === req.params.id);
  if (index === -1) {
    return res.status(404).json({
      code: 404,
      message: '萌娃不存在',
      context: null,
    });
  }
  children[index] = { ...children[index], ...req.body };
  res.json({
    code: 0,
    message: null,
    context: { message: '更新成功' },
  });
});

router.delete('/children/:id', (req, res) => {
  const index = children.findIndex((c) => c.id === req.params.id);
  if (index === -1) {
    return res.status(404).json({
      code: 404,
      message: '萌娃不存在',
      context: null,
    });
  }
  children.splice(index, 1);
  res.json({
    code: 0,
    message: null,
    context: { message: '删除成功' },
  });
});

// ========== 地址管理 ==========
router.get('/addresses', (req, res) => {
  res.json({
    code: 0,
    message: null,
    context: addresses,
  });
});

router.get('/addresses/:id', (req, res) => {
  const address = addresses.find((a) => a.id === req.params.id);
  if (!address) {
    return res.status(404).json({
      code: 404,
      message: '地址不存在',
      context: null,
    });
  }
  res.json({
    code: 0,
    message: null,
    context: address,
  });
});

router.post('/addresses', (req, res) => {
  const newId = `addr-${String(addresses.length + 1).padStart(3, '0')}`;
  const { province, city, district, detail, isDefault, ...rest } = req.body;
  const newAddress = {
    id: newId,
    ...rest,
    province,
    city,
    district,
    detail,
    fullAddress: `${province}${city}${district}${detail}`,
    isDefault: isDefault || false,
  };
  // 如果设置为默认，取消其他默认
  if (newAddress.isDefault) {
    addresses.forEach((a) => (a.isDefault = false));
  }
  addresses.push(newAddress);
  res.json({
    code: 0,
    message: null,
    context: { id: newId },
  });
});

router.put('/addresses/:id', (req, res) => {
  const index = addresses.findIndex((a) => a.id === req.params.id);
  if (index === -1) {
    return res.status(404).json({
      code: 404,
      message: '地址不存在',
      context: null,
    });
  }
  addresses[index] = { ...addresses[index], ...req.body };
  res.json({
    code: 0,
    message: null,
    context: { message: '更新成功' },
  });
});

router.delete('/addresses/:id', (req, res) => {
  const index = addresses.findIndex((a) => a.id === req.params.id);
  if (index === -1) {
    return res.status(404).json({
      code: 404,
      message: '地址不存在',
      context: null,
    });
  }
  addresses.splice(index, 1);
  res.json({
    code: 0,
    message: null,
    context: { message: '删除成功' },
  });
});

router.put('/addresses/:id/default', (req, res) => {
  const index = addresses.findIndex((a) => a.id === req.params.id);
  if (index === -1) {
    return res.status(404).json({
      code: 404,
      message: '地址不存在',
      context: null,
    });
  }
  // 取消所有默认
  addresses.forEach((a) => (a.isDefault = false));
  addresses[index].isDefault = true;
  res.json({
    code: 0,
    message: null,
    context: { message: '设置成功' },
  });
});

// ========== 陪伴官列表 ==========
router.get('/companions', (req, res) => {
  let result = [...companions];
  const { page = 1, size = 10, tags, serviceTypes, radius } = req.query;

  // 筛选
  if (tags) {
    const tagList = Array.isArray(tags) ? tags : [tags];
    result = result.filter((c) => c.tags.some((t) => tagList.includes(t)));
  }
  if (serviceTypes) {
    const typeList = Array.isArray(serviceTypes) ? serviceTypes : [serviceTypes];
    result = result.filter((c) =>
      c.serviceTypes?.some((t) => typeList.includes(t))
    );
  }
  if (radius) {
    result = result.filter((c) => c.distance <= Number(radius));
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
      totalPages: Math.ceil(total / Number(size)),
    },
  });
});

router.get('/companions/:id', (req, res) => {
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

// ========== 钱包信息 ==========
router.get('/wallet', (req, res) => {
  res.json({
    code: 0,
    message: null,
    context: walletInfo,
  });
});

// ========== 服务日历 ==========
router.get('/calendar', (req, res) => {
  const { month } = req.query;
  // 返回模拟日历数据 - 包含已完成、进行中、待服务三种状态
  // 使用与订单数据一致的 ID，确保跳转订单详情时能正确匹配
  const tasks = [
    // 已完成的服务
    {
      date: `${month}-10`,
      tasks: [
        {
          id: 'order-004',
          taskNo: 'TASK20250110001',
          serviceType: 'HOMEWORK',
          startTime: '14:00',
          endTime: '16:00',
          childName: '小明',
          companionName: '小王老师',
          companionLevel: '金牌',
          companionAvatar: 'https://picsum.photos/seed/c1/400/400',
          companionPhone: '13800138001',
          address: '北京市朝阳区建国路88号SOHO现代城A座1501',
          status: 'COMPLETED',
        },
      ],
    },
    {
      date: `${month}-08`,
      tasks: [
        {
          id: 'order-005',
          taskNo: 'TASK20250108001',
          serviceType: 'INTEREST',
          startTime: '10:00',
          endTime: '12:00',
          childName: '小红',
          companionName: '小张老师',
          companionLevel: '银牌',
          companionAvatar: 'https://picsum.photos/seed/c2/400/400',
          companionPhone: '13800138002',
          address: '北京市朝阳区建国路88号SOHO现代城A座1501',
          status: 'COMPLETED',
        },
      ],
    },
    // 进行中的服务
    {
      date: `${month}-18`,
      tasks: [
        {
          id: 'order-003',
          taskNo: 'TASK20250118001',
          serviceType: 'PICKUP',
          startTime: '16:30',
          endTime: '17:30',
          childName: '小刚',
          companionName: '小刘老师',
          companionLevel: '金牌',
          companionAvatar: 'https://picsum.photos/seed/c3/400/400',
          companionPhone: '13800138003',
          address: '北京市朝阳区建国路88号SOHO现代城A座1501',
          status: 'IN_PROGRESS',
        },
      ],
    },
    // 待服务
    {
      date: `${month}-15`,
      tasks: [
        {
          id: 'order-001',
          taskNo: 'TASK20250115001',
          serviceType: 'HOMEWORK',
          startTime: '14:00',
          endTime: '16:00',
          childName: '小明',
          companionName: '待分配',
          companionLevel: '',
          companionAvatar: '',
          companionPhone: '',
          address: '北京市朝阳区建国路88号SOHO现代城A座1501',
          status: 'PENDING',
        },
      ],
    },
    {
      date: `${month}-16`,
      tasks: [
        {
          id: 'order-002',
          taskNo: 'TASK20250116001',
          serviceType: 'ACCOMPANY',
          startTime: '09:00',
          endTime: '12:00',
          childName: '小红',
          companionName: '小张老师',
          companionLevel: '银牌',
          companionAvatar: 'https://picsum.photos/seed/c4/400/400',
          companionPhone: '13800138004',
          address: '北京市朝阳区建国路88号SOHO现代城A座1501',
          status: 'PENDING',
        },
      ],
    },
    {
      date: `${month}-17`,
      tasks: [
        {
          id: 'task-new-001',
          taskNo: 'TASK20250117001',
          serviceType: 'TUTORING',
          startTime: '15:00',
          endTime: '17:00',
          childName: '小明',
          companionName: '小陈老师',
          companionLevel: '标准',
          companionAvatar: 'https://picsum.photos/seed/c5/400/400',
          companionPhone: '13800138005',
          address: '北京市海淀区中关村大街1号海龙大厦8层',
          status: 'PENDING',
        },
      ],
    },
  ];

  res.json({
    code: 0,
    message: null,
    context: {
      tasks,
      summary: {
        totalTasks: 6,
        completedTasks: 2,
        inProgressTasks: 1,
        pendingTasks: 3,
      },
    },
  });
});

module.exports = router;
