import { Controller, Get, Post, Body, Param, Session, Res, ForbiddenException, Delete, UnauthorizedException, NotFoundException } from '@nestjs/common';
import { AdminService } from './admin.service';

@Controller('admin')
export class AdminController {
  constructor(private adminService: AdminService) {}

  private checkAdmin(session: any) {
    if (!session.userId || session.role !== 'ADMIN') {
      throw new UnauthorizedException('Chỉ dành cho Admin');
    }
  }

  @Get('users')
  async getAllUsers(@Session() session: any) {
    this.checkAdmin(session);
    return this.adminService.getAllUsers();
  }

  @Post('users/role/:id')
  async updateUserRole(
    @Param('id') id: string,
    @Body('role') role: string,
    @Session() session: any
  ) {
    this.checkAdmin(session);
    return this.adminService.updateUserRole(id, role);
  }

  @Post('users/status/:id')
  async updateUserStatus(@Param('id') id: string, @Body('status') status: string, @Session() session: any) {
    this.checkAdmin(session);
    return this.adminService.updateUserStatus(id, status);
  }

  @Delete('users/:id')
  async deleteUser(@Param('id') id: string, @Session() session: any) {
    this.checkAdmin(session);
    return this.adminService.deleteUser(id);
  }

  @Get('users/activity/:id')
  async getUserActivity(@Param('id') id: string, @Session() session: any) {
    this.checkAdmin(session);
    return this.adminService.getUserActivity(id);
  }

  @Get('tasks')
  async getAllTasks(@Session() session: any) {
    this.checkAdmin(session);
    return this.adminService.getAllTasks();
  }

  @Post('tasks/approve/:id')
  async approveTask(@Param('id') id: string, @Session() session: any) {
    this.checkAdmin(session);
    return this.adminService.approveTask(id);
  }

  @Post('tasks/pay/:id')
  async payTask(@Param('id') id: string, @Session() session: any) {
    this.checkAdmin(session);
    return this.adminService.payTask(id);
  }

  @Post('tasks/reject/:id')
  async rejectTask(@Param('id') id: string, @Body('reason') reason: string, @Session() session: any) {
    this.checkAdmin(session);
    return this.adminService.rejectTask(id, reason);
  }

  @Post('process-payouts')
  async runPayoutJob(@Session() session: any) {
    this.checkAdmin(session);
    return this.adminService.processPayouts();
  }

  @Get('withdrawals')
  async getWithdrawals(@Session() session: any) {
    this.checkAdmin(session);
    return this.adminService.getAllWithdrawals();
  }

  @Post('withdrawals/approve/:id')
  async approveWithdrawal(@Param('id') id: string, @Session() session: any) {
    this.checkAdmin(session);
    return this.adminService.approveWithdrawal(id);
  }

  @Post('withdrawals/reject/:id')
  async rejectWithdrawal(@Param('id') id: string, @Body('reason') reason: string, @Session() session: any) {
    this.checkAdmin(session);
    return this.adminService.rejectWithdrawal(id, reason);
  }

  // --- TAGS ---
  @Get('tags')
  async getAllTags(@Session() session: any) {
    this.checkAdmin(session);
    return this.adminService.getAllTags();
  }

  @Post('tags')
  async createTag(@Body() body: { name: string, slug: string }, @Session() session: any) {
    this.checkAdmin(session);
    return this.adminService.createTag(body);
  }

  @Post('tags/:id')
  async updateTag(@Param('id') id: string, @Body() body: { name: string, slug: string }, @Session() session: any) {
    this.checkAdmin(session);
    return this.adminService.updateTag(id, body);
  }

  @Post('tags/delete/:id')
  async deleteTag(@Param('id') id: string, @Session() session: any) {
    this.checkAdmin(session);
    return this.adminService.deleteTag(id);
  }

  // --- CATEGORIES & BOARDS ---
  @Get('categories')
  async getAllCategories(@Session() session: any) {
    this.checkAdmin(session);
    return this.adminService.getAllCategories();
  }

  @Post('categories/:id/status')
  async updateCategoryStatus(
    @Param('id') id: string,
    @Body('status') status: string,
    @Session() session: any
  ) {
    this.checkAdmin(session);
    return this.adminService.updateCategoryStatus(id, status);
  }

  @Post('categories')
  async createCategory(@Body() body: any, @Session() session: any) {
    this.checkAdmin(session);
    return this.adminService.createCategory(body);
  }

  @Post('categories/:id')
  async updateCategory(@Param('id') id: string, @Body() body: any, @Session() session: any) {
    this.checkAdmin(session);
    return this.adminService.updateCategory(id, body);
  }

  @Post('categories/delete/:id')
  async deleteCategory(@Param('id') id: string, @Session() session: any) {
    this.checkAdmin(session);
    return this.adminService.deleteCategory(id);
  }

  @Get('boards')
  async getAllBoards(@Session() session: any) {
    this.checkAdmin(session);
    return this.adminService.getAllBoards();
  }

  @Post('boards/:id/status')
  async updateBoardStatus(
    @Param('id') id: string,
    @Body('status') status: string,
    @Session() session: any
  ) {
    this.checkAdmin(session);
    return this.adminService.updateBoardStatus(id, status);
  }

  @Post('boards')
  async createBoard(@Body() body: any, @Session() session: any) {
    this.checkAdmin(session);
    return this.adminService.createBoard(body);
  }

  @Post('boards/:id')
  async updateBoard(@Param('id') id: string, @Body() body: any, @Session() session: any) {
    this.checkAdmin(session);
    return this.adminService.updateBoard(id, body);
  }

  @Post('boards/delete/:id')
  async deleteBoard(@Param('id') id: string, @Session() session: any) {
    this.checkAdmin(session);
    return this.adminService.deleteBoard(id);
  }

  @Post('notifications')
  async sendNotification(@Body() body: any, @Session() session: any) {
    this.checkAdmin(session);
    return this.adminService.sendCustomNotification({
      ...body,
      senderId: session.userId
    });
  }
}
