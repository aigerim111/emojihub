namespace EmojiApp.Models
{
    public class EmojiSuggestion
    {
        public string Topic { get; set; } = "";
        public DateTime GeneratedAtUtc { get; set; }
        public List<string> Emojis { get; set; } = new();
    }
}
