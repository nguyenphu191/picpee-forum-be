import { PrismaClient } from '@prisma/client';
const prisma = new PrismaClient();
async function main() {
  const user = await prisma.user.findUnique({ where: { email: 'minhnzz1202@gmail.com' } });
  if (user) {
    console.log('USER_ID:', user.id);
    const otherUser = await prisma.user.findFirst({ where: { id: { not: user.id } } });
    const thread = await prisma.thread.findFirst();
    
    // Create sample notifications
    await prisma.notification.createMany({
      data: [
        {
          receiverId: user.id,
          senderId: otherUser?.id,
          type: 'LIKE',
          content: 'đã thích bài viết của bạn: ' + (thread?.title || 'Bài viết mẫu'),
          link: thread ? `/thread/${thread.slug}` : '/',
          isRead: false
        },
        {
          receiverId: user.id,
          senderId: otherUser?.id,
          type: 'REPLY',
          content: 'đã trả lời bài viết của bạn',
          link: thread ? `/thread/${thread.slug}` : '/',
          isRead: false
        },
        {
          receiverId: user.id,
          type: 'SYSTEM',
          content: 'Chào mừng bạn đến với Picpee Forum! Hãy bắt đầu chia sẻ và kiếm tiền ngay nhé.',
          link: '/',
          isRead: false
        }
      ]
    });
    console.log('Notifications created successfully');
  } else {
    console.log('USER_NOT_FOUND');
  }
}
main().catch(console.error).finally(() => prisma.$disconnect());
