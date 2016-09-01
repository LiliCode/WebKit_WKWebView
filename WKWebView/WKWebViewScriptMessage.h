//
//  WKWebViewScriptMessage.h
//  WKWebView
//
//  Created by LiliEhuu on 16/9/1.
//  Copyright © 2016年 LiliEhuu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WKScriptMessageHandler.h>

@interface WKWebViewScriptMessage : NSObject<WKScriptMessageHandler>

/**
 *  创建消息处理者
 *
 *  @param scriptDelegate 代理对象
 *
 *  @return 返回当前实例
 */
+ (instancetype)webViewScriptMessageWithDelegate:(__weak id<WKScriptMessageHandler>)scriptDelegate;


@end
