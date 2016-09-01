//
//  WKWebViewController+PublicMethod.m
//  WKWebView
//
//  Created by Lili on 16/9/1.
//  Copyright © 2016年 LiliEhuu. All rights reserved.
//

#import "WKWebViewController+PublicMethod.h"
#import "NSString+JSON.h"

@implementation WKWebViewController (PublicMethod)

//重写添加公共消息处理
- (void)addPublicScriptMessageHandlers
{
    [self.webView addScriptMessageHandler:self funcSelector:@selector(userInfo:)];
}

//重写OC返回值处理
- (void)webView:(WKWebView *)webView didReceiveOCMethodReturnValue:(id)value selectorName:(NSString *)selName
{
    if ([selName isEqualToString:@"userInfo"])
    {
        NSString *script = [NSString stringWithFormat:@"ocCallJavaScriptFunction(\"%@\")", value];
        [self.webView evaluateJavaScript:script completionHandler:^(id _Nullable jsValue, NSError * _Nullable error) {
            if (error)
            {
                NSLog(@"JavaScript执行错误：%@", error.userInfo[NSLocalizedDescriptionKey]);
            }
        }];
    }
}

- (NSString *)userInfo:(id)json
{
    return [NSString stringWithFormat:@"name:Lili sex:%@", json];
}


@end
