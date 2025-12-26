using EmojiApp.Models;
using Microsoft.Extensions.Caching.Memory;
using System.Net;

namespace EmojiApp.Services
{
    public class EmojiService
    {
        private readonly EmojiHubClient _client;
        private readonly IMemoryCache _cache;

        private const string AllKey = "emojihub_all";
        private const string CategoriesKey = "emojihub_categories";
        private const string GroupsKey = "emojihub_groups";

        public EmojiService(EmojiHubClient client, IMemoryCache cache)
        {
            _client = client;
            _cache = cache;
        }

        public async Task<IReadOnlyList<string>> GetCategoriesAsync(CancellationToken ct)
        {
            return await _cache.GetOrCreateAsync(CategoriesKey, async entry =>
            {
                entry.AbsoluteExpirationRelativeToNow = TimeSpan.FromHours(24);
                return await _client.GetCategoriesAsync(ct);
            }) ?? new List<string>();
        }

        public async Task<IReadOnlyList<string>> GetGroupsAsync(CancellationToken ct)
        {
            return await _cache.GetOrCreateAsync(GroupsKey, async entry =>
            {
                entry.AbsoluteExpirationRelativeToNow = TimeSpan.FromHours(24);
                return await _client.GetGroupsAsync(ct);
            }) ?? new List<string>();
        }

        public async Task<Pagination<Emoji>> QueryAsync(
            string? query,
            string? category,
            string? sort,
            string? order,
            int skip,
            int take,
            CancellationToken ct)
        {
            skip = Math.Max(0, skip);
            take = Math.Clamp(take, 1, 200);

            var normCategory = NormalizeCategory(category);
            var sortMode = (sort ?? "alpha").Trim().ToLowerInvariant();
            var desc = string.Equals(order, "desc", StringComparison.OrdinalIgnoreCase);

            List<Emoji> source = new List<Emoji>();

            if (!string.IsNullOrWhiteSpace(query))
            {
                source = await _client.SearchAsync(query.Trim(), ct);
            }
            else
            {
                source = await _cache.GetOrCreateAsync(AllKey, async entry =>
                {
                    entry.AbsoluteExpirationRelativeToNow = TimeSpan.FromHours(12);
                    return await _client.GetAllAsync(ct);
                }) ?? new List<Emoji>();
            }

            IEnumerable<Emoji> filtered = source;

            if (!string.IsNullOrWhiteSpace(normCategory))
            {
                filtered = filtered.Where(e => NormalizeCategory(e.Category) == normCategory);
            }

            filtered = sortMode switch
            {
                "category" => desc
                    ? filtered.OrderByDescending(e => e.Category).ThenByDescending(e => e.Name)
                    : filtered.OrderBy(e => e.Category).ThenBy(e => e.Name),

                _ => desc
                    ? filtered.OrderByDescending(e => e.Name)
                    : filtered.OrderBy(e => e.Name),
            };

            var list = filtered.ToList();
            var pageItems = list.Skip(skip).Take(take).Select(Normalize).ToArray();

            return new Pagination<Emoji>
            (
                list.Count,
                skip,
                take,
                pageItems
            );
        }

        private static Emoji Normalize(Emoji e)
        {
            var html = e.HtmlCode ?? new List<string>();
            var unicode = e.Unicode ?? new List<string>();

            // Обычно htmlCode содержит "&#128512;" и т.п. Декодим в реальный символ.
            var decoded = string.Concat(html.Select(WebUtility.HtmlDecode));

            return new Emoji
            {
                Name = e.Name ?? "",
                Category = e.Category ?? "",
                Group = e.Group ?? "",
                HtmlCode = html,
                Unicode = unicode,
                HtmlCodeDecoded = decoded
            };
        }

        private static string NormalizeCategory(string? s)
        {
            if (string.IsNullOrWhiteSpace(s)) return "";
            return s.Trim().ToLowerInvariant()
                .Replace('_', ' ')
                .Replace('-', ' ')
                .Replace("  ", " ");
        }
    }

}
