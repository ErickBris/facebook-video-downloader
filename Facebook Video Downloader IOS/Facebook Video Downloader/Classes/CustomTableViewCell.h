//
//  CustomTableViewCell.h
//  Facebook Video Downloader
//
//  Created by Kalai on 14/6/15.
//  Copyright (c) 2015 com.PTS. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 *  Example of a custom cell built in Storyboard
 */

@interface CustomTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *fileName;

@property (weak, nonatomic) IBOutlet UILabel *durationLabel;


@property (weak, nonatomic) IBOutlet UIButton *playButton;

@property (weak, nonatomic) IBOutlet UIImageView *thumbNail;




@end
