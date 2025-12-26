using EmojiApp.Models;
using Microsoft.Extensions.Caching.Memory;

namespace EmojiApp.Services;

public class EmojiSuggestionService
{
    private readonly IMemoryCache _cache;
    private readonly IEmojiSuggestionProvider _provider;

    public EmojiSuggestionService(IMemoryCache cache, IEmojiSuggestionProvider provider)
    {
        _cache = cache;
        _provider = provider;
    }

    public async Task<EmojiSuggestion> GetAsync(string? topicRaw, CancellationToken ct)
    {
        var topic = NormalizeTopic(topicRaw);
        var key = $"emoji_suggest:v1:{topic}";

        if (_cache.TryGetValue<EmojiSuggestion>(key, out var cached))
        {
            return cached;
        }

        return await _cache.GetOrCreateAsync(key, async entry =>
        {
            entry.AbsoluteExpiration = DateTime.Now.Date.AddDays(1).AddMilliseconds(-1);

            var emojis = await _provider.GenerateThreeEmojisAsync(topic, ct);
            return new EmojiSuggestion
            {
                Topic = topic,
                GeneratedAtUtc = DateTime.UtcNow,
                Emojis = emojis.ToList()
            };
        }) ?? throw new InvalidOperationException("Cache creation failed");
    }

    private static string NormalizeTopic(string? s)
    {
        var t = (s ?? "").Trim();
        return string.IsNullOrWhiteSpace(t) ? "daily" : t.ToLowerInvariant();
    }
}
