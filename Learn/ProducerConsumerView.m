//
//  ProducerConsumerView.m
//  Learn
//
//  Created by Vince on 2018/2/17.
//  Copyright © 2018年 ChenghaoWang. All rights reserved.
//

#import "ProducerConsumerView.h"
#import "Buffer.h"

@interface ProducerConsumerView()

@end


@implementation ProducerConsumerView

static const CGFloat kRING_WIDTH = 60.f;
static const CGFloat kLINE_WIDTH = 1.f;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    // get current context
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextAddRect(ctx, rect);
    CGContextSetFillColorWithColor(ctx, [[UIColor whiteColor] CGColor]);
    CGContextFillPath(ctx);

    // assume @param rect is a square
    CGFloat length = rect.size.width;
    CGFloat outerRadius = (length - 2 * kLINE_WIDTH) * 0.5;
    CGFloat innerRadius = (length - 2 * (kLINE_WIDTH + kRING_WIDTH)) * 0.5;
    
    // buffer border of the ring
    CGMutablePathRef bufferBorder = CGPathCreateMutable();
    
    CGFloat bufferAngle = (2 * M_PI) / self.buffer.size;
    CGFloat currentAngle = 0;
    
    CGAffineTransform deltaTransform = CGAffineTransformTranslate(CGAffineTransformIdentity, length * 0.5, length * 0.5);
    
    if (self.buffer.productionCount > 0) {
        CGMutablePathRef bufferArea = CGPathCreateMutable();
        CGFloat startAngle = self.buffer.currentConsumePosition * bufferAngle;
        CGFloat totalAngel = bufferAngle * self.buffer.productionCount;
        CGAffineTransform startTransform = CGAffineTransformRotate(deltaTransform, startAngle);
        CGPathMoveToPoint(bufferArea, &startTransform, innerRadius, 0);
        CGPathAddLineToPoint(bufferArea, &startTransform, outerRadius, 0);
        CGPathAddArc(bufferArea, &startTransform, 0, 0, outerRadius, 0, totalAngel, false);
        CGAffineTransform endTransform = CGAffineTransformRotate(startTransform, totalAngel);
        CGPathAddLineToPoint(bufferArea, &endTransform, innerRadius, 0);
        CGPathAddArc(bufferArea, &endTransform, 0, 0, innerRadius, 0, -1 * totalAngel, true);
        CGContextSetFillColorWithColor(ctx, [[UIColor blackColor] CGColor]);
        CGContextAddPath(ctx, bufferArea);
        CGContextFillPath(ctx);
        CGPathRelease(bufferArea);
    }
    
    // outer border of the ring
    CGPathRef outerCircle = CGPathCreateWithEllipseInRect(CGRectMake(kLINE_WIDTH, kLINE_WIDTH, outerRadius * 2, outerRadius * 2), NULL);
    CGContextAddPath(ctx, outerCircle);

    // inner border of the ring
    CGPathRef innerCircle = CGPathCreateWithEllipseInRect(CGRectMake(kLINE_WIDTH + kRING_WIDTH, kLINE_WIDTH + kRING_WIDTH, innerRadius * 2, innerRadius * 2), NULL);
    CGContextAddPath(ctx, innerCircle);
    
    for (int i = 0; i < self.buffer.size + 1; i++) {
        CGPathMoveToPoint(bufferBorder, &deltaTransform, innerRadius * cos(currentAngle), innerRadius * sin(currentAngle));
        CGPathAddLineToPoint(bufferBorder, &deltaTransform, outerRadius * cos(currentAngle), outerRadius * sin(currentAngle));
        currentAngle += bufferAngle;
    }
    
    
    CGContextAddPath(ctx, bufferBorder);
    
    CGContextSetLineWidth(ctx, kLINE_WIDTH);
    CGContextSetStrokeColorWithColor(ctx, [[UIColor blackColor] CGColor]);
    CGContextStrokePath(ctx);
    
    CGPathRelease(outerCircle);
    CGPathRelease(innerCircle);
    CGPathRelease(bufferBorder);
}


@end
