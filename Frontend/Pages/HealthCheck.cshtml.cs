namespace Development_Praxisworkshop.Pages;

[AllowAnonymous]
[ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
public class HealthCheckPageModel : PageModel
{
    public string RequestId { get; set; }

    public bool ShowRequestId => !string.IsNullOrEmpty(RequestId);

    private readonly ILogger<HealthCheckPageModel> _logger;

    public HealthCheckPageModel(ILogger<HealthCheckPageModel> logger)
    {
        _logger = logger;
    }

    public void OnGet()
    {
        RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier;

        _logger.LogInformation("HealthCheckPageModel.OnGet executed.");
    }
}