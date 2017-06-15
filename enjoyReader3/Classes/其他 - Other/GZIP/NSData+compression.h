#import <Foundation/NSData.h>

@interface NSData (Compression)

- (NSData *)zlibInflate;//压缩
- (NSData *)zlibDeflate;//解压

@end
