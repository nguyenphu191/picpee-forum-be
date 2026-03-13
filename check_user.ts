import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  const user = await prisma.user.findUnique({
    where: { email: 'minhnzz1202@gmail.com' }
  });
  console.log('USER_INFO:', JSON.stringify(user));
}

main()
  .catch(console.error)
  .finally(async () => {
    await prisma.$disconnect();
  });
