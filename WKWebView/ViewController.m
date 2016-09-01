//
//  ViewController.m
//  WKWebView
//
//  Created by LiliEhuu on 16/8/26.
//  Copyright © 2016年 LiliEhuu. All rights reserved.
//

#import "ViewController.h"
#import "TestViewController.h"
#import "WKWebViewController+PublicMethod.h"

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
    
    [self.webView addScriptMessageHandler:self funcSelector:@selector(userInfo:)];
    
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
    //回调js
    NSString *script = [NSString stringWithFormat:@"ocCallJavaScriptFunction(\"%@\")", value];
    [self.webView evaluateJavaScript:script completionHandler:^(id _Nullable jsValue, NSError * _Nullable error) {
        if (error)
        {
            NSLog(@"JavaScript执行错误：%@", error.userInfo[NSLocalizedDescriptionKey]);
        }
    }];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)dealloc
{
    NSLog(@"释放了第一个页面");
    //删除全部消息处理者
    [self.webView removeAllScriptMessageHandler];
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





