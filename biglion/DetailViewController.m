//
//  BeltItemController3.m
//  px
//
//  Created by User on 30.08.13.
//  Copyright (c) 2013 User. All rights reserved.
//

#import "DetailViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

// TODO: handle videos from all services
@interface DetailViewController ()

@end

@implementation DetailViewController
#define kElementDistance 8


- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"**err: request failed description %@, url: %@", [request.error description], [request url]);

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Сетевая ошибка" // TODO: not necessary
                                                    message:@"Ошибка"
                                                   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

- (CGFloat) calculateHeightForText:(NSString*)text inFont:(UIFont*)font sizeRect:(CGSize)size
{
    CGSize size_title = [text sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    return ceilf(size_title.height);
}

CGFloat headerInitialHeight = 0;
-(void)displayItem
{
    // clear all widgets if there are
    for (UIView *v in headerViewWidgets) {
        [v removeFromSuperview];
    }
    [headerViewWidgets removeAllObjects];
    
    CGFloat imgCommentsX = labelAuthor.frame.origin.x + labelAuthor.frame.size.width + kElementDistance;
    CGRect imgCommentsFrame = imgComment.frame;
    imgCommentsFrame.origin.x = imgCommentsX;
    [imgComment setFrame:imgCommentsFrame];
    
    // adjust title label
    NSString *titleText = [[self.item valueForKey:@"short_name"] stringByAppendingString:@" " /*space before date representation*/];
    
    
    int length = titleText.length;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[[self.item valueForKey:@"end_date"]doubleValue]];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents* dcomps = [calendar components:NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:[NSDate date] toDate:date options:0];
    NSString *dateString = [NSString stringWithFormat:@"Осталось %d дн. %d:%d" , [dcomps day], [dcomps hour], [dcomps minute]];
    
    titleText = [titleText stringByAppendingString:dateString];

    
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:titleText];
    UIFont *font = [UIFont systemFontOfSize:17];
    [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, length)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(length, dateString.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1.0] range:NSMakeRange(length, dateString.length)];
    CGRect rect = [attributedString boundingRectWithSize:CGSizeMake(303.0f, 20000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];

    
    
//    UIFont *font = [UIFont fontWithName:@"Helvetica" size:17.0];
//    CGFloat titleHeight = [self calculateHeightForText:titleText inFont:font sizeRect:CGSizeMake(309, 20000)];
    CGFloat titleHeight = ceilf(rect.size.height);
//    [labelTitle setFont:font];
//    [labelTitle setText:titleText];
    [labelTitle setFrame:CGRectMake(labelTitle.frame.origin.x, labelTitle.frame.origin.y, 303.0, titleHeight)];
    [labelTitle setAttributedText:attributedString];
    
    CGFloat yForBelow = labelTitle.frame.origin.y + titleHeight + kElementDistance - 2 /* less distance according to design */;
    
    CGRect authorFrame = btnAuthor.frame;
    authorFrame.origin.y = yForBelow;
    [btnAuthor setFrame:authorFrame];
//    NSString *authorName = [self.item valueForKey:@"authorName"];
    NSString *discount = [self.item valueForKey:@"discount"];
    NSString *originalPrice = [self.item valueForKey:@"original_price"];
    float discountPrice = [originalPrice floatValue] * ([discount floatValue]/100.0);
    NSString *authorName = [NSString stringWithFormat:@"%@р. - %@%% = %dр.", originalPrice, discount, [originalPrice integerValue] - (int)discountPrice];
    [btnAuthor setTitle:authorName forState:UIControlStateNormal];
    [btnAuthor sizeToFit];
    
    CGFloat redactionX = btnAuthor.frame.origin.x + btnAuthor.frame.size.width + kElementDistance;
    CGRect redactionFrame = btnRedaction.frame;
    redactionFrame.origin.x = redactionX;
    redactionFrame.origin.y = yForBelow;
    [btnRedaction setFrame:redactionFrame];
    NSArray *blogsUnsorted = [self.item valueForKeyPath:@"blogs"];
    NSString *btnRedactionFullTitle = authorName;
    if([blogsUnsorted count] > 0) {
        NSArray* arr =  [blogsUnsorted sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            NSNumber *first = [(NSDictionary*)a valueForKey:@"id"];
            NSNumber *second = [(NSDictionary*)b valueForKey:@"id"];
            return first > second;
        }];
        btnRedactionFullTitle = [[arr objectAtIndex:0] valueForKey:@"name"];
    }
    if ([btnRedactionFullTitle isEqualToString:authorName]) { // если название редакции совпадает с именем автора - показывать только имя автора
        btnRedactionFullTitle = @"";
    }
    int treshold = 70; // approximately 40 characters wide for both author and redaction titles
    if ((btnRedactionFullTitle.length + authorName.length) > treshold) {
        btnRedactionFullTitle = [[btnRedactionFullTitle substringWithRange:NSMakeRange(0, treshold - authorName.length)] stringByAppendingString:@"..."];
    }
    
    NSString *redaction = [NSString stringWithFormat:@"%@%@%@",
                           [[NSLocale currentLocale] objectForKey:NSLocaleQuotationBeginDelimiterKey],
                           btnRedactionFullTitle,
                           [[NSLocale currentLocale] objectForKey:NSLocaleQuotationEndDelimiterKey]];
    
    btnRedactionFullTitle = btnRedactionFullTitle.length == 0 ? @"" : redaction;
    [btnRedaction setTitle:btnRedactionFullTitle  forState:UIControlStateNormal];
    [btnRedaction sizeToFit];
    
    CGRect fr = labelLikes.frame;
    fr.origin.y = yForBelow;
    [labelLikes setFrame:fr];
    
    fr = labelComments.frame;
    fr.origin.y = yForBelow;
    [labelComments setFrame:fr];
    
    fr = labelAuthor.frame;
    fr.origin.y = yForBelow;
    [labelAuthor setFrame:fr];
    
    fr = imgComment.frame;
    fr.origin.y = yForBelow;
    [imgComment setFrame:fr];
    
    fr = imgLike.frame;
    fr.origin.y = yForBelow;
    [imgLike setFrame:fr];
    
    fr = labelDivider.frame;
    fr.origin.y = imgLike.frame.origin.y + imgLike.frame.size.height + kElementDistance + 7 /*some more distance*/;
    [labelDivider setFrame:fr];
    
    fr.origin.y = labelDivider.frame.origin.y + labelDivider.frame.size.height + kElementDistance;
    
    
    CGRect frame = headerView.frame;
    if (headerInitialHeight == 0) {
        headerInitialHeight = ceilf(frame.size.height);
    }
    frame.size.height = headerInitialHeight + titleHeight;
    [headerView setFrame:frame];
    
    
    CGFloat next_y = labelDivider.frame.origin.y + labelDivider.frame.size.height + kElementDistance + 12 /* some more distance for the first widget */; // height of the item cell with initial data
    
    
    frame = viewSugetsMaterialsControl.frame;
    frame.origin.y = next_y + 4 /* distance between last section and Похожие материалы */;
    [viewSugetsMaterialsControl setFrame:frame];
    
    frame = headerView.frame;
    frame.size.height += 8 /* distance between Похожие материалы and first cell of related materials table */;
    [headerView setFrame:frame];

    [self.tableView setTableHeaderView:headerView];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    headerViewWidgets = [[NSMutableArray alloc] init];
    
    btnAuthor.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [self displayItem];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0; // + loading cell
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* tvCell = [[UITableViewCell alloc] init];
    return tvCell; // not used
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // not used
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

@end
