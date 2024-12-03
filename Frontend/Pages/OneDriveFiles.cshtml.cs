using Microsoft.Graph.Models;
using static Microsoft.ApplicationInsights.MetricDimensionNames.TelemetryContext;

namespace Development_Praxisworkshop.Pages;

//[Authorize(Policy="MustHaveOneDrive")] // need onedrive permissions
[AuthorizeForScopes(Scopes = new[]{"files.readwrite", "Sites.Read.All"})] // Welche scopes fordern wir auf dieser seite (ggf.) an?
public class OneDriveFilesModel : PageModel
{
    private readonly ILogger<PrivacyModel> _logger;
    private readonly IConfiguration _config;
    readonly ITokenAcquisition _tokenAcquisition;
    private string _accessToken;
    private readonly GraphServiceClient _graphServiceClient;
    public DriveItemCollectionResponse _files;
    private readonly MicrosoftIdentityConsentAndConditionalAccessHandler _consentHandler;

    private string[] _graphScopes;
    public OneDriveFilesModel(ILogger<PrivacyModel> logger, 
                                    IConfiguration config, 
                                    ITokenAcquisition tokenAcquisition,
                                    GraphServiceClient graphServiceClient,
                                    MicrosoftIdentityConsentAndConditionalAccessHandler consentHandler)
    {
        _logger = logger;
        _config = config;
        _tokenAcquisition = tokenAcquisition;
        _graphServiceClient = graphServiceClient;
        this._consentHandler = consentHandler;
        _accessToken = "";
        _graphScopes = new[] {"files.readwrite", "Sites.Read.All"}; // required for Onedrive Items/Folders
    }

    public async void OnGet()
    {
        // Scopes, welche JETZT benötigt werden.
        //string[] scopes = new string[]{"Contacts.Read","Family.Read"}; // Inkrementelle Anforderung automatisch durch bekanntgabe gaaaanz oben
        string[] scopes = new string[]{"files.readwrite", "Sites.Read.All"}; // Inkrementelle Anforderung automatisch durch bekanntgabe gaaaanz oben
        _accessToken = _tokenAcquisition.GetAccessTokenForUserAsync(scopes).Result;
        Console.WriteLine(_accessToken);

		var rootDrive = await _graphServiceClient.Users["admin@devtobi.onmicrosoft.com"].Drive.GetAsync();

		var drive = await _graphServiceClient.Me.Drive.GetAsync();
        Console.WriteLine(drive.Id);

		_files = await _graphServiceClient.Drives[drive.Id].Items["root"].Children.GetAsync();//  .Drives[drive.Id].Item["root"].Children.GetAsync().Result;
		Console.WriteLine($"filesCount {_files.OdataCount}");
    }

    
}