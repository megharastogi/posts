//
//  AddDataViewController.h
//  Posts
//
//  Created by MEGHA GULATI on 9/10/13.
//  Copyright (c) 2013 MEGHA GULATI. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddDataViewController;
@class PostDoc;

@protocol AddDataDelegate <NSObject>
@optional
-(void) addDataViewController:(AddDataViewController*)addDataViewController
             didCreateNewPost:(PostDoc*)post;
@end

@interface AddDataViewController : UIViewController <UIGestureRecognizerDelegate, UITextViewDelegate, UITextFieldDelegate,UIAlertViewDelegate>


@property (nonatomic, weak) id <AddDataDelegate> delegate;


#pragma mark - Properties

@property (strong, nonatomic) IBOutlet UITextField *userName;
@property (strong, nonatomic) IBOutlet UITextField *postTitle;
@property (strong, nonatomic) IBOutlet UITextView *content;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture;

-(IBAction) pressedSubmitButton;

@property (strong,nonatomic) UITextField *activeField;
@property (strong,nonatomic) UITextView *activeTextView;

#pragma mark - Public Methods

- (void)handleTap:(UITapGestureRecognizer *)sender;

@end
