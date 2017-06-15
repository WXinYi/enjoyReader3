//
//  CommentTextView.h
//  enjoyReader3
//
//  Created by 王馨仪 on 16/8/9.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTextView : UIView
@property (strong, nonatomic) IBOutlet UITextView *commentTextInputView;
@property (strong, nonatomic) IBOutlet UIButton *sendBtn;
@property (strong, nonatomic) IBOutlet UIView *lineView;

@end
