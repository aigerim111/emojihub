using EmojiApp.Models;
using System.Net.Http.Json;

namespace EmojiApp.Services;

public class EmojiHubClient
{
    private readonly HttpClient _http;

    public EmojiHubClient(HttpClient http) => _http = http;

    public async Task<List<Emoji>> GetAllAsync(CancellationToken ct)
        => await _http.GetFromJsonAsync<List<Emoji>>("api/all", ct) ?? new();

    public async Task<List<Emoji>> SearchAsync(string q, CancellationToken ct)
        => await _http.GetFromJsonAsync<List<Emoji>>($"api/search?q={Uri.EscapeDataString(q)}", ct) ?? new();

    public async Task<List<string>> GetCategoriesAsync(CancellationToken ct)
        => await _http.GetFromJsonAsync<List<string>>("api/categories", ct) ?? new();

    public async Task<List<string>> GetGroupsAsync(CancellationToken ct)
        => await _http.GetFromJsonAsync<List<string>>("api/groups", ct) ?? new();
}
