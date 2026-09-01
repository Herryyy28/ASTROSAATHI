import { Controller, Get, Post, Body, Header } from '@nestjs/common';
import { AdminService } from './admin.service';

@Controller('admin')
export class AdminController {
  constructor(private readonly adminService: AdminService) {}

  /// Event logger called by mobile client upon sign-in/up/payments
  @Post('log-event')
  async logEvent(@Body() dto: { actionType: string; userId: string; userEmail: string; name?: string; details?: any }) {
    return this.adminService.logEvent(dto);
  }

  /// Download or inspect complete formatted SQL statements
  @Get('export-sql')
  @Header('Content-Type', 'text/plain')
  async exportSql() {
    return this.adminService.exportFormattedSqlStatements();
  }

  /// Interactive HTML developer sheet view of all SQL database data
  @Get('developer-sheet')
  @Header('Content-Type', 'text/html')
  async getDeveloperSheet() {
    return this.adminService.renderDeveloperSheetHtml();
  }
}
