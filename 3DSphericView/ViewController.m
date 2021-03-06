//
//  ViewController.m
//  3DSphericView
//
//  Created by CHEN KAIDI on 15/4/2016.
//  Copyright © 2016 Putao. All rights reserved.
//

#import "ViewController.h"
#import "PTDiskScrollView.h"
#import <StoreKit/StoreKit.h>
#import <math.h>

@interface ViewController () <PTDiskScrollViewDelegate, SKStoreProductViewControllerDelegate>
@property (nonatomic, strong) PTDiskScrollView *diskView;
//@property (nonatomic, assign) CGPoint previousPoint;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self performSelector:@selector(launchDiskView) withObject:nil afterDelay:0.3];

}

-(void)launchDiskView{
    self.diskView.center = self.view.center;
    [self.view addSubview:self.diskView];
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    self.diskView.frame = CGRectMake(0, 0, self.view.bounds.size.height, self.view.bounds.size.width);
    [self.diskView resetPosition];
}

//-(void)changeOvalSize{
//    self.diskView.ovalSize = CGSizeMake(arc4random()%400+100, arc4random()%400+100);
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PTDiskScrollViewDelegate
-(NSInteger)numberOfItemsInScrollView:(PTDiskScrollView *)scrollView{
    return 7;
}

-(CGSize)sizeForItemInScrollView:(PTDiskScrollView *)scrollView{
    return CGSizeMake(100, 100);
}

-(PTDiskScrollViewCell *)scrollView:(PTDiskScrollView *)scrollView cellForIndex:(NSInteger)index{
    PTDiskScrollViewCell *cell = [[PTDiskScrollViewCell alloc] init];
    cell.imageView.image = [UIImage imageNamed:@"putao"];
    return cell;
}

-(void)scrollView:(PTDiskScrollView *)scrollView didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"PTDiskScrollView did select index:%ld",(long)index);
    [self showMyApps];
}

-(void)scrollViewDidBeginScrolling:(PTDiskScrollView *)scrollView{
    NSLog(@"PTDiskScrollView did begin scrolling");
}

-(void)scrollViewDidEndScrolling:(PTDiskScrollView *)scrollView{
     NSLog(@"PTDiskScrollView did end scrolling");
}

-(void)showMyApps
{
    SKStoreProductViewController* spvc = [[SKStoreProductViewController alloc] init];
    [spvc loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier : @"1071377582"}
                    completionBlock:^(BOOL result, NSError *error)  {
                        if (result) {
                            //show
                            
                        }else {
                            NSLog(@"ERROR WITH STORE CONTROLLER %@\n", error.description);
                            //redirect to app store
                            //[[UIApplication sharedApplication] openURL:[[self class] appStoreURL]];
                        }
                    }];
    spvc.delegate = self;
    [self presentViewController:spvc animated:YES completion:nil];
    
}

-(void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Getters/Setters
-(PTDiskScrollView *)diskView{
    if (!_diskView) {
        _diskView = [[PTDiskScrollView alloc] initWithFrame:self.view.bounds ovalSize:CGSizeMake(600, 200)];
        _diskView.delegate = self;
    }
    return _diskView;
}


@end
