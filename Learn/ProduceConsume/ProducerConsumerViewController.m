//
//  ProducerConsumerViewController.m
//  Learn
//
//  Created by Vince on 2018/2/17.
//  Copyright © 2018年 ChenghaoWang. All rights reserved.
//
//  This class combined with related classes are to learn
//  the basic concepts of CoreGraphics & GrandCentralDispatch.
//

#import "ProducerConsumerViewController.h"
#import "ProducerConsumerView.h"
#import "Producer.h"
#import "Consumer.h"
#import "Buffer.h"
#import "RoundRectButton.h"

typedef NS_ENUM(NSUInteger, ControlButtonState) {
    ControlButtonStateStart = 0,
    ControlButtonStatePause = 1,
};

@interface ProducerConsumerViewController ()

@property (nonatomic, strong) ProducerConsumerView* pcView;

@property (nonatomic, strong) Buffer* buffer;

@property (nonatomic, strong) Producer* producer;

@property (nonatomic, strong) Consumer* consumer;

@property (nonatomic, strong) RoundRectButton* controlBtn;

@end

@implementation ProducerConsumerViewController

static const NSUInteger kBUFFER_COUNT = 8;

- (instancetype)init {
    if (self = [super init]) {
        _buffer = [[Buffer alloc] initWithSize:kBUFFER_COUNT];
        dispatch_semaphore_wait(_buffer.mutex, DISPATCH_TIME_FOREVER);
        _pcView = [[ProducerConsumerView alloc] initWithFrame:CGRectMake(10, 100, 300, 300)];
        _producer = [[Producer alloc] initWithBuffer:_buffer view:_pcView];
        _consumer = [[Consumer alloc] initWithBuffer:_buffer view:_pcView];
        _controlBtn = [[RoundRectButton alloc] initWithFrame:CGRectMake(100, 450, 120, 40)];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _pcView.buffer = _buffer;
    
    [_controlBtn setTitle:@"Start" forState:UIControlStateNormal];
    [_controlBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_controlBtn addTarget:self action:@selector(startPC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_controlBtn];
    
    [self.view addSubview:_pcView];
}

- (void)startPC {
    // use mutex (semaphore) to switch the threads
    if (self.controlBtn.flag == ControlButtonStateStart) {
        self.controlBtn.flag = ControlButtonStatePause;
        [_controlBtn setTitle:@"Pause" forState:UIControlStateNormal];
        dispatch_semaphore_signal(_buffer.mutex);
    } else {
        self.controlBtn.flag = ControlButtonStateStart;
        [_controlBtn setTitle:@"Start" forState:UIControlStateNormal];
        dispatch_semaphore_wait(_buffer.mutex, DISPATCH_TIME_FOREVER);
    }
}

@end
