//
//  WKWebViewScriptMessage.m
//  WKWebView
//
//  Created by LiliEhuu on 16/9/1.
//  Copyright © 2016年 LiliEhuu. All rights reserved.
//

#import "WKWebViewScriptMessage.h"

@interface WKWebViewScriptMessage ()
@property (weak , nonatomic) id<WKScriptMessageHandler> scriptDelegate;

@end

@implementation WKWebViewScriptMessage

+ (instancetype)webViewScriptMessageWithDelegate:(__weak id<WKScriptMessageHandler>)scriptDelegate
{
    return [[self alloc] initWithDelegate:scriptDelegate];
}

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate
{
    if (self = [super init])
    {
        self.scriptDelegate = scriptDelegate;
    }
    
    return self;
}


#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    //消息中转
    if ([self.scriptDelegate respondsToSelector:@selector(userContentController:didReceiveScriptMessage:)])
    {
        [self.scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
    }
}


@end





