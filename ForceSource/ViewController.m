//
//  ViewController.m
//  ForceSource
//
//  Created by 翁志方 on 16/3/1.
//  Copyright © 2016年 wzf. All rights reserved.
//

#import "ViewController.h"
#import "FSIndicator.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    FSIndicator *indicator = [[FSIndicator alloc] init];
    indicator.center = self.view.center;
    [self.view addSubview:indicator];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
