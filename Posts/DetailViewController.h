//
//  DetailViewController.h
//  Posts
//
//  Created by MEGHA GULATI on 9/10/13.
//  Copyright (c) 2013 MEGHA GULATI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostDoc.h"

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) PostDoc *detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (nonatomic) IBOutlet UILabel *userName;
@property (nonatomic) IBOutlet UITextView *content;
@property (nonatomic) IBOutlet UILabel *timeStamp;

@end
