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
#import <AWSS3/AWSS3.h>
#import <AWSRuntime/AWSRuntime.h>

@interface AddDataViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate>
{
    IBOutlet UIImageView *imageView;
}

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
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activeField = textField;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)aTextView
{
    self.activeField = aTextView;
    return YES;
    //Has Focus
}

- (void)keyboardDidHide: (NSNotification *) notif{
    // Do something here
}

-(IBAction) pressedSubmitButton
{

    PostDoc *post = [[PostDoc alloc] initWithUserName: _userName.text title: _postTitle.text content: _content.text imageFilename:@"" postColor:[UIColor pickRandomColor]];
    
    post.postImage = imageView.image;
    
    
//    NSData *imageData = UIImagePNGRepresentation(imageView.image);

    
    Post *newPost = [[Post alloc] init];
    newPost.title =_postTitle.text;
    newPost.userName =_userName.text;
    newPost.content =_content.text;
    newPost.id = nil;
    
    if(imageView.image){
    //generate random filename
    NSInteger filename_size = 10;
    post.data.imageFilename = [self genRandStringLength:filename_size];
    newPost.imageFilename = post.data.imageFilename;
  
    
    [self uploadImageToS3:post];
 
    }
    
    [newPost remoteCreate:nil];

    
    if( [_delegate respondsToSelector:@selector(addDataViewController:didCreateNewPost:)] ){
        
        [_delegate addDataViewController:self didCreateNewPost:post];
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (IBAction)takePicture:(id)sender
{
    
    UIActionSheet *displayImageOption = [[UIActionSheet alloc] initWithTitle:@""
                                                              delegate:self
                                                              cancelButtonTitle:@"Cancel"
                                                              destructiveButtonTitle:nil
                                                              otherButtonTitles:@"Pick from Camera Roll", @"Take a picture",nil];
    
    [displayImageOption showInView:self.view];

}
-(void)selectPicker
{

    UIImagePickerController *picker = [UIImagePickerController new];
    [picker setDelegate:self];
    [picker setAllowsEditing:YES];
    [self presentViewController:picker animated:YES completion:^{
        
    }];

}

-(void)selectCamera
{
    
    UIImagePickerController *camera = [UIImagePickerController new];
    [camera setDelegate:self];
    [camera setAllowsEditing:YES];
    [self presentViewController:camera animated:YES completion:nil];
    
    if( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        camera.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    
}

-(void)uploadImageToS3:(PostDoc*)post
{
    // Initial the S3 Client.
    self.s3 = [[AmazonS3Client alloc] initWithAccessKey:@"access_key" withSecretKey:@"secret_key"];
    self.s3.endpoint = [AmazonEndpoints s3Endpoint:US_WEST_2];
    
    
    
    
    S3PutObjectRequest *por = [[S3PutObjectRequest alloc] initWithKey:post.data.imageFilename inBucket:@"bucket"];
    por.contentType = @"image/jpeg";
    NSData *pictureData = UIImageJPEGRepresentation(imageView.image, 1.0);
    
    por.data = pictureData;
    [self.s3 putObject:por];
}

-(NSString *) genRandStringLength: (int) len {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    
    return randomString;
}

#pragma mark - UIActionSheet Delegate


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 0){
        [self selectPicker];
    }
    if(buttonIndex == 1){
        [self selectCamera];
    }
    
}

#pragma mark - UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"Finished Picking Image");
    [self dismissViewControllerAnimated:YES completion:^{
//               UIImage *pickedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        UIImage *pickedImage = [info objectForKey:UIImagePickerControllerEditedImage];
        [imageView setImage:pickedImage];
    }];

}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Cancelled Image Picker");
    }];
}




@end
