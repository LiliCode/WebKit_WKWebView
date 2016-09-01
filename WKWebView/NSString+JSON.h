//
//  NSString+JSON.h
//  WKWebView
//
//  Created by LiliEhuu on 16/9/1.
//  Copyright © 2016年 LiliEhuu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JSON)

/**
 *  json转换成字典
 *
 *  @return 返回字典对象
 */
- (NSDictionary *)jsonToDictionary;


@end
