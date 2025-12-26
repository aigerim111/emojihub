using EmojiApp.Models;
using EmojiApp.Services;
using Microsoft.AspNetCore.Mvc;

namespace EmojiApp.Controllers
{

    [ApiController]
    [Route("api/suggestions")]
    public sealed class SuggestionsController : ControllerBase
    {
        private readonly EmojiSuggestionService _service;

        public SuggestionsController(EmojiSuggestionService service) => _service = service;

        [HttpGet]
        [ProducesResponseType(typeof(EmojiSuggestion), StatusCodes.Status200OK)]
        public async Task<ActionResult<EmojiSuggestion>> Get([FromQuery] string? topic, CancellationToken ct)
            => Ok(await _service.GetAsync(topic, ct));
    }
}
