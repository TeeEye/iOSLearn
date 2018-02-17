//
//  RoundRectButton.m
//  Learn
//
//  Created by Vince on 2018/2/17.
//  Copyright © 2018年 ChenghaoWang. All rights reserved.
//

#import "RoundRectButton.h"

@implementation RoundRectButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addTarget:self action:@selector(render) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(render) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

const static CGFloat kBORDER_WIDTH = 2.f;

- (void)render {
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    UIColor* fillColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.f];
    
    if (self.state == UIControlStateHighlighted) {
        fillColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.f];
    }
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
//    CGContextAddRect(ctx, rect);
//    CGContextSetFillColorWithColor(ctx, [[UIColor clearColor] CGColor]);
//    CGContextFillPath(ctx);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRoundedRect(path, NULL, CGRectMake(kBORDER_WIDTH, kBORDER_WIDTH, rect.size.width - 2 * kBORDER_WIDTH, rect.size.height - 2 * kBORDER_WIDTH), 5, 5);
    CGContextAddPath(ctx, path);
    CGContextSetStrokeColorWithColor(ctx, [[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.f]  CGColor]);
    CGContextSetLineWidth(ctx, kBORDER_WIDTH);
    CGContextSetFillColorWithColor(ctx, [fillColor  CGColor]);
    CGContextFillPath(ctx);
    CGContextAddPath(ctx, path);
    CGContextStrokePath(ctx);
    
    CGPathRelease(path);
}


@end
