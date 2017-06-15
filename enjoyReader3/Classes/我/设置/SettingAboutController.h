//
//  SettingAboutController.h
//  EnjoyReader
//
//  Created by 王馨仪 on 16/6/15.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingAboutItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface SettingAboutController : UITableViewController

+ (instancetype)viewControllerWithLogo:(nonnull UIImage  *)logo
                             introduce:(nonnull NSString *)introduce
                                 items:(nonnull NSArray <SettingAboutItem *>*)items;

- (instancetype)initWithLogo:(nonnull UIImage  *)logo
                   introduce:(nonnull NSString *)introduce
                       items:(nonnull NSArray <SettingAboutItem *>*)items;

@end

NS_ASSUME_NONNULL_END
