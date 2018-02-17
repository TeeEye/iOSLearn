//
//  Buffer.m
//  Learn
//
//  Created by Vince on 2018/2/17.
//  Copyright © 2018年 ChenghaoWang. All rights reserved.
//

#import "Buffer.h"

@interface Buffer()

@property(nonatomic, strong) NSMutableArray<NSNumber*>* buffer;

@property(nonatomic, assign) NSUInteger currentProducePosition;

@property(nonatomic, assign) NSUInteger currentConsumePosition;

@end

@implementation Buffer

- (instancetype)initWithSize:(NSUInteger)size {
    if (self = [super init]) {
        _size = size;
        _buffer = [NSMutableArray arrayWithCapacity:size];
        for (int i = 0; i < size; i++) {
            _buffer[i] = @false;
        }
        _emptyMutex = dispatch_semaphore_create(size);
        _fullMutex = dispatch_semaphore_create(0);
        _mutex = dispatch_semaphore_create(1);
    }
    return self;
}

- (void)produce {
    if (_productionCount == _size) {
        NSLog(@"trying to produce when buffer is full!");
        return;
    }
    _buffer[_currentProducePosition] = @true;
    _currentProducePosition = (_currentProducePosition + 1) % _size;
    _productionCount++;
}

- (void)consume {
    if (_productionCount == 0) {
        NSLog(@"trying to consume when buffer is empty!");
        return;
    }
    _buffer[_currentConsumePosition] = @false;
    _currentConsumePosition = (_currentConsumePosition + 1) % _size;
    _productionCount--;
}

@end
