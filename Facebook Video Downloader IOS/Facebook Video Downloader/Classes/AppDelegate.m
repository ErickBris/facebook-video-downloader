//
//  AppDelegate.m
//  Facebook Video Downloader
//
//  Created by Kalai on 13/6/15.
//  Copyright (c) 2015 com.PTS. All rights reserved.
//

#import "AppDelegate.h"



#define SYSTEM_VERSION_LESS_THAN(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)


#define DOWNLOADS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Downloads"]


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    
    
    NSArray *versionArray = [[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."];
    
    if ([[versionArray objectAtIndex:0] intValue] >= 8) {
        
        // do this if we're runnign iOS 7 or higher
        if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
            [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
        }
        
    } else {
        
        // do this if we're running iOS 6 or below
        
        
    }
    
#endif
    
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    
    NSString *defaultPrefsFile = [[NSBundle mainBundle] pathForResource:@"defaultPrefs" ofType:@"plist"];
    NSDictionary *defaultPreferences = [NSDictionary dictionaryWithContentsOfFile:defaultPrefsFile];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultPreferences];
    
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL iCloudBackUpStatus = [defaults integerForKey:@"iCloudBackUpOn"];
    
    
    if (iCloudBackUpStatus) {
        
        NSLog(@"icloud backup is turned on");
        
    } else {
        
        NSLog(@"icloud  backup is turned off");
        
        NSURL *icloudOffUrl = [NSURL fileURLWithPath:DOWNLOADS_FOLDER];
        
        [[NSFileManager defaultManager] addSkipBackupAttributeToItemAtURL:icloudOffUrl];
        
        //   NSLog(@"icloud off url: %@", icloudOffUrl);

    }

   
    

    
    return YES;
}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - Backgrounding Methods -

- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier
  completionHandler:(void (^)())completionHandler
{
    self.backgroundSessionCompletionHandler = completionHandler;
    
    
}


@end
