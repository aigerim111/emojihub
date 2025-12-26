namespace EmojiApp.Models
{
    public record Pagination<T>(
        int Total,
        int Skip,
        int Take,
        T[]? Items
    );
}
