import { PrismaClient, Role } from '@prisma/client';
import * as bcrypt from 'bcrypt';

const prisma = new PrismaClient();

async function main() {
  console.log('--- Seeding EXTENDED Demo Data ---');

  const password = await bcrypt.hash('Demo123!', 10);
  
  // 1. More Diverse Users
  const userSpecs = [
    { email: 'minh_crypto@example.com', username: 'MinhCrypto', sig: 'HODL to the moon 🚀', avatar: 'Minh' },
    { email: 'thao_writer@example.com', username: 'ThaoPhan_Content', sig: 'Viết lách là đam mê', avatar: 'Thao' },
    { email: 'quoc_mmo@example.com', username: 'QuocMMO_Master', sig: 'Chuyên kèo AirDrop & Retroactive', avatar: 'Quoc' },
    { email: 'an_freelance@example.com', username: 'An_Designer', sig: 'Thiết kế thương hiệu | Freelancer', avatar: 'An' },
    { email: 'phuong_gift@example.com', username: 'Phuong_Picpee', sig: 'Picpee Support Team', avatar: 'Phuong' },
  ];

  const users = [];
  for (const spec of userSpecs) {
    const u = await prisma.user.upsert({
      where: { email: spec.email },
      update: {},
      create: {
        email: spec.email,
        username: spec.username,
        password,
        role: Role.USER,
        reputation: Math.floor(Math.random() * 200),
        signature: spec.sig,
        avatarUrl: `https://api.dicebear.com/7.x/avataaars/svg?seed=${spec.avatar}`,
      },
    });
    users.push(u);
  }

  // Get previous users too
  const user1 = await prisma.user.findUnique({ where: { email: 'hoang_tuan@example.com' } });
  const user2 = await prisma.user.findUnique({ where: { email: 'linh_marketing@example.com' } });

  console.log('Extended users created.');

  // 2. New Categories & Boards
  const catService = await prisma.category.upsert({
    where: { slug: 'dich-vu-freelance' },
    update: {},
    create: {
      name: 'Dịch Vụ Freelance',
      slug: 'dich-vu-freelance',
      description: 'Nơi tìm kiếm và cung cấp các dịch vụ số.',
      order: 3,
    },
  });

  const boardDesign = await prisma.board.upsert({
    where: { slug: 'thiet-ke-do-hoa' },
    update: {},
    create: {
      name: 'Thiết kế đồ họa',
      slug: 'thiet-ke-do-hoa',
      description: 'Logo, Banner, UI/UX và các loại hình thiết kế khác.',
      categoryId: catService.id,
      order: 1,
    },
  });

  const boardWriting = await prisma.board.upsert({
    where: { slug: 'viet-lach-content' },
    update: {},
    create: {
      name: 'Viết lách & Content',
      slug: 'viet-lach-content',
      description: 'Copywriting, SEO, Dịch thuật.',
      categoryId: catService.id,
      order: 2,
    },
  });

  console.log('New categories/boards created.');

  // 3. More Threads
  const threadsData = [
    {
      title: 'Chia sẻ bộ tài liệu học UI/UX từ cơ bản đến nâng cao',
      slug: 'bo-tai-lieu-hoc-ui-ux-free',
      content: 'Mình vừa tổng hợp được kho tài liệu cực chất về Figma và quy trình thiết kế Product. Thả tim và comment mình gửi link nhé!',
      author: users[3], // An_Designer
      board: boardDesign,
      views: 450
    },
    {
      title: 'Dịch vụ viết bài chuẩn SEO giá rẻ cho anh em Picpee',
      slug: 'dich-vu-content-seo-gia-re',
      content: 'Nhận viết bài chuẩn SEO đa lĩnh vực. Ưu đãi giảm 30% cho thành viên có uy tín trên 50 tại forum.',
      author: users[1], // ThaoPhan
      board: boardWriting,
      views: 210
    },
    {
      title: 'Kèo AirDrop nhận 50$ cực uy tín từ dự án X',
      slug: 'keo-airdrop-50-do-cuc-uy-tin',
      content: 'Dự án này vừa được Backed bởi các quỹ lớn. Anh em chỉ cần làm task social đơn giản là có slot. Link hướng dẫn tại đây...',
      author: users[2], // QuocMMO
      board: (await prisma.board.findUnique({ where: { slug: 'share-earn-tips' } }))!,
      views: 3200,
      isFeatured: true
    },
    {
      title: 'Quy định rút tiền mới nhất tại Picpee Forum',
      slug: 'quy-dinh-rut-tien-moi-nhat',
      content: 'Để đảm bảo tính minh bạch, tất cả yêu cầu rút tiền sẽ được xử lý trong vòng 24h-48h kể từ ngày yêu cầu (trừ cuối tuần).',
      author: users[4], // Phuong_Picpee
      board: (await prisma.board.findUnique({ where: { slug: 'ra-mat-thanh-vien' } }))!, // or system board
      views: 890,
      isPinned: true
    }
  ];

  for (const t of threadsData) {
    if (t.author && t.board) {
      await prisma.thread.upsert({
        where: { slug: t.slug },
        update: {},
        create: {
          title: t.title,
          slug: t.slug,
          content: t.content,
          authorId: t.author.id,
          boardId: t.board.id,
          views: t.views,
          isFeatured: t.isFeatured || false,
          isPinned: t.isPinned || false
        }
      });
    }
  }

  console.log('Bulk threads created.');

  // 4. Massive Comments (Posts)
  const allThreads = await prisma.thread.findMany();
  const comments = [
    'Hóng link quá bạn ơi!',
    'Đã inbox, check hộ mình nhé.',
    'Dự án này ngon thật, mình cũng vừa làm xong.',
    'Giá bài viết 1000 chữ bao nhiêu vậy bạn?',
    'Picpee duyệt tiền nhanh thật, vừa rút tối qua sáng nay nhận được luôn.',
    'Cảm ơn admin đã thông báo.',
    'Ủng hộ forum ngày càng phát triển!',
    'Chữ ký đẹp đấy ông ơi.',
    'Kèo này còn làm được không nhỉ?',
    'Tuyệt vời, tài liệu rất chi tiết!'
  ];

  for (const thread of allThreads) {
    // Add 2-4 random comments to each thread
    const numComments = Math.floor(Math.random() * 3) + 2;
    for (let i = 0; i < numComments; i++) {
      const randomUser = users[Math.floor(Math.random() * users.length)];
      const randomComment = comments[Math.floor(Math.random() * comments.length)];
      await prisma.post.create({
        data: {
          content: randomComment,
          authorId: randomUser.id,
          threadId: thread.id,
        }
      });
    }
  }

  console.log('Massive comments seeded.');
  console.log('--- Extended Seed Done! ---');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
