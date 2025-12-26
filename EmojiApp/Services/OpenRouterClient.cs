using System.Net.Http.Headers;
using System.Text;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace EmojiApp.Services;

public  class OpenRouterClient
{
    private readonly HttpClient _http;

    public OpenRouterClient(HttpClient http) => _http = http;

    public async Task<List<string>> GetThreeEmojisOrDefaultAsync(
        string apiKey,
        object payload,
        CancellationToken ct)
    {
        using var req = new HttpRequestMessage(HttpMethod.Post, "chat/completions");
        req.Headers.Authorization = new AuthenticationHeaderValue("Bearer", apiKey);

        req.Content = new StringContent(JsonConvert.SerializeObject(payload), Encoding.UTF8, "application/json");

        using var res = await _http.SendAsync(req, ct);
        var body = await res.Content.ReadAsStringAsync(ct);

        if (!res.IsSuccessStatusCode)
            return DefaultEmojis();

        try
        {
            var root = JObject.Parse(body);
            var content = root.SelectToken("choices[0].message.content")?.Value<string>() ?? "";

            var arr = JArray.Parse((content ?? "").Trim());
            var emojis = arr
                .Select(x => x?.Type == JTokenType.String ? x.Value<string>() : null)
                .Where(x => !string.IsNullOrWhiteSpace(x))
                .Select(x => x!.Trim())
                .Distinct()
                .Take(3)
                .ToList();

            return emojis.Count == 3 ? emojis : DefaultEmojis();
        }
        catch
        {
            return DefaultEmojis();
        }
    }

    private static List<string> DefaultEmojis()
        => new() { "😀", "✨", "🧿" };
}
