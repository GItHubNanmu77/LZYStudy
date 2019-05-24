//
//  NSObject+QTAdd.h
//  Pods
//
//  Created by 张俊博 on 16/8/22.
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (QTAdd)

#pragma mark - Sending messages with variable parameters
///=============================================================================
/// @name Sending messages with variable parameters
///=============================================================================

/**
 Sends a specified message to the receiver and returns the result of the message.
 
 @param sel    A selector identifying the message to send. If the selector is
 NULL or unrecognized, an NSInvalidArgumentException is raised.
 
 @param ...    Variable parameter list. Parameters type must correspond to the
 selector's method declaration, or unexpected results may occur.
 It doesn't support union or struct which is larger than 256 bytes.
 
 @return       An object that is the result of the message.
 
 @discussion   The selector's return value will be wrap as NSNumber or NSValue
 if the selector's `return type` is not object. It always returns nil
 if the selector's `return type` is void.
 
 Sample Code:
 
 // no variable args
 [view performSelectorWithArgs:@selector(removeFromSuperView)];
 
 // variable arg is not object
 [view performSelectorWithArgs:@selector(setCenter:), CGPointMake(0, 0)];
 
 // perform and return object
 UIImage *image = [UIImage.class performSelectorWithArgs:@selector(imageWithData:scale:), data, 2.0];
 
 // perform and return wrapped number
 NSNumber *lengthValue = [@"hello" performSelectorWithArgs:@selector(length)];
 NSUInteger length = lengthValue.unsignedIntegerValue;
 
 // perform and return wrapped struct
 NSValue *frameValue = [view performSelectorWithArgs:@selector(frame)];
 CGRect frame = frameValue.CGRectValue;
 */
- (nullable id)performSelectorWithArgs:(SEL)sel, ...;

/**
 Invokes a method of the receiver on the current thread using the default mode after a delay.
 
 @warning      It can't cancelled by previous request.
 
 @param sel    A selector identifying the message to send. If the selector is
 NULL or unrecognized, an NSInvalidArgumentException is raised immediately.
 
 @param delay  The minimum time before which the message is sent. Specifying
 a delay of 0 does not necessarily cause the selector to be
 performed immediately. The selector is still queued on the
 thread's run loop and performed as soon as possible.
 
 @param ...    Variable parameter list. Parameters type must correspond to the
 selector's method declaration, or unexpected results may occur.
 It doesn't support union or struct which is larger than 256 bytes.
 
 Sample Code:
 
 // no variable args
 [view performSelectorWithArgs:@selector(removeFromSuperView) afterDelay:2.0];
 
 // variable arg is not object
 [view performSelectorWithArgs:@selector(setCenter:), afterDelay:0, CGPointMake(0, 0)];
 */
- (void)performSelectorWithArgs:(SEL)sel afterDelay:(NSTimeInterval)delay, ...;

/**
 Invokes a method of the receiver on the current thread after a delay.
 
 @warning     arc-performSelector-leaks
 
 @param sel   A selector that identifies the method to invoke. The method should
 not have a significant return value and should take no argument.
 If the selector is NULL or unrecognized,
 an NSInvalidArgumentException is raised after the delay.
 
 @param delay The minimum time before which the message is sent. Specifying a
 delay of 0 does not necessarily cause the selector to be performed
 immediately. The selector is still queued on the thread's run loop
 and performed as soon as possible.
 
 @discussion  This method sets up a timer to perform the aSelector message on
 the current thread's run loop. The timer is configured to run in
 the default mode (NSDefaultRunLoopMode). When the timer fires, the
 thread attempts to dequeue the message from the run loop and
 perform the selector. It succeeds if the run loop is running and
 in the default mode; otherwise, the timer waits until the run loop
 is in the default mode.
 */
- (void)performSelector:(SEL)sel afterDelay:(NSTimeInterval)delay;


#pragma mark - Swap method (Swizzling)
///=============================================================================
/// @name Swap method (Swizzling)
///=============================================================================

/**
 Swap two instance method's implementation in one class. Dangerous, be careful.
 
 @param originalSel   Selector 1.
 @param newSel        Selector 2.
 @return              YES if swizzling succeed; otherwise, NO.
 */
+ (BOOL)swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel;

/**
 Swap two class method's implementation in one class. Dangerous, be careful.
 
 @param originalSel   Selector 1.
 @param newSel        Selector 2.
 @return              YES if swizzling succeed; otherwise, NO.
 */
+ (BOOL)swizzleClassMethod:(SEL)originalSel with:(SEL)newSel;

+ (BOOL)swizzleInstanceMethod:(SEL)srcSel tarClass:(Class)tarClass tarSel:(SEL)tarSel;

#pragma mark - Others
///=============================================================================
/// @name Others
///=============================================================================

/**
 Returns the class name in NSString.
 
 @discussion Apple has implemented this method in NSObject(NSLayoutConstraintCallsThis),
 but did not make it public.
 */
- (NSString *)className;

- (NSDictionary *)qt_dictionary;

- (NSComparisonResult)compare:(NSObject *)object;

@end

NS_ASSUME_NONNULL_END
