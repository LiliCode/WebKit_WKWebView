//
//  WebProgressView.h
//  WKWebView
//
//  Created by LiliEhuu on 16/8/31.
//  Copyright © 2016年 LiliEhuu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKWebView+Extension.h"

@interface WebProgressView : UIProgressView

/**
 *  创建并初始化进度条
 *
 *  @param webView 需要监听的webView
 *
 *  @return 返回进度条
 */
+ (instancetype)progressViewWithWebView:(WKWebView *)webView;


@end
