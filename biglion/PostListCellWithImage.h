//
//  PostListCellWithImage.h
//  rustoria
//
//  Created by User on 08.11.13.
//  Copyright (c) 2013 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostListCellWithImage : UITableViewCell {

    IBOutlet UIImageView *imageAuthorAvatar;
    IBOutlet UILabel *likesSymbolLabel;
    IBOutlet UIView *postImageContainer;
    IBOutlet UIImageView *commentsImageView;
    IBOutlet UIImageView *postImage;
    IBOutlet UILabel *labelLikes;
    IBOutlet UILabel *labelComments;

}
@property (strong, nonatomic) NSDictionary* postItem;
-(void)cellSelected;
@property (strong, nonatomic) IBOutlet UIView *viewImageCover;
@property (strong, nonatomic) IBOutlet UIView *viewTitleBackground;
@property (strong, nonatomic) IBOutlet UILabel *labelRedaction;
//@property (strong, nonatomic) IBOutlet UILabel *labelFor;
@property (strong, nonatomic) IBOutlet UILabel *labelAuthor;
@property (strong, nonatomic) IBOutlet UILabel *labelTitle;

@end
