//
//  LLCenterDetailPostRequest.h
//  LZYStudy
//
//  Created by cisdi on 2019/6/5.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "LZYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLCenterDetailPostRequest : LZYBaseRequest

- (id)initPreWarningDetailWithoutTokenAPI:(NSString *)recordId ;
@end

NS_ASSUME_NONNULL_END
