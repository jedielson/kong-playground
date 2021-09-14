import {
  Body,
  Controller,
  Get,
  Param,
  Post,
  Query,
  UseInterceptors,
} from '@nestjs/common';
import { LocationInterceptor } from '../../../core/http/location.interceptor';
import { AuthorService } from './author.service';
import { CreateAuthorRequest } from './dto/create-authors.dto';
import { GetAuthorsRequest } from './dto/get-authors.dto';

@Controller('author')
export class AuthorController {
  constructor(private authService: AuthorService) {}

  @Get()
  getAll(@Query() body: GetAuthorsRequest) {
    return this.authService.getAll(body);
  }

  @Get(':id')
  get(@Param('id') id: number) {
    return this.authService.find(id);
  }

  @UseInterceptors(LocationInterceptor)
  @Post()
  create(@Body() req: CreateAuthorRequest) {
    return this.authService.create(req);
  }
}
