//
//  AddDataViewController.m
//  Posts
//
//  Created by MEGHA GULATI on 9/10/13.
//  Copyright (c) 2013 MEGHA GULATI. All rights reserved.
//

#import "AddDataViewController.h"
#import "PostDoc.h"
#import "UIColor+PickRandomColor.h"
#import "Post.h"

@interface AddDataViewController () 

@end

@implementation AddDataViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Listen for keyboard appearances and disappearances
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    [self.scrollView setUserInteractionEnabled:YES];
    
    self.tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleTap:)];
    self.tapGesture.numberOfTapsRequired = 1;
    [self.scrollView addGestureRecognizer:self.tapGesture];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleTap:(UITapGestureRecognizer *)sender {
    
    NSLog(@"got tap");
    if (sender.state == UIGestureRecognizerStateEnded)     {
        // handling code
        [self.userName resignFirstResponder];
        [self.postTitle resignFirstResponder];
        [self.content resignFirstResponder];
        [self.saveButton resignFirstResponder];
    }
}

- (void)keyboardDidShow: (NSNotification *) aNotification{
    // Do something here
    
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);

    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;

    
    if (!CGRectContainsPoint(aRect, self.activeField.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, self.activeField.frame.origin.y-kbSize.height);
        [self.scrollView setContentOffset:scrollPoint animated:YES];
    }
    
    NSLog(@"text view got focus %f",self.activeTextView.frame.origin.y);
    
    if (!CGRectContainsPoint(aRect, self.activeTextView.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, self.activeTextView.frame.origin.y);
        [self.scrollView setContentOffset:scrollPoint animated:YES];
    }

}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activeField = textField;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)aTextView
{
    self.activeTextView = aTextView;
    return YES;
    //Has Focus
}

- (void)keyboardDidHide: (NSNotification *) notif{
    // Do something here
}

-(IBAction) pressedSubmitButton
{

      PostDoc *post = [[PostDoc alloc] initWithUserName: _userName.text title: _postTitle.text content: _content.text postColor:[UIColor pickRandomColor]];
    
    Post *newPost = [[Post alloc] init];
    newPost.title =_postTitle.text;
    newPost.userName =_userName.text;
    newPost.content =_content.text;
    newPost.id = nil;
    [newPost remoteCreate:nil];

   
    if( [_delegate respondsToSelector:@selector(addDataViewController:didCreateNewPost:)] ){
        
        [_delegate addDataViewController:self didCreateNewPost:post];
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}




@end
