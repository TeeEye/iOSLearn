//
//  Producer.h
//  Learn
//
//  Created by Vince on 2018/2/17.
//  Copyright © 2018年 ChenghaoWang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Buffer;
@class ProducerConsumerView;

static const NSNotificationName kPRODUCE_NOTIFICATION = @"PRODUCE_READY";

@interface Producer : NSObject

- (instancetype)initWithBuffer:(Buffer*)buffer view:(ProducerConsumerView*)view;

@end
