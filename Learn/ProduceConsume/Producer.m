//
//  Producer.m
//  Learn
//
//  Created by Vince on 2018/2/17.
//  Copyright © 2018年 ChenghaoWang. All rights reserved.
//

#import "Producer.h"
#import "Buffer.h"
#import "ProducerConsumerView.h"

@interface Producer()

@property (nonatomic, weak) Buffer* buffer;

@property (nonatomic, weak) ProducerConsumerView* pcView;

@property (nonatomic, strong) dispatch_queue_t productQueue;

@end

@implementation Producer

- (instancetype)initWithBuffer:(Buffer *)buffer view:(ProducerConsumerView *)view {
    if (self = [super init]) {
        _buffer = buffer;
        _pcView = view;
        _productQueue = dispatch_queue_create("PRODUCE_QUEUE", DISPATCH_QUEUE_SERIAL);
        [self produce];
    }
    return self;
}

- (void)produce {
    dispatch_async(_productQueue, ^{
        dispatch_wait(_buffer.emptyMutex, DISPATCH_TIME_FOREVER);
        //        NSLog(@"start produce");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((arc4random() % 2 + 0.5) * NSEC_PER_SEC)),_productQueue, ^{
            //            NSLog(@"produce ready");
            dispatch_wait(_buffer.mutex, DISPATCH_TIME_FOREVER);
            [_buffer produce];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_pcView setNeedsDisplay];
                //                NSLog(@"end produce");
                dispatch_semaphore_signal(_buffer.mutex);
                dispatch_semaphore_signal(_buffer.fullMutex);
                [self produce];
            });
        });
    });
}

@end
