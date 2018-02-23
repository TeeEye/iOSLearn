//
//  TestViewController.m
//  Learn
//
//  Created by Vince on 2018/2/18.
//  Copyright © 2018年 ChenghaoWang. All rights reserved.
//

#import "TestViewController.h"
#import "AlipayActivityIndicator.h"
#import "RoundRectButton.h"

@interface TestViewController ()

@property (nonatomic, strong) AlipayActivityIndicator* aai;

@property (nonatomic, strong) RoundRectButton* stopBtn;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.stopBtn = [[RoundRectButton alloc] initWithFrame:CGRectMake(110, 400, 100, 50)];
    [self.stopBtn addTarget:self action:@selector(stop) forControlEvents:UIControlEventTouchUpInside];
    [self.stopBtn setTitle:@"INIT" forState:UIControlStateNormal];
    [self.view addSubview:self.stopBtn];
}


- (void)stop {
    self.stopBtn.flag = (self.stopBtn.flag + 1) % 3;
    if (self.stopBtn.flag == 1) {
        [self.stopBtn setTitle:@"START" forState:UIControlStateNormal];
        if (self.aai != nil) {
            [self.aai removeFromSuperview];
            self.aai = nil;
        }
        self.aai = [[AlipayActivityIndicator alloc] initWithFrame:CGRectMake(110, 200, 100, 100)];
        [self.view addSubview:self.aai];
    } else if (self.stopBtn.flag == 2) {
        self.aai.starting = YES;
        [self.stopBtn setTitle:@"STOP" forState:UIControlStateNormal];
    } else {
        self.aai.starting = NO;
        [self.stopBtn setTitle:@"INIT" forState:UIControlStateNormal];
    }
}

@end
