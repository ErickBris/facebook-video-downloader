//
//  ViewController.m
//  Facebook Video Downloader
//
//  Created by Kalai on 15/6/15.
//  Copyright (c) 2015 com.PTS. All rights reserved.
//

#import "FacebookViewController.h"
#import "MZDownloadManagerViewController.h"

#define downloadsFolder [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]


@interface FacebookViewController () <MZDownloadDelegate>
{
    MZDownloadManagerViewController *mzDownloadingViewObj;
    
    CGPoint *startPoint;
    CGPoint *longpressTouchedPoint;
    
    BOOL imageSelected;
    
    NSString *urltodownload;
    
    
}



@end



@implementation FacebookViewController {
    
    NSMutableArray *items;
    
    
    
}

///synthesize, webview, back and forward

@synthesize webView;

@synthesize popover;

@synthesize globalURL;

@synthesize back;


/*=====================================================================================================*/

///in view will apprear method, we initiate the activitivity indicator programmatically

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    
}

/*=====================================================================================================*/







- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
}



- (void)viewDidLoad
{
    
    
    
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    /// once view is loaded we call loadHomePage method
    
    [self loadFacebookHomePage];
    
    
    buttonTag = 0;
    
    
    
    self.webView.scalesPageToFit= TRUE;
    
    
    UINavigationController *mzDownloadingNav = [self.tabBarController.viewControllers objectAtIndex:1];
    mzDownloadingViewObj = [mzDownloadingNav.viewControllers objectAtIndex:0];
    [mzDownloadingViewObj setDelegate:self];
    
    mzDownloadingViewObj.downloadingArray = [[NSMutableArray alloc] init];
    mzDownloadingViewObj.sessionManager = [mzDownloadingViewObj backgroundSession];
    [mzDownloadingViewObj populateOtherDownloadTasks];
    
    
    
    
    UILongPressGestureRecognizer* longPressed = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
    longPressed.delegate = self;
    [self.webView addGestureRecognizer:longPressed];
    
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL admobStatus = [defaults integerForKey:@"admobTurnedOn"];
    
    
    if (admobStatus) {
        
        NSLog(@"Admob is turned on");
        
        NSLog(@"Google Mobile Ads SDK version: %@", [GADRequest sdkVersion]);
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *bannerViewAdUnitID = [defaults valueForKey:@"admobBannerViewID"];

        self.bannerView.adUnitID = bannerViewAdUnitID;
        self.bannerView.rootViewController = self;
        [self.bannerView loadRequest:[GADRequest request]];
        
        self.interstitial = [self createAndLoadInterstitial];
        
        [self performSelector:@selector(disPlayAd) withObject:nil afterDelay:2.0];
        
        
    } else {
        
        NSLog(@"Admob is turned off");
        
     
        self.bannerView.hidden = true;
        
        
    }

    
   }

- (void)disPlayAd {
    if ([self.interstitial isReady]) {
        [self.interstitial presentFromRootViewController:self];
    }
}

- (GADInterstitial *)createAndLoadInterstitial {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *interstitalAdUnitID = [defaults valueForKey:@"admobInterstitialID"];
    
    GADInterstitial *interstitial = [[GADInterstitial alloc] initWithAdUnitID:interstitalAdUnitID];
    interstitial.delegate = self;
    [interstitial loadRequest:[GADRequest request]];
    return interstitial;
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial {
    self.interstitial = [self createAndLoadInterstitial];
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)orientation
                                         duration:(NSTimeInterval)duration {
    
    self.bannerView.adSize = [self adSizeForOrientation:orientation];
}





- (GADAdSize)adSizeForOrientation:(UIInterfaceOrientation)orientation {
    
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        return kGADAdSizeSmartBannerLandscape;
    }
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return kGADAdSizeSmartBannerPortrait;
    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return kGADAdSizeBanner;
    }
    
    return kGADAdSizeBanner;
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{

    if (imageSelected && navigationType == UIWebViewNavigationTypeLinkClicked) {
        imageSelected = YES;

        return YES;
    }
    return YES;
}


- (IBAction)longPressed:(UILongPressGestureRecognizer*)recognizer
{
    [self tap:recognizer];
}


- (IBAction)tap:(UIGestureRecognizer*)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        NSLog(@"Long press detected.");
        
        
        CGPoint touchPoint = [sender locationInView:self.webView];
        
        
        NSString *imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", touchPoint.x, touchPoint.y];
        NSString *urlToSave = [self.webView stringByEvaluatingJavaScriptFromString:imgURL];

        
        if (urlToSave.length == 0) {
            return;
        }
        imageSelected = YES;
        NSURL * imageURL = [NSURL URLWithString:urlToSave];
        
        
        urltodownload = [imageURL absoluteString];
        NSLog(@"url is: %@", imageURL);
        
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:self
                                      cancelButtonTitle:@"Cancel"
                                      destructiveButtonTitle:@"Download"
                                      otherButtonTitles: nil];
        
        [actionSheet showInView:self.view];
        
        
        
    }
    
    
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    otherGestureRecognizer.cancelsTouchesInView = NO;
    
    if ([otherGestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
        otherGestureRecognizer.enabled = NO;

    }

    return YES;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {

    return YES;
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{

    return YES;
}





/*=====================================================================================================*/
/*=====================================================================================================*/



/// this calls the home page . Change the web page address here if you want to load another website

-(void)loadFacebookHomePage

{
    /// If we just want to call a website, we use the following method
    
    
    NSURL *url = [NSURL URLWithString:@"http://www.facebook.com"]; NSURLRequest *requestURL = [NSURLRequest requestWithURL:url];[webView loadRequest:requestURL];
    
    
}

/*=====================================================================================================*/


-(IBAction)loadHomePage: (id)sender{
    
   
    [self loadFacebookHomePage];
    
    

}





/// this method animates the uiactivity indicator when web view starts to load

- (void)webViewDidStartLoad:(UIWebView *)thisWebView
{
    
    //animates iactivity indicator
    
    [(UIActivityIndicatorView *)[self navigationItem].rightBarButtonItem.customView startAnimating];
    
    back.enabled = NO;      // disable back button

    
    
}

/*=====================================================================================================*/


/// this method staop the animation of the uiactivity indicator when web view finish loading

- (void)webViewDidFinishLoad:(UIWebView *)thisWebView
{
    //stop animating activity indicator once loading finished
    
    [(UIActivityIndicatorView *)[self navigationItem].rightBarButtonItem.customView stopAnimating];
    
    
    if(thisWebView.canGoBack == YES)    //we check whether the view can go backward
    {
        back.enabled = YES; // enable back button
    }
    
}


/*=====================================================================================================*/



//method for going backward in the webpage history

-(IBAction)backButtonPressed:(id)sender {
    
    [webView goBack]; // go one step backward
}



/*=====================================================================================================*/
/*=====================================================================================================*/


- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([buttonTitle isEqualToString:@"Download"]) {
        
        
        
        NSLog(@"File Name: %@", urltodownload);
        
        
        
        NSString *urlLastPathComponent = [[urltodownload componentsSeparatedByString:@"/"] lastObject];
        NSString *fileName = [MZUtility getUniqueFileNameForName:urlLastPathComponent];
        [mzDownloadingViewObj addDownloadTask:fileName fileURL:urltodownload];
        
        [self performSelector:@selector(disPlayAd) withObject:nil afterDelay:1.0];

        
    }
    
}




#pragma mark - MZDownloadManager Delegates -
-(void)downloadRequestStarted:(NSURLSessionDownloadTask *)downloadTask
{
    [self updateDownloadingTabBadge];
}
-(void)downloadRequestFinished:(NSString *)fileName
{
    [self updateDownloadingTabBadge];
    NSString *docDirectoryPath = [fileDest stringByAppendingPathComponent:fileName];
    [[NSNotificationCenter defaultCenter] postNotificationName:DownloadCompletedNotif object:docDirectoryPath];
}
-(void)downloadRequestCanceled:(NSURLSessionDownloadTask *)downloadTask
{
    [self updateDownloadingTabBadge];
}


#pragma mark - My Methods -
- (void)updateDownloadingTabBadge
{
    UITabBarItem *downloadingTab = [self.tabBarController.tabBar.items objectAtIndex:1];
    int badgeCount = (int) mzDownloadingViewObj.downloadingArray.count;
    if(badgeCount == 0)
        [downloadingTab setBadgeValue:nil];
    else
        [downloadingTab setBadgeValue:[NSString stringWithFormat:@"%d",badgeCount]];
}


-(void)viewDidUnload
{
    
    
}










@end
