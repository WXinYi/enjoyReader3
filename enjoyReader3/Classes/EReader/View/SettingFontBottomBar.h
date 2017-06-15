//
//  SettingFontBottomBar.h
//  EnjoyReader
//
//  Created by 王馨仪 on 16/6/2.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import <Foundation/Foundation.h>




@protocol SettingFontBottomBarDelegate <NSObject>

- (void)shutOffPageViewControllerGesture:(BOOL)yesOrNo;

- (void)themeButtonAction:(id)myself themeIndex:(NSInteger)theme;
@end

@interface SettingFontBottomBar : UIView


@property (nonatomic,assign) id<SettingFontBottomBarDelegate>delegate;
- (void)showFontBar;

- (void)hideFontBar;
@end
