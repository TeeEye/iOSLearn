//
//  Consumer.m
//  Learn
//
//  Created by Vince on 2018/2/17.
//  Copyright © 2018年 ChenghaoWang. All rights reserved.
//

#import "Consumer.h"
#import "Buffer.h"
#import "ProducerConsumerView.h"

@interface Consumer()

@property (nonatomic, weak) Buffer* buffer;

@property (nonatomic, weak) ProducerConsumerView* pcView;

@property (nonatomic, strong) dispatch_queue_t consumeQueue;

@end

@implementation Consumer

- (instancetype)initWithBuffer:(Buffer *)buffer view:(ProducerConsumerView *)view {
    if (self = [super init]) {
        _buffer = buffer;
        _pcView = view;
        _consumeQueue = dispatch_queue_create("CONSUME_QUEUE", DISPATCH_QUEUE_SERIAL);
        [self consume];
    }
    return self;
}

- (void)consume {
    dispatch_async(_consumeQueue, ^{
        dispatch_wait(_buffer.fullMutex, DISPATCH_TIME_FOREVER);
        //        NSLog(@"start consume");
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((arc4random() % 2 + 0.8) * NSEC_PER_SEC)), _consumeQueue, ^{
            dispatch_wait(_buffer.mutex, DISPATCH_TIME_FOREVER);
            [_buffer consume];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_pcView setNeedsDisplay];
                //                NSLog(@"end consume");
                dispatch_semaphore_signal(_buffer.mutex);
                dispatch_semaphore_signal(_buffer.emptyMutex);
                [self consume];
            });
        });
    });
}

@end
