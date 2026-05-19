import express from 'express';

const router = express.Router();

let nextId = 1;
const bookings = [
  { id: nextId++, name: 'Phỏng vấn ứng viên', date: '2026-05-25', time: '10:00', note: 'Phòng họp A' },
  { id: nextId++, name: 'Họp với khách hàng', date: '2026-05-26', time: '14:30', note: 'Zoom' }
];

router.get('/', (req, res) => {
  try {
    res.json({ bookings });
  } catch (error) {
    console.error('Bookings GET failed', error);
    res.status(500).json({ message: 'Unable to load bookings' });
  }
});

router.post('/', (req, res) => {
  try {
    const { name, date, time, note } = req.body;
    if (!name || !date) {
      return res.status(400).json({ message: 'Missing required fields' });
    }
    const booking = { id: nextId++, name, date, time: time || '', note: note || '' };
    bookings.push(booking);
    res.status(201).json(booking);
  } catch (error) {
    console.error('Bookings POST failed', error);
    res.status(500).json({ message: 'Unable to create booking' });
  }
});

router.delete('/:id', (req, res) => {
  try {
    const id = Number(req.params.id);
    const idx = bookings.findIndex((b) => b.id === id);
    if (idx === -1) return res.status(404).json({ message: 'Not found' });
    const [removed] = bookings.splice(idx, 1);
    res.json(removed);
  } catch (error) {
    console.error('Bookings DELETE failed', error);
    res.status(500).json({ message: 'Unable to delete booking' });
  }
});

export default router;
