//
//  TabbarTableViewCell.h
//  enjoyReader3
//
//  Created by WangXy on 16/9/18.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabbarTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *chooseIcon;
@property (strong, nonatomic) IBOutlet UILabel *chooseTitle;
@property (strong, nonatomic) IBOutlet UIView *chooseLine;

@end
