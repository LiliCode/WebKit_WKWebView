//
//  NSString+JSON.m
//  WKWebView
//
//  Created by LiliEhuu on 16/9/1.
//  Copyright © 2016年 LiliEhuu. All rights reserved.
//

#import "NSString+JSON.h"


@implementation NSString (JSON)

- (NSDictionary *)jsonToDictionary
{
    NSAssert(self, @"json字符串为空");
    
    NSData *json_data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:json_data options:0 error:&error];
    if(error)
    {
        NSLog(@"解析JSON错误详情:%@",error.description);
        return nil;
    }
    
    return dic;
}



@end
