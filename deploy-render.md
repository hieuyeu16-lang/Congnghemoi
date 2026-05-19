# Deploy to Render

## Backend Deployment

1. Create a new Web Service on Render
2. Connect your GitHub repository
3. Configure build settings:
   - Build Command: `cd backend && npm install`
   - Start Command: `cd backend && npm start`
4. Add environment variables:
   - DATABASE_URL: `postgresql://[your_render_db_url]`
   - PORT: `10000` (Render assigns port automatically)

## Frontend Deployment

1. Create a new Static Site on Render
2. Connect the same GitHub repository
3. Configure build settings:
   - Build Command: `cd frontend && npm install && npm run build`
   - Publish Directory: `frontend/dist`
4. Add environment variable:
   - VITE_API_URL: `https://[your-backend-service].onrender.com`

## Database Setup

1. Create a PostgreSQL database on Render
2. Note the connection string
3. Update backend DATABASE_URL with the Render database URL

## Notes

- Render provides free tier for both web services and databases
- Automatic HTTPS certificates
- Custom domains available
- Environment variables are securely stored
- Logs available in Render dashboard

## Troubleshooting

- If backend fails to connect to database, check DATABASE_URL format
- If frontend can't reach backend, verify VITE_API_URL is correct
- Check Render logs for detailed error messages