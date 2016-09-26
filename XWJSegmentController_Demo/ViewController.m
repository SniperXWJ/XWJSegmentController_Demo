//
//  ViewController.m
//  XWJSegmentController_Demo
//
//  Created by qianfeng on 16/9/26.
//  Copyright © 2016年 com.xuwenjie. All rights reserved.
//

#import "ViewController.h"
#import "XWJSegmentViewController.h"
#import "XWJChildrenViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"跳转" forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 40, 30);
    button.center = self.view.center;
    button.backgroundColor = [UIColor redColor];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(jumpToXWJSegmentController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}


- (void)jumpToXWJSegmentController {
    
    //1.创建XWJSegmentViewController对象
    XWJSegmentViewController *segmentController = [[XWJSegmentViewController alloc] init];
    
    
    
    
    //2.为XWJSegmentViewController对象添加子控制器
    NSArray *titles = @[@"首页",@"新闻",@"图片",@"民间",@"社会",@"国际",@"非洲"];
    
    [titles enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL * _Nonnull stop) {
        
        XWJChildrenViewController *child = [[XWJChildrenViewController alloc] init];
        child.title = title;
        child.view.backgroundColor = RandomColor;
        [segmentController.segmentChildrenControllers addObject:child];
    }];
    
    
    
    
    
    //3.将XWJSegmentViewController对象嵌套一个UINavigationController
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:segmentController];
    
    
    
    
    
    //4.跳转到页面显示
    [self presentViewController:navigationController animated:YES completion:nil];

    
}

@end
