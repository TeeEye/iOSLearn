//
//  Buffer.h
//  Learn
//
//  Created by Vince on 2018/2/17.
//  Copyright © 2018年 ChenghaoWang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Buffer : NSObject

@property(nonatomic, assign, readonly) NSUInteger currentProducePosition;

@property(nonatomic, assign, readonly) NSUInteger currentConsumePosition;

@property(nonatomic, assign, readonly) NSUInteger productionCount;

@property(nonatomic, assign, readonly) NSUInteger size;

@property (nonatomic, strong) dispatch_semaphore_t emptyMutex;

@property (nonatomic, strong) dispatch_semaphore_t fullMutex;

@property (nonatomic, strong) dispatch_semaphore_t mutex;

- (instancetype)initWithSize:(NSUInteger)size;

- (void)consume;

- (void)produce;

@end
