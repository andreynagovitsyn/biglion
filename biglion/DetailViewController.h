//
//  BeltItemController3.h
//  px
//
//  Created by User on 30.08.13.
//  Copyright (c) 2013 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface DetailViewController : UITableViewController {
    int postBookmarkCurrentStatus; // init with invalid postbookmarkstatus
    NSMutableArray *posts;
    
    NSMutableArray *headerViewWidgets;
    IBOutlet UIView *btnBack;
    IBOutlet UIButton *bookmarkButton;
    IBOutlet UIButton *btnAuthor;
    IBOutlet UIButton *btnRedaction;
    IBOutlet UIView *viewCommentsControl;
    IBOutlet UIButton *commentsButton;
    IBOutlet UILabel *labelRating;
    IBOutlet UIView *titleView;
//    IBOutlet UISegmentedControl *sugetsSegmentedControl;
    IBOutlet UILabel *labelDivider;
    IBOutlet UIImageView *imgLike;
    IBOutlet UIImageView *imgComment;
    IBOutlet UIView *viewSugetsMaterialsControl;
//    IBOutlet UILabel *labelAnnounce;
    IBOutlet UILabel *labelLikes;
    IBOutlet UILabel *labelComments;
    IBOutlet UILabel *labelAuthor;
    IBOutlet UILabel *labelTitle;
    IBOutlet UILabel *labelDate;
//    IBOutlet UILabel *labelRubrika;
    IBOutlet UIView *headerView;
}
@property (strong, nonatomic) NSDictionary* item;
@end
