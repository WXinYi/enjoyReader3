//
//  CommentDetailTableViewCell.h
//  enjoyReader3
//
//  Created by WangXy on 2016/10/10.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentDetailTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *iconImage;
@property (strong, nonatomic) IBOutlet UILabel *nameTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;

@end
