//
//  PTCircularScrollView.m
//  3DSphericView
//
//  Created by CHEN KAIDI on 15/4/2016.
//  Copyright © 2016 Putao. All rights reserved.
//

#import "PTDiskScrollView.h"
#import <math.h>

@interface PTDiskScrollView (){
    NSInteger numberOfViews;
    CGFloat angleStep;
    CGFloat directionalAngleStep;
    CGFloat changingDelta;
    CGPoint currentPoint;
    CGPoint previousPoint;
    
    NSInteger selectedIndex;
    NSMutableArray *angleDeltaArray;
}
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSMutableArray *viewArray;
@property (nonatomic, assign) CGFloat ovalRadiusA; //椭圆长轴
@property (nonatomic, assign) CGFloat ovalRadiusB; //椭圆短轴
@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, assign) CGFloat itemHeight;
@end

@implementation PTDiskScrollView

-(instancetype)initWithFrame:(CGRect)frame ovalSize:(CGSize)ovalSize{
    self = [super initWithFrame:frame];
    if (self) {
        
        // set Gesture
        UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftWithGesture:)];
        swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
        UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRightWithGesture:)];
        swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:swipeLeft];
        [self addGestureRecognizer:swipeRight];
        self.ovalRadiusA = ovalSize.width/2;
        self.ovalRadiusB = ovalSize.height/2;
        
        
        
    }
    return self;
}

-(void)setDelegate:(id<PTDiskScrollViewDelegate>)delegate{
    _delegate = delegate;
    [self reloadData];
}

-(void)reloadData {
    
    angleDeltaArray = [[NSMutableArray alloc] init];
    [self.viewArray removeAllObjects];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (self.delegate && [self.delegate respondsToSelector:@selector(numberOfItemsInScrollView:)]) {
        numberOfViews = [self.delegate numberOfItemsInScrollView:self];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(sizeForItemInScrollView:)]) {
        CGSize itemSize = [self.delegate sizeForItemInScrollView:self];
        self.itemWidth = itemSize.width;
        self.itemHeight = itemSize.height;
    }

    angleStep = (CGFloat)360/(CGFloat)numberOfViews;

    for (NSInteger index = 0 ; index < numberOfViews; index++) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(scrollView:cellForIndex:)]) {
            PTDiskScrollViewCell *cell = [self.delegate scrollView:self cellForIndex:index];
            cell.frame = CGRectMake(0, 0, _itemWidth, _itemHeight);
            [self addSubview:cell];
            [cell addTarget:self action:@selector(didSelectItem:) forControlEvents:UIControlEventTouchUpInside];
            cell.tag = index;
            [angleDeltaArray addObject:[NSNumber numberWithFloat:(index*angleStep + 90)]];
            [self.viewArray addObject:cell];
        }
    }
    
    [self updateScrollViewWithDelta:0];

}

-(void)didSelectItem:(UIControl *)item{
   //NSLog(@"Did select at index: %ld",(long)item.tag);
    NSInteger tappedIndex = item.tag;

    angleStep = [[angleDeltaArray objectAtIndex:tappedIndex] floatValue]-90;
    //NSLog(@"Angle Step:%f",angleStep);
    if (angleStep>180) {
        angleStep = -(360-angleStep);
        //NSLog(@"Turn right");
    }else{
        //NSLog(@"Turn left");
    }
    
     directionalAngleStep = angleStep;
    if (angleStep == 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(scrollView:didSelectItemAtIndex:)]) {
            [self.delegate scrollView:self didSelectItemAtIndex:tappedIndex];
        }
    }else{
        [self fireAnimation];
    }
    
  
}


-(void)swipeLeftWithGesture:(UIGestureRecognizer *)gesture{
    //NSLog(@"Swipe left !");
    directionalAngleStep = -angleStep;
    [self fireAnimation];
}

-(void)swipeRightWithGesture:(UIGestureRecognizer *)gesture{
   // NSLog(@"Swipe right !");
    directionalAngleStep = angleStep;
    [self fireAnimation];
}

-(void)fireAnimation{
    if (self.timer) {
        return;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(rotateDisk) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:UITrackingRunLoopMode];
    [self.timer fire];
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollViewDidBeginScrolling:)]) {
        [self.delegate scrollViewDidBeginScrolling:self];
    }
}

-(void)rotateDisk{
    if (directionalAngleStep>0) {
        if (changingDelta < directionalAngleStep) {
            changingDelta+=2;
            [self updateScrollViewWithDelta:changingDelta];
        }else{
            changingDelta = directionalAngleStep;
            angleStep = (CGFloat)360/(CGFloat)numberOfViews;
            [self.timer invalidate];
            self.timer = nil;
            [self updateScrollViewWithDelta:changingDelta];
            [self updateAngleDeltaArray];
            changingDelta = 0;
            if (self.delegate && [self.delegate respondsToSelector:@selector(scrollViewDidEndScrolling:)]) {
                [self.delegate scrollViewDidEndScrolling:self];
            }
        }
    }else{
        if (changingDelta > directionalAngleStep) {
            changingDelta-=2;
            [self updateScrollViewWithDelta:changingDelta];
        }else{
            changingDelta = directionalAngleStep;
            angleStep = (CGFloat)360/(CGFloat)numberOfViews;
            [self.timer invalidate];
            self.timer = nil;
            [self updateScrollViewWithDelta:changingDelta];
            [self updateAngleDeltaArray];
            changingDelta = 0;
            if (self.delegate && [self.delegate respondsToSelector:@selector(scrollViewDidEndScrolling:)]) {
                [self.delegate scrollViewDidEndScrolling:self];
            }
        }

    }
    
}


-(void)updateScrollViewWithDelta:(CGFloat)delta{
    
    //计算伪景深的透视形变
    for(NSInteger index = 0 ; index < angleDeltaArray.count; index++){
        UILabel* view = _viewArray[index];
        
        // transform
        NSInteger deltaNew = [angleDeltaArray[index] integerValue] - delta;
        
        CGFloat x = self.ovalRadiusA * cos(deltaNew*M_PI/180) + self.bounds.size.width/2;
        CGFloat y = self.ovalRadiusB * sin(deltaNew*M_PI/180) + self.bounds.size.height/2;
        view.center = CGPointMake(x, y);
        
        // scale
        CGFloat ratio = (y)/((self.ovalRadiusB*2))/2;
        view.transform = CGAffineTransformMakeScale(ratio, ratio);
    }
    
    // z-index
    //重新排列视图Hierarchy, 模仿3D效果
    NSArray *sortedArray;
    sortedArray = [self.viewArray sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        CGFloat yA = [(UIView *)a center].y;
        CGFloat yB = [(UIView *)b center].y;
        return yA > yB;
    }];

    for(UILabel *view in sortedArray){
        [self bringSubviewToFront:view];
    }
    
    //[self logItemInfo];
}

-(void)updateAngleDeltaArray{
    // pan -> velocity -> toogle, 所有位移结束，
    // 更新angleDelta数组，为下一次pan -> velocity -> toogle做准备
    for (NSInteger index = 0 ; index < angleDeltaArray.count; index++) {
        CGFloat angle = [angleDeltaArray[index] floatValue];
        
        CGFloat deltaNew = angle - directionalAngleStep;
        
        if (deltaNew > 360+90) {
            deltaNew -= 360;
        }else if (deltaNew < 90){
            deltaNew += 360;
        }
        angleDeltaArray[index] = [NSNumber numberWithFloat:deltaNew];
       // NSLog(@"delta Array[%ld]: %f",(long)index,deltaNew);
    }
    int index = 0;
    selectedIndex = 0;
    CGFloat yMax = 0;
    for (UILabel* item in _viewArray){
       // NSInteger angle = [[angleDeltaArray objectAtIndex:index] integerValue];
       // NSLog(@"angle=%ld, index=%d, x=%f, y=%f", (long)angle, index, item.center.x, item.center.y);
        if(item.center.y > yMax){
            yMax = item.center.y;
            selectedIndex = index;
        }
        index++;
    }
    
    //NSLog(@"selectIndex = %ld\n", (long)selectedIndex);
}

#pragma mark -- getter/setter

-(NSMutableArray *)viewArray{
    if (!_viewArray) {
        _viewArray = [[NSMutableArray alloc] init];
    }
    return _viewArray;
}

@end
