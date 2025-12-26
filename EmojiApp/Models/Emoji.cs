namespace EmojiApp.Models
{

    public class Emoji
    {
        public string? Name { get; set; }
        public string? Category { get; set; }
        public string? Group { get; set; }
        public List<string>? HtmlCode { get; set; }
        public List<string>? Unicode { get; set; }
        public string? HtmlCodeDecoded { get; set; }

    }

}
