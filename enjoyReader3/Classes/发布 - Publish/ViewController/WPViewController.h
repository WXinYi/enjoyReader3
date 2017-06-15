#import <UIKit/UIKit.h>
#import "WPEditorViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "publishedArticleViewModel.h"
#import "WPEditorConfiguration.h"
#import <Foundation/Foundation.h>

@interface WPViewController : WPEditorViewController <WPEditorViewControllerDelegate,UIActionSheetDelegate>
@property(nonatomic,retain)publishedArticleViewModel *viewModel;

@property (nonatomic,strong) NSString *contentText;
@property (nonatomic,strong) NSString *nameText;
@property (nonatomic,strong) NSString *md5Str;
@property (nonatomic,strong) NSString *createString;

@end
