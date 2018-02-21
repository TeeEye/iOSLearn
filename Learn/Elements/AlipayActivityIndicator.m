//
//  AlipayActivityIndicator.m
//  Learn
//
//  Created by Vince on 2018/2/18.
//  Copyright © 2018年 ChenghaoWang. All rights reserved.
//

#import "AlipayActivityIndicator.h"
#import <QuartzCore/CAAnimation.h>

@interface AlipayActivityIndocatorInner:UIView

@end

@interface AlipayActivityIndicator()

@property (nonatomic, strong) UIImageView* arcView;

@property (nonatomic, strong) AlipayActivityIndocatorInner* innerView;

@end

@implementation AlipayActivityIndicator

const static CGFloat kARC_WIDTH = 5.f;
const static CGFloat kARC_INSET = 5.f;
const static CGFloat kARC_DURATION = 1.f;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        
    }
    return self;
}

- (UIImageView*)arcView {
    if (_arcView == nil) {
        
        CGSize contextSize = self.bounds.size;
        UIGraphicsBeginImageContextWithOptions(contextSize, NO, false);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        
        CGColorRef tintColor;
        
        if (self.tintColor == nil) {
            tintColor = [[UIColor colorWithRed:0 green:0.6 blue:1.f alpha:1.f] CGColor];
        } else {
            tintColor = [self.tintColor CGColor];
        }
        
        CGContextSetStrokeColorWithColor(ctx, tintColor);
        
        CGPoint centerPoint = CGPointMake(contextSize.width * 0.5, contextSize.height * 0.5);
        CGFloat arcRadius = contextSize.width * 0.5 - kARC_INSET - kARC_WIDTH;
        
        CGContextAddArc(ctx, centerPoint.x, centerPoint.y, arcRadius, 0, 3 * M_PI_2, 0);
        CGContextSetLineCap(ctx, kCGLineCapRound);
        CGContextSetLineWidth(ctx, kARC_WIDTH);
        
        CGContextStrokePath(ctx);
        
        UIImage* arcImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        _arcView = [[UIImageView alloc] initWithFrame:self.bounds];
        _arcView.image = arcImage;
        _arcView.userInteractionEnabled = NO;

        [self addSubview:_arcView];
    }
    
    return _arcView;
}

- (void)setIsStart:(BOOL)isStart {
    _isStart = isStart;
    if (_isStart) {
        [self start];
    }
}

- (void)setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;
    _arcView = nil;
}

- (void)start {
    
    self.arcView.hidden = NO;
    self.innerView.hidden = NO;
    
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.toValue = @(2 * M_PI);
    animation.repeatCount = HUGE_VALF;
    animation.duration = kARC_DURATION;
    
    [self.arcView.layer addAnimation:animation forKey:@"ARC_ANIMAITON"];
}

- (void)end {
    self.arcView.hidden = YES;
    self.innerView.hidden = YES;
}

- (void)complete {
    NSLog(@"1");
}

@end

@interface AlipayActivityIndocatorInner()

@property (nonatomic, strong) CADisplayLink* displayLink;

@property (nonatomic, assign) CGFloat rotationValue;

@property (nonatomic, assign) CGFloat checkValue;

@property (nonatomic, assign) BOOL isRotation;

@property (nonatomic, assign) BOOL isCheck;

@property (nonatomic, assign) NSTimeInterval previousTime;

@end

@implementation AlipayActivityIndocatorInner

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
    
    self.rotationValue += delta * (1 / kARC_DURATION);
    
    if (self.rotationValue > 0.5) {
        self.rotationValue = 0.5;
        self.isCheck = true;
    }
    
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
}

@end
