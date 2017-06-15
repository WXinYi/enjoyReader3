//
//  QuanTableViewCell.h
//  enjoyReader3
//
//  Created by WangXy on 2016/9/28.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuanTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *iconImage;

@property (strong, nonatomic) IBOutlet UILabel *nameAndTime;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UIButton *commentBtn;

@property (strong, nonatomic) IBOutlet UIButton *zanBtn;

@property (strong, nonatomic) IBOutlet UITableView *replyTable;

@property (strong, nonatomic) IBOutlet UIButton *arrarBtn;



@end

