//
//  HJButton.m
//  HJCategory
//
//  Created by hj on 16/7/23.
//  Copyright © 2016年 hj. All rights reserved.
//

#import "HJButton.h"

@implementation UIButton (ImagePosition)

- (void)hj_setImagePosition:(POImagePosition)postion withInset:(CGFloat)inset
{
    [self setTitle:self.currentTitle forState:UIControlStateNormal];
    [self setImage:self.currentImage forState:UIControlStateNormal];
    
    CGFloat imageWidth  = self.imageView.image.size.width;
    CGFloat imageHeight = self.imageView.image.size.height;
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    CGFloat labelWidth  = [self.titleLabel.text sizeWithFont:self.titleLabel.font].width;
    CGFloat labelHeight = [self.titleLabel.text sizeWithFont:self.titleLabel.font].height;
#pragma clang diagnostic pop
    
    CGFloat imageOffsetX = (imageWidth + labelWidth) / 2 - imageWidth / 2;
    CGFloat imageOffsetY = imageHeight / 2 + inset / 2;
    CGFloat labelOffsetX = (imageWidth + labelWidth / 2) - (imageWidth + labelWidth) / 2;
    CGFloat labelOffsetY = labelHeight / 2 + inset / 2;
    
    CGFloat tempWidth     = MAX(labelWidth, imageWidth);
    CGFloat changedWidth  = labelWidth + imageWidth - tempWidth;
    CGFloat tempHeight    = MAX(labelHeight, imageHeight);
    CGFloat changedHeight = labelHeight + imageHeight + inset - tempHeight;
    
    switch (postion) {
        case POImagePositionLeft:
            self.imageEdgeInsets = UIEdgeInsetsMake(0, -inset/2, 0, inset/2);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, inset/2, 0, -inset/2);
            self.contentEdgeInsets = UIEdgeInsetsMake(0, inset/2, 0, inset/2);
            break;
        case POImagePositionRight:
            self.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + inset/2, 0, -(labelWidth + inset/2));
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageWidth + inset/2), 0, imageWidth + inset/2);
            self.contentEdgeInsets = UIEdgeInsetsMake(0, inset/2, 0, inset/2);
            break;
        case POImagePositionTop:
            self.imageEdgeInsets = UIEdgeInsetsMake(-imageOffsetY, imageOffsetX, imageOffsetY, -imageOffsetX);
            self.titleEdgeInsets = UIEdgeInsetsMake(labelOffsetY, -labelOffsetX, -labelOffsetY, labelOffsetX);
            self.contentEdgeInsets = UIEdgeInsetsMake(imageOffsetY, -changedWidth/2, changedHeight-imageOffsetY, -changedWidth/2);
            break;
        case POImagePositionBottom:
            self.imageEdgeInsets = UIEdgeInsetsMake(imageOffsetY, imageOffsetX, -imageOffsetY, -imageOffsetX);
            self.titleEdgeInsets = UIEdgeInsetsMake(-labelOffsetY, -labelOffsetX, labelOffsetY, labelOffsetX);
            self.contentEdgeInsets = UIEdgeInsetsMake(changedHeight-imageOffsetY, -changedWidth/2, imageOffsetY, -changedWidth/2);
            break;
        default:
            break;
    }
}

@end

@implementation UIButton (EnlargeEdge)

static char topNameKey;
static char leftNameKey;
static char bottomNameKey;
static char rightNameKey;

- (void)hj_setEnlargeEdge:(CGFloat) size
{
    objc_setAssociatedObject(self, &topNameKey,   [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey,  [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey,[NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)hj_setEnlargeEdgeWithTop:(CGFloat) top left:(CGFloat) left bottom:(CGFloat) bottom right:(CGFloat) right
{
    objc_setAssociatedObject(self, &topNameKey,   [NSNumber numberWithFloat:top],   OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey,  [NSNumber numberWithFloat:left],  OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey,[NSNumber numberWithFloat:bottom],OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:right], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGRect)enlargedRect
{
    NSNumber* topEdge    = objc_getAssociatedObject(self, &topNameKey);
    NSNumber* rightEdge  = objc_getAssociatedObject(self, &rightNameKey);
    NSNumber* bottomEdge = objc_getAssociatedObject(self, &bottomNameKey);
    NSNumber* leftEdge   = objc_getAssociatedObject(self, &leftNameKey);
    
    if (topEdge && rightEdge && bottomEdge && leftEdge)
    {
        return CGRectMake(self.bounds.origin.x    - leftEdge.floatValue,
                          self.bounds.origin.y    - topEdge.floatValue,
                          self.bounds.size.width  + leftEdge.floatValue + rightEdge.floatValue,
                          self.bounds.size.height + topEdge.floatValue + bottomEdge.floatValue);
        
    }
    return self.bounds;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect rect = [self enlargedRect];
    
    if (CGRectEqualToRect(rect, self.bounds))
    {
        return [super pointInside:point withEvent:event];
    }
    return CGRectContainsPoint(rect, point) ? YES : NO;
}

/**
 针对UIView及其派生类
 - (UIView*)hitTest:(CGPoint) point withEvent:(UIEvent*) event
 {
    CGRect rect = [self enlargedRect];
 
 if (CGRectEqualToRect(rect, self.bounds))
 {
    return [super hitTest:point withEvent:event];
 }
    return CGRectContainsPoint(rect, point) ? self : nil;
 }
 **/

@end

@implementation UIButton (Simplify)

- (void)setTitle:(NSString *)title
{
    [self setTitle:title forState:UIControlStateNormal];
}

- (void)setHighlightedtTitle:(NSString *)highlightedtTitle
{
    [self setTitle:highlightedtTitle forState:UIControlStateHighlighted];
}

- (void)setSelectedTitle:(NSString *)selectedTitle
{
    [self setTitle:selectedTitle forState:UIControlStateSelected];
}

- (void)setTitleColor:(UIColor *)titleColor
{
    [self setTitleColor:titleColor forState:UIControlStateNormal];
}

- (void)setHighlightedTitleColor:(UIColor *)highlightedTitleColor
{
    [self setTitleColor:highlightedTitleColor forState:UIControlStateHighlighted];
}

- (void)setSelectedTitleColor:(UIColor *)selectedTitleColor
{
    [self setTitleColor:selectedTitleColor forState:UIControlStateSelected];
}

- (void)setImage:(UIImage *)image
{
    [self setImage:image forState:UIControlStateNormal];
}

- (void)setHighlightedImage:(UIImage *)highlightedImage
{
    [self setImage:highlightedImage forState:UIControlStateHighlighted];
}

- (void)setSelectedImage:(UIImage *)selectedImage
{
    [self setImage:selectedImage forState:UIControlStateSelected];
}

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    [self setBackgroundImage:backgroundImage forState:UIControlStateNormal];
}

- (void)setHighlightedBackgroundImage:(UIImage *)highlightedBackgroundImage
{
    [self setBackgroundImage:highlightedBackgroundImage forState:UIControlStateNormal];
}

- (void)setSelectedBackgroundImage:(UIImage *)selectedBackgroundImage
{
    [self setBackgroundImage:selectedBackgroundImage forState:UIControlStateNormal];
}

- (NSString *)title
{
   return [self titleForState:UIControlStateNormal];
}

- (NSString *)highlightedtTitle
{
   return [self titleForState:UIControlStateHighlighted];
}

- (NSString *)selectedTitle
{
   return [self titleForState:UIControlStateSelected];
}

- (UIColor *)titleColor
{
   return self.currentTitleColor;
}

- (UIColor *)highlightedTitleColor
{
   return self.currentTitleColor;
}

- (UIColor *)selectedTitleColor
{
   return self.currentTitleColor;
}

- (UIImage *)image
{
   return self.currentImage;
}

- (UIImage *)highlightedImage
{
   return self.currentImage;
}

- (UIImage *)selectedImage
{
   return self.currentImage;
}

- (UIImage *)backgroundImage
{
   return self.currentBackgroundImage;
}

- (UIImage *)highlightedBackgroundImage
{
   return self.currentBackgroundImage;
}

- (UIImage *)selectedBackgroundImage
{
   return self.currentBackgroundImage;
}

- (void)addTarget:(id)target action:(SEL)action
{
    [self addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
}

@end


@implementation UIButton (CountDown)

- (void)hj_startWithDuration:(NSInteger)duration running:(RunBlock)runBlock finished:(EndBlock)endBlock
{
    __block NSInteger timeOut = duration;
    dispatch_queue_t queue    = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer  = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        
        if (timeOut <= 0) {
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                endBlock(self);
            });
        } else {
            
            int allTime = (int)duration + 1;
            int seconds = timeOut % allTime;
            dispatch_async(dispatch_get_main_queue(), ^{
                runBlock(self, duration, seconds);
            });
            timeOut--;
        }
    });
    dispatch_resume(_timer);
}

@end
