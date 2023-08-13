//
//  LargeImageLayer.h
//  LargeImageView
//
//  Created by sunner on 2023/8/13.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LargeImageLayer : CALayer

- (instancetype)initWithLargeImage:(UIImage *)largeImage;

+ (instancetype)layerWithLargeImage:(UIImage *)largeImage;

@end

NS_ASSUME_NONNULL_END
