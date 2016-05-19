//
//  UIBezierPath+XFBezierPath.h
//  RadarChart
//
//  Created by yinxiangfu on 16/5/16.
//  Copyright © 2016年 xiangfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBezierPath (XFBezierPath)

+ (CGPathRef)drawPentagonWithCenter:(CGPoint)center Length:(double)length;

+ (CGPathRef)drawPentagonWithCenter:(CGPoint)center LengthArray:(NSArray *)lengths;

+ (NSArray *)converCoordinateFromLength:(NSArray *)lengthArray Center:(CGPoint)center;

@end
