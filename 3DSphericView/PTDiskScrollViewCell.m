
//
//  PTDiskScrollViewCell.m
//  3DSphericView
//
//  Created by CHEN KAIDI on 19/4/2016.
//  Copyright © 2016 Putao. All rights reserved.
//

#import "PTDiskScrollViewCell.h"

@implementation PTDiskScrollViewCell

-(instancetype)init{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.imageView];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
}

-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

@end
