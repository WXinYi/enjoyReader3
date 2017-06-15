//
//  E_ReaderViewController.h
//  E_Reader
//
//  Created by 王馨仪 on 16/5/23.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  显示阅读内容
 */

@protocol ReaderViewControllerDelegate <NSObject>

- (void)shutOffPageViewControllerGesture:(BOOL)yesOrNo;
- (void)hideTheSettingBar;
- (void)ciBaWithString:(NSString *)ciBaString;

@end


@interface ReaderViewController : UIViewController

@property (nonatomic,assign) id<ReaderViewControllerDelegate>delegate;
@property (nonatomic,unsafe_unretained) NSUInteger currentPage;
@property (nonatomic,unsafe_unretained) NSUInteger totalPage;
@property (nonatomic,strong)            NSString   *text;
@property (nonatomic,unsafe_unretained) NSUInteger  font;
@property (nonatomic, copy)             NSString   *chapterTitle;
@property (nonatomic, unsafe_unretained,readonly) CGSize readerTextSize;
@property (nonatomic,strong)            UIImage    *themeBgImage;
@property (nonatomic,strong)            NSString   *keyWord;

- (CGSize)readerTextSize;

@end

