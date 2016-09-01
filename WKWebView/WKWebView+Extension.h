//
//  WKWebView+Extension.h
//  WKWebView
//
//  Created by LiliEhuu on 16/8/29.
//  Copyright © 2016年 LiliEhuu. All rights reserved.
//

#import <WebKit/WebKit.h>

@interface WKWebView (Extension)

/**
 *  创建WKWebView 并初始化
 *
 *  @param frame webView的frame
 *
 *  @return 返回当前webView
 */
+ (instancetype)webViewWithFrame:(CGRect)frame;

/**
 *  加载请求
 *
 *  @param url 请求的链接
 */
- (void)loadRequestURL:(NSString *)url;

/**
 *  加载POST请求
 *
 *  @param url  POST请求链接
 *  #paran body body
 */
- (void)loadPOSTRequestURL:(NSString *)url body:(NSString *)body;

/**
 *  加载本地网页文件
 *
 *  @param path 文件路径
 */
- (void)loadHtmlFile:(NSString *)path;

/**
 *  向WebView插入OC方法
 *
 *  @param scriptMessageHandler 消息处理者
 *  @param selector             OC 方法选择器
 */
- (void)addScriptMessageHandler:(id <WKScriptMessageHandler>)scriptMessageHandler funcSelector:(SEL)selector;

/**
 *  删除全部消息处理
 */
- (void)removeAllScriptMessageHandler;


@end





