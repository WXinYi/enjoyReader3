//
//  ExtractTableViewCell.h
//  enjoyReader3
//
//  Created by WangXy on 2016/9/28.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExtractTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UILabel *bookNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@end
