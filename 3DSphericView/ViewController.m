//
//  ViewController.m
//  3DSphericView
//
//  Created by CHEN KAIDI on 15/4/2016.
//  Copyright © 2016 Putao. All rights reserved.
//

#import "ViewController.h"
#import "PTDiskScrollView.h"
#import <math.h>

@interface ViewController () <PTDiskScrollViewDelegate>
@property (nonatomic, strong) PTDiskScrollView *diskView;
//@property (nonatomic, assign) CGPoint previousPoint;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.diskView.center = self.view.center;
    [self.view addSubview:self.diskView];
 
}

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
}

-(void)scrollViewDidBeginScrolling:(PTDiskScrollView *)scrollView{
    NSLog(@"PTDiskScrollView did begin scrolling");
}

-(void)scrollViewDidEndScrolling:(PTDiskScrollView *)scrollView{
     NSLog(@"PTDiskScrollView did end scrolling");
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
