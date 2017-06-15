#import "WPViewController.h"

@import Photos;
@import AVFoundation;
@import MobileCoreServices;
#import "WPEditorField.h"
#import "WPEditorView.h"
#import "WPImageMetaViewController.h"
#import "imageSelectController.h"
#import "LNNotificationsUI.h"
#import "UICustomActionSheet.h"
#import "LXAlertView.h"
#import "draftSingle.h"
#import "FileOperation.h"
@interface WPViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, WPImageMetaViewControllerDelegate,UICustomActionSheetDelegate>
@property(nonatomic, strong) NSMutableDictionary *mediaAdded;
@property(nonatomic, strong) NSString *selectedMediaID;
@property(nonatomic, strong) NSCache *videoPressCache;
@property(retain,nonatomic)UIPopoverController *popoverController;
@property(retain,nonatomic)NSTimer * saveTimer;
@end

@implementation WPViewController
{
    UILabel *titleLable;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    WPEditorConfiguration *_WPEditorConfiguration = [WPEditorConfiguration sharedWPEditorConfiguration];
    
//创建草稿文件夹
    [[draftSingle shareInstance] creatDraftFile];
    
// kLMDefaultLanguage  @"en-US"
// kLMChinese          @"zh-Hans"
// kLMChineseTW         @"zh-TW"
// kLMChineseHK         @"zh-HK"
// kLMChineseT         @"zh-Hant"
    
    _WPEditorConfiguration.localizable = kLMChineseTW;
    
    _WPEditorConfiguration.enableImageSelect =   ZSSRichTextEditorImageSelectPhotoLibrary |ZSSRichTextEditorImageSelectTakePhoto;
    
    self.delegate = self;
    
    self.itemTintColor = [UIColor blackColor];
    
    [self initView];
    
    [[LNNotificationCenter defaultCenter] registerApplicationWithIdentifier:@"com.ougohome.softDecorationMaster" name:@"Roc.Tian" icon:nil];
    
    self.mediaAdded = [NSMutableDictionary dictionary];
    self.videoPressCache = [[NSCache alloc] init];
    
    _viewModel = [publishedArticleViewModel new];
    _viewModel.article_id = [[NSUUID UUID] UUIDString];
    _viewModel.userId = [[NSUUID UUID] UUIDString];
    _viewModel.createTime = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000];
    
}

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [self setNil];
    if (_saveTimer) {
        [_saveTimer invalidate];
    }
    
}

-(void)initView{
    //自定义导航栏
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    
    //    navView.backgroundColor =THEMECOLOR;
    navView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    titleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, 37)];
    titleLable.text= NSLocalizedString(@"publishedArticle", @"创建文章");
    titleLable.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:17];
    titleLable.dk_textColorPicker = DKColorPickerWithKey(TXTONE);
    
    titleLable.textAlignment = 1 ;
    
    [navView addSubview:titleLable];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 25, 30, 30)];
    
    [backButton setImage:[UIImage imageNamed:@"public_back"] forState:UIControlStateNormal];
    
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [navView addSubview:backButton];
    
    UIButton *publishBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-60 , 30, 40, 20)];

    [publishBtn setTitle:NSLocalizedString(@"published", @"发表") forState:0];
    [publishBtn dk_setTitleColorPicker:DKColorPickerWithKey(TXTONE) forState:UIControlStateNormal];
    [publishBtn addTarget:self action:@selector(publishedAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [navView addSubview:publishBtn];
    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(BBG);
    [self.view addSubview:navView];
    
    
    self.bodyPlaceholderText = NSLocalizedString(@"pleaseInputMessage",@"写点什么吧");
    self.titlePlaceholderText = NSLocalizedString(@"pleaseInputTitle",@"请输入标题");
   
}
#pragma mark ----------------返回按钮----------------
-(void)backAction:(UIButton *)back{

    [self.view endEditing:YES];

    if(_viewModel.content.length > 0 || _viewModel.title.length > 0){

        UICustomActionSheet* actionSheet = [[UICustomActionSheet alloc] initWithTitle:nil delegate:self buttonTitles:@[@"取消",@"保存草稿",@"放弃草稿"]];
        
        [actionSheet setButtonColors:@[[UIColor lightGrayColor],[UIColor lightGrayColor],[UIColor lightGrayColor]]];
        [actionSheet setBackgroundColor:[UIColor clearColor]];
        

        
        [actionSheet showInView:self.view];

    }else{
    
        [self backToRootViewController];
    
    }
    


}
- (void)backToRootViewController
{
    
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"backFromWP" object:nil userInfo:nil];

    }];
}
#pragma  mark  UICustomActionSheetDelegate
-(void)customActionSheet:(UICustomActionSheet *)customActionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
        //取消
        [customActionSheet hideAlert];
        
    }else if (buttonIndex == 1){
    
        
        NSString *txt;
        //标题为文件名
        if (self.viewModel.title.length <= 0) {
            LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"提示" message:@"您还没有输入标题\n快给您的文章起个名字吧" cancelBtnTitle:nil otherBtnTitle:@"我知道了" clickIndexBlock:^(NSInteger clickIndex) {
                
            }];
            [alert showLXAlertView];
        }else{
            txt = self.viewModel.title;
            
            if (self.md5Str.length>0) {
                //更新草稿
                [[draftSingle shareInstance] updataDraftContentWithmd5Str:self.md5Str WithTitleName:txt withcontent:self.viewModel.content];
                
            }else{
                //保存草稿
                [[draftSingle shareInstance] saveDraftContentWithTitleName:txt withcontent:self.viewModel.content];
            
            }
            
            [self dismissViewControllerAnimated:YES completion:^(){
                
                [self setNil];
                
            }];

        }
           }else{
               
               if (self.viewModel.title.length>0||self.viewModel.content.length>0) {
                   
                   
                   LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"提示" message:@"真的要抛弃草稿吗" cancelBtnTitle:@"抛弃" otherBtnTitle:@"不抛弃" clickIndexBlock:^(NSInteger clickIndex) {
                       
                       if (clickIndex == 0) {
                           if (self.md5Str.length>0) {
                               //有草稿
                               [[draftSingle shareInstance] deleteDraftWithMd5:self.md5Str];
                               
                           }
                           
                           [self backToRootViewController];
                           
                           [self dismissViewControllerAnimated:YES completion:^(){
                               
                               [self setNil];
                               
                           }];

                       }else{
                       

                       
                       }
                       
                       
                   }];
                   [alert showLXAlertView];
                   
                   
                   
               }
        
            }
}
-(void)publishedMethod{
    
   
}
#pragma mark -------------发布------------------
- (IBAction)publishedAction:(id)sender {
    
    [self.view endEditing:YES];
    
    if(_viewModel.title.length == 0){
        
        LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"提示" message:@"您还没有输入标题\n快给您的文章起个名字吧" cancelBtnTitle:nil otherBtnTitle:@"我知道了" clickIndexBlock:^(NSInteger clickIndex) {

        }];
//        alert.dontDissmiss=YES;
        //设置动画类型(默认是缩放)
        //_alert.animationStyle=LXASAnimationTopShake;
        [alert showLXAlertView];

        
        return;
    }
    
    
    
    if(_viewModel.content.length==0){
        
 
        LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"提示" message:@"您还没有输入内容\n快去写点什么再发表吧" cancelBtnTitle:nil otherBtnTitle:@"我知道了" clickIndexBlock:^(NSInteger clickIndex) {

            
        }];
        alert.dontDissmiss=NO;
        //设置动画类型(默认是缩放)
        alert.animationStyle=LXASAnimationTopShake;
        [alert showLXAlertView];

        
        return;
        
    }
    else{
        
        _viewModel.cover_image_url = [self.editorView getCoverImage];
        NSArray *allImage = [self.editorView getAllImage];
        
        NSLog(@"Image Count:%ld",allImage.count);
        
    }
    
}
#pragma mark - Navigation Bar

- (void)editTouchedUpInside
{
    if (self.isEditing) {
        [self stopEditing];
    } else {
        [self startEditing];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [self.editorView saveSelection];
    [super prepareForSegue:segue sender:sender];
}

#pragma mark - IBActions

- (IBAction)exit:(UIStoryboardSegue*)segue
{
}

#pragma mark - WPEditorViewController代理

- (void)editorDidBeginEditing:(WPEditorViewController *)editorController
{
    NSLog(@"开始编辑.");
}

- (void)editorDidEndEditing:(WPEditorViewController *)editorController
{
    NSLog(@"结束编辑.");
}

- (void)editorDidFinishLoadingDOM:(WPEditorViewController *)editorController
{
   
    _viewModel.content =self.contentText;
    _viewModel.title = self.nameText;
    [self setTitleText:_viewModel.title];
    [self setBodyText:_viewModel.content];
    if ([self.dk_manager.themeVersion isEqualToString:DKThemeVersionNight]) {
        
        NSString* bodybackgroundcolor = [NSString stringWithFormat:@"document.body.style.backgroundColor=\"#3f3f3f\";"];
        [self.editorView.webView stringByEvaluatingJavaScriptFromString:bodybackgroundcolor];
        
        NSString* bodycolor = [NSString stringWithFormat:@"document.zss_field_content.color=\"#b3b3b3\";"];
//        ZSSEditor.getField("zss_field_content").enableEditing();

        [self.editorView.webView stringByEvaluatingJavaScriptFromString:bodycolor];
        
    
    }else{
        NSString* bodybackgroundcolor = [NSString stringWithFormat:@"document.body.style.backgroundColor=\"#f7f8fa\";"];
        [self.editorView.webView stringByEvaluatingJavaScriptFromString:bodybackgroundcolor];
        
        //日间
        //        bobybackgroundcolor= [NSString stringWithFormat:@"background:#f7f8fa;color:#2c2c2c"];
        //        blockquotecolor = [NSString stringWithFormat:@"background-color: #edeef0;border-color: #bcbcbc"];
    }

    [self startEditing];

}

- (BOOL)editorShouldDisplaySourceView:(WPEditorViewController *)editorController
{
    [self.editorView pauseAllVideos];
    
    return YES;
    
}

- (void)editorDidPressMedia:(int)type
{
     NSLog(@"点击添加图片按钮!");
    
     [self selectImageType:type];
    
}

- (void)editorTitleDidChange:(WPEditorViewController *)editorController
{
    NSLog(@"标题改变: %@", self.titleText);
    
    _viewModel.title = self.titleText;
    
    [self initSaveTimer];
    
}

- (void)editorTextDidChange:(WPEditorViewController *)editorController
{
    
    NSLog(@"修改内容: %@", self.bodyText);
    
    
  
//     NSString* selection = [self.editorView.webView stringByEvaluatingJavaScriptFromString:["document.getElementById('zss_field_content').value.replace(/[^\x00-\xff]/g, "").length;"]];
//
    
    
    
    NSString *noHtmlContent = [self filterHTML:self.bodyText];
    
    NSLog(@"%lu",(unsigned long)noHtmlContent.length);
    titleLable.text = [NSString stringWithFormat:@"已输入%lu个字",(unsigned long)noHtmlContent.length];
    titleLable.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:12];

    _viewModel.content =  self.bodyText;
    
    [self initSaveTimer];
    
}

-(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
        
    }
        NSString * regEx = @"<([^>]*)>";

        html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
        NSString *strUrl = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];

    return strUrl;
}


-(void)initSaveTimer{

    if(!_saveTimer)
//        20秒自动保存一次
        _saveTimer = [NSTimer scheduledTimerWithTimeInterval:20
                                                      target:self
                                                    selector:@selector(autoSaveArticle:)
                                                    userInfo:nil
                                                     repeats:YES];
    
}

- (void)editorViewController:(WPEditorViewController *)editorViewController fieldCreated:(WPEditorField*)field{
    
    NSLog(@"编辑文件夹创建： %@", field.nodeId);
    
}

- (void)editorViewController:(WPEditorViewController*)editorViewController
                 imageTapped:(NSString *)imageId
                         url:(NSURL *)url
                   imageMeta:(WPImageMeta *)imageMeta
{
    if (imageId.length == 0) {
        
        [self showImageDetailsForImageMeta:imageMeta];
        
    } else {
        
        [self showPromptForImageWithID:imageId];
        
    }
}

- (void)editorViewController:(WPEditorViewController*)editorViewController
                 videoTapped:(NSString *)videoId
                         url:(NSURL *)url{
    
    [self showPromptForVideoWithID:videoId];
    
}

- (void)editorViewController:(WPEditorViewController *)editorViewController imageReplaced:(NSString *)imageId{
    
    [self.mediaAdded removeObjectForKey:imageId];
    
}

- (void)editorViewController:(WPEditorViewController *)editorViewController videoReplaced:(NSString *)videoId{
    
    [self.mediaAdded removeObjectForKey:videoId];
    
}

- (void)editorViewController:(WPEditorViewController *)editorViewController videoPressInfoRequest:(NSString *)videoID
{
    NSDictionary * videoPressInfo = [self.videoPressCache objectForKey:videoID];
    NSString * videoURL = videoPressInfo[@"source"];
    NSString * posterURL = videoPressInfo[@"poster"];
    if (videoURL) {
        [self.editorView setVideoPress:videoID source:videoURL poster:posterURL];
    }
}

- (void)editorViewController:(WPEditorViewController *)editorViewController mediaRemoved:(NSString *)mediaID
{
    NSProgress * progress = self.mediaAdded[mediaID];
    [progress cancel];
}

- (void)editorFormatBarStatusChanged:(WPEditorViewController *)editorController
                             enabled:(BOOL)isEnabled
{
    NSLog(@"辑器格式栏状态是现在是 %@.", (isEnabled ? @"可用" : @"不可用"));
}

#pragma mark - Media actions

- (void)showImageDetailsForImageMeta:(WPImageMeta *)imageMeta
{
    WPImageMetaViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"WPImageMetaViewController"];
    controller.imageMeta = imageMeta;
    controller.delegate = self;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    //111
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)showPromptForImageWithID:(NSString *)imageId
{
    if (imageId.length == 0){
        return;
    }
    
    __weak __typeof(self)weakSelf = self;
    UITraitCollection *traits = self.navigationController.traitCollection;
    NSProgress *progress = self.mediaAdded[imageId];
    UIAlertController *alertController;
    if (traits.userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        alertController = [UIAlertController alertControllerWithTitle:nil
                                                              message:nil
                                                       preferredStyle:UIAlertControllerStyleAlert];
    } else {
        alertController = [UIAlertController alertControllerWithTitle:nil
                                                              message:nil
                                                       preferredStyle:UIAlertControllerStyleActionSheet];
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *action){}];
    [alertController addAction:cancelAction];
    
    if (!progress.cancelled){
        UIAlertAction *stopAction = [UIAlertAction actionWithTitle:@"取消上传"
                                                             style:UIAlertActionStyleDestructive
                                                           handler:^(UIAlertAction *action){
                                                               [weakSelf.editorView removeImage:weakSelf.selectedMediaID];
                                                           }];
        [alertController addAction:stopAction];
        
    } else {
        UIAlertAction *removeAction = [UIAlertAction actionWithTitle:@"移除图片"
                                                               style:UIAlertActionStyleDestructive
                                                             handler:^(UIAlertAction *action){
                                                                 [weakSelf.editorView removeImage:weakSelf.selectedMediaID];
                                                             }];
        
        UIAlertAction *retryAction = [UIAlertAction actionWithTitle:@"重新上传"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction *action){
                                                                NSProgress * progress = [[NSProgress alloc] initWithParent:nil userInfo:@{@"imageID":self.selectedMediaID}];
                                                                progress.totalUnitCount = 100;
                                                                [NSTimer scheduledTimerWithTimeInterval:0.1
                                                                                                 target:self
                                                                                               selector:@selector(timerFireMethod:)
                                                                                               userInfo:progress
                                                                                                repeats:YES];
                                                                weakSelf.mediaAdded[weakSelf.selectedMediaID] = progress;
                                                                [weakSelf.editorView unmarkImageFailedUpload:weakSelf.selectedMediaID];
                                                            }];
        [alertController addAction:removeAction];
        [alertController addAction:retryAction];
    }
    //111
    self.selectedMediaID = imageId;
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)showPromptForVideoWithID:(NSString *)videoId
{
    if (videoId.length == 0){
        return;
    }
    __weak __typeof(self)weakSelf = self;
    UITraitCollection *traits = self.navigationController.traitCollection;
    NSProgress *progress = self.mediaAdded[videoId];
    UIAlertController *alertController;
    if (traits.userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        alertController = [UIAlertController alertControllerWithTitle:nil
                                                              message:nil
                                                       preferredStyle:UIAlertControllerStyleAlert];
    } else {
        alertController = [UIAlertController alertControllerWithTitle:nil
                                                              message:nil
                                                       preferredStyle:UIAlertControllerStyleActionSheet];
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *action){}];
    [alertController addAction:cancelAction];
    
    if (!progress.cancelled){
        UIAlertAction *stopAction = [UIAlertAction actionWithTitle:@"停止上传"
                                                             style:UIAlertActionStyleDestructive
                                                           handler:^(UIAlertAction *action){
                                                               [weakSelf.editorView removeVideo:weakSelf.selectedMediaID];
                                                           }];
        [alertController addAction:stopAction];
    } else {
        UIAlertAction *removeAction = [UIAlertAction actionWithTitle:@"移除视频"
                                                               style:UIAlertActionStyleDestructive
                                                             handler:^(UIAlertAction *action){
                                                                 [weakSelf.editorView removeVideo:weakSelf.selectedMediaID];
                                                             }];
        
        UIAlertAction *retryAction = [UIAlertAction actionWithTitle:@"重新上传"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction *action){
                                                                NSProgress * progress = [[NSProgress alloc] initWithParent:nil userInfo:@{@"videoID":weakSelf.selectedMediaID}];
                                                                progress.totalUnitCount = 100;
                                                                [NSTimer scheduledTimerWithTimeInterval:0.1
                                                                                                 target:self
                                                                                               selector:@selector(timerFireMethod:)
                                                                                               userInfo:progress
                                                                                                repeats:YES];
                                                                weakSelf.mediaAdded[self.selectedMediaID] = progress;
                                                                [weakSelf.editorView unmarkVideoFailedUpload:weakSelf.selectedMediaID];
                                                            }];
        [alertController addAction:removeAction];
        [alertController addAction:retryAction];
    }
    //111
    self.selectedMediaID = videoId;
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)showPhotoPicker
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.navigationBar.translucent = NO;
    picker.modalPresentationStyle = UIModalPresentationCurrentContext;
    picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
   //111
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)addImageAssetToContent:(PHAsset *)asset
{
    PHImageRequestOptions *options = [PHImageRequestOptions new];
    options.synchronous = NO;
    options.networkAccessAllowed = YES;
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    options.version = PHImageRequestOptionsVersionCurrent;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    NSString *imageID = [[NSUUID UUID] UUIDString];
    NSString *path = [NSString stringWithFormat:@"%@/%@.jpg", NSTemporaryDirectory(), imageID];
    [[PHImageManager defaultManager] requestImageDataForAsset:asset
                                                      options:options
                                                resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        [imageData writeToFile:path atomically:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.editorView insertLocalImage:[[NSURL fileURLWithPath:path] absoluteString] uniqueId:imageID];
            
            [self submitImage:imageData imageID:imageID];
        });
    }];

//    NSProgress *progress = [[NSProgress alloc] initWithParent:nil userInfo:@{ @"imageID": imageID,
//                                                                              @"url": path }];
//    progress.cancellable = YES;
//    progress.totalUnitCount = 100;
//    NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:0.1
//                                     target:self
//                                   selector:@selector(timerFireMethod:)
//                                   userInfo:progress
//                                    repeats:YES];
//    [progress setCancellationHandler:^{
//        [timer invalidate];
//    }];
//    self.mediaAdded[imageID] = progress;
}

- (void)addVideoAssetToContent:(PHAsset *)originalAsset
{
    PHImageRequestOptions *options = [PHImageRequestOptions new];
    options.synchronous = NO;
    options.networkAccessAllowed = YES;
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    options.version = PHImageRequestOptionsVersionCurrent;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    NSString *videoID = [[NSUUID UUID] UUIDString];
    NSString *videoPath = [NSString stringWithFormat:@"%@%@.mov", NSTemporaryDirectory(), videoID];
    [[PHImageManager defaultManager] requestImageForAsset:originalAsset
                                               targetSize:[UIScreen mainScreen].bounds.size
                                              contentMode:PHImageContentModeAspectFit
                                                  options:options
                                            resultHandler:^(UIImage *image, NSDictionary * _Nullable info) {
        NSData *data = UIImageJPEGRepresentation(image, 0.7);
        NSString *posterImagePath = [NSString stringWithFormat:@"%@/%@.jpg", NSTemporaryDirectory(), [[NSUUID UUID] UUIDString]];
        [data writeToFile:posterImagePath atomically:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.editorView insertInProgressVideoWithID:videoID
                                        usingPosterImage:[[NSURL fileURLWithPath:posterImagePath] absoluteString]];
        });
        PHVideoRequestOptions *videoOptions = [PHVideoRequestOptions new];
        videoOptions.networkAccessAllowed = YES;
        [[PHImageManager defaultManager] requestExportSessionForVideo:originalAsset
                                                              options:videoOptions
                                                         exportPreset:AVAssetExportPresetPassthrough
                                                        resultHandler:^(AVAssetExportSession * _Nullable exportSession, NSDictionary * _Nullable info) {
                                                            exportSession.outputFileType = (__bridge NSString*)kUTTypeQuickTimeMovie;
                                                            exportSession.shouldOptimizeForNetworkUse = YES;
                                                            exportSession.outputURL = [NSURL fileURLWithPath:videoPath];
                                                            [exportSession exportAsynchronouslyWithCompletionHandler:^{
                                                                if (exportSession.status != AVAssetExportSessionStatusCompleted) {
                                                                    return;
                                                                }
                                                                dispatch_async(dispatch_get_main_queue(), ^{
//                                                                    NSProgress *progress = [[NSProgress alloc] initWithParent:nil
//                                                                                                                     userInfo:@{@"videoID": videoID, @"url": videoPath, @"poster": posterImagePath }];
//                                                                    progress.cancellable = YES;
//                                                                    progress.totalUnitCount = 100;
//                                                                    [NSTimer scheduledTimerWithTimeInterval:0.1
//                                                                                                     target:self
//                                                                                                   selector:@selector(timerFireMethod:)
//                                                                                                   userInfo:progress
//                                                                                                    repeats:YES];
//                                                                    self.mediaAdded[videoID] = progress;
                                                                });
                                                            }];
            
        }];
    }];
}

- (void)addAssetToContent:(NSURL *)assetURL
{
    PHFetchResult *assets = [PHAsset fetchAssetsWithALAssetURLs:@[assetURL] options:nil];
    if (assets.count < 1) {
        return;
    }
    PHAsset *asset = [assets firstObject];
        
    if (asset.mediaType == PHAssetMediaTypeVideo) {
        [self addVideoAssetToContent:asset];
    } if (asset.mediaType == PHAssetMediaTypeImage) {
        [self addImageAssetToContent:asset];
    }
}

- (void)timerFireMethod:(NSTimer *)timer
{
    NSProgress *progress = (NSProgress *)timer.userInfo;
    progress.completedUnitCount++;
    NSString *imageID = progress.userInfo[@"imageID"];
    if (imageID) {
        [self.editorView setProgress:progress.fractionCompleted onImage:imageID];
        // Uncomment this code if you need to test a failed image upload
        //    if (progress.fractionCompleted >= 0.15){
        //        [progress cancel];
        //        [self.editorView markImage:imageID failedUploadWithMessage:@"Failed"];
        //        [timer invalidate];
        //    }
        if (progress.fractionCompleted >= 1) {
            [self.editorView replaceLocalImageWithRemoteImage:[[NSURL fileURLWithPath:progress.userInfo[@"url"]] absoluteString] uniqueId:imageID];
            [timer invalidate];
        }
        return;
    }

    NSString *videoID = progress.userInfo[@"videoID"];
    if (videoID) {
        [self.editorView setProgress:progress.fractionCompleted onVideo:videoID];
        // Uncomment this code if you need to test a failed video upload
//        if (progress.fractionCompleted >= 0.15) {
//            [progress cancel];
//            [self.editorView markVideo:videoID failedUploadWithMessage:@"Failed"];
//            [timer invalidate];
//        }
        if (progress.fractionCompleted >= 1) {
            NSString * videoURL = [[NSURL fileURLWithPath:progress.userInfo[@"url"]] absoluteString];
            NSString * posterURL = [[NSURL fileURLWithPath:progress.userInfo[@"poster"]] absoluteString];
            [self.editorView replaceLocalVideoWithID:videoID
                                      forRemoteVideo:videoURL
                                        remotePoster:posterURL
                                          videoPress:videoID];
            [self.videoPressCache setObject:@ {@"source":videoURL, @"poster":posterURL} forKey:videoID];
            [timer invalidate];
        }
        return;
    }
}

#pragma mark - UIImagePickerControllerDelegate methods

//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//    [self.navigationController dismissViewControllerAnimated:YES completion:^{
//        NSURL *assetURL = info[UIImagePickerControllerReferenceURL];
//        [self addAssetToContent:assetURL];
//    }];
//    
//}

#pragma mark - WPImageMetaViewControllerDelegate

- (void)imageMetaViewController:(WPImageMetaViewController *)controller didFinishEditingImageMeta:(WPImageMeta *)imageMeta
{
    [self.editorView updateCurrentImageMeta:imageMeta];
}


-(void)submitImage:(NSData *)imageData imageID:(NSString *)imageID{
    
    [self submitImageMethod:imageData imageID:imageID];
}



-(void)submitImageMethod:(NSData *)imageData imageID:(NSString *)imageID{
    
    NSData *data = [_viewModel.content dataUsingEncoding:NSNonLossyASCIIStringEncoding];
    NSString *goodValue = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"Text:%@",goodValue);
    
    
    NSDictionary *params = @{@"publishDesc":goodValue,@"mod":@"1",@"act":@"57"};
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:[@"http://api.ougohome.com/index.php/" stringByAppendingString:@"api/main"] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
        
        [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"pic%d",1] fileName:[NSString stringWithFormat:@"publish%d.jpg",1] mimeType:@"image/jpg"];
        
        
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSProgress *progress;
    
    
    NSURLSessionUploadTask *uploadTask;
//    uploadTask = [manager
//                  uploadTaskWithStreamedRequest:request
//                  progress:&progress
//                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//                      
//                      //                      dispatch_async(dispatch_get_main_queue(), ^{
//                      //                         [progress removeObserver:self forKeyPath:@"fractionCompleted"];
//                      //
//                      //                      });
//                      
//                      
//                      if (error) {
//                          NSLog(@"Error: %@", error);
//                          
//                          
//                      } else {
//                          NSLog(@"%@ %@", response, responseObject);
//                          
//                            [self.editorView replaceLocalImageWithRemoteImage:@"http://pic19.nipic.com/20120310/8061225_093309101000_2.jpg" uniqueId:imageID];
//                          
//                          NSString *path = [NSString stringWithFormat:@"%@/%@.jpg", NSTemporaryDirectory(), imageID];
//                          
//                          //    NSLog(@"url:%@",path);
//                          
//                          NSFileManager* fileManager = [NSFileManager defaultManager];
//                          
//                          if ([fileManager fileExistsAtPath:path])
//                          {
//                              [fileManager removeItemAtPath:path error:nil];
//                          }
//                          
//
//                          return;
//                      }
//                  }];
//    
//    [uploadTask resume];
    
    [progress setUserInfoObject:imageID forKey:@"imageID"];
    
    
    // 3. 监听NSProgress对象
    [progress addObserver:self
               forKeyPath:@"fractionCompleted"
                  options:NSKeyValueObservingOptionNew context:nil];
    
    self.mediaAdded[imageID] = progress;
}
// 监听处理方法
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    NSProgress *progress = nil;
    if ([object isKindOfClass:[NSProgress class]]) {
        progress = (NSProgress *)object;
    }
    if (progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"已经完成：%f", progress.fractionCompleted);
            NSString *imageID = progress.userInfo[@"imageID"];
            if (imageID) {
                
               [self.editorView setProgress:progress.fractionCompleted onImage:imageID];
                
            }
        });
    }
}

-(void)selectImageType:(int)buttonIndex{


    if (buttonIndex == 1) {
        //判断当前的设备照相是否可以用
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            
            return ;
            
        }
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            
            self.popoverController = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
            [self.popoverController presentPopoverFromRect:self.view.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            
        } else {
            
            [self presentViewController:imagePicker animated:YES completion:^(){}];

//            [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
            
        }
        
    }else if (buttonIndex == 0) {
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            
            self.popoverController = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
            [self.popoverController presentPopoverFromRect:self.view.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            
        } else {
            
            [self presentViewController:imagePicker animated:YES completion:^(){}];


        }
        
    }else if(buttonIndex == 2) {
        
        [self showInsertImageAlternatePicker];
        
        
    }

}
-(void)showInsertImageAlternatePicker{

      

}

#pragma mark - UIImagePickerControllerDelegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    
    
    [self dismissViewControllerAnimated:YES completion:^{
    
        
        NSURL *assetURL = info[UIImagePickerControllerReferenceURL];
        
        if (!assetURL) {
            
            UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
            [self addImageFromCamera:image];
        }
        
        else{
            
            
            [self addAssetToContent:assetURL];
        }
    
    }];
    
    
    
//    [picker dismissViewControllerAnimated:YES completion:^{
//        
//    }];
    
}
-(void)addImageFromCamera:(UIImage *)image{
    
    NSString *imageID = [[NSUUID UUID] UUIDString];
    NSString *path = [NSString stringWithFormat:@"%@/%@.jpg", NSTemporaryDirectory(), imageID];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    
    [imageData writeToFile:path atomically:YES];
    
    [self submitImage:imageData imageID:imageID];
    [self.editorView insertLocalImage:[[NSURL fileURLWithPath:path] absoluteString] uniqueId:imageID];
    
}
-(void)autoSaveArticle:(id)args{

    if(_viewModel.content.length>0 || _viewModel.title.length>0){
    
    
        
        NSDate *dateTime = [NSDate new];
        
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"HH:mm:ss"];
        
        LNNotification* notification = [LNNotification notificationWithMessage:@"Welcome to LNNotificationsUI!"];
        notification.title = [NSString stringWithFormat:@"%@ %@",[formatter stringFromDate:dateTime],NSLocalizedString(@"已保存至草稿箱", @"已保存至草稿箱")];
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        
        NSString *createPath = [NSString stringWithFormat:@"%@",[[draftSingle shareInstance] getDraftPath]];
        
        NSLog(@"%@已保存至草稿箱",[formatter stringFromDate:dateTime]);
        //标题为文件名
        NSString *txt =  [createPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt",self.viewModel.title]];
        
        [fileManager createFileAtPath:txt contents:[self.viewModel.content dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];

        [[LNNotificationCenter defaultCenter] presentNotification:notification forApplicationIdentifier:@"com.ougohome.softDecorationMaster"];
    
    }
    
}


-(void)setNil{

    self.delegate = nil;
    [self setBodyText:@""];
    [self setTitleText:@""];
    
    _popoverController.delegate = nil;
    
    _popoverController = nil;
    
    if(_saveTimer){
        
        [_saveTimer invalidate];
        _saveTimer = nil;
        
    }

}
@end
