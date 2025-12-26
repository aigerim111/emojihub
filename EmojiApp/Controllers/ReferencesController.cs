using EmojiApp.Services;
using Microsoft.AspNetCore.Mvc;

namespace EmojiApp.Controllers;

[ApiController]
[Route("api")]
public class ReferencesController : ControllerBase
{
    private readonly EmojiService _service;

    public ReferencesController(EmojiService service) => _service = service;

    [HttpGet("categories")]
    public async Task<ActionResult<IReadOnlyList<string>>> Categories(CancellationToken ct)
        => Ok(await _service.GetCategoriesAsync(ct));

    [HttpGet("groups")]
    public async Task<ActionResult<IReadOnlyList<string>>> Groups(CancellationToken ct)
        => Ok(await _service.GetGroupsAsync(ct));
}
