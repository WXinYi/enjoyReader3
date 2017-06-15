//
//  SettingHeaderCell.h
//  EnjoyReader
//
//  Created by 王馨仪 on 16/6/15.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingHeaderCell : UITableViewCell

+ (NSString *)cellIdentifier;

- (void)configWithLogo:(UIImage *)logo
             introduce:(NSString *)introduce;

@end
