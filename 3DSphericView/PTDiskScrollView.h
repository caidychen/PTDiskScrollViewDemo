//
//  PTCircularScrollView.h
//  3DSphericView
//
//  Created by CHEN KAIDI on 15/4/2016.
//  Copyright © 2016 Putao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTDiskScrollViewCell.h"

@protocol PTDiskScrollViewDelegate;

@interface PTDiskScrollView : UIView
@property (nonatomic, weak) id<PTDiskScrollViewDelegate>delegate;
@property (nonatomic, assign) CGSize ovalSize;                          // RadiusA = OvalSize.width/2, RadiusB = OvalSize.height/2
-(instancetype)initWithFrame:(CGRect)frame ovalSize:(CGSize)ovalSize;
-(void)reloadData;                                                      // Refresh data and redraw everything
@end

@protocol PTDiskScrollViewDelegate <NSObject>

@required
-(NSInteger)numberOfItemsInScrollView:(PTDiskScrollView *)scrollView;
-(CGSize)sizeForItemInScrollView:(PTDiskScrollView *)scrollView;
-(PTDiskScrollViewCell *)scrollView:(PTDiskScrollView *)scrollView cellForIndex:(NSInteger)index;

@optional
-(void)scrollViewDidBeginScrolling:(PTDiskScrollView *)scrollView;
-(void)scrollViewDidEndScrolling:(PTDiskScrollView *)scrollView;
-(void)scrollView:(PTDiskScrollView *)scrollView didSelectItemAtIndex:(NSInteger)index;

@end