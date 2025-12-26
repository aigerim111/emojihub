using EmojiApp.Models;
using EmojiApp.Services;
using Microsoft.AspNetCore.Mvc;

namespace EmojiApp.Controllers;

[ApiController]
[Route("api/emojis")]
public class EmojiController : ControllerBase
{
    private readonly EmojiService _service;

    public EmojiController(EmojiService service) => _service = service;

    [HttpGet]
    [ProducesResponseType(typeof(Emoji), StatusCodes.Status200OK)]
    public async Task<ActionResult<Emoji>> Get(
        [FromQuery] string? query,
        [FromQuery] string? category,
        [FromQuery] string? sort,
        [FromQuery] string? order,
        [FromQuery] int skip = 0,
        [FromQuery] int take = 50,
        CancellationToken ct = default)
    {
        var result = await _service.QueryAsync(query, category, sort, order, skip, take, ct);
        return Ok(result);
    }
}
