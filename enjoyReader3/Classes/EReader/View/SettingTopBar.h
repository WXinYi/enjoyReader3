//
//  E_SettingBar.h
//  WFReader
//
//  Created by 王馨仪 on 16/5/23.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "E_Paging.h"
/**
 *  顶部设置条
 */

@protocol E_SettingTopBarDelegate <NSObject>

- (void)goBack;//退出
//- (void)bookMarkBtnClick:(UIButton*)button;
//- (id)initWithFrame:(CGRect)frame andrangPage:(NSInteger)readPage;
@end

@interface SettingTopBar : UIView
{
    E_Paging             * _paginater;
}
@property(nonatomic,assign)id<E_SettingTopBarDelegate>delegate;
@property (assign, nonatomic) NSInteger readPage;
@property (nonatomic,assign) BOOL isHidden;
- (void)showToolBar;

- (void)hideToolBar;

@end
