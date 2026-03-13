
import { PrismaClient } from '@prisma/client';
import * as bcrypt from 'bcrypt';

const prisma = new PrismaClient();

async function main() {
  const email = 'admin.pp.forum@gmail.com';
  const password = 'AdminPP@1123';
  const hashedPassword = await bcrypt.hash(password, 10);

  const user = await prisma.user.upsert({
    where: { email },
    update: {
      password: hashedPassword,
      role: 'ADMIN',
      reputation: 999,
    },
    create: {
      email,
      username: 'AdminPP',
      password: hashedPassword,
      role: 'ADMIN',
      reputation: 999,
      avatarUrl: `https://api.dicebear.com/7.x/avataaars/svg?seed=AdminPP`,
      signature: 'Picpee Senior Admin',
    },
  });

  console.log('--- ADMIN CREATED ---');
  console.log('Email:', user.email);
  console.log('Role:', user.role);
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
