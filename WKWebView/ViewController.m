//
//  ViewController.m
//  WKWebView
//
//  Created by LiliEhuu on 16/8/26.
//  Copyright © 2016年 LiliEhuu. All rights reserved.
//

#import "ViewController.h"
#import "TestViewController.h"
#import "WKWebViewScriptMessage.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //加载
    [self.webView loadHtmlFile:[[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"]];
    
    //注册方法
//    WKWebViewScriptMessage *scriptMesaage = [WKWebViewScriptMessage webViewScriptMessageWithDelegate:self];
//    [self.webView.configuration.userContentController addScriptMessageHandler:scriptMesaage name:@"func"];
//    [self.webView.configuration.userContentController addScriptMessageHandler:scriptMesaage name:@"func1"];
    
    [self.webView addScriptMessageHandler:self funcSelector:@selector(func1)];
    [self.webView addScriptMessageHandler:self funcSelector:@selector(func:)];
    
    NSLog(@"方法字符串：%@", NSStringFromSelector(@selector(func:)));
}


- (IBAction)reload:(UIBarButtonItem *)sender
{
    [self.webView reload];
}


- (void)func:(NSString *)json
{
    NSDictionary *info = [json jsonToDictionary];
    
    [self performSegueWithIdentifier:@"segue" sender:info];
}

- (NSNumber *)func1
{
    return @123456789;
}


- (void)webView:(WKWebView *)webView didReceiveOCMethodReturnValue:(id)value
{
    //回调js
    NSString *script = [NSString stringWithFormat:@"ocCallJavaScriptFunction(%@)", value];
    [self.webView evaluateJavaScript:script completionHandler:nil];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)dealloc
{
    NSLog(@"释放了第一个页面");
    
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"func"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"func1"];
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





