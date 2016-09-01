//
//  ViewController.m
//  WKWebView
//
//  Created by LiliEhuu on 16/8/26.
//  Copyright © 2016年 LiliEhuu. All rights reserved.
//

#import "ViewController.h"
#import "TestViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //加载
    [self.webView loadHtmlFile:[[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"]];
    
    //注册方法
//    [self.webView addScriptMessageHandler:self funcSelector:@selector(func1)];
    [self.webView addScriptMessageHandler:self funcSelector:@selector(func:)];
    
}


- (IBAction)reload:(UIBarButtonItem *)sender
{
    [self.webView reload];
}


- (void)func:(id)json
{
    NSDictionary *info = [json jsonToDictionary];
    
    [self performSegueWithIdentifier:@"segue" sender:info];
}

- (NSNumber *)func1
{
    return @123456789;
}


- (void)webView:(WKWebView *)webView didReceiveOCMethodReturnValue:(id)value selectorName:(NSString *)selName
{
    [super webView:webView didReceiveOCMethodReturnValue:value selectorName:selName];
    //处理其它返回值
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)dealloc
{
    NSLog(@"释放了第一个页面");
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segue"])
    {
        TestViewController *test = [segue destinationViewController];
        test.info = sender;
    }
}

@end





