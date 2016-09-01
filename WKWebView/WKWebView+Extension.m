//
//  WKWebView+Extension.m
//  WKWebView
//
//  Created by LiliEhuu on 16/8/29.
//  Copyright © 2016年 LiliEhuu. All rights reserved.
//

#import "WKWebView+Extension.h"
#import "WKWebViewScriptMessage.h"

@implementation WKWebView (Extension)


+ (instancetype)webViewWithFrame:(CGRect)frame
{
    //配置
    WKWebViewConfiguration *cfg = [[WKWebViewConfiguration alloc] init];
    cfg.preferences.javaScriptEnabled = YES;        //允许JavaScript交互
    cfg.processPool = [[WKProcessPool alloc] init]; //使用进程池
    cfg.userContentController = [[WKUserContentController alloc] init];   //内容控制
    //初始化webView
    return [[WKWebView alloc] initWithFrame:frame configuration:cfg];
}

- (void)loadRequestURL:(NSString *)url
{
    NSURL *URL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    [self loadRequest:request];
}

- (void)loadPOSTRequestURL:(NSString *)url body:(NSString *)body
{
    //对url中有中文编码
    NSString *encodingUrl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:encodingUrl]];
    //设置头
    [request setValue:@"ios" forHTTPHeaderField:@"OS"];
    //设置类型
    [request setValue:@"text/html; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    //有json数据
    [request setHTTPMethod:@"POST"];
    //转码 UTF-8
    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self loadRequest:request];
}

- (void)loadHtmlFile:(NSString *)path
{
    if(path)
    {
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0)
        {
            // iOS9
            NSURL *fileURL = [NSURL fileURLWithPath:path];
            [self loadFileURL:fileURL allowingReadAccessToURL:fileURL];
        }
        else
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                // iOS8.
                NSURL *fileURL = [self fileURLForBuggyWKWebView8:[NSURL fileURLWithPath:path]];
                NSURLRequest *request = [NSURLRequest requestWithURL:fileURL];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self loadRequest:request];
                });
            });
        }
    }
}

//将文件copy到tmp目录
- (NSURL *)fileURLForBuggyWKWebView8:(NSURL *)fileURL
{
    NSError *error = nil;
    if (!fileURL.fileURL || ![fileURL checkResourceIsReachableAndReturnError:&error])
    {
        return nil;
    }
    // Create "/temp/www" directory
    NSFileManager *fileManager= [NSFileManager defaultManager];
    NSURL *temDirURL = [[NSURL fileURLWithPath:NSTemporaryDirectory()] URLByAppendingPathComponent:@"www"];
    [fileManager createDirectoryAtURL:temDirURL withIntermediateDirectories:YES attributes:nil error:&error];
    
    NSURL *dstURL = [temDirURL URLByAppendingPathComponent:fileURL.lastPathComponent];
    // Now copy given file to the temp directory
    [fileManager removeItemAtURL:dstURL error:&error];
    [fileManager copyItemAtURL:fileURL toURL:dstURL error:&error];
    // Files in "/temp/www" load flawlesly :)
    return dstURL;
}



- (void)addScriptMessageHandler:(id <WKScriptMessageHandler>)scriptMessageHandler funcSelector:(SEL)selector
{
    //获取方法名称
    NSString *methodName = NSStringFromSelector(selector);
    //去除 ":"
    NSRange range = [methodName rangeOfString:@":"];
    if (range.length)
    {
        NSMutableString *mString = [methodName mutableCopy];
        [mString deleteCharactersInRange:range];
        methodName = [mString copy];
    }
    
    //注册方法
    WKWebViewScriptMessage *scriptMesaage = [WKWebViewScriptMessage webViewScriptMessageWithDelegate:scriptMessageHandler];
    [self.configuration.userContentController addScriptMessageHandler:scriptMesaage name:NSStringFromSelector(selector)];
}



@end




