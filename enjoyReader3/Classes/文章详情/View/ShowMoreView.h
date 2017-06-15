//
//  ShowMoreView.h
//  enjoyReader3
//
//  Created by WangXy on 2016/9/29.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowMoreView : UIView
@property (strong, nonatomic) IBOutlet UIView *toolView;
@property (strong, nonatomic) IBOutlet UIView *nightView;
@property (strong, nonatomic) IBOutlet UILabel *nightLabel;

@property (strong, nonatomic) IBOutlet UISwitch *nightSwitch;

@property (strong, nonatomic) IBOutlet UIView *SeeAuthorView;
@property (strong, nonatomic) IBOutlet UILabel *seeAuthorLabel;

@property (strong, nonatomic) IBOutlet UIView *followAuthorView;
@property (strong, nonatomic) IBOutlet UILabel *followAuthorLabel;

@property (strong, nonatomic) IBOutlet UIView *jubaoView;
@property (strong, nonatomic) IBOutlet UILabel *jubaoLabel;
@end
