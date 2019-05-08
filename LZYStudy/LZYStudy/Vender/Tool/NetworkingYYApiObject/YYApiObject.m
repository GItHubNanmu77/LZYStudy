//
//  YYApiObject.m
//  Project
//
//  Created by luowei on 2018/11/21.
//  Copyright © 2018年 luowei. All rights reserved.
//

#import "YYApiObject.h"

@implementation YYApiObject

- (NSString*)apiUrl{
    return @"";
}

//请求方法默认POST(POST、GET)
- (NSString*)method{
    return @"POST";
}

//是否缓存
- (BOOL)isCache{
    return FALSE;
}

//是否显示hud
- (BOOL)isShowHud{
    return TRUE;
}

//加载提示信息
- (NSString*)hudTips{
    return nil;
}


//缓存数据表扩展名
- (NSString*)getTableNameExt{
    return @"";
}

- (NSString *)getItemIDExt {
    if(self.isCache)
    {
        NSAssert(NO, @"subClass must implement the method: getItemIDExt");
    }
    return @"";
}
@end
