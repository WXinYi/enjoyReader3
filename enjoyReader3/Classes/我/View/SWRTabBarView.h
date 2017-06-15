//
//  SWRTabBarView.h
//  JianshuMyPage
//
//  Created by Weiran Shi on 2015-12-10.
//  Copyright © 2015 Vera Shi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SWRTabBarViewDelegate <NSObject>

- (void)menuHeaderButtonClicked:(UIButton *)button;

@end
@interface SWRTabBarView : UIView

// [NSSting: BOOL] -> [title: selected]
@property (nonatomic, strong) NSArray *buttonArr;
@property (nonatomic, assign) id<SWRTabBarViewDelegate> delegate;

- (void)shiftWhenScroll:(UIScrollView *)scrollView headerViewHeight:(CGFloat)headerViewHeight initialPositionY:(CGFloat)initialPositionY;

@end
