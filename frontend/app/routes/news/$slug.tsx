import { useLoaderData } from "react-router";
import { Link } from "react-router";
import { format } from "date-fns";
import { ja } from "date-fns/locale";
import { ChevronLeftIcon } from "lucide-react";
import { getNewsBySlug } from "../../services/news.server";
import { type NewsItemType } from "../../components/NewsCard";
import {
  Breadcrumb,
  BreadcrumbItem,
  BreadcrumbLink,
  BreadcrumbList,
  BreadcrumbSeparator,
} from "../../components/ui/breadcrumb";
import { Button } from "../../components/ui/button";
import { Separator } from "../../components/ui/separator";
import { NEWS_CATEGORY_LABELS, NEWS_CATEGORY_COLORS } from "../../utils/categories";

export async function loader({ params }: { params: { slug: string } }) {
  const newsItem = await getNewsBySlug(params.slug);
  
  if (!newsItem) {
    throw new Response("Not Found", { status: 404 });
  }
  
  return { newsItem };
}

export function meta({ data }: { data: { newsItem: NewsItemType } }) {
  const { newsItem } = data;
  
  return [
    { title: `${newsItem.title} | お知らせ | 東方編曲録` },
    { name: "description", content: newsItem.summary || `${newsItem.title}の詳細情報です。` },
  ];
}

export default function NewsDetail() {
  const { newsItem } = useLoaderData() as { newsItem: NewsItemType };
  
  return (
    <main className="container px-4 md:px-6 py-12 max-w-5xl mx-auto">
      <Breadcrumb className="mb-6">
        <BreadcrumbList>
          <BreadcrumbItem>
            <BreadcrumbLink asChild>
              <Link to="/">ホーム</Link>
            </BreadcrumbLink>
          </BreadcrumbItem>
          <BreadcrumbSeparator />
          <BreadcrumbItem>
            <BreadcrumbLink asChild>
              <Link to="/news">お知らせ一覧</Link>
            </BreadcrumbLink>
          </BreadcrumbItem>
          <BreadcrumbSeparator />
          <BreadcrumbItem>
            <BreadcrumbLink className="font-medium truncate max-w-[200px]">
              {newsItem.title}
            </BreadcrumbLink>
          </BreadcrumbItem>
        </BreadcrumbList>
      </Breadcrumb>

      <article className="bg-background/60 backdrop-blur-sm border border-foreground/5 rounded-lg p-6 md:p-8 shadow-sm">
        <header className="mb-8">
          <div className="flex items-center gap-2 mb-3">
            <time dateTime={newsItem.publishedAt} className="text-sm text-foreground/60">
              {format(new Date(newsItem.publishedAt), 'yyyy年MM月dd日', { locale: ja })}
            </time>
            {newsItem.category && (
              <span 
                className={`inline-block text-xs px-2 py-1 rounded ${
                  NEWS_CATEGORY_COLORS[newsItem.category] 
                    ? `${NEWS_CATEGORY_COLORS[newsItem.category].bg} ${NEWS_CATEGORY_COLORS[newsItem.category].text}` 
                    : 'bg-foreground/5 text-foreground/70'
                }`}
              >
                {NEWS_CATEGORY_LABELS[newsItem.category] || newsItem.category}
              </span>
            )}
            {newsItem.isImportant && (
              <span className="inline-block bg-primary/10 text-primary/90 text-xs font-semibold px-2 py-0.5 rounded">
                重要
              </span>
            )}
          </div>
          <h1 className="text-2xl md:text-3xl font-bold tracking-tight">
            {newsItem.title}
          </h1>
        </header>
        
        <Separator className="mb-8" />
        
        <div className="prose prose-neutral dark:prose-invert max-w-none mb-8">
          {/* HTMLをレンダリングする場合はdangerouslySetInnerHTMLを使用 */}
          <div dangerouslySetInnerHTML={{ __html: newsItem.content }} />
        </div>
        
        <div className="flex justify-between items-center mt-12">
          <Button variant="outline" asChild>
            <Link to="/news" className="flex items-center">
              <ChevronLeftIcon className="mr-2 h-4 w-4" />
              お知らせ一覧に戻る
            </Link>
          </Button>
        </div>
      </article>
    </main>
  );
} 