const express = require('express');
const router = express.Router();

// 查询哀悼日状态
router.get('/status', (req, res) => {
  // 获取当前日期
  const now = new Date();
  const month = now.getMonth() + 1; // 月份从0开始
  const day = now.getDate();

  let isMourningDay = false;
  let reason = null;

  // 检查是否是哀悼日
  if (month === 12 && day === 13) {
    isMourningDay = true;
    reason = '南京大屠杀死难者国家公祭日';
  } else if (month === 5 && day === 12) {
    isMourningDay = true;
    reason = '汶川地震纪念日';
  } else if (month === 4 && day === 4) {
    isMourningDay = true;
    reason = '清明节';
  } else if (month === 7 && day === 28) {
    isMourningDay = true;
    reason = '唐山大地震纪念日';
  }

  console.log('查询了哀悼日状态');

  res.json({
    code: 0,
    message: null,
    data: {
      isMourningDay,
      reason,
      startDate: isMourningDay ? now.toISOString().split('T')[0] : null,
      endDate: isMourningDay ? now.toISOString().split('T')[0] : null,
    },
  });
});

module.exports = router;
