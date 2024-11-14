import path from 'path';
import serviceAccount from '../../serviceAccount.json'
import admin from 'firebase-admin'

admin.initializeApp({
  credential: admin.credential.cert(path.resolve(__dirname, '../../serviceAccount.json')),
  databaseURL: `https://${serviceAccount.project_id}.firebaseio.com`
});

export default admin;