//
//  serializeView.h
//  enjoyReader3
//
//  Created by WangXy on 16/9/18.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface serializeView : UIView
@property (strong, nonatomic) IBOutlet UIView *line1;
@property (strong, nonatomic) IBOutlet UIView *view1;
@property (strong, nonatomic) IBOutlet UIView *view2;
@property (strong, nonatomic) IBOutlet UIView *line2;
@property (strong, nonatomic) IBOutlet UIScrollView *serializeScroll;//scrollView
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *viewWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *secondViewLeading;//第二个view距离superview左边距的距离
@property (strong, nonatomic) IBOutlet UIImageView *coverImage;//封面
@property (strong, nonatomic) IBOutlet UILabel *coverLabel;

@property (strong, nonatomic) IBOutlet UITextField *worksNameField;//作品名称
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@property (strong, nonatomic) IBOutlet UITextView *introduceTextView;//简介
@property (strong, nonatomic) IBOutlet UILabel *introduceLabel;

@property (strong, nonatomic) IBOutlet UILabel *mostNumLabel;
@property (strong, nonatomic) IBOutlet UIButton *view1DoneBtn;//第一个页面的确定

@property (strong, nonatomic) IBOutlet UITableView *havenTableView;//已有的表单

@property (strong, nonatomic) IBOutlet UIButton *view2DoneBtn;//view2确定菜单


@end
