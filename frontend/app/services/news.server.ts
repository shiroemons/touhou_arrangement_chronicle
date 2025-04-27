import { sql } from 'drizzle-orm';
import { db } from './db.server';
import { news } from '../schema';
import { desc, eq, gt, isNull, lte, and } from 'drizzle-orm';

// ホームページに表示するお知らせを取得する関数
export async function getHomeNews(limit = 5) {
  const currentDate = new Date();
  
  // 現在日時以降に公開され、有効期限内（または無期限）のお知らせを取得
  const newsItems = await db
    .select({
      id: news.id,
      title: news.title,
      summary: news.summary,
      content: news.content,
      slug: news.slug,
      publishedAt: news.publishedAt,
      expiredAt: news.expiredAt,
      isImportant: news.isImportant,
      category: news.category,
    })
    .from(news)
    .where(
      and(
        lte(news.publishedAt, currentDate),
        // expiredAtがnullか、currentDateよりも後ろの場合
        sql`(${news.expiredAt} IS NULL OR ${news.expiredAt} > ${currentDate})`
      )
    )
    .orderBy(desc(news.isImportant), desc(news.publishedAt))
    .limit(limit);

  return newsItems;
}

// 特定のお知らせを取得する関数
export async function getNewsBySlug(slug: string) {
  const currentDate = new Date();
  
  const newsItem = await db
    .select()
    .from(news)
    .where(
      and(
        eq(news.slug, slug),
        lte(news.publishedAt, currentDate),
        // expiredAtがnullか、currentDateよりも後ろの場合
        sql`(${news.expiredAt} IS NULL OR ${news.expiredAt} > ${currentDate})`
      )
    )
    .limit(1);

  return newsItem[0] || null;
}

// すべてのお知らせを取得する関数
export async function getAllNews() {
  const currentDate = new Date();
  
  const newsItems = await db
    .select()
    .from(news)
    .where(
      and(
        lte(news.publishedAt, currentDate),
        // expiredAtがnullか、currentDateよりも後ろの場合
        sql`(${news.expiredAt} IS NULL OR ${news.expiredAt} > ${currentDate})`
      )
    )
    .orderBy(desc(news.publishedAt));

  return newsItems;
} 