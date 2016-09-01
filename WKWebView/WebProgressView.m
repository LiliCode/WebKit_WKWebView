//
//  WebProgressView.m
//  WKWebView
//
//  Created by LiliEhuu on 16/8/31.
//  Copyright © 2016年 LiliEhuu. All rights reserved.
//

#import "WebProgressView.h"

@interface WebProgressView ()
@property (strong , nonatomic) WKWebView *webView;

@end

@implementation WebProgressView

+ (instancetype)progressViewWithWebView:(WKWebView *)webView
{
    return [[self alloc] initWithWebView:webView];
}

- (instancetype)initWithWebView:(WKWebView *)webView
{
    if (self = [super init])
    {
        //设置轨道颜色
        self.trackTintColor = [UIColor clearColor];
        //设置webView
        self.webView = webView;
        //添加监听 监听WKWebView的进度属性
        [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    }
    
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    //获取进度
    float progressValue = [change[@"new"] floatValue];
    //开始
    if (progressValue > 0 && self.hidden)
    {
        self.hidden = NO;   //如果值大于0 并且 进度条为隐藏，就使他不隐藏
    }
    
    //设置进度
    [self setProgress:progressValue animated:YES];
    
    //结束
    if (progressValue == 1)
    {
        [self stop];
    }
}


- (void)stop
{
    //设置为0
    [self setProgress:0];
    //隐藏
    self.hidden = YES;
}



- (void)dealloc
{
    //删除KVO监听
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}


@end





