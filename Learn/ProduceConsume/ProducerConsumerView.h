//
//  ProducerConsumerView.h
//  Learn
//
//  Created by Vince on 2018/2/17.
//  Copyright © 2018年 ChenghaoWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Buffer;

@interface ProducerConsumerView : UIView

@property (nonatomic, weak) Buffer* buffer;

@end
