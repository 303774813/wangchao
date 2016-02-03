//
//  ViewController.m
//  MeMPlayer
//
//  Created by mellow on 16/1/19.
//  Copyright © 2016年 mellow. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.layer.cornerRadius=5;
    self.view.layer.opacity=1;
    
    void (^block)(int)=^(int a){
        a=4;
    };
    
    block(4);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
