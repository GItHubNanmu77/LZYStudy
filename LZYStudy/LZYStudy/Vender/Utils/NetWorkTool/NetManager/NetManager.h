//
//  NetManager.h
//  LZYStudy
//
//  Created by cisdi on 2019/5/7.
//  Copyright © 2019 lzy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetManager : NSObject

+(NetManager *)shareInstance;

- (void)requestPost:(NSString *)url param:(NSDictionary*)params withVC:(UIViewController*)vc successBlock:(void(^)(id resobject))successBlock failurBlock:(void(^)(NSError *error))errorBlock withShowHUD:(BOOL)show;


- (void)requestGet:(NSString *)url param:(NSDictionary*)params withVC:(UIViewController*)vc successBlock:(void(^)(id resobject))successBlock failurBlock:(void(^)(NSError *error))errorBlock withShowHUD:(BOOL)show;
@end

NS_ASSUME_NONNULL_END

