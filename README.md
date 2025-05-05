# Full Stack Application

This is a full stack application with a Flutter frontend and an Express.js backend.

## Project Structure

```
project-root/
├── app/          # Flutter frontend application
└── server/      # Express.js backend server
```

## Backend Setup (Express.js)

### Prerequisites
- Node.js (v22.1.0 or higher)
- MongoDB database

### Environment Variables

Create a `.env` file in the `server` folder with the following variables:

```
DBNAME=your_database_name
MONGODB_URL=your_mongodb_connection_string
SMS_API_KEY=your_sms_api_key
SMS_SENDERID=your_sms_sender_id
JWT_SECRET=your_jwt_secret_key
```

### Installation

1. Navigate to the server folder:
   ```bash
   cd server
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Start the development server:
   ```bash
   npm start
   ```

The server should now be running on `http://localhost:3000` (or the port you've configured).

## Frontend Setup (Flutter)

### Prerequisites
- Flutter SDK
- Android Studio/Xcode (for mobile development)

### Google Maps API Key

Add your Google Maps API key to the `local.properties` file in the Flutter project:

1. Navigate to the app folder:
   ```bash
   cd app
   ```

2. Create or edit `android/local.properties` and add:
   ```
   google.maps.key=YOUR_GOOGLE_MAPS_API_KEY
   ```

### Installation

1. Get Flutter dependencies:
   ```bash
   flutter pub get
   ```

2. Run the app:
   ```bash
   flutter run
   ```

## Development

### Backend
- The Express server uses MongoDB for data storage
- JWT is used for authentication
- SMS functionality is integrated via an external API

### Frontend
- The Flutter app communicates with the backend via HTTP requests
- Google Maps integration requires proper API key setup
