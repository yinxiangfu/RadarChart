//
//  ViewController.m
//  RadarChart
//
//  Created by yinxiangfu on 16/5/16.
//  Copyright © 2016年 xiangfu. All rights reserved.
//

#import "ViewController.h"
#import "UIBezierPath+XFBezierPath.h"
#import "UIColor+HexString.h"
#import "RADotView.h"

#define kColor(r,g,b)   [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define kColorWithHexStr(str)   [UIColor colorWithHexString:str]

@interface ViewController ()
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) CAShapeLayer *layer;

@property (nonatomic, strong) NSArray *scoresArray;
@end

@implementation ViewController

- (void)setName{
    CGFloat length = 12+22+30+30;
    NSMutableArray *lengthArr = [NSMutableArray arrayWithCapacity:5];
    for (int i = 0; i < 5; i ++) {
        [lengthArr addObject:[NSNumber numberWithFloat:length]];
    }
    NSArray *arr = [UIBezierPath converCoordinateFromLength:lengthArr Center:self.view.center];
    NSArray *nameArr = @[@"中单",@"上单",@"下路",@"辅助",@"打野"];
    for (int i = 0; i < 5; i ++) {
        CGPoint p = [arr[i] CGPointValue];
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
        lb.textColor = [UIColor blackColor];
        lb.font = [UIFont systemFontOfSize:14];
        lb.textAlignment = NSTextAlignmentCenter;
        lb.text = nameArr[i];
        if (i == 0 || i == 1) {
            lb.center = CGPointMake(p.x, p.y-CGRectGetHeight(lb.frame)/2);
        }else if (i == 2){
            lb.center = CGPointMake(p.x+CGRectGetWidth(lb.frame)/2, p.y);
        }else if (i == 3){
            lb.center = CGPointMake(p.x, p.y+CGRectGetHeight(lb.frame)/2);
        }else if (i == 4){
            lb.center = CGPointMake(p.x-CGRectGetWidth(lb.frame)/2, p.y);
        }
        [self.view addSubview:lb];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setName];
    self.view.backgroundColor = kColor(240, 240, 240);
    
    self.scoresArray = @[@2, @2, @2, @3, @4];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    CGPathRef path = [UIBezierPath drawPentagonWithCenter:self.view.center Length:12+22+30+30];
    layer.path = path;
    layer.fillColor = kColor(251,237,233).CGColor;
    layer.strokeColor = nil;
    [self.view.layer addSublayer:layer];
    
    CAShapeLayer *layer2 = [CAShapeLayer layer];
    CGPathRef path2 = [UIBezierPath drawPentagonWithCenter:self.view.center Length:12+22+30];
    layer2.path = path2;
    layer2.fillColor = kColor(251,218,200).CGColor;
    layer2.strokeColor = nil;
    [layer addSublayer:layer2];
    
    CAShapeLayer *layer3 = [CAShapeLayer layer];
    CGPathRef path3 = [UIBezierPath drawPentagonWithCenter:self.view.center Length:12+22];
    layer3.path = path3;
    layer3.fillColor = kColor(251,200,170).CGColor;
    layer3.strokeColor = nil;
    [layer2 addSublayer:layer3];
    
    CAShapeLayer *layer4 = [CAShapeLayer layer];
    CGPathRef path4 = [UIBezierPath drawPentagonWithCenter:self.view.center Length:12];
    layer4.path = path4;
    layer4.fillColor = kColor(251,180,145).CGColor;
    layer4.strokeColor = nil;
    [layer3 addSublayer:layer4];
    
    self.layer = layer;
    
    self.shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.fillColor = [kColor(247, 164, 118) colorWithAlphaComponent:0.5].CGColor;
    self.shapeLayer.strokeColor = nil;
    
    [self drawScorePentagonV2];
}

#pragma mark - 描绘分数五边行  按照与各边成比例的速度放大
- (void)drawScorePentagonV1
{
    NSArray *lengthsArray = [self convertLengthsFromScore:self.scoresArray];
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnimation.fromValue = (id)[UIBezierPath drawPentagonWithCenter:self.view.center Length:0];
    pathAnimation.toValue = (id)[UIBezierPath drawPentagonWithCenter:self.view.center LengthArray:lengthsArray];
    pathAnimation.duration = 0.75;
    pathAnimation.autoreverses = NO;
    pathAnimation.repeatCount = 0;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.shapeLayer addAnimation:pathAnimation forKey:@"scale"];
    self.shapeLayer.path = [UIBezierPath drawPentagonWithCenter:self.view.center LengthArray:lengthsArray];
    [self.layer addSublayer:self.shapeLayer];
    [self performSelector:@selector(changeBgSizeFinish) withObject:nil afterDelay:0.75];
}

#pragma mark - 描绘分数五边行  按照各边同样的速度放大
- (void)drawScorePentagonV2
{
    NSArray *scoresArray = [self analysisScoreArray:self.scoresArray];
    NSMutableArray *lengthsArray = [NSMutableArray array];
    [lengthsArray addObject:(id)[UIBezierPath drawPentagonWithCenter:self.view.center Length:0.0]];
    for (int i = 0; i < [scoresArray count]; i++) {
        NSArray *scores = [scoresArray objectAtIndex:i];
        [lengthsArray addObject:(id)[UIBezierPath drawPentagonWithCenter:self.view.center LengthArray:[self convertLengthsFromScore:scores]]];
    }
    CAKeyframeAnimation *frameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    frameAnimation.values = lengthsArray;
    frameAnimation.keyTimes = [self analysisDurationArray:self.scoresArray];
    frameAnimation.duration = 2;
    frameAnimation.calculationMode = kCAAnimationLinear;
    [self.shapeLayer addAnimation:frameAnimation forKey:@"scale"];
    self.shapeLayer.path = [UIBezierPath drawPentagonWithCenter:self.view.center LengthArray:[self convertLengthsFromScore:[scoresArray lastObject]]];
    [self.layer addSublayer:self.shapeLayer];
    [self performSelector:@selector(changeBgSizeFinish) withObject:nil afterDelay:2];
}

#pragma mark - 描点
- (void)changeBgSizeFinish
{
    NSArray *array = [self convertLengthsFromScore:self.scoresArray];
    NSArray *lengthsArray = [UIBezierPath converCoordinateFromLength:array Center:self.view.center];
    for (int i = 0; i < [lengthsArray count]; i++) {
        CGPoint point = [[lengthsArray objectAtIndex:i] CGPointValue];
        RADotView *dotV = [[RADotView alloc] init];
        dotV.dotColor = [UIColor colorWithHexString:@"0xF86465"];
        dotV.center = point;
        dotV.bounds = CGRectMake(0, 0, 8, 8);
        [self.view addSubview:dotV];
    }
}

#pragma mark - 分数转换
- (NSNumber *)convertLengthFromScore:(double)score
{
    if (score >= 4) {
        return @(12 + 22 + 30 + 30);
    } else if (score >= 3){
        return @(12 + 22 + 30 + 30 * (score - 3));
    } else if (score >= 2) {
        return @(12 + 22 + 30 * (score - 2));
    } else if (score >= 1) {
        return @(12 + 22 * (score - 1));
    } else  {
        return @(12 * score);
    }
}
- (NSArray *)convertLengthsFromScore:(NSArray *)scoreArray
{
    NSMutableArray *lengthArray = [NSMutableArray array];
    for (int i = 0; i < [scoreArray count]; i++) {
        double score = [[scoreArray objectAtIndex:i] doubleValue];
        [lengthArray addObject:[self convertLengthFromScore:score]];
    }
    return lengthArray;
}

#pragma mark - 对分数进行排序（第二种动画方法需要）
- (NSArray *)sortMergeScoresArray:(NSArray *)scores
{
    NSMutableArray *sortArray = [NSMutableArray arrayWithArray:scores];
    for (int i = 0; i < [sortArray count] - 1; i++) {
        for (int j = 0; j < [sortArray count] - i - 1 ; j++) {
            if ([[sortArray objectAtIndex:j] doubleValue] > [[sortArray objectAtIndex:j + 1] doubleValue]) {
                [sortArray exchangeObjectAtIndex:j withObjectAtIndex:j + 1];
            }
        }
    }
    return  sortArray;
}
- (NSArray *)analysisDurationArray:(NSArray *)scores
{
    NSMutableArray *analysisArray = [NSMutableArray array];
    NSArray *sortArray = [self sortMergeScoresArray:scores];
    [analysisArray addObject:@(0)];
    for (int i = 0; i < [sortArray count]; i++) {
        double currentProportion = [[sortArray objectAtIndex:i] doubleValue] / [[sortArray lastObject] doubleValue];
        [analysisArray addObject:@(currentProportion)];
    }
    return analysisArray;
}
- (NSArray *)analysisScoreArray:(NSArray *)scores
{
    NSArray *sortArray = [self sortMergeScoresArray:scores];
    NSMutableArray *analysisArray = [NSMutableArray array];
    for (int i = 0; i < [sortArray count]; i++) {
        double stepScore = [[sortArray objectAtIndex:i] doubleValue];
        NSMutableArray *analysisScores = [NSMutableArray array];
        for (int j = 0; j < [scores count]; j++) {
            double score = [[scores objectAtIndex:j] doubleValue];
            if (stepScore > score) {
                [analysisScores addObject:@(score)];
            } else {
                [analysisScores addObject:@(stepScore)];
            }
        }
        [analysisArray addObject:analysisScores];
    }
    return analysisArray;
}

@end
