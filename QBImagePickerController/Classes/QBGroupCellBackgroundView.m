//
//  GroupCellBackgroundView.m
//  QDMail
//
//  Created by Wenzhe Zhou on 14-3-1.
//  Copyright (c) 2014年 QiDuo Tech Inc. All rights reserved.
//

#import "QBGroupCellBackgroundView.h"

#define offset 15.f

@interface QBGroupCellBackgroundView()

@property (nonatomic, strong) UIView *lightBlueView;

@end

@implementation QBGroupCellBackgroundView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
            _lightBlueView = [[UIView alloc] init];
            _lightBlueView.backgroundColor = [UIColor colorWithRed:72.f/255.f green:169.f/255.f blue:236.f/255.f alpha:1.f];
            [self addSubview:_lightBlueView];
        } else {
            self.backgroundColor = [UIColor colorWithRed:72.f/255.f green:169.f/255.f blue:236.f/255.f alpha:1.f];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        CGRect bounds = self.bounds;
        bounds.origin.x += offset;
        bounds.size.width -= offset;
        
        self.lightBlueView.frame = bounds;
    }
}

@end
