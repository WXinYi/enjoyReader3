//
//  E_DrawerView.h
//  WFReader
//
//  Created by 王馨仪 on 16/5/23.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListView.h"
#import "Mark.h"

@protocol E_DrawerViewDelegate <NSObject>

- (void)openTapGes;
- (void)turnToClickChapter:(NSInteger)chapterIndex;
- (void)turnToClickMark:(Mark *)eMark;

@end

@interface DrawerView : UIView<UIGestureRecognizerDelegate,E_ListViewDelegate>{
    
    ListView *_listView;
}
@property(nonatomic, strong) UIView *parent;
@property(nonatomic, assign) id<E_DrawerViewDelegate>delegate;

- (id)initWithFrame:(CGRect)frame parentView:(UIView *)p;

@end
