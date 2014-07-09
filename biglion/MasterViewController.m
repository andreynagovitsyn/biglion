//
//  MasterViewController.m
//  biglion
//
//  Created by User on 08.07.14.
//  Copyright (c) 2014 User. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailviewController.h"
#import "PostListCellWithImage.h"
#import "ASIHTTPRequest.h"

@interface MasterViewController () {
    NSMutableArray *deals;
}
@end

@implementation MasterViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


//NSString *currentURL = @"";
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:request.responseData options: NSJSONReadingMutableContainers error:NULL];
    
    [deals addObjectsFromArray:[jsonArray valueForKeyPath:@"result.deals"]];
    
    [self.tableView reloadData];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"**err: request failed description %@, url: %@", [request.error description], [request url]);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка запроса" // TODO:
                                                    message:[request.error description]
                                                   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINib *countryNib = [UINib nibWithNibName:@"PostListCellWithImage" bundle:nil];
    [self.tableView registerNib:countryNib
         forCellReuseIdentifier:@"PostListCellWithImage"];
    
    deals = [[NSMutableArray alloc] init];
    
    NSURL* url = [NSURL URLWithString:@"http://api.biglion.ru/api.php?version=1.0&type=json_unescaped&method=get_deal_offer&short=1&city_id=18&active_today=1&startindex=0&quantity=36&category_id=131&rev=2.1"];
    ASIHTTPRequest* currentRequest = [ASIHTTPRequest requestWithURL:url];
    
    [currentRequest setDelegate:self];
    [currentRequest startAsynchronous];
}

- (void)insertNewObject:(id)sender
{
    if (!deals) {
        deals = [[NSMutableArray alloc] init];
    }
    [deals insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return deals.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 197.0f; // height of row with image
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* MyIdentifier = @"PostListCellWithImage";
    
    PostListCellWithImage *cell = (PostListCellWithImage*)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    
    NSDictionary *pItem = [deals objectAtIndex:indexPath.row];
    cell.postItem = pItem;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    
    NSDictionary *deal = [deals objectAtIndex:indexPath.row];
    
    detailViewController.item = deal;
    
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}

@end
