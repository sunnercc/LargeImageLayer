//
//  LargeImageLayer.m
//  LargeImageView
//
//  Created by sunner on 2023/8/13.
//

#import "LargeImageLayer.h"

// 限制内存波动 500 * 500 * 4 = 1M
static size_t block_size = 500;

@implementation LargeImageLayer

+ (instancetype)layerWithLargeImage:(UIImage *)largeImage {
    return [[self alloc] initWithLargeImage:largeImage];
}

- (instancetype)initWithLargeImage:(UIImage *)largeImage {
    if (self = [super init]) {
        [self decodeLargeImage:largeImage];
        size_t w = CGImageGetWidth(largeImage.CGImage);
        size_t h = CGImageGetHeight(largeImage.CGImage);
        self.frame = CGRectMake(0, 0, w, h);
    }
    return self;
}

- (void)decodeLargeImage:(UIImage *)largeImage {
    for (CALayer *subLayer in self.sublayers) {
        [subLayer removeFromSuperlayer];
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        CGImageRef originImageRef = largeImage.CGImage;
        size_t originWidth = CGImageGetWidth(originImageRef);
        size_t originHeight = CGImageGetHeight(originImageRef);
        size_t originBitsPerComponent = CGImageGetBitsPerComponent(originImageRef);
        CGColorSpaceRef originSpace = CGImageGetColorSpace(originImageRef);
        CGBitmapInfo originBitmapInfo = CGImageGetBitmapInfo(originImageRef);
        
        size_t rows = (originWidth / block_size) + (originWidth % block_size > 0 ? 1 : 0);
        size_t cols = (originHeight / block_size) + (originHeight % block_size > 0 ? 1 : 0);
        
        for (size_t col = 0; col < cols; col++) {
            for (size_t row = 0; row < rows; row++) {
                //
                CGFloat x = row * block_size;
                CGFloat y = col * block_size;
                CGFloat w = (originWidth - x) <= block_size ? (originWidth - x) : block_size;
                CGFloat h = (originHeight - y) <= block_size ? (originHeight - y) : block_size;
                
                CGImageRef blockImageRef = CGImageCreateWithImageInRect(originImageRef, CGRectMake(x, y, w, h));
                CGContextRef blockBitmapContext = CGBitmapContextCreate(NULL, w, h, originBitsPerComponent, 0, originSpace, originBitmapInfo);
                
                if (blockBitmapContext == NULL) continue;
                
                CGContextDrawImage(blockBitmapContext, CGRectMake(0, 0, w, h), blockImageRef);
                CGImageRef bitmapImageRef = CGBitmapContextCreateImage(blockBitmapContext);
                
                CGImageRelease(blockImageRef);
                CGContextRelease(blockBitmapContext);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    CALayer *subLayer = [CALayer layer];
                    subLayer.frame = CGRectMake(x, y, w, h);
                    subLayer.contents = (__bridge id _Nullable)(bitmapImageRef);
                    [self addSublayer:subLayer];
                    CGImageRelease(bitmapImageRef);
                });
            }
        }
    });
}



@end
