//
//  TestViewController.m
//  WKWebView
//
//  Created by LiliEhuu on 16/9/1.
//  Copyright © 2016年 LiliEhuu. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.info[@"title"];
    
    [self.webView loadRequestURL:self.info[@"url"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)dealloc
{
    NSLog(@"释放了第二个页面");
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}


@end



