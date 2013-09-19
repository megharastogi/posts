//
//  MasterViewController.h
//  Posts
//
//  Created by MEGHA GULATI on 9/10/13.
//  Copyright (c) 2013 MEGHA GULATI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddDataViewController.h"
#import "DetailViewController.h"
#import <AWSS3/AWSS3.h>

@interface MasterViewController : UITableViewController <AddDataDelegate,UpdateDataDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;
@property (strong) NSMutableArray *postList;
@property (nonatomic) UIColor *firstRowColor;

@property (nonatomic, retain) AmazonS3Client *s3;


@end
