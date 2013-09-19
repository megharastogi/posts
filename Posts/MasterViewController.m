//
//  MasterViewController.m
//  Posts
//
//  Created by MEGHA GULATI on 9/10/13.
//  Copyright (c) 2013 MEGHA GULATI. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"
#import "PostData.h"
#import "PostDoc.h"
#import "Post.h"
#import "AddDataViewController.h"
#import "DetailViewController.h"
#import "UIColor+PickRandomColor.h"
#import <AWSRuntime/AWSRuntime.h>
#import <AWSS3/AWSS3.h>


@interface MasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation MasterViewController

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.postList = [[NSMutableArray alloc] init];

    [self syncFromRails];
    
    self.firstRowColor = [UIColor pickRandomColor];
    
	// Do any additional setup after loading the view, typically from a nib.
//    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    
    self.title = @"Post List";

}

-(void)syncFromRails
{
    
    [Post remoteAllAsync:^(NSArray *allRemote, NSError *error) {
        
        NSMutableArray * postListRails = [NSMutableArray arrayWithArray:allRemote];
        
        
        for( Post* post in postListRails ) {
            PostDoc *post1 = [[PostDoc alloc] initWithUserName:post.userName title:post.title content:post.content imageFilename:post.imageFilename postColor:[UIColor pickRandomColor]];
            
            NSDictionary *hashSentByRails = post.remoteAttributes;
            
            post1.remoteObjectID = hashSentByRails[@"id"];
            [self.postList addObject:post1];
        }
        
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    [self performSegueWithIdentifier:@"addData" sender:self];
    
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}



#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _postList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyBasicCell" forIndexPath:indexPath];
    

    PostDoc *post = [self.postList objectAtIndex:indexPath.row];
    cell.textLabel.text = post.data.title;
    [cell setBackgroundColor:post.data.postColor];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    NSURL *imageUrl = [self fetchImageUrlFromS3:post];
    
    imgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
    
    cell.imageView.image =  imgView.image;

    return cell;
}

-(NSURL *)fetchImageUrlFromS3:(PostDoc *)post
{
    
    self.s3 = [[AmazonS3Client alloc] initWithAccessKey:@"access_key" withSecretKey:@"secret_key"];
    self.s3.endpoint = [AmazonEndpoints s3Endpoint:US_WEST_2];

    S3ResponseHeaderOverrides *override = [[S3ResponseHeaderOverrides alloc] init];
    override.contentType = @"image/jpeg";
    
    S3GetPreSignedURLRequest *gpsur = [[S3GetPreSignedURLRequest alloc] init];
    gpsur.key     = post.data.imageFilename;
    gpsur.bucket  = @"bucket";
    gpsur.expires = [NSDate dateWithTimeIntervalSinceNow:(NSTimeInterval) 3600];  // Added an hour's worth of seconds to the current time.
    gpsur.responseHeaderOverrides = override;

    NSURL *url = [self.s3 getPreSignedURL:gpsur];

    return url;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        PostDoc *post = [self.postList objectAtIndex:indexPath.row];
        self.detailViewController.detailItem = post;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PostDoc *post = _postList[indexPath.row];
        self.detailViewController.detailItem = post;
        [[segue destinationViewController] setDetailItem:post];
    }
    
    if ([[segue identifier] isEqualToString:@"createNew"]) {

        AddDataViewController* addDataController  = segue.destinationViewController;
        addDataController.delegate = self;
    }
    
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        
        DetailViewController* detailViewController  = segue.destinationViewController;
        detailViewController.delegate = self;
    }

}



-(void) addDataViewController:(AddDataViewController *)addDataViewController
             didCreateNewPost:(PostDoc*)post;
{
    
    [self.postList removeAllObjects];

    [self syncFromRails];

    [self.tableView reloadData];
    
}

-(void) detailViewController:(DetailViewController *)detailViewController
             didUpdatePost:(PostDoc*)post;
{
    

    [self syncFromRails];
    [self.tableView reloadData];
    
}

-(void) detailViewController:(DetailViewController *)detailViewController
               didDeletePost:(PostDoc*)post;
{
    
//    [self.postList removeObject:post];

    [self.postList removeAllObjects];
    
    [self syncFromRails];

    [self.tableView reloadData];
    
}



@end
