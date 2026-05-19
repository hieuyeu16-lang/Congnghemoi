import dotenv from 'dotenv';
import app from './app.js';

dotenv.config();
const port = process.env.PORT || 4000;

app.listen(port, () => {
  console.log(`Backend running on http://0.0.0.0:${port}`);
});
