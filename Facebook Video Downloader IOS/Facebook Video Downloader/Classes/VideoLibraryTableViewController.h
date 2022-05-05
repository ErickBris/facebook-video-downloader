//
//  VideoLibraryTableViewController.h
//  Facebook Video Downloader
//
//  Created by Kalai on 17/6/15.
//  Copyright (c) 2015 com.PTS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "CustomTableViewCell.h"
#import <MobileCoreServices/MobileCoreServices.h>

@import GoogleMobileAds;


@interface VideoLibraryTableViewController : UITableViewController < UITextFieldDelegate, UIAlertViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate, UIVideoEditorControllerDelegate, UIDocumentInteractionControllerDelegate>
{
    
    /// Lets create an array to hold the files
    NSArray	*videoList;
    
    UIActionSheet *sheet;

    /// Lets create an NSIndexpath so that we can keep track of last selected index path
    NSIndexPath *obj_IndexPath;



    
}



///We declare the activitycontroller here. When user tap on the share icon, we bring up the activity controller
@property (nonatomic, strong) UIActivityViewController *activityViewController;





@property(nonatomic, strong) NSString *libraryVideoFileName;

@property (nonatomic, strong) UIPopoverController *popOver;

@property(nonatomic, strong) NSString *importedVideo;


@property (retain) UIDocumentInteractionController * documentInteractionController;



@property (weak, nonatomic) IBOutlet GADBannerView  *bannerView;




@end
