
import { PrismaClient } from '@prisma/client';
import * as bcrypt from 'bcrypt';

const prisma = new PrismaClient();

async function main() {
  const hashedPassword = await bcrypt.hash('password123', 10);
  
  // 1. Get an active board
  const board = await prisma.board.findFirst({
    where: { status: 'ACTIVE' }
  });

  if (!board) {
    console.error('No ACTIVE board found. Please create one first.');
    return;
  }

  console.log(`Using board: ${board.name} (${board.id})`);

  // 2. Create 5 users
  const users = [];
  for (let i = 1; i <= 5; i++) {
    const email = `user${Date.now()}${i}@example.com`;
    const username = `Member_${i}_${Math.floor(Math.random() * 1000)}`;
    const user = await prisma.user.create({
      data: {
        email,
        username,
        password: hashedPassword,
        reputation: 10,
        avatarUrl: `https://api.dicebear.com/7.x/pixel-art/svg?seed=${username}`,
      }
    });
    users.push(user);
    console.log(`Created User: ${username}`);
  }

  // 3. Create 5 threads
  const threadTitles = [
    'Làm thế nào để bắt đầu với Freelance năm 2024?',
    'Chia sẻ kinh nghiệm kiếm tiền từ Affiliate Marketing',
    'Tìm đồng đội làm dự án khởi nghiệp công nghệ',
    'Review các công cụ hỗ trợ làm việc từ xa tốt nhất',
    'Kể về lần đầu tiên bạn kiếm được tiền trên mạng'
  ];

  for (let i = 0; i < 5; i++) {
    const author = users[i];
    const thread = await prisma.thread.create({
      data: {
        title: threadTitles[i],
        content: `Chào mọi người, mình là ${author.username}. Đây là nội dung bài viết thứ ${i+1} về chủ đề "${threadTitles[i]}". Hy vọng nhận được nhiều chia sẻ từ anh em!`,
        slug: `bai-viet-mau-${Date.now()}-${i}`,
        boardId: board.id,
        authorId: author.id,
        views: Math.floor(Math.random() * 100),
      }
    });
    console.log(`Created Thread: ${thread.title}`);

    // 4. Create 1-3 comments for each thread
    const commentCount = Math.floor(Math.random() * 3) + 1;
    for (let j = 0; j < commentCount; j++) {
      const commenter = users[Math.floor(Math.random() * users.length)];
      await prisma.post.create({
        data: {
          content: `Bình luận thứ ${j+1} từ ${commenter.username}. Bài viết rất hữu ích!`,
          threadId: thread.id,
          authorId: commenter.id,
        }
      });
    }
    console.log(`- Added ${commentCount} comments to "${thread.title}"`);
  }

  console.log('\n--- SEEDING COMPLETED ---');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
