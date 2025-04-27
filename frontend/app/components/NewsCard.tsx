import { Link } from "react-router";
import { format } from "date-fns";
import { ja } from "date-fns/locale";
import { BellIcon, ArrowRightIcon } from "lucide-react";
import { 
  Card, 
  CardContent, 
  CardFooter, 
  CardHeader, 
  CardTitle 
} from "./ui/card";
import { Button } from "./ui/button";
import { Separator } from "./ui/separator";
import { NEWS_CATEGORY_COLORS, NEWS_CATEGORY_LABELS } from "../utils/categories";

// ニュースアイテムの型を定義
export type NewsItemType = {
  id: string;
  title: string;
  summary?: string | null;
  content: string;
  slug: string;
  publishedAt: string;
  expiredAt?: string | null;
  isImportant: boolean;
  category?: string | null;
};

type NewsCardProps = {
  newsItems: NewsItemType[];
  limit?: number;
};

export function NewsCard({ newsItems, limit = 3 }: NewsCardProps) {
  // 表示件数を制限
  const displayItems = newsItems.slice(0, limit);

  return (
    <Card className="backdrop-blur-sm bg-background/50 border-foreground/5 shadow-sm hover:shadow-md transition-shadow overflow-hidden">
      <CardHeader className="pb-3">
        <CardTitle className="flex items-center text-lg">
          <BellIcon className="mr-3 h-5 w-5 text-primary" />
          <span>お知らせ</span>
        </CardTitle>
      </CardHeader>
      <Separator className="mb-3" />
      <CardContent className="space-y-4 pb-6">
        {displayItems && displayItems.length > 0 ? (
          displayItems.map((item) => (
            <NewsItem 
              key={item.id}
              title={item.title} 
              date={format(new Date(item.publishedAt), 'yyyy.MM.dd', { locale: ja })}
              href={`/news/${item.slug}`}
              isImportant={item.isImportant}
              category={item.category}
            />
          ))
        ) : (
          <p className="text-foreground/60 text-center py-4">お知らせはありません</p>
        )}
      </CardContent>
      <CardFooter>
        <Button variant="ghost" size="sm" asChild className="group">
          <Link to="/news">
            <span className="group-hover:mr-2 transition-all">すべてのお知らせを見る</span> 
            <ArrowRightIcon className="ml-1 h-4 w-4 group-hover:translate-x-1 transition-transform" />
          </Link>
        </Button>
      </CardFooter>
    </Card>
  );
}

// お知らせアイテム
function NewsItem({ title, date, href, isImportant = false, category }: { 
  title: string; 
  date: string; 
  href: string;
  isImportant?: boolean;
  category?: string | null;
}) {
  return (
    <div className="group">
      <Link to={href} className="block">
        <div className={`flex flex-col py-3 border-b border-foreground/10 group-hover:border-foreground/20 transition-colors ${isImportant ? 'bg-primary/5 -mx-4 px-4' : ''}`}>
          <div className="flex justify-between items-center mb-1">
            <span className="text-xs text-foreground/50">{date}</span>
            {category && (
              <span 
                className={`inline-block text-xs px-1.5 py-0.5 rounded ${
                  NEWS_CATEGORY_COLORS[category] 
                    ? `${NEWS_CATEGORY_COLORS[category].bg} ${NEWS_CATEGORY_COLORS[category].text}` 
                    : 'bg-foreground/5 text-foreground/70'
                }`}
              >
                {NEWS_CATEGORY_LABELS[category] || category}
              </span>
            )}
          </div>
          <h4 className={`font-medium group-hover:text-primary transition-colors ${isImportant ? 'text-primary/90' : ''}`}>
            {isImportant && <span className="inline-block bg-primary/10 text-primary/90 text-xs font-semibold px-2 py-0.5 rounded mr-2">重要</span>}
            {title}
          </h4>
        </div>
      </Link>
    </div>
  );
} 