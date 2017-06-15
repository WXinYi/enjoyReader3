//
//  E_ReaderView.h
//  E_Reader
//
//  Created by 王馨仪 on 16/5/23.
//  Copyright © 2016年 王馨仪. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "MagnifiterView.h"
#import "CursorView.h"

/**
 *  显示文本类
 */

@protocol E_ReaderViewDelegate <NSObject>

- (void)shutOffGesture:(BOOL)yesOrNo;
- (void)hideSettingToolBar;
- (void)ciBa:(NSString *)ciBasString;

@end

@interface ReaderView : UIView

@property(unsafe_unretained, nonatomic)NSUInteger font;
@property(copy, nonatomic)NSString *text;

@property (strong, nonatomic) CursorView *leftCursor;
@property (strong, nonatomic) CursorView *rightCursor;
@property (strong, nonatomic) MagnifiterView *magnifierView;
@property (assign, nonatomic) id<E_ReaderViewDelegate>delegate;
@property (strong, nonatomic) UIImage  *magnifiterImage;
@property (copy  , nonatomic) NSString *keyWord;

- (void)render;

@end
