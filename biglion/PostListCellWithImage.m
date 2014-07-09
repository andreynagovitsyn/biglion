//
//  PostListCellWithImage.m
//  rustoria
//
//  Created by User on 08.11.13.
//  Copyright (c) 2013 User. All rights reserved.
//

#import "PostListCellWithImage.h"
#import "UIImageView+WebCache.h"

@implementation PostListCellWithImage
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)cellSelected {
    [self.viewImageCover setAlpha:0.2];
    [self.labelTitle setTextColor:[UIColor lightGrayColor]];
    [self.labelAuthor setTextColor:[UIColor lightGrayColor]];
}

#define kElementDistance 8
-(void)setPostItem:(NSDictionary *)pItem
{
    
    // image
    NSString *url = [pItem valueForKey:@"image"];

    // finally set image url
    [postImage setImageWithURL:[NSURL URLWithString:url]
              placeholderImage:nil];

    
    // set attributed text for title
    NSString *textTitle = [[pItem valueForKey:@"short_name"] stringByAppendingString:@" " /*space before data representation*/];
    
    UIFont *font = [UIFont boldSystemFontOfSize:16];
    int length = textTitle.length;
    
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[[pItem valueForKey:@"end_date"]doubleValue]];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents* dcomps = [calendar components:NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:[NSDate date] toDate:date options:0];
    NSString *dateString = [NSString stringWithFormat:@"Осталось %d дн. %d:%d" , [dcomps day], [dcomps hour], [dcomps minute]];
    
    NSString *formattedDateString = dateString;
    
    textTitle = [textTitle stringByAppendingString:formattedDateString];
    
    
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:textTitle];
    
    [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, length)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(length, formattedDateString.length)];

    // configure author
    NSString *discount = [pItem valueForKey:@"discount"];
    NSString *originalPrice = [pItem valueForKey:@"original_price"];
    float discountPrice = [originalPrice floatValue] * ([discount floatValue]/100.0);
    NSString *authorText = [NSString stringWithFormat:@"%@р. - %@%% = %dр.", originalPrice, discount, [originalPrice integerValue] - (int)discountPrice];

    NSArray *blogsUnsorted = [pItem valueForKeyPath:@"blogs"];
//    NSString *redactionText = authorText;
    NSString *redactionText = [pItem valueForKey:@"discount"];
    if([blogsUnsorted count] > 0) {
        NSArray* arr =  [blogsUnsorted sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            NSNumber *first = [(NSDictionary*)a valueForKey:@"id"];
            NSNumber *second = [(NSDictionary*)b valueForKey:@"id"];
            return first > second;
        }];
        redactionText = [[arr objectAtIndex:0] valueForKey:@"name"];
    }

    [self.labelAuthor setText:authorText];
//    [self.labelAuthor sizeToFit];
    
    CGRect rect = [attributedString boundingRectWithSize:CGSizeMake(297.0f, 20000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    CGSize size_title = rect.size;
    
    CGFloat height = ceil(size_title.height);
    CGRect vtbRect = self.viewTitleBackground.frame;
    vtbRect.origin.y = 131; // reset y
    vtbRect.origin.y -= height - 19 /* the lesser the heigher viewTitleBackground */;
    vtbRect.size.height = 33;
    vtbRect.size.height += height - 18 /* the lesser the thicker viewTitleBackground */;
    [self.viewTitleBackground setFrame:vtbRect];

    CGRect vtleRect = self.labelTitle.frame;
    vtleRect.origin.y = 136; // reset y
    vtleRect.origin.y -= height - 19 /* the lesser the heigher self.labelTitle */;
//    vtleRect.size.height = 17; //
    vtleRect.size.height = height;
    [self.labelTitle setFrame:vtleRect];
    
    
    [self.labelTitle setAttributedText:attributedString];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
