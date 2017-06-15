//
//  E_ReaderViewController.m
//  E_Reader
//
//  Created by 王馨仪 on 16/5/23.
//  Copyright © 2016年 王馨仪. All rights reserved.
//

#import "ReaderViewController.h"
#import "ReaderView.h"
#import "CommonManager.h"

#define MAX_FONT_SIZE 27
#define MIN_FONT_SIZE 17

@interface ReaderViewController ()<E_ReaderViewDelegate>
{
    ReaderView *_readerView;
}

@end

@implementation ReaderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//  文章内容坐标
    _readerView = [[ReaderView alloc] initWithFrame:CGRectMake(offSet_x, offSet_y+10, self.view.frame.size.width - 2 * offSet_x, self.view.frame.size.height - offSet_y*2 )];
    _readerView.keyWord = _keyWord;
    _readerView.magnifiterImage = _themeBgImage;
    _readerView.delegate = self;
    [self.view addSubview:_readerView];
    
}

#pragma mark - ReaderViewDelegate
- (void)shutOffGesture:(BOOL)yesOrNo{
    
    [_delegate shutOffPageViewControllerGesture:yesOrNo];
    
}

- (void)ciBa:(NSString *)ciBaString{

    [_delegate ciBaWithString:ciBaString];
}

- (void)hideSettingToolBar{
    [_delegate hideTheSettingBar];
}

- (void)setFont:(NSUInteger )font_
{
    _readerView.font = font_;
}

- (void)setText:(NSString *)text
{
    _text = text;
    _readerView.text = text;
   
    [_readerView render];
}

- (NSUInteger )font
{
    return _readerView.font;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//每页阅读界面的尺寸
- (CGSize)readerTextSize
{
    return _readerView.bounds.size;
}
@end
