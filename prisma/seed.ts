import { PrismaClient, Role } from '@prisma/client';
import * as bcrypt from 'bcrypt';

const prisma = new PrismaClient();

async function main() {
  console.log('--- Seeding Demo Data ---');

  // 1. Create Demo Users
  const password = await bcrypt.hash('Demo123!', 10);
  
  const user1 = await prisma.user.upsert({
    where: { email: 'hoang_tuan@example.com' },
    update: {},
    create: {
      email: 'hoang_tuan@example.com',
      username: 'HoangTuan_Dev',
      password,
      role: Role.USER,
      reputation: 150,
      signature: 'Code is life | Fullstack Developer',
      avatarUrl: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Hoang',
    },
  });

  const user2 = await prisma.user.upsert({
    where: { email: 'linh_marketing@example.com' },
    update: {},
    create: {
      email: 'linh_marketing@example.com',
      username: 'LinhMKT',
      password,
      role: Role.USER,
      reputation: 85,
      signature: 'Sẻ chia cơ hội - Cùng nhau kiếm tiền 💸',
      avatarUrl: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Linh',
    },
  });

  const testUser = await prisma.user.upsert({
    where: { email: 'minhnzz1202@gmail.com' },
    update: {},
    create: {
      email: 'minhnzz1202@gmail.com',
      username: 'MinhNzz',
      password,
      role: Role.ADMIN,
      reputation: 999,
      signature: 'Picpee Lead Developer',
      avatarUrl: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Minh',
    },
  });

  console.log('Users created.');

  // 2. Create Categories & Boards
  const catGeneral = await prisma.category.upsert({
    where: { slug: 'thao-luan-chung' },
    update: {},
    create: {
      name: 'Thảo Luận Chung',
      slug: 'thao-luan-chung',
      description: 'Nơi giao lưu, làm quen và tán gẫu.',
      order: 1,
    },
  });

  const boardIntro = await prisma.board.upsert({
    where: { slug: 'ra-mat-thanh-vien' },
    update: {},
    create: {
      name: 'Ra mắt thành viên',
      slug: 'ra-mat-thanh-vien',
      description: 'Bạn mới gia nhập? Hãy giới thiệu bản thân tại đây!',
      categoryId: catGeneral.id,
      order: 1,
    },
  });

  const catEarn = await prisma.category.upsert({
    where: { slug: 'kiem-tien-online' },
    update: {},
    create: {
      name: 'Kiếm Tiền Online (MMO)',
      slug: 'kiem-tien-online',
      description: 'Chia sẻ các kèo hot, task ngon và kinh nghiệm kiếm tiền.',
      order: 2,
    },
  });

  const boardShareEarn = await prisma.board.upsert({
    where: { slug: 'share-earn-tips' },
    update: {},
    create: {
      name: 'Mẹo Share & Earn',
      slug: 'share-earn-tips',
      description: 'Cách tối ưu hóa thu nhập từ hệ thống Share Task của Picpee.',
      categoryId: catEarn.id,
      order: 1,
    },
  });

  console.log('Categories & Boards created.');

  const tag1 = await prisma.tag.upsert({
    where: { slug: 'kiem-tien' },
    update: {},
    create: { name: 'Kiếm Tiền', slug: 'kiem-tien' },
  });

  const tag2 = await prisma.tag.upsert({
    where: { slug: 'chia-se' },
    update: {},
    create: { name: 'Chia Sẻ', slug: 'chia-se' },
  });

  const tag3 = await prisma.tag.upsert({
    where: { slug: 'huong-dan' },
    update: {},
    create: { name: 'Hướng Dẫn', slug: 'huong-dan' },
  });

  const tag4 = await prisma.tag.upsert({
    where: { slug: 'tan-gau' },
    update: {},
    create: { name: 'Tán Gẫu', slug: 'tan-gau' },
  });

  console.log('Tags created.');

  // 3. Create Threads
  const thread1 = await prisma.thread.upsert({
    where: { slug: 'huong-dan-kiem-500k-moi-ngay-tu-picpee' },
    update: {},
    create: {
      title: 'Hướng dẫn kiếm 500k mỗi ngày từ Picpee Share Task',
      slug: 'huong-dan-kiem-500k-moi-ngay-tu-picpee',
      content: `Chào anh em, mình đã tham gia Picpee được 1 tháng và rút được hơn 10 triệu. Bí quyết nằm ở việc chọn lọc thread có Share Task cao và chia sẻ lên đúng các group Facebook có tệp user phù hợp.
      
      Bước 1: Tìm bài viết có nút "Share & Earn".
      Bước 2: Copy link giới thiệu cá nhân.
      Bước 3: Viết caption thu hút và đăng lên MXH.
      
      Chúc anh em thành công!`,
      authorId: user1.id,
      boardId: boardShareEarn.id,
      views: 1250,
      isFeatured: true,
      tags: {
        connect: [{ id: tag1.id }, { id: tag2.id }, { id: tag3.id }]
      }
    },
  });

  const thread2 = await prisma.thread.upsert({
    where: { slug: 'xin-chao-minh-la-thanh-vien-moi' },
    update: {},
    create: {
      title: 'Xin chào, mình là thành viên mới đến từ Hà Nội',
      slug: 'xin-chao-minh-la-thanh-vien-moi',
      content: 'Rất vui được làm quen với mọi người. Mình hy vọng sẽ học hỏi được nhiều kinh nghiệm MMO tại đây.',
      authorId: user2.id,
      boardId: boardIntro.id,
      views: 45,
      tags: {
        connect: [{ id: tag4.id }]
      }
    },
  });

  const thread3 = await prisma.thread.upsert({
    where: { slug: 'top-cac-nen-tang-mmo-uy-tin-2026' },
    update: {},
    create: {
      title: 'Top các nền tảng MMO uy tín 2026',
      slug: 'top-cac-nen-tang-mmo-uy-tin-2026',
      content: 'Bài viết tổng hợp các network và nền tảng tốt nhất để anh em cày cuốc trong năm nay.',
      authorId: testUser.id,
      boardId: boardShareEarn.id,
      views: 890,
      tags: {
        connect: [{ id: tag1.id }, { id: tag2.id }]
      }
    },
  });

  console.log('Threads created.');

  // 4. Create Posts (Replies)
  await prisma.post.create({
    data: {
      content: 'Bài viết hữu ích quá bạn ơi, mình vừa thử và đã có Task đầu tiên được duyệt!',
      authorId: user2.id,
      threadId: thread1.id,
    },
  });

  console.log('Posts created.');

  // 5. Create Wallet for users
  await prisma.wallet.upsert({
    where: { userId: user1.id },
    update: {},
    create: {
      userId: user1.id,
      balance: 1500000,
      pendingBalance: 200000,
    },
  });

  await prisma.wallet.upsert({
    where: { userId: user2.id },
    update: {},
    create: {
      userId: user2.id,
      balance: 50000,
      pendingBalance: 15000,
    },
  });

  console.log('Wallets created.');

  // 6. Create Notifications
  await prisma.notification.createMany({
    data: [
      {
        receiverId: testUser.id,
        senderId: user1.id,
        type: 'LIKE',
        content: 'đã thích bài viết của bạn: ' + thread1.title,
        link: `/thread/${thread1.slug}`,
      },
      {
        receiverId: testUser.id,
        senderId: user2.id,
        type: 'REPLY',
        content: 'đã trả lời một thảo luận bạn đang theo dõi',
        link: `/thread/${thread1.slug}`,
      },
      {
        receiverId: testUser.id,
        type: 'SYSTEM',
        content: 'Ví của bạn vừa được cộng 50.000đ từ sự kiện chào mừng!',
        link: '/wallet',
      },
      {
        receiverId: testUser.id,
        senderId: user1.id,
        type: 'MENTION',
        content: 'đã nhắc đến bạn trong một bình luận',
        link: `/thread/${thread1.slug}`,
      }
    ]
  });

  console.log('Notifications created.');
  console.log('--- Seed Done! ---');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
