using System.Text.Json;

namespace EmojiApp.Services;


public interface IEmojiSuggestionProvider
{
    Task<IReadOnlyList<string>> GenerateThreeEmojisAsync(string topic, CancellationToken ct);
}

public class OpenRouterEmojiSuggestionProvider : IEmojiSuggestionProvider
{
    private readonly OpenRouterClient _client;
    private readonly IConfiguration _cfg;

    public OpenRouterEmojiSuggestionProvider(OpenRouterClient client, IConfiguration cfg)
    {
        _client = client;
        _cfg = cfg;
    }

    public async Task<IReadOnlyList<string>> GenerateThreeEmojisAsync(string topic, CancellationToken ct)
    {
        var apiKey = _cfg["OpenRouter:ApiKey"] ?? throw new InvalidOperationException("OpenRouter:ApiKey missing");
        var model = _cfg["OpenRouter:Model"] ?? throw new InvalidOperationException("OpenRouter:Model missing");

        // ВАЖНО: просим вернуть только JSON-массив из 3 emoji (без текста)
        var prompt = $"""
        Return exactly 3 distinct emoji for "prediction of the day" topic: "{topic}".

        Output MUST be only valid JSON array of 3 strings, like:
        ["😀","✨","🚀"]

        Rules:
        - Exactly 3 items
        - Each item is exactly one emoji character
        - No extra text, no markdown
        """;

        var payload = new
        {
            model =  model,
            messages = new object[]
            {
                new { role = "user", content = prompt }
            },
            temperature = 0.8,
            stream = false
        };

        var emojis = await _client.GetThreeEmojisOrDefaultAsync(apiKey, payload, ct);

        emojis = emojis
            .Select(e => (e ?? "").Trim())
            .Where(e => e.Length > 0 && !e.Any(char.IsLetterOrDigit))
            .Distinct()
            .Take(3)
            .ToList();

        if (emojis.Count != 3)
        {
            return new[] { "😀", "✨", "🧿" };
        }

        return emojis;
    }
}
