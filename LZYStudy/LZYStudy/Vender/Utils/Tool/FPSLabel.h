//
//  FPSLabel.h
//  Pods
//
//  Created by 张俊博 on 16/9/6.
//
//

#import <UIKit/UIKit.h>

@interface FPSLabel : UILabel

@end

@interface WeakProxy : NSProxy

/**
 The proxy target.
 */
@property (nonatomic, weak) id target;

/**
 Creates a new weak proxy for target.
 
 @param target Target object.
 
 @return A new proxy object.
 */
- (instancetype)initWithTarget:(id)target;

/**
 Creates a new weak proxy for target.
 
 @param target Target object.
 
 @return A new proxy object.
 */
+ (instancetype)proxyWithTarget:(id)target;

@end
