import { useEffect, useState } from 'react';
import logo from './assets/logo.svg';

const apiUrl = import.meta.env.VITE_API_URL || '';
const apiBase = apiUrl || '';

function App() {
  const [health, setHealth] = useState(null);
  const [bookings, setBookings] = useState([]);
  const [error, setError] = useState(null);
  const [bookingForm, setBookingForm] = useState({ name: '', date: '', time: '', note: '' });
  const [showList, setShowList] = useState(true);

  useEffect(() => {
    async function load() {
      try {
        const healthRes = await fetch(`${apiBase}/api/health`);
        const bookingsRes = await fetch(`${apiBase}/api/bookings`);
        if (!healthRes.ok) throw new Error('Không thể kết nối tới backend');
        const healthData = await healthRes.json();
        const bookingsData = await bookingsRes.json();
        setHealth(healthData);
        setBookings(bookingsData.bookings || []);
      } catch (err) {
        setError(err.message);
      }
    }
    load();
  }, []);

  return (
    <div className="app-wrapper">
      <div className="app-container">
      <div className="hero-panel">
        <div>
          <div className="hero-header">
            <img src={logo} alt="App logo" className="app-logo" />
            <div>
              <p className="eyebrow">Bản demo</p>
              <h1>Hệ thống đặt lịch</h1>
            </div>
          </div>
          <p className="hero-text">Tạo, xem và hủy lịch đặt đơn giản và nhanh chóng.</p>
        </div>
        <div className="summary-card">
          <p className="summary-title">Tổng quan hệ thống</p>
          <p><strong>API backend:</strong> <code>{apiUrl}</code></p>
          <p><strong>Số lịch hiện có:</strong> {bookings.length}</p>
          <p><strong>Trạng thái backend:</strong> {health?.status ?? 'Loading...'}</p>
        </div>
      </div>

      <section className="status-section">
        <div className="status-card">
          <h2>Trạng thái backend</h2>
          {error && <p className="error">Lỗi: {error}</p>}
          {health ? (
            <div className="status-grid">
              <div>
                <span>Trạng thái</span>
                <strong>{health.status}</strong>
              </div>
              <div>
                <span>Cơ sở dữ liệu</span>
                <strong>{health.db}</strong>
              </div>
              <div>
                <span>Thời điểm</span>
                <strong>{new Date(health.timestamp).toLocaleString('vi-VN')}</strong>
              </div>
            </div>
          ) : (
            <p>Đang tải trạng thái hệ thống phụ trợ...</p>
          )}
        </div>
      </section>

      <section className="booking-section">
        <div className="section-header">
          <h2>Hệ thống đặt lịch</h2>
          <div style={{ display: 'flex', gap: '12px', alignItems: 'center' }}>
            <span className="task-count">{bookings.length} lịch</span>
            <button className="btn secondary" onClick={() => setShowList(s => !s)}>{showList ? 'Ẩn danh sách' : 'Xem danh sách'}</button>
          </div>
        </div>

        <div className="booking-grid">
          <form className="booking-form" onSubmit={async (e) => {
            e.preventDefault();
            try {
              const res = await fetch(`${apiUrl}/api/bookings`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(bookingForm)
              });
              if (!res.ok) throw new Error('Không thể tạo lịch');
              const created = await res.json();
              setBookings((s) => [created, ...s]);
              setBookingForm({ name: '', date: '', time: '', note: '' });
              setError(null);
            } catch (err) {
              setError(err.message);
            }
          }}>
            <label>Họ tên</label>
            <input value={bookingForm.name} onChange={(e) => setBookingForm({ ...bookingForm, name: e.target.value })} required />
            <label>Ngày</label>
            <input type="date" value={bookingForm.date} onChange={(e) => setBookingForm({ ...bookingForm, date: e.target.value })} required />
            <label>Thời gian</label>
            <input type="time" value={bookingForm.time} onChange={(e) => setBookingForm({ ...bookingForm, time: e.target.value })} />
            <label>Ghi chú</label>
            <input value={bookingForm.note} onChange={(e) => setBookingForm({ ...bookingForm, note: e.target.value })} />
            <div className="form-actions">
              <button className="btn primary" type="submit">Tạo lịch</button>
            </div>
          </form>

          <div>
            {showList && (
              (bookings.length === 0) ? <p>Chưa có lịch đặt.</p> : (
                <ul className="booking-list">
                  {bookings.map((b) => (
                    <li key={b.id} className="booking-item">
                      <div>
                        <strong>{b.name}</strong>
                        <div className="muted">{b.date} {b.time && `• ${b.time}`}</div>
                        {b.note && <div className="muted">{b.note}</div>}
                      </div>
                      <div className="booking-actions">
                        <button className="btn danger" onClick={async () => {
                          try {
                            const res = await fetch(`${apiUrl}/api/bookings/${b.id}`, { method: 'DELETE' });
                            if (!res.ok) throw new Error('Không thể hủy lịch');
                            setBookings((s) => s.filter(x => x.id !== b.id));
                          } catch (err) {
                            setError(err.message);
                          }
                        }}>Hủy</button>
                      </div>
                    </li>
                  ))}
                </ul>
              )
            )}
          </div>
        </div>
      </section>
      </div>
    </div>
  );
}

export default App;
