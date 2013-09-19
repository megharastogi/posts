//
//  DetailViewController.m
//  Posts
//
//  Created by MEGHA GULATI on 9/10/13.
//  Copyright (c) 2013 MEGHA GULATI. All rights reserved.
//

#import "DetailViewController.h"
#import "PostDoc.h"
#import "PostData.h"
#import "Post.h"
#import <Social/Social.h>

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.detailDescriptionLabel.text = self.detailItem.data.title;
        self.userName.text = self.detailItem.data.userName;
        self.content.text = self.detailItem.data.content;
        self.timeStamp.text = self.detailItem.data.timeStamp;
        self.postImage.image = self.detailItem.postImage;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
   

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dismissKeyboard {
    [_detailDescriptionLabel resignFirstResponder];
    [_userName resignFirstResponder];
    [_content resignFirstResponder];

}


-(IBAction) pressedUpdateButton
{
    
    _detailItem.data.title = _detailDescriptionLabel.text;
    _detailItem.data.userName = _userName.text;
    _detailItem.data.content = _content.text;
    NSDateFormatter *formatter;
    NSString        *dateString;
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    
    dateString = [formatter stringFromDate:[NSDate date]];
    _detailItem.data.timeStamp = dateString;
    
    
    NSLog(@"asjdaskld%@",_detailItem.remoteObjectID);
    
    [Post remoteObjectWithID:_detailItem.remoteObjectID async:^(Post *myPost, NSError *error) {

        myPost.title = _detailDescriptionLabel.text;
        myPost.userName = _userName.text;
        myPost.content = _content.text;
        myPost.remoteID = _detailItem.remoteObjectID;
        [myPost remoteUpdate:&error];

    }];


    if( [_delegate respondsToSelector:@selector(detailViewController:didUpdatePost:)] ){
        
        [_delegate detailViewController:self didUpdatePost:_detailItem];
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

-(IBAction) pressedDelete
{
    
    [Post remoteObjectWithID:_detailItem.remoteObjectID async:^(Post *myPost, NSError *error) {
        myPost.remoteID = _detailItem.remoteObjectID;
        [myPost remoteDestroy:&error];
        
    }];
    
    if( [_delegate respondsToSelector:@selector(detailViewController:didDeletePost:)] ){
        
        [_delegate detailViewController:self didDeletePost:_detailItem];
    }


    [self.navigationController popToRootViewControllerAnimated:YES];

}

-(IBAction)postToTwitter
{
    NSLog(@"goes here");
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:_detailItem.data.title];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
    
}


#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
