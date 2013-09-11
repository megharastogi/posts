//
//  DetailViewController.h
//  Posts
//
//  Created by MEGHA GULATI on 9/10/13.
//  Copyright (c) 2013 MEGHA GULATI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostDoc.h"

@class DetailViewController;

@protocol UpdateDataDelegate <NSObject>
@optional
-(void) detailViewController:(DetailViewController*)detailViewController
             didUpdatePost:(PostDoc*)post;
@end



@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>


@property (nonatomic, weak) id <UpdateDataDelegate> delegate;


@property (strong, nonatomic) PostDoc *detailItem;
@property (strong, nonatomic) IBOutlet UITextField *detailDescriptionLabel;
@property (strong, nonatomic) IBOutlet UITextField *userName;
@property (nonatomic) IBOutlet UITextView *content;
@property (nonatomic) IBOutlet UILabel *timeStamp;

-(IBAction) pressedUpdateButton;

@end
