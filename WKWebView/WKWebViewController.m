//
//  WKWebViewController.m
//  WKWebView
//
//  Created by LiliEhuu on 16/9/1.
//  Copyright © 2016年 LiliEhuu. All rights reserved.
//

#import "WKWebViewController.h"

#define alert(msg) \
UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];\
[alert show];



@interface WKWebViewController ()
@property (strong , nonatomic) WKWebView *wkWebView;
@property (strong , nonatomic) WebProgressView *progressView;

@end

@implementation WKWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadInterface];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //添加进度条
    [self.navigationController.navigationBar addSubview:self.progressView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //从父视图上面删除
    [self.progressView removeFromSuperview];
}


- (void)loadInterface
{
    [self.view addSubview:self.wkWebView];
    
    //执行添加公共方法虚函数
    if ([self respondsToSelector:@selector(addPublicScriptMessageHandlers)])
    {
        [self addPublicScriptMessageHandlers];
    }
}


- (WebProgressView *)progressView
{
    if (!_progressView)
    {
        CGFloat progressBarHeight = 2.0f;
        CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
        CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
        _progressView = [WebProgressView progressViewWithWebView:self.wkWebView];
        _progressView.frame = barFrame;
        _progressView.tintColor = [UIColor colorWithRed:22.f / 255.f green:126.f / 255.f blue:251.f / 255.f alpha:1.0];
        _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    
    return _progressView;
}

- (WKWebView *)wkWebView
{
    if (!_wkWebView)
    {
        //配置
        _wkWebView = [WKWebView webViewWithFrame:self.view.bounds];
        _wkWebView.UIDelegate = self;
        _wkWebView.navigationDelegate = self;
        _wkWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    
    return _wkWebView;
}

- (WKWebView *)webView
{
    return self.wkWebView;
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    NSLog(@"开始加载");
    //开启活动指示器
    if (![UIApplication sharedApplication].isNetworkActivityIndicatorVisible)
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    NSLog(@"加载完成");
    //活动指示器停止
    if ([UIApplication sharedApplication].isNetworkActivityIndicatorVisible)
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"加载失败：%@", error.description);
    if (error)
    {
        alert(error.userInfo[NSLocalizedDescriptionKey]);
    }
}

//页面跳转代理

// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation
{
    
}

// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    decisionHandler(WKNavigationResponsePolicyAllow);     //允许加载
}

// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    //是否允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);   //允许
}


#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    //收到js调用OC
    NSLog(@"javaScript调用Objective-C: 方法：%@ 参数：%@", message.name, message.body);
    
    //拼接方法名
    NSString *funcName = [message.body isMemberOfClass:[NSNull class]]? message.name : [message.name stringByAppendingString:@":"];
    
    //在ARC(自动内存管理)的条件下，使用选择器，很可能会报警
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    
    SEL sel = NSSelectorFromString(funcName);
    //判断是否能相应此方法
    if ([self respondsToSelector:sel])
    {
        //方法签名
        NSMethodSignature *methodSignature = [[self class] instanceMethodSignatureForSelector:sel];
        //判断是否是无返回值 void
        if (!strcmp("v", methodSignature.methodReturnType))
        {
            //方法无返回值
            [self performSelector:sel withObject:message.body];
        }
        else
        {
            //方法有返回值
            id returnValue = [self performSelector:sel withObject:message.body];
            
            if ([self respondsToSelector:@selector(webView:didReceiveOCMethodReturnValue:selectorName:)])
            {
                [self webView:self.webView didReceiveOCMethodReturnValue:returnValue selectorName:message.name];  //执行虚函数
            }
        }
    }
    else
    {
        NSLog(@"未实现的选择器实例：[%@ %@]", NSStringFromClass(self.class), funcName);
    }
    
#pragma clang diagnostic pop
}

#pragma mark - WKUIDelegate

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    //弹出本地框
    alert(message);
    
    completionHandler();
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)dealloc
{
    //删除注入的所有消息处理者
    [self.webView removeAllScriptMessageHandler];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}


@end






