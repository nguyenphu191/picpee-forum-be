import { PrismaClient, Role } from '@prisma/client';
import * as bcrypt from 'bcrypt';

const prisma = new PrismaClient();

async function main() {
  const username = 'admin';
  const email = 'admin@picpee.com';
  const password = 'AdminPassword123!'; // User can change this later

  const hashedPassword = await bcrypt.hash(password, 10);

  const user = await prisma.user.upsert({
    where: { email },
    update: {
      role: Role.ADMIN,
      username: username,
    },
    create: {
      email,
      username,
      password: hashedPassword,
      role: Role.ADMIN,
      emailVerified: true,
    },
  });

  console.log('Admin user created/updated:', user.username);
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
