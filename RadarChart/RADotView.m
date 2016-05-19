//
//  RADotView.m
//  RadarChart
//
//  Created by yinxiangfu on 16/5/16.
//  Copyright © 2016年 xiangfu. All rights reserved.
//

#import "RADotView.h"

@implementation RADotView

- (void)setDotColor:(UIColor *)dotColor
{
    self.backgroundColor = dotColor;
    
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    self.layer.cornerRadius = CGRectGetWidth(bounds)/2;
    self.layer.masksToBounds = NO;
    
    CAShapeLayer *centerLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(bounds.size.width/2, bounds.size.height/2) radius:CGRectGetWidth(bounds)/4 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    centerLayer.path = path.CGPath;
    centerLayer.fillColor = self.backgroundColor.CGColor;
    centerLayer.strokeColor = nil;
    [self.layer addSublayer:centerLayer];
    
    self.backgroundColor = [UIColor whiteColor];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
