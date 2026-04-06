import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class ForumService {
  constructor(private prisma: PrismaService) {}

  async getCategories() {
    return this.prisma.category.findMany({
      where: { status: 'ACTIVE' },
      include: {
        boards: {
          where: { status: 'ACTIVE' },
          include: {
            _count: {
              select: { threads: true }
            }
          }
        }
      },
      orderBy: { order: 'asc' }
    });
  }

  async getBoard(slug: string, page: number = 1, limit: number = 10) {
    const board = await this.prisma.board.findUnique({
      where: { slug, status: 'ACTIVE' },
      include: {
        category: true,
        threads: {
          include: {
            author: { select: { username: true, avatarUrl: true } },
            _count: { select: { posts: true } }
          },
          orderBy: { createdAt: 'desc' },
          skip: (page - 1) * limit,
          take: limit
        },
        _count: { select: { threads: true } }
      }
    });

    if (!board) return null;

    return {
      ...board,
      pagination: {
        page,
        limit,
        total: board._count.threads,
        totalPages: Math.ceil(board._count.threads / limit)
      }
    };
  }

  async createThread(dto: { title: string, content: string, boardId: string, authorId: string, tags?: string[] }) {
    const board = await this.prisma.board.findUnique({
      where: { id: dto.boardId }
    });

    if (!board || board.status !== 'ACTIVE') {
      throw new Error('Bạn không thể đăng bài trong khu vực này.');
    }

    const slug = dto.title.toLowerCase().split(' ').join('-') + '-' + Math.random().toString(36).substring(2, 7);
    
    const threadData: any = {
      title: dto.title,
      content: dto.content,
      boardId: dto.boardId,
      authorId: dto.authorId,
      slug,
    };

    if (dto.tags && dto.tags.length > 0) {
      threadData.tags = {
        connect: dto.tags.map(tagId => ({ id: tagId }))
      };
    }

    const thread = await this.prisma.thread.create({
      data: threadData
    });

    // Gamification: +5 Reputation for creating a thread
    await this.prisma.user.update({
      where: { id: dto.authorId },
      data: { reputation: { increment: 5 } }
    });

    return thread;
  }

  async getThreadBySlug(slug: string) {
    const thread = await this.prisma.thread.findUnique({
      where: { slug },
      include: {
        author: { select: { id: true, username: true, avatarUrl: true, reputation: true, signature: true } },
        board: { select: { id: true, name: true, slug: true } },
        posts: {
          include: {
            author: { select: { id: true, username: true, avatarUrl: true, signature: true } },
            _count: { select: { likes: true } }
          },
          orderBy: { createdAt: 'asc' }
        },
        tags: true,
        _count: { select: { likes: true, posts: true } }
      }
    });

    if (thread) {
      await this.prisma.thread.update({
        where: { id: thread.id },
        data: { views: { increment: 1 } }
      });

      // Record Click Analytics
      await this.prisma.analytics.create({
        data: {
          threadId: thread.id,
          eventType: 'CLICK'
        }
      });
    }

    return thread;
  }

  async getTrendingThreads() {
    // Trending score = (views * 1) + (likes * 5)
    // We'll calculate this in application layer for simplicity or use a raw query if needed
    // For now, let's fetch threads with their counts
    const threads = await this.prisma.thread.findMany({
      include: {
        author: { select: { username: true, avatarUrl: true } },
        board: { select: { name: true, slug: true } },
        tags: true,
        _count: { select: { posts: true, likes: true } }
      },
      take: 50 // Fetch a pool to sort
    });

    const trending = threads.map(t => ({
      ...t,
      score: (t.views * 1) + (t._count.likes * 5)
    }))
    .sort((a, b) => b.score - a.score)
    .slice(0, 16);

    return trending;
  }

  async getAnalyticsStats() {
    const totalViews = await this.prisma.thread.aggregate({
      _sum: { views: true }
    });

    const totalClicks = await this.prisma.analytics.count({
      where: { eventType: 'CLICK' }
    });

    const totalLikes = await this.prisma.like.count();

    const topThreads = await this.prisma.thread.findMany({
      orderBy: { views: 'desc' },
      take: 10,
      select: { title: true, views: true, _count: { select: { likes: true } } }
    });

    return {
      totalViews: totalViews._sum.views || 0,
      totalClicks,
      totalLikes,
      topThreads: topThreads.map(t => ({
        title: t.title,
        views: t.views,
        likes: t._count.likes
      }))
    };
  }

  async getRelatedThreads(slug: string) {
    // Find the current thread with its tags
    const thread = await this.prisma.thread.findUnique({
      where: { slug },
      include: { tags: true }
    });

    if (!thread || thread.tags.length === 0) {
      // Fallback: return recent threads from the same board
      return this.prisma.thread.findMany({
        where: { boardId: thread?.boardId, slug: { not: slug } },
        include: {
          author: { select: { username: true, avatarUrl: true } },
          board: { select: { name: true, slug: true } },
          tags: true,
          _count: { select: { posts: true, likes: true } }
        },
        orderBy: { createdAt: 'desc' },
        take: 5
      });
    }

    const tagIds = thread.tags.map(t => t.id);

    // Find threads that share at least one tag
    return this.prisma.thread.findMany({
      where: {
        slug: { not: slug },
        tags: { some: { id: { in: tagIds } } }
      },
      include: {
        author: { select: { username: true, avatarUrl: true } },
        board: { select: { name: true, slug: true } },
        tags: true,
        _count: { select: { posts: true, likes: true } }
      },
      orderBy: { views: 'desc' },
      take: 5
    });
  }

  async createPost(dto: { content: string, threadId: string, parentId?: string, authorId: string }) {
    const post = await this.prisma.post.create({
      data: {
        content: dto.content,
        threadId: dto.threadId,
        parentId: dto.parentId,
        authorId: dto.authorId,
      },
      include: {
        author: { select: { username: true, avatarUrl: true, signature: true } },
        thread: { select: { title: true, slug: true, authorId: true } }
      }
    });

    // Gamification: +2 Reputation for posting a comment
    await this.prisma.user.update({
      where: { id: dto.authorId },
      data: { reputation: { increment: 2 } }
    });

    // Notify thread author
    if (post.thread.authorId !== dto.authorId) {
       await this.createNotification({
         receiverId: post.thread.authorId,
         senderId: dto.authorId,
         type: 'REPLY',
         content: `đã bình luận trong bài viết của bạn: ${post.thread.title}`,
         link: `/thread/${post.thread.slug}`
       });
    }

    return post;
  }

  async toggleLike(dto: { userId: string, threadId?: string, postId?: string }) {
    const where = {
      userId: dto.userId,
      threadId: dto.threadId,
      postId: dto.postId,
    };

    const existingLike = await this.prisma.like.findFirst({ where });

    if (existingLike) {
      await this.prisma.like.delete({ where: { id: existingLike.id } });
      
      // Deduct reputation from the owner
      if (existingLike.threadId) {
        const thread = await this.prisma.thread.findUnique({ where: { id: existingLike.threadId } });
        if (thread && thread.authorId !== dto.userId) {
          await this.prisma.user.update({
            where: { id: thread.authorId },
            data: { reputation: { decrement: 1 } }
          });
        }
      } else if (existingLike.postId) {
        const post = await this.prisma.post.findUnique({ where: { id: existingLike.postId } });
        if (post && post.authorId !== dto.userId) {
          await this.prisma.user.update({
            where: { id: post.authorId },
            data: { reputation: { decrement: 1 } }
          });
        }
      }

      return { liked: false };
    } else {
      await this.prisma.like.create({ data: { ...dto } });
      
      // Notify the owner and give reputation
      if (dto.threadId) {
        const thread = await this.prisma.thread.findUnique({ where: { id: dto.threadId } });
        if (thread && thread.authorId !== dto.userId) {
          // +1 Reputation for the thread author
          await this.prisma.user.update({
            where: { id: thread.authorId },
            data: { reputation: { increment: 1 } }
          });

          await this.createNotification({
            receiverId: thread.authorId,
            senderId: dto.userId,
            type: 'LIKE',
            content: `đã thích bài viết của bạn: ${thread.title}`,
            link: `/thread/${thread.slug}`
          });
        }
      } else if (dto.postId) {
        const post = await this.prisma.post.findUnique({ 
          where: { id: dto.postId },
          include: { thread: true }
        });
        if (post && post.authorId !== dto.userId) {
          // +1 Reputation for the post author
          await this.prisma.user.update({
            where: { id: post.authorId },
            data: { reputation: { increment: 1 } }
          });

          await this.createNotification({
            receiverId: post.authorId,
            senderId: dto.userId,
            type: 'LIKE',
            content: `đã thích bình luận của bạn trong: ${post.thread.title}`,
            link: `/thread/${post.thread.slug}`
          });
        }
      }

      return { liked: true };
    }
  }

  async createShareTask(dto: { userId: string, sharedUrl: string, threadId: string, proofNote?: string }) {
    // Ensure user has a wallet
    let wallet = await this.prisma.wallet.findUnique({ where: { userId: dto.userId } });
    if (!wallet) {
      wallet = await this.prisma.wallet.create({ data: { userId: dto.userId } });
    }

    // Default reward amount for sharing (e.g. 5.00 USD)
    const rewardAmount = 5.00;

    return this.prisma.shareTask.create({
      data: {
        userId: dto.userId,
        threadId: dto.threadId,
        sharedUrl: dto.sharedUrl,
        proofNote: dto.proofNote,
        rewardAmount,
        status: 'PENDING',
      }
    });
  }

  async getUserShareTasks(userId: string) {
    return this.prisma.shareTask.findMany({
      where: { userId },
      include: {
        thread: { select: { title: true, slug: true } }
      },
      orderBy: { createdAt: 'desc' }
    });
  }

  async getUserWallet(userId: string) {
    let wallet = await this.prisma.wallet.findUnique({ 
      where: { userId },
      include: { transactions: { orderBy: { createdAt: 'desc' }, take: 10 } }
    });
    
    if (!wallet) {
      wallet = await this.prisma.wallet.create({ 
        data: { userId },
        include: { transactions: true }
      });
    }
    
    return wallet;
  }

  async requestWithdrawal(userId: string, amount: number) {
     if (amount < 50000) {
        throw new Error('Số tiền rút tối thiểu là 50.000đ');
     }
     
     const wallet = await this.prisma.wallet.findUnique({ where: { userId } });
     if (!wallet || wallet.balance.toNumber() < amount) {
        throw new Error('Số dư không đủ để thực hiện giao dịch');
     }

     // Start transaction implicitly to deduct & record
     const [updatedWallet, transaction] = await this.prisma.$transaction([
        this.prisma.wallet.update({
           where: { userId },
           data: { balance: { decrement: amount } }
        }),
        this.prisma.transaction.create({
           data: {
              wallet: { connect: { userId } },
              amount,
              type: 'WITHDRAW',
              status: 'PENDING',
              description: `Yêu cầu rút tiền ${amount.toLocaleString('vi-VN')}đ`
           }
        })
     ]);

     return { success: true, transaction };
  }

  private async createNotification(data: { receiverId: string, senderId?: string, type: string, content: string, link?: string }) {
    return this.prisma.notification.create({
      data: {
        receiverId: data.receiverId,
        senderId: data.senderId,
        type: data.type,
        content: data.content,
        link: data.link,
      }
    });
  }

  async getNotifications(userId: string) {
    return this.prisma.notification.findMany({
      where: { receiverId: userId },
      include: {
        sender: { select: { username: true, avatarUrl: true } }
      },
      orderBy: { createdAt: 'desc' },
      take: 20
    });
  }

  async markNotificationAsRead(id: string) {
    return this.prisma.notification.update({
      where: { id },
      data: { isRead: true }
    });
  }

  async markAllNotificationsAsRead(userId: string) {
    return this.prisma.notification.updateMany({
      where: { receiverId: userId, isRead: false },
      data: { isRead: true }
    });
  }

  async getAllTags() {
    return this.prisma.tag.findMany({
      include: {
        _count: {
          select: { threads: true }
        }
      },
      orderBy: {
        threads: { _count: 'desc' }
      }
    });
  }

  async getTagBySlug(slug: string) {
    return this.prisma.tag.findUnique({
      where: { slug },
      include: {
        threads: {
          include: {
            author: { select: { username: true, avatarUrl: true } },
            board: { select: { name: true, slug: true } },
            tags: true,
            _count: { select: { posts: true, likes: true } }
          },
          orderBy: { createdAt: 'desc' }
        },
        _count: {
          select: { threads: true }
        }
      }
    });
  }

  async getUserThreads(userId: string) {
    return this.prisma.thread.findMany({
      where: { authorId: userId },
      include: {
        board: { select: { name: true, slug: true } },
        tags: true,
        _count: { select: { posts: true, likes: true } }
      },
      orderBy: { createdAt: 'desc' }
    });
  }

  async updateThread(id: string, authorId: string, dto: { title: string, content: string, tags?: string[] }) {
    const thread = await this.prisma.thread.findUnique({
      where: { id }
    });

    if (!thread || thread.authorId !== authorId) {
      throw new Error('Bạn không có quyền chỉnh sửa bài viết này.');
    }

    const data: any = {
      title: dto.title,
      content: dto.content,
    };

    if (dto.tags) {
      data.tags = {
        set: [], // Clear existing tags
        connect: dto.tags.map(tagId => ({ id: tagId }))
      };
    }

    return this.prisma.thread.update({
      where: { id },
      data
    });
  }

  async toggleBookmark(threadId: string, userId: string) {
    const existing = await this.prisma.bookmark.findUnique({
      where: { userId_threadId: { userId, threadId } }
    });

    if (existing) {
      await this.prisma.bookmark.delete({ where: { userId_threadId: { userId, threadId } } });
      return { bookmarked: false };
    } else {
      await this.prisma.bookmark.create({ data: { userId, threadId } });
      return { bookmarked: true };
    }
  }

  async getUserBookmarks(userId: string) {
    return this.prisma.bookmark.findMany({
      where: { userId },
      include: {
        thread: {
          include: {
            author: { select: { username: true, avatarUrl: true } },
            board: { select: { name: true, slug: true } },
            _count: { select: { posts: true, likes: true } }
          }
        }
      },
      orderBy: { createdAt: 'desc' }
    });
  }

  async isBookmarked(threadId: string, userId: string) {
    const b = await this.prisma.bookmark.findUnique({
      where: { userId_threadId: { userId, threadId } }
    });
    return { bookmarked: !!b };
  }

  async deleteThread(id: string, authorId: string) {
    const thread = await this.prisma.thread.findUnique({
      where: { id }
    });

    if (!thread || thread.authorId !== authorId) {
      throw new Error('Bạn không có quyền xóa bài viết này.');
    }

    // Manual cascade delete because not configured in schema
    await this.prisma.$transaction([
      this.prisma.post.deleteMany({ where: { threadId: id } }),
      this.prisma.like.deleteMany({ where: { threadId: id } }),
      this.prisma.bookmark.deleteMany({ where: { threadId: id } }),
      this.prisma.report.deleteMany({ where: { threadId: id } }),
      this.prisma.analytics.deleteMany({ where: { threadId: id } }),
      this.prisma.shareTask.deleteMany({ where: { threadId: id } }),
      this.prisma.thread.delete({ where: { id } })
    ]);
    
    return { success: true };
  }
}
