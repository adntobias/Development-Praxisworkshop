namespace Development_Praxisworkshop.Pages;

//[AllowAnonymous]
[Authorize(Roles = ("a6d89943-0f07-4eec-aa1c-2f9ef44fb5c5"))] // Win10E3License - 3b166cfb-21ff-4ba7-9460-819d066d9b94
public class GalleryModel : PageModel
{
    private readonly ILogger<PrivacyModel> _logger;
    private readonly IConfiguration _config;
    public List<String> images;
    public GalleryModel(ILogger<PrivacyModel> logger, IConfiguration config)
    {
        _logger = logger;
        _config = config;
        images = new List<String>();
    }
    public void OnGet()
    {
        StorageAccountHelper todo = new StorageAccountHelper(_config);
        images = todo.GetImages();
    }
}