import express from 'express';

const router = express.Router();

const sampleTasks = [
  {
    id: 1,
    title: 'Lên kế hoạch tuần',
    description: 'Tạo danh sách công việc và ưu tiên cho tuần này.',
    completed: false,
    dueDate: '2026-05-22'
  },
  {
    id: 2,
    title: 'Hoàn thành báo cáo',
    description: 'Gửi báo cáo tiến độ dự án cho quản lý.',
    completed: true,
    dueDate: '2026-05-18'
  },
  {
    id: 3,
    title: 'Họp nhóm sprint',
    description: 'Chuẩn bị nội dung và chia sẻ tình trạng công việc.',
    completed: false,
    dueDate: '2026-05-19'
  }
];

router.get('/', async (req, res) => {
  try {
    res.json({ tasks: sampleTasks });
  } catch (error) {
    console.error('Tasks API failed', error);
    res.status(500).json({ message: 'Unable to load tasks' });
  }
});

export default router;
