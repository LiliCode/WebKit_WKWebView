//
//  WKWebViewController.h
//  WKWebView
//
//  Created by LiliEhuu on 16/9/1.
//  Copyright © 2016年 LiliEhuu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebProgressView.h"
#import "NSString+JSON.h"

#define VIRTUAL_FUNC

@protocol OCReturnValueDelegate <NSObject>

@optional
/**
 *  接收到OC方法返回值的虚函数
 *
 *  @param webView 当前WebView
 *  @param value   OC方法的返回值
 *  @param selName 返回值的选择器名称
 */
VIRTUAL_FUNC - (void)webView:(WKWebView *)webView didReceiveOCMethodReturnValue:(id)value selectorName:(NSString *)selName;

@end

@interface WKWebViewController : UIViewController<WKNavigationDelegate, WKScriptMessageHandler, WKUIDelegate, OCReturnValueDelegate>

@property (strong , nonatomic , readonly) WKWebView *webView;



@end
