//
//  TestViewController.m
//  Learn
//
//  Created by Vince on 2018/2/18.
//  Copyright © 2018年 ChenghaoWang. All rights reserved.
//

#import "TestViewController.h"
#import "AlipayActivityIndicator.h"

@interface TestViewController ()

@property (nonatomic, strong) AlipayActivityIndicator* aai;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.aai = [[AlipayActivityIndicator alloc] initWithFrame:CGRectMake(110, 200, 100, 100)];
    [self.view addSubview:self.aai];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.aai.isStart = YES;
}

@end
