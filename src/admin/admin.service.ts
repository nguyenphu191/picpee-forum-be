import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class AdminService {
  constructor(private prisma: PrismaService) {}

  async getAllUsers() {
    return this.prisma.user.findMany({
      select: {
        id: true,
        email: true,
        username: true,
        avatarUrl: true,
        role: true,
        status: true,
        reputation: true,
        createdAt: true,
        _count: { select: { threads: true, posts: true } },
        wallet: { select: { balance: true } }
      },
      orderBy: { createdAt: 'desc' }
    });
  }

  async updateUserStatus(userId: string, status: string) {
    return this.prisma.user.update({
      where: { id: userId },
      data: { status }
    });
  }

  async deleteUser(userId: string) {
    // Note: Due to foreign key constraints, we might need cascade or handle related data
    // For simplicity, we assume relation settings or simple deletion here.
    return this.prisma.user.delete({
      where: { id: userId }
    });
  }

  async getUserActivity(userId: string) {
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
      select: {
        id: true,
        username: true,
        threads: { take: 10, orderBy: { createdAt: 'desc' } },
        posts: { take: 10, include: { thread: true }, orderBy: { createdAt: 'desc' } },
        wallet: { include: { transactions: { take: 20, orderBy: { createdAt: 'desc' } } } }
      }
    });

    if (!user) throw new NotFoundException('User not found');
    return user;
  }

  async updateUserRole(userId: string, targetRole: any) {
    // Only allow changing roles among the valid Prisma Role enums
    return this.prisma.user.update({
      where: { id: userId },
      data: { role: targetRole },
      select: { id: true, username: true, role: true }
    });
  }

  async getAllTasks() {
    return this.prisma.shareTask.findMany({
      include: {
        user: { select: { id: true, username: true, email: true } },
        thread: { select: { title: true, slug: true } }
      },
      orderBy: { createdAt: 'desc' }
    });
  }

  async approveTask(taskId: string) {
    const task = await this.prisma.shareTask.findUnique({
      where: { id: taskId },
      include: { user: { include: { wallet: true } } }
    });

    if (!task) throw new NotFoundException('Không tìm thấy nhiệm vụ');
    if (task.status !== 'PENDING') return task;

    const approvedAt = new Date();
    const paymentDueAt = new Date();
    paymentDueAt.setDate(approvedAt.getDate() + 7); // Auto pay after 7 days

    // Update task status to APPROVED
    const updatedTask = await this.prisma.shareTask.update({
      where: { id: taskId },
      data: { 
        status: 'APPROVED',
        approvedAt,
        paymentDueAt
      }
    });

    // Gamification: +10 Reputation for completing a marketing task
    await this.prisma.user.update({
      where: { id: task.user.id },
      data: { reputation: { increment: 10 } }
    });

    return updatedTask;
  }

  async payTask(taskId: string) {
    const task = await this.prisma.shareTask.findUnique({
      where: { id: taskId },
      include: { user: { include: { wallet: true } }, thread: true }
    });

    if (!task) throw new NotFoundException('Không tìm thấy nhiệm vụ');
    if (task.status === 'PAID') return task;

    // 1. Ensure user has a wallet
    let wallet = task.user.wallet;
    if (!wallet) {
      wallet = await this.prisma.wallet.create({
        data: { userId: task.userId }
      });
    }

    // 2. Update wallet balance
    await this.prisma.wallet.update({
      where: { id: wallet.id },
      data: {
        balance: { increment: task.rewardAmount },
      }
    });

    // 2b. Deduct from Admin wallet
    const admin = await this.prisma.user.findFirst({
      where: { role: 'ADMIN' },
      include: { wallet: true }
    });

    if (admin) {
      let adminWallet = admin.wallet;
      if (!adminWallet) {
        adminWallet = await this.prisma.wallet.create({ data: { userId: admin.id } });
      }
      await this.prisma.wallet.update({
        where: { id: adminWallet.id },
        data: { balance: { decrement: task.rewardAmount } }
      });

      // Track admin transaction
      await this.prisma.transaction.create({
        data: {
          amount: task.rewardAmount,
          type: 'WITHDRAW', // Using Withdraw as deduction
          status: 'COMPLETED',
          description: `Chi trả nhiệm vụ cho: ${task.user.username}`,
          walletId: adminWallet.id
        }
      });
    }

    // 3. Create Transaction for User
    await this.prisma.transaction.create({
      data: {
        amount: task.rewardAmount,
        type: 'REWARD',
        status: 'COMPLETED',
        description: `Thanh toán nhiệm vụ: ${task.thread.title}`,
        walletId: wallet.id
      }
    });

    // 4. Set task to PAID
    return this.prisma.shareTask.update({
      where: { id: task.id },
      data: { status: 'PAID' }
    });
  }

  async rejectTask(taskId: string, reason?: string) {
    return this.prisma.shareTask.update({
      where: { id: taskId },
      data: { 
        status: 'REJECTED',
        proofNote: reason ? `Admin: ${reason}` : undefined
      }
    });
  }

  // A helper to "Pay out" tasks that reached their due date
  async processPayouts() {
    const now = new Date();

    const tasksToPay = await this.prisma.shareTask.findMany({
      where: {
        status: 'APPROVED',
        paymentDueAt: { lte: now }
      }
    });

    for (const task of tasksToPay) {
      await this.payTask(task.id);
    }
    
    return { paidCount: tasksToPay.length };
  }

  async getAllWithdrawals() {
    return this.prisma.transaction.findMany({
      where: { type: 'WITHDRAW' },
      include: {
        wallet: { include: { user: { select: { id: true, username: true, bankName: true, bankAccountNumber: true, bankAccountName: true, phoneNumber: true } } } }
      },
      orderBy: { createdAt: 'desc' }
    });
  }

  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  private formatAmount(amount: any): string {
    return '$' + Number(amount).toLocaleString('en-US', { minimumFractionDigits: 2 });
  }

  async approveWithdrawal(transactionId: string) {
    const tx = await this.prisma.transaction.update({
      where: { id: transactionId },
      data: { status: 'COMPLETED' },
      include: { wallet: true }
    });

    await this.createNotification({
      receiverId: tx.wallet.userId,
      type: 'PAYMENT',
      content: `Yêu cầu rút tiền ${this.formatAmount(tx.amount)}đ của bạn đã được thực hiện thành công.`,
    });

    return tx;
  }

  async rejectWithdrawal(transactionId: string, reason: string) {
    const tx = await this.prisma.transaction.findUnique({
      where: { id: transactionId },
      include: { wallet: true }
    });

    if (!tx || tx.status !== 'PENDING') return tx;

    // Refund the amount back to wallet
    await this.prisma.wallet.update({
      where: { id: tx.walletId },
      data: { balance: { increment: tx.amount } }
    });

    const updatedTx = await this.prisma.transaction.update({
      where: { id: transactionId },
      data: { 
        status: 'REJECTED',
        description: `Từ chối: ${reason}`
      }
    });

    await this.createNotification({
      receiverId: tx.wallet.userId,
      type: 'PAYMENT',
      content: `Yêu cầu rút tiền ${this.formatAmount(tx.amount)}đ bị từ chối. Lý do: ${reason}`,
    });

    return updatedTx;
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

  // --- TAGS MANAGEMENT ---
  async getAllTags() {
    return this.prisma.tag.findMany({
      include: {
        _count: { select: { threads: true } }
      },
      orderBy: { createdAt: 'desc' }
    });
  }

  async createTag(data: { name: string, slug: string }) {
    return this.prisma.tag.create({ data });
  }

  async updateTag(id: string, data: { name: string, slug: string }) {
    return this.prisma.tag.update({
      where: { id },
      data
    });
  }

  async deleteTag(id: string) {
    return this.prisma.tag.delete({ where: { id } });
  }

  // --- CATEGORIES MANAGEMENT ---
  async getAllCategories() {
    return this.prisma.category.findMany({
      include: {
        boards: {
          include: { _count: { select: { threads: true } } }
        }
      },
      orderBy: { order: 'asc' }
    });
  }

  async updateCategoryStatus(id: string, status: string) {
    return this.prisma.category.update({
      where: { id },
      data: { status }
    });
  }

  async createCategory(data: { name: string, slug: string, description?: string, order?: number }) {
    return this.prisma.category.create({ data });
  }

  async updateCategory(id: string, data: { name: string, slug: string, description?: string, order?: number }) {
    return this.prisma.category.update({
      where: { id },
      data
    });
  }

  async deleteCategory(id: string) {
    return this.prisma.category.delete({ where: { id } });
  }

  // --- BOARDS MANAGEMENT ---
  async getAllBoards() {
    return this.prisma.board.findMany({
      include: {
        category: true,
        _count: { select: { threads: true } }
      },
      orderBy: { createdAt: 'desc' }
    });
  }

  async updateBoardStatus(id: string, status: string) {
    return this.prisma.board.update({
      where: { id },
      data: { status }
    });
  }

  async createBoard(data: { name: string, slug: string, description?: string, categoryId: string, order?: number }) {
    return this.prisma.board.create({ data });
  }

  async updateBoard(id: string, data: { name: string, slug: string, description?: string, categoryId: string, order?: number }) {
    return this.prisma.board.update({
      where: { id },
      data
    });
  }

  async deleteBoard(id: string) {
    return this.prisma.board.delete({ where: { id } });
  }

  async sendCustomNotification(data: { receiverId?: string, type: string, content: string, link?: string, senderId?: string }) {
    if (data.receiverId) {
      // Gửi cho 1 người dùng cụ thể
      return this.createNotification({
        receiverId: data.receiverId,
        senderId: data.senderId,
        type: data.type,
        content: data.content,
        link: data.link
      });
    } else {
      // Gửi cho tất cả người dùng
      const users = await this.prisma.user.findMany({ select: { id: true } });
      const notifications = users.map(user => ({
        receiverId: user.id,
        senderId: data.senderId,
        type: data.type,
        content: data.content,
        link: data.link
      }));

      // createMany might be more efficient for bulk
      return this.prisma.notification.createMany({
        data: notifications,
        skipDuplicates: true,
      });
    }
  }
}
