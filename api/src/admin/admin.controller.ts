import { Controller, Get, Post, Body, Header, Req, UseGuards, ForbiddenException } from '@nestjs/common';
import { AdminService } from './admin.service';
import { AuthGuard } from '../auth/auth.guard';

@Controller('admin')
@UseGuards(AuthGuard)
export class AdminController {
  constructor(private readonly adminService: AdminService) {}

  /// Event logger called by client upon sign-in/up/payments
  @Post('log-event')
  async logEvent(@Req() req: any, @Body() dto: { actionType: string; userId?: string; userEmail?: string; name?: string; details?: any }) {
    const userId = req.user.uid;
    const userEmail = req.user.email || dto.userEmail || '';
    return this.adminService.logEvent({
      ...dto,
      userId,
      userEmail,
    });
  }

  /// Download or inspect complete formatted SQL statements (Admin restricted)
  @Get('export-sql')
  @Header('Content-Type', 'text/plain')
  async exportSql(@Req() req: any) {
    if (process.env.NODE_ENV === 'production') {
      throw new ForbiddenException('SQL Export is disabled in production environment');
    }
    return this.adminService.exportFormattedSqlStatements();
  }

  /// Interactive HTML developer sheet view of database data (Admin restricted)
  @Get('developer-sheet')
  @Header('Content-Type', 'text/html')
  async getDeveloperSheet(@Req() req: any) {
    if (process.env.NODE_ENV === 'production') {
      throw new ForbiddenException('Developer sheet is disabled in production environment');
    }
    return this.adminService.renderDeveloperSheetHtml();
  }
}
