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

- (NSString *)userInfo:(id)json
{
    return [NSString stringWithFormat:@"name:Lili sex:%@", json];
}


@end
