//
//  CommentTableViewCell.h
//  enjoyReader3
//
//  Created by 王馨仪 on 16/8/8.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *allCommentBtn;
@property (strong, nonatomic) IBOutlet UIButton *allZanBtn;
@property (strong, nonatomic) IBOutlet UIImageView *allCommentIcon;
@property (strong, nonatomic) IBOutlet UILabel *allCommentName;
@property (strong, nonatomic) IBOutlet UILabel *allCommentTime;
@property (strong, nonatomic) IBOutlet UILabel *allCommentContent;

@end
