import * as admin from 'firebase-admin';
import * as path from 'path';

if (!admin.apps.length) {
  const serviceAccountPath = path.resolve(__dirname, '../../firebase-service-account.json');
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccountPath),
  });
}

export default admin;
