//
//  VideoLibraryTableViewController.m
//  Facebook Video Downloader
//
//  Created by Kalai on 17/6/15.
//  Copyright (c) 2015 com.PTS. All rights reserved.
//

#import "VideoLibraryTableViewController.h"

#define FONT_ROBOTO_THIN(s) [UIFont fontWithName:@"Roboto-Thin" size:s]
#define FONT_ROBOTO_MED(s) [UIFont fontWithName:@"Roboto-Medium" size:s]
#define FONT_ROBOTO_COND(s) [UIFont fontWithName:@"Roboto-Condensed" size:s]



#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define DOWNLOADS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Downloads"]



@interface VideoLibraryTableViewController () {
  
    NSMutableArray *downloadedFilesArray;
   
    
    NSMutableArray *downloadedFiles;

    
    NSFileManager *fileManger;

}

@end

@implementation VideoLibraryTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void) viewWillAppear: (BOOL) animated
{
    [self renameFile];

    
    
}

- (void) viewDidAppear: (BOOL) animated
{
	
   }

-(void)renameFile{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
   
    downloadedFiles = [[NSMutableArray alloc] init];
    
    
    NSString *stringPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"Downloads"];

    if (![[NSFileManager defaultManager] fileExistsAtPath:stringPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:stringPath withIntermediateDirectories:NO attributes:nil error:&error];

    
    fileManger = [NSFileManager defaultManager];

    downloadedFiles = [[fileManger contentsOfDirectoryAtPath:DOCUMENTS_FOLDER error:&error] mutableCopy];
    
    if([downloadedFiles containsObject:@".DS_Store"])
        [downloadedFiles removeObject:@".DS_Store"];
        [downloadedFiles removeObject:@"Downloads"];
    
        for (int i = 0; i < [downloadedFiles count]; i++)
        {
            NSLog(@"%@", [downloadedFiles objectAtIndex:i]);
            
            
            //append the name of the file in jpg form
            NSString *filePath = [DOCUMENTS_FOLDER stringByAppendingPathComponent:[downloadedFiles objectAtIndex:i]];
            
            NSString* theFileName = [[filePath lastPathComponent] stringByDeletingPathExtension];
            
            //check if the file exists (completely unnecessary).
            if ([fileManager fileExistsAtPath:filePath]) {
                //get new resource path with different extension
             
                NSString *newFileName = [NSString stringWithFormat:@"%@.mp4", theFileName];
                NSString *resourcePath = [DOWNLOADS_FOLDER stringByAppendingPathComponent:newFileName];
                //copy it over
                [fileManager copyItemAtPath:filePath toPath:resourcePath error:&error];
                
                NSLog(@"New path: %@",resourcePath);
                [fileManager removeItemAtPath:filePath error:&error];
        }
        
        }
    
    
    
    [downloadedFiles removeAllObjects];


    [self loadFileList];
    [self.tableView reloadData];

    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
   

    [self loadFileList];
    
    [self.tableView reloadData];


    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    
    
}




- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    GADBannerView *bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *bannerViewAdUnitID = [defaults valueForKey:@"admobBannerViewID"];

    bannerView_.adUnitID = bannerViewAdUnitID;
    bannerView_.rootViewController = self;
    GADRequest *request = [GADRequest request];

    [bannerView_ loadRequest:request];
    
    bannerView_.backgroundColor = [UIColor clearColor];
    
    return bannerView_;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL admobStatus = [defaults integerForKey:@"admobTurnedOn"];
    
    
    if (admobStatus) {
    
        
        return 50.0;

        
    } else {
        
        
    
        return 0;

        
    }

    
    
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











//=======================================================================================================

// let's load the recorded file list

//=======================================================================================================


///this method checks for available files in document directory with file extension of "m4r". If exists, it will assign them to NSArray

- (void) loadFileList
{

    NSArray *matchArray = [NSArray arrayWithObject:@"mp4"];
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:DOWNLOADS_FOLDER error:nil];
    
    
	videoList = [contents pathsMatchingExtensions:matchArray];
    
    
    
    
}




//=======================================================================================================

// Table View Delegate

//=======================================================================================================


// Data Source Methods.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}


///lets update no of rows from file list
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return videoList.count;
}




- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}





- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 238 ;
}








///configure cell


- (UITableViewCell *)tableView:(UITableView *)tView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"VideoCell";
    CustomTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (cell == nil)
    {
        cell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
   
    
  
    cell.thumbNail.backgroundColor = [UIColor whiteColor];
    cell.thumbNail.layer.borderColor = [UIColor colorWithWhite:0.8f alpha:0.8f].CGColor;
    cell.thumbNail.layer.borderWidth = 5.0f;
    cell.thumbNail.layer.cornerRadius = 0.1f;
    cell.thumbNail.layer.masksToBounds = YES;


    
    NSString *path = [DOWNLOADS_FOLDER stringByAppendingPathComponent:[videoList objectAtIndex:[indexPath row]]];
    NSURL *videoURL = [NSURL fileURLWithPath:path];
    
    
    cell.thumbNail.image = [self thumbnailFromVideoAtURL:videoURL];
    cell.fileName.text = [[videoList objectAtIndex:[indexPath row]] stringByDeletingPathExtension];

    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL
                                                options:[NSDictionary dictionaryWithObjectsAndKeys:
                                                         [NSNumber numberWithBool:YES],
                                                         AVURLAssetPreferPreciseDurationAndTimingKey,
                                                         nil]] ;
    
    NSTimeInterval durationInSeconds = 0.0;
    if (asset)
        durationInSeconds = CMTimeGetSeconds(asset.duration) ;
    
    cell.durationLabel.text = [self stringFromTimeInterval:durationInSeconds];

    
    

    return cell;
}


- (NSString *)stringFromTimeInterval:(NSTimeInterval)interval {
    NSInteger ti = (NSInteger)interval;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    return [NSString stringWithFormat:@"%02ldh %02ldm %02lds", (long)hours, (long)minutes, (long)seconds];
}



- (UIImage *)thumbnailFromVideoAtURL:(NSURL *)url
{
    AVAsset *asset = [AVAsset assetWithURL:url];
    
    //  Get thumbnail at the 2nd second of the video
    CMTime thumbnailTime = [asset duration];
    thumbnailTime.value = thumbnailTime.timescale * 1;
    
    //  Get image from the video at the given time
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:thumbnailTime actualTime:NULL error:NULL];
    UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return thumbnail;
}





-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    obj_IndexPath = indexPath;

    if(obj_IndexPath !=nil){
        
        if (sheet) {
            [sheet dismissWithClickedButtonIndex:-1 animated:YES];
        }
        
        sheet = [[UIActionSheet alloc]
                 initWithTitle:@"What do you want to do with selected Video?"
                 delegate:self
                 cancelButtonTitle:@"Cancel"
                 destructiveButtonTitle:@"Delete"
                 otherButtonTitles:@"Play", @"Share",@"Open In...", nil];
        
        sheet.tag = 1; //assign a tag
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            
            
            [sheet showInView:self.view];

        }else{
            
            [sheet showInView:self.view];
            
        }
    }
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];


}







- (void)willPresentActionSheet:(UIActionSheet *)actionSheet {
    [actionSheet.subviews enumerateObjectsUsingBlock:^(id _currentView, NSUInteger idx, BOOL *stop) {
        if ([_currentView isKindOfClass:[UIButton class]]) {
            [((UIButton *)_currentView).titleLabel setFont:FONT_ROBOTO_COND(22.0f)];

        }
    }];
}










-(void)deleteVideo
{
    
    if(obj_IndexPath !=nil){
    
    CustomTableViewCell *cell =(CustomTableViewCell *) [self.tableView cellForRowAtIndexPath:obj_IndexPath];
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    NSString *path = [DOWNLOADS_FOLDER stringByAppendingPathComponent:[videoList objectAtIndex:[indexPath row]]];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil]; // remove the file from list
    
    }
    
 
    
    obj_IndexPath = nil;
    
    [self loadFileList];
    [self.tableView reloadData];
}





-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1) {
        
        if (buttonIndex == actionSheet.destructiveButtonIndex)
        {
            [self deleteVideo];

        }

        else {
        
        switch (buttonIndex) {
            case 1:
                

                [self tableView: self.tableView playButtonTappedForRowWithIndexPath: obj_IndexPath];

                
                
                break;
            case 2:
                
                [self shareVideo];


                break;
        
            case 3:
                
                [self openIn];
                
                break;
                
     

            }
        }
    }
    
}


-(void)openIn {
    
    if(obj_IndexPath !=nil){
        
        CustomTableViewCell *cell =(CustomTableViewCell *) [self.tableView cellForRowAtIndexPath:obj_IndexPath];
        
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        NSString *path = [DOWNLOADS_FOLDER stringByAppendingPathComponent:[videoList objectAtIndex:[indexPath row]]];
        

        
            _documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:path]];

            _documentInteractionController.delegate = self;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {

            [_documentInteractionController presentOpenInMenuFromRect:CGRectMake(0, 0, 0, 0) inView:self.view animated: YES];
        }
        else {

            [_documentInteractionController presentOpenInMenuFromRect:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/4, 0, 0) inView:self.view animated: YES];

            
        }
        
        } else {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Your device doesn't have any app that can open this video" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        
    
}





-(void)shareVideo
{
    if(obj_IndexPath !=nil){
        
        CustomTableViewCell *cell =(CustomTableViewCell *) [self.tableView cellForRowAtIndexPath:obj_IndexPath];

    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    NSString *path = [DOWNLOADS_FOLDER stringByAppendingPathComponent:[videoList objectAtIndex:[indexPath row]]];
    
    NSURL *audioURL = [NSURL fileURLWithPath:path]; //create the path of the file
    
    self.activityViewController = [[UIActivityViewController alloc]
                                   
                                   initWithActivityItems:@[audioURL] applicationActivities:nil]; // pass it to activity controller
    
    [self.activityViewController setValue:@"Video via Facebook Video Downloader" forKey:@"subject"];
    
    
        
        //if iPhone
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            [self presentViewController:self.activityViewController animated:YES completion:nil];
        }
        //if iPad
        else {
            // Change Rect to position Popover
            UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:self.activityViewController];
            [popup presentPopoverFromRect:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/4, 0, 0)inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        
        
    }
    else {
     
        
    }
    
}






//=======================================================================================================

// Table View Delegate

//=======================================================================================================




- (IBAction)playButtonTapped:(id)sender event:(id)event
{
	NSSet *touches = [event allTouches];
	UITouch *touch = [touches anyObject];
	CGPoint currentTouchPosition = [touch locationInView:self.tableView];
	NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
	if (indexPath != nil)
		
	{
        [self tableView: self.tableView playButtonTappedForRowWithIndexPath: indexPath];
        
        
	}
    
    
}





///when the play button is pressed, we initialise the player and play the file.
- (void)tableView:(UITableView *)tableView playButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    
   	NSString *path = [DOWNLOADS_FOLDER stringByAppendingPathComponent:[videoList objectAtIndex:[indexPath row]]];
    
    NSLog(@"extension: %@", [path pathExtension]);


    CustomTableViewCell *cell =(CustomTableViewCell *) [self.tableView cellForRowAtIndexPath:indexPath];

    NSString *nameOfTheFile= cell.fileName.text;

    NSLog (@"Name of the File: %@",nameOfTheFile);
    
    NSURL *url2 = [NSURL fileURLWithPath:path];

    MPMoviePlayerViewController *theMovie = [[MPMoviePlayerViewController alloc] initWithContentURL:url2];
    [self presentMoviePlayerViewControllerAnimated:theMovie];
    theMovie.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
    [theMovie.moviePlayer play];

    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
