//
//  AlipayActivityIndicator.m
//  Learn
//
//  Created by Vince on 2018/2/18.
//  Copyright © 2018年 ChenghaoWang. All rights reserved.
//

#import "AlipayActivityIndicator.h"
#import <QuartzCore/CAAnimation.h>

@interface AlipayActivityIndicatorInner:UIView

- (void)succeedWithRotaitonValue:(CGFloat)rotationValue;

@property (nonatomic, weak) UIImageView* arcView;

@end

@interface AlipayActivityIndicator()

@property (nonatomic, strong) UIImageView* arcView;

@property (nonatomic, strong) AlipayActivityIndicatorInner* innerView;

@end

@implementation AlipayActivityIndicator

const static CGFloat kARC_WIDTH = 5.f;
const static CGFloat kARC_INSET = 5.f;
const static CGFloat kARC_DURATION = 1.f;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        
        self.arcView.hidden = YES;
        [self addSubview:self.arcView];
        
        self.innerView.hidden = YES;
        self.innerView.arcView = self.arcView;
        [self addSubview:self.innerView];
        
    }
    return self;
}

- (UIImageView*)arcView {
    if (_arcView == nil) {
        
        CGSize contextSize = self.bounds.size;
        UIGraphicsBeginImageContextWithOptions(contextSize, NO, false);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        
        CGColorRef tintColor = [[UIColor colorWithRed:0 green:0.6 blue:1.f alpha:1.f] CGColor];
        
        CGContextSetStrokeColorWithColor(ctx, tintColor);
        
        CGPoint centerPoint = CGPointMake(contextSize.width * 0.5, contextSize.height * 0.5);
        CGFloat arcRadius = contextSize.width * 0.5 - kARC_INSET - kARC_WIDTH;
        
        CGContextAddArc(ctx, centerPoint.x, centerPoint.y, arcRadius, 0, M_PI_2, true);
        CGContextSetLineCap(ctx, kCGLineCapRound);
        CGContextSetLineWidth(ctx, kARC_WIDTH);
        
        CGContextStrokePath(ctx);
        
        UIImage* arcImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        _arcView = [[UIImageView alloc] initWithFrame:self.bounds];
        _arcView.image = arcImage;
        _arcView.userInteractionEnabled = NO;

    }
    
    return _arcView;
}

- (AlipayActivityIndicatorInner*)innerView {
    if (_innerView == nil) {
        _innerView = [[AlipayActivityIndicatorInner alloc] initWithFrame:self.bounds];
    }
    return _innerView;
}

- (void)setStarting:(BOOL)start {
    _starting = start;
    if (_starting) {
        [self start];
    } else {
        [self end];
    }
}

- (void)start {

    self.arcView.hidden = NO;
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.toValue = @(-2 * M_PI);
    animation.repeatCount = HUGE_VALF;
    animation.duration = kARC_DURATION;
    [self.arcView.layer addAnimation:animation forKey:@"ARC_ANIMAITON"];
}

- (void)end {
    self.innerView.hidden = NO;
    CGFloat rotationValue = -1 * [[self.arcView.layer.presentationLayer valueForKeyPath:@"transform.rotation.z"] floatValue] / (2 * M_PI);
    [self.innerView succeedWithRotaitonValue:rotationValue];
}

@end

@interface AlipayActivityIndicatorInner()

@property (nonatomic, strong) CADisplayLink* displayLink;

@property (nonatomic, assign) CGFloat rotationValue;

@property (nonatomic, assign) CGFloat checkValue;

@property (nonatomic, assign) BOOL isRotation;

@property (nonatomic, assign) BOOL isCheck;

@property (nonatomic, assign) NSTimeInterval previousTime;

@end

@implementation AlipayActivityIndicatorInner

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)dealloc {
    self.displayLink.paused = true;
    [self.displayLink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)succeedWithRotaitonValue:(CGFloat)rotationValue {
    self.rotationValue = rotationValue;
    self.isRotation = YES;
    self.displayLink.paused = NO;
}

- (CADisplayLink*)displayLink {
    if (_displayLink == nil) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkUpdate)];
        _displayLink.paused = YES;
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    return _displayLink;
}

- (void)displayLinkUpdate {
    if (self.previousTime < DBL_EPSILON) {
        self.previousTime = CACurrentMediaTime();
        return;
    }
    
    NSTimeInterval delta = CACurrentMediaTime() - self.previousTime;
    
    self.rotationValue += delta * (1.f / kARC_DURATION) /10;
    
    if (self.rotationValue > 0.75) {
        self.rotationValue = 0.75;
        self.isCheck = true;
    }
    
    if (self.isCheck) {
        self.checkValue += delta * (1.f / kARC_DURATION) /10;
        if (self.checkValue > 1.f) {
            self.checkValue = 1.f;
        }
    }
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGSize contextSize = self.bounds.size;

    CGColorRef tintColor = [[UIColor colorWithRed:0 green:0.6 blue:1.f alpha:1.f] CGColor];
    
    CGContextSetStrokeColorWithColor(ctx, tintColor);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetLineWidth(ctx, kARC_WIDTH);
    
    CGPoint centerPoint = CGPointMake(contextSize.width * 0.5, contextSize.height * 0.5);
    CGFloat arcRadius = contextSize.width * 0.5 - kARC_INSET - kARC_WIDTH;
    
    if (self.isRotation && !self.isCheck) {
        CGFloat rotationAngle = self.rotationValue * -2 * M_PI;
        CGContextAddArc(ctx, centerPoint.x, centerPoint.y, arcRadius, rotationAngle, rotationAngle + M_PI_2, true);
        CGContextSetLineCap(ctx, kCGLineCapRound);
        CGContextSetLineWidth(ctx, kARC_WIDTH);
        
    } else if (self.isCheck) {
        if (self.checkValue < 0.75) {
            CGFloat rotationAngle = -1.5 * M_PI - self.checkValue * 2 * M_PI;
            CGContextAddArc(ctx, centerPoint.x, centerPoint.y, arcRadius, rotationAngle, -1 * M_PI, true);

        } else {
            if (self.checkValue < 0.85) {
                CGContextMoveToPoint(ctx, kARC_INSET, rect.size.height * 0.5);
                CGFloat ratio = (self.checkValue - 0.75) * 10;
                CGContextAddLineToPoint(ctx, rect.size.width * 0.3 * ratio, rect.size.height * 0.5 + (rect.size.height * 0.2 * ratio));
            } else {
                CGContextMoveToPoint(ctx, kARC_INSET, rect.size.height * 0.5);
                CGContextAddLineToPoint(ctx, rect.size.width * 0.3, rect.size.height * 0.7);
                CGFloat ratio = (self.checkValue - 0.85) / 0.15;
                CGContextAddLineToPoint(ctx, rect.size.width * 0.3 + rect.size.width * 0.4 * ratio , rect.size.height * 0.7 - (rect.size.height * 0.5 * ratio));
            }
        }
    }
    
    CGContextStrokePath(ctx);
    self.arcView.hidden = YES;
}

@end
