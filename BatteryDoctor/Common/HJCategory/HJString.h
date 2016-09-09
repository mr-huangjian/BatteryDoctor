//
//  HJString.h
//  WaaShow
//
//  Created by hj on 16/8/8.
//  Copyright © 2016年 ShanRuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extensin)

// 判断字符串为纯数字
- (BOOL)isPureInt;

/**
 *  @author feiyu, 08.11 16:08 2016
 *
 *  @brief 判断字符串对象是否包含subString字符串
 *
 *  @brief iOS 8以上系统也可使用[self containsString: subString]
 *
 *  @param subString 子字符串
 *
 *  @return 包含返回YES,不包含返回NO
 */
- (BOOL)isContainerString:(NSString *)subString;

@end
