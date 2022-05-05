//
//  ViewController.h
//  Facebook Video Downloader
//
//  Created by Kalai on 15/6/15.
//  Copyright (c) 2015 com.PTS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MZUtility.h"

@import GoogleMobileAds;


@interface FacebookViewController : UIViewController <UIWebViewDelegate, UIAlertViewDelegate, UIPopoverControllerDelegate, UIActionSheetDelegate, UIScrollViewDelegate,  UIGestureRecognizerDelegate, GADInterstitialDelegate> {
    
    int buttonTag;
    
}




///We create webview to display the contents on the main view of application
@property (strong, nonatomic) IBOutlet UIWebView *webView;





///in iPad, we display the uiactivity controller as popover
@property (nonatomic, strong) UIPopoverController *popover;





@property (weak, nonatomic) NSString *globalURL;





@property(nonatomic,retain)IBOutlet UIBarButtonItem *back;

-(IBAction)backButtonPressed: (id)sender;


-(IBAction)loadHomePage: (id)sender;


@property (weak, nonatomic) IBOutlet GADBannerView  *bannerView;

@property(nonatomic, strong) GADInterstitial *interstitial;



@end
