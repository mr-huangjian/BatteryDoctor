#import "ScanView.h"

#define CORNERLENGTH 12
#define CORNERWITH 5

@interface ScanView (){
    CGRect scanRect;//二维码扫描区域Rect

    NSMutableArray *LayerArray;//存放四角Layer
}
@property (nonatomic, strong) CAShapeLayer *overlay;//二维码扫描区域Layer
//@property (nonatomic, strong) CAShapeLayer *lineLayer;//扫描时，运行动画直线

@end

@implementation ScanView

- (id)initWithFrame:(CGRect)frame{
    if ((self = [super initWithFrame:frame])) {
        
        LayerArray = [NSMutableArray array];
        self.fillColor = HexStringColor(@"#5FAEFF");
        [self addLayer];
    }
    
    return self;
}

- (void)setFillColor:(UIColor *)fillColor { _fillColor = fillColor; [self setNeedsDisplay]; }

- (void)drawRect:(CGRect)rect{
    CGRect innerRect = CGRectInset(rect, 8, 8);
    
//    CGFloat minSize = MIN(innerRect.size.width, innerRect.size.height);
//    if (innerRect.size.width != minSize) {
//        innerRect.origin.x   += (innerRect.size.width - minSize) / 2;
//        innerRect.size.width = minSize;
//    }
//    else if (innerRect.size.height != minSize) {
//        innerRect.origin.y    += (innerRect.size.height - minSize) / 2;
//        innerRect.size.height = minSize;
//    }
    
    scanRect = CGRectOffset(innerRect, 0, 0);
    _overlay.path = [UIBezierPath bezierPathWithRoundedRect:scanRect cornerRadius:0].CGPath;
//    _lineLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(scanRect.origin.x+1, scanRect.origin.y, scanRect.size.width-2,2) cornerRadius:0].CGPath;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(CGRectGetMinX(scanRect) + CORNERLENGTH, CGRectGetMinY(scanRect))];
    [path addLineToPoint:CGPointMake(CGRectGetMinX(scanRect)+ CORNERLENGTH,CGRectGetMinY(scanRect) - CORNERWITH)];
    [path addLineToPoint:CGPointMake(CGRectGetMinX(scanRect) - CORNERWITH,CGRectGetMinY(scanRect) - CORNERWITH)];
    [path addLineToPoint:CGPointMake(CGRectGetMinX(scanRect)- CORNERWITH,CGRectGetMinY(scanRect) + CORNERLENGTH)];
    [path addLineToPoint:CGPointMake(CGRectGetMinX(scanRect),CGRectGetMinY(scanRect)+CORNERLENGTH)];
    [path addLineToPoint:CGPointMake(CGRectGetMinX(scanRect),CGRectGetMinY(scanRect))];
    ((CAShapeLayer *)LayerArray[0]).path = path.CGPath;
    
    path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(CGRectGetMaxX(scanRect) - CORNERLENGTH, CGRectGetMinY(scanRect))];
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(scanRect) - CORNERLENGTH,CGRectGetMinY(scanRect) - CORNERWITH)];
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(scanRect) + CORNERWITH,CGRectGetMinY(scanRect) - CORNERWITH)];
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(scanRect) + CORNERWITH,CGRectGetMinY(scanRect) + CORNERLENGTH)];
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(scanRect),CGRectGetMinY(scanRect) + CORNERLENGTH)];
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(scanRect),CGRectGetMinY(scanRect))];
    ((CAShapeLayer *)LayerArray[1]).path = path.CGPath;
    
    path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(CGRectGetMaxX(scanRect),CGRectGetMaxY(scanRect) - CORNERLENGTH)];
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(scanRect)+ CORNERWITH,CGRectGetMaxY(scanRect) - CORNERLENGTH)];
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(scanRect) + CORNERWITH,CGRectGetMaxY(scanRect) + CORNERWITH)];
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(scanRect) - CORNERLENGTH,CGRectGetMaxY(scanRect) + CORNERWITH)];
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(scanRect) - CORNERLENGTH,CGRectGetMaxY(scanRect))];
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(scanRect),CGRectGetMaxY(scanRect))];
    ((CAShapeLayer *)LayerArray[2]).path = path.CGPath;
    
    path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(CGRectGetMinX(scanRect)+ CORNERLENGTH,CGRectGetMaxY(scanRect))];
    [path addLineToPoint:CGPointMake(CGRectGetMinX(scanRect) + CORNERLENGTH,CGRectGetMaxY(scanRect) + CORNERWITH)];
    [path addLineToPoint:CGPointMake(CGRectGetMinX(scanRect) - CORNERWITH,CGRectGetMaxY(scanRect) + CORNERWITH)];
    [path addLineToPoint:CGPointMake(CGRectGetMinX(scanRect) - CORNERWITH,CGRectGetMaxY(scanRect) - CORNERLENGTH)];
    [path addLineToPoint:CGPointMake(CGRectGetMinX(scanRect),CGRectGetMaxY(scanRect) -CORNERLENGTH)];
    [path addLineToPoint:CGPointMake(CGRectGetMinX(scanRect),CGRectGetMaxY(scanRect))];
    ((CAShapeLayer *)LayerArray[3]).path = path.CGPath;

}

#pragma mark - 增建动画Layer
- (void)addLayer{
    
    _overlay = [[CAShapeLayer alloc] init];
    _overlay.backgroundColor = [UIColor clearColor].CGColor;
    _overlay.fillColor  = [UIColor clearColor].CGColor;
    _overlay.strokeColor = HexStringColor(@"#5FAEFF").CGColor;
    _overlay.lineWidth = 1.0;
    _overlay.lineDashPhase = 0;
    
    [self.layer addSublayer:_overlay];
    [_overlay addObserver:self forKeyPath:@"path" options:NSKeyValueObservingOptionNew context:@"_overlay"];
    
//    _lineLayer = [[CAShapeLayer alloc] init];
//    _lineLayer.fillColor  = self.fillColor.CGColor;
//    _lineLayer.anchorPoint = CGPointMake(0, 0.5);
//  
//    [self.layer addSublayer:_lineLayer];
//    
//    _lineLayer.shadowOffset  = CGSizeMake(0, 2);
//    _lineLayer.shadowRadius  = 10;
//    _lineLayer.shadowColor   = HexStringColor(Theme_BlueColor).CGColor;
//    _lineLayer.shadowOpacity = 1;
   
    CAGradientLayer * gradientLayer = [CAGradientLayer layer];
    
    gradientLayer.frame     = CGRectMake(8, 0, screenW - 16, self.bounds.size.height - 8);
    gradientLayer.colors    = @[(__bridge id)[UIColor colorWithWhite:1 alpha:0.1].CGColor,
                                (__bridge id)HexStringColor(@"49A3FD").CGColor];
    gradientLayer.locations = @[@(0.8), @(1.0)];
    
    [self.layer addSublayer:gradientLayer];
    
    //创建4个角Layer
    for (NSInteger i = 0; i < 4; i++) {
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        layer.fillColor       = self.fillColor.CGColor;
        [self.layer addSublayer:layer];
        [LayerArray addObject:layer];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
//    CAShapeLayer *layer = (CAShapeLayer *)object;
//    if (_overlay == layer && [@"path" isEqualToString:keyPath]) {
//
//        [CATransaction begin];
//        [CATransaction setDisableActions:YES];//去掉隐形动画
//        _lineLayer.position = CGPointMake(0,CGRectGetHeight(scanRect));
//        [CATransaction commit];
//        
//        [self animationWithFrom:0 to:CGRectGetHeight(scanRect)];
//    }
}

//- (void)animationWithFrom:(CGFloat)fromValue to:(CGFloat)toValue{
//  
//    @autoreleasepool {
//        //1.创建基本动画
//        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.y"];
//        //2.设置动画的属性
//        [animation setDuration:1];
//        animation.fromValue = @(fromValue);
//        animation.toValue = @(toValue);
//        [animation setValue:@(toValue) forKey:@"toEndValue"];
//        
//        animation.repeatCount = DBL_MAX;//重复次数
//        animation.autoreverses = YES;//自动反向
//
//        animation.removedOnCompletion = NO;
//        animation.fillMode = kCAFillModeForwards;
//        //3.增加动画到对应的曾上
//        [_lineLayer addAnimation:animation forKey:nil];
//    }
//}
//
//#pragma mark - 退出扫描界面，停止动画
//- (void)stopAction {
//    _lineLayer.speed = 0.0;
//
//    [_lineLayer removeAllAnimations];
//}


@end
