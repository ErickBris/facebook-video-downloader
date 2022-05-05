//
//  AppDelegate.h
//  Facebook Video Downloader
//
//  Created by Kalai on 13/6/15.
//  Copyright (c) 2015 com.PTS. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NSFileManager+DoNotBackup.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (copy) void (^backgroundSessionCompletionHandler)();



@end

