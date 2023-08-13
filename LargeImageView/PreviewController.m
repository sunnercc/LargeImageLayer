//
//  PreviewController.m
//  LargeImageView
//
//  Created by sunner on 2023/8/13.
//

#import "PreviewController.h"
#import "LargeImageLayer.h"

@interface PreviewController () <UIScrollViewDelegate>
@property (nonatomic, weak) UIImageView *largeImageView;
@end

@implementation PreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 100, 375, 375)];
    scrollView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:scrollView];
    scrollView.contentSize = CGSizeMake(10000, 10000);
    scrollView.delegate = self;
    scrollView.minimumZoomScale = 0.01;
    scrollView.maximumZoomScale = 10;
    
    UIImageView *largeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 9054, 5945)];
    largeImageView.backgroundColor = [UIColor redColor];
    [scrollView addSubview:largeImageView];
    self.largeImageView = largeImageView;
    
    
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"pic" ofType:@"bundle"];
    NSBundle *picBundle = [NSBundle bundleWithPath:bundlePath];
    NSString *largeImagePath = [picBundle pathForResource:@"map" ofType:@"jpg"];
    
    NSURL *url = [NSURL URLWithString:largeImagePath];
    
//    [LMImageDecoder decodeWithURL:url];
    
    LargeImageLayer *layer = [LargeImageLayer layerWithLargeImage:[UIImage imageWithContentsOfFile:largeImagePath]];
    
    [self.largeImageView.layer addSublayer:layer];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.largeImageView;
}

@end
