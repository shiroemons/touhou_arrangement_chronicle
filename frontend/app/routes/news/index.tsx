import { useLoaderData } from "react-router";
import { Link } from "react-router";
import { format } from "date-fns";
import { ja } from "date-fns/locale";
import { BellIcon, ChevronRightIcon } from "lucide-react";
import { getAllNews } from "../../services/news.server";
import { type NewsItemType } from "../../components/NewsCard";
import {
  Breadcrumb,
  BreadcrumbItem,
  BreadcrumbLink,
  BreadcrumbList,
  BreadcrumbSeparator,
} from "../../components/ui/breadcrumb";
import { Separator } from "../../components/ui/separator";
import { NEWS_CATEGORY_LABELS, NEWS_CATEGORY_COLORS } from "../../utils/categories";

export async function loader() {
  const newsItems = await getAllNews();
  return { newsItems };
}

export function meta() {
  return [
    { title: "お知らせ一覧 | 東方編曲録　〜 Arrangement Chronicle" },
    { name: "description", content: "東方編曲録に関するお知らせ一覧です" },
  ];
}

export default function NewsIndex() {
  const { newsItems } = useLoaderData() as { newsItems: NewsItemType[] };

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
            <BreadcrumbLink className="font-medium">お知らせ一覧</BreadcrumbLink>
          </BreadcrumbItem>
        </BreadcrumbList>
      </Breadcrumb>

      <div className="mb-8">
        <h1 className="text-3xl md:text-4xl font-bold tracking-tighter mb-4 flex items-center">
          <BellIcon className="mr-3 h-7 w-7 text-primary" />
          <span>お知らせ一覧</span>
        </h1>
        <p className="text-foreground/60 max-w-2xl">
          東方編曲録に関する最新情報やお知らせを掲載しています。
        </p>
      </div>

      <Separator className="mb-8" />

      <div className="space-y-8">
        {newsItems && newsItems.length > 0 ? (
          newsItems.map((item) => (
            <article key={item.id} className="bg-background/60 backdrop-blur-sm border border-foreground/5 rounded-lg p-6 hover:shadow-md transition-shadow">
              <div className="flex flex-col">
                <div className="flex justify-between items-center mb-2">
                  <time dateTime={item.publishedAt} className="text-sm text-foreground/60">
                    {format(new Date(item.publishedAt), 'yyyy年MM月dd日', { locale: ja })}
                  </time>
                  {item.category && (
                    <span 
                      className={`inline-block text-xs px-2 py-1 rounded ${
                        NEWS_CATEGORY_COLORS[item.category] 
                          ? `${NEWS_CATEGORY_COLORS[item.category].bg} ${NEWS_CATEGORY_COLORS[item.category].text}` 
                          : 'bg-foreground/5 text-foreground/70'
                      }`}
                    >
                      {NEWS_CATEGORY_LABELS[item.category] || item.category}
                    </span>
                  )}
                </div>
                <h2 className="text-xl font-semibold mb-3 group">
                  <Link to={`/news/${item.slug}`} className="hover:text-primary transition-colors flex items-center">
                    {item.isImportant && (
                      <span className="inline-block bg-primary/10 text-primary/90 text-xs font-semibold px-2 py-0.5 rounded mr-2">重要</span>
                    )}
                    {item.title}
                  </Link>
                </h2>
                {item.summary && (
                  <p className="text-foreground/70 mb-4">{item.summary}</p>
                )}
                <Link to={`/news/${item.slug}`} className="text-primary hover:text-primary/80 text-sm font-medium flex items-center self-start mt-auto">
                  続きを読む
                  <ChevronRightIcon className="h-4 w-4 ml-1" />
                </Link>
              </div>
            </article>
          ))
        ) : (
          <div className="text-center py-12 text-foreground/60">
            <p>お知らせはありません</p>
          </div>
        )}
      </div>
    </main>
  );
} 