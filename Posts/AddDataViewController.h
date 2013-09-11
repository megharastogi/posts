//
//  AddDataViewController.h
//  Posts
//
//  Created by MEGHA GULATI on 9/10/13.
//  Copyright (c) 2013 MEGHA GULATI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddDataViewController : UIViewController <UIGestureRecognizerDelegate, UITextViewDelegate, UITextFieldDelegate>

#pragma mark - Properties

@property (strong, nonatomic) IBOutlet UITextField *userName;
@property (strong, nonatomic) IBOutlet UITextField *postTitle;
@property (strong, nonatomic) IBOutlet UITextView *content;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) IBOutlet UIView *view;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture;

@property (strong,nonatomic) UITextField *activeField;

#pragma mark - Public Methods

- (void)handleTap:(UITapGestureRecognizer *)sender;

@end
