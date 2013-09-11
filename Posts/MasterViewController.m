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
#import "AddDataViewController.h"
#import "DetailViewController.h"

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
    
    PostDoc *post1 = [[PostDoc alloc] initWithUserName:@"Megha" title:@"Title1" content:@"someContent"];
    PostDoc *post2 = [[PostDoc alloc] initWithUserName:@"Megha" title:@"Title2" content:@"someContent2"];
    PostDoc *post3 = [[PostDoc alloc] initWithUserName:@"Megha" title:@"Title3" content:@"someContent3"];
    self.postList = [NSMutableArray arrayWithObjects:post1, post2, post3, nil];
    
	// Do any additional setup after loading the view, typically from a nib.
//    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    self.title = @"Post List";

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
    return cell;
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
    
    if ([[segue identifier] isEqualToString:@"addData"]) {

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
    
    
    [self.postList addObject:post];
    [self.tableView reloadData];
    
}

-(void) detailViewController:(DetailViewController *)detailViewController
             didUpdatePost:(PostDoc*)post;
{
    
    
    [self.tableView reloadData];
    
}



@end
