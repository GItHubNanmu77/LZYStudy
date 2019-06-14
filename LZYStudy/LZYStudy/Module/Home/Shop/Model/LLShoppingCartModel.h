//
//  LLShoppingCartModel.h
//  LZYStudy
//
//  Created by cisdi on 2019/6/14.
//  Copyright © 2019 lzy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLShoppingCartModel : NSObject
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, assign) NSInteger count;
@end

NS_ASSUME_NONNULL_END
