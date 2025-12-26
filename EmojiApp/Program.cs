using System.Text.Json;
using EmojiApp.Services;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers().AddJsonOptions(o =>
{
    o.JsonSerializerOptions.PropertyNamingPolicy = JsonNamingPolicy.CamelCase;
    o.JsonSerializerOptions.PropertyNameCaseInsensitive = true;
});

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddMemoryCache();


builder.Services.AddHttpClient<EmojiHubClient>((sp, client) =>
{
    var cfg = sp.GetRequiredService<IConfiguration>();
    var baseUrl = cfg["EmojiHubApi:BaseUrl"];
    client.BaseAddress = new Uri(baseUrl);
    client.Timeout = TimeSpan.FromSeconds(15);
});

builder.Services.AddScoped<EmojiService>();

builder.Services.AddMemoryCache();

builder.Services.AddHttpClient<OpenRouterClient>((sp, client) =>
{
    var cfg = sp.GetRequiredService<IConfiguration>();
    client.BaseAddress = new Uri(cfg["OpenRouter:BaseUrl"]!);
    client.Timeout = TimeSpan.FromSeconds(20);
    client.DefaultRequestHeaders.Accept.ParseAdd("application/json");


    var appUrl = cfg["OpenRouter:AppUrl"];
    var appName = cfg["OpenRouter:AppName"];
    if (!string.IsNullOrWhiteSpace(appUrl))
        client.DefaultRequestHeaders.TryAddWithoutValidation("HTTP-Referer", appUrl);
    if (!string.IsNullOrWhiteSpace(appName))
        client.DefaultRequestHeaders.TryAddWithoutValidation("X-Title", appName);
});

builder.Services.AddScoped<IEmojiSuggestionProvider, OpenRouterEmojiSuggestionProvider>();
builder.Services.AddScoped<EmojiSuggestionService>();


builder.Services.AddCors(options =>
{
    options.AddPolicy("flutter-dev", p => p
        .AllowAnyHeader()
        .AllowAnyMethod()
        .SetIsOriginAllowed(_ => true));
});

var app = builder.Build();

app.UseSwagger();
app.UseSwaggerUI();

app.UseCors("flutter-dev");

app.MapControllers();

app.Run();
