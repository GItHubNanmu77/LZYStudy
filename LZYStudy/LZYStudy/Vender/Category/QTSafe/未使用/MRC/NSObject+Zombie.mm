//
//  NSObject+Zombie.m
//  QTCategory
//
//  Created by 张俊博 on 2018/4/11.
//  Copyright © 2018年 CISDI. All rights reserved.
//

#import "NSObject+Zombie.h"
#import "NSObject+QTAdd.h"
#import "malloc/malloc.h"
#import <objc/runtime.h>
#import <list>
#import "pthread.h"
#import <UIKit/UIKit.h>

//define
#define MAX_UNFREE_POINTER 2000  //最大2000个指针
#define MAX_UNFREE_MEM     1024*1024*10 //最大10MB
#define FREE_POINTER_NUM   100          //每次释放100个指针

typedef struct unfreeZombieMem {
    void *p;
    struct unfreeZombieMem *next;
}UNFREE_ZOMBIE_MEM, *P_UNFREE_ZOMBIE_MEM;

typedef struct unfreeZombieList {
    P_UNFREE_ZOMBIE_MEM header_list;
    P_UNFREE_ZOMBIE_MEM tail_list;
    size_t      unfree_count;
    size_t      unfree_size;
}UNFREE_ZOMBIE_LIST, *P_UNFREE_ZOMBIE_LIST;

P_UNFREE_ZOMBIE_LIST global_unfree_zombie_list = NULL;
static dispatch_queue_t global_zombie_queue() {
    static dispatch_queue_t global_zombie_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        global_zombie_queue = dispatch_queue_create("com.qingtui.im.zombie", DISPATCH_QUEUE_SERIAL);
    });
    
    return global_zombie_queue;
}

@class QTZombie;

void push(void *p) {
    if (!p) {
        return;
    }
    dispatch_async(global_zombie_queue(), ^{
        if (global_unfree_zombie_list == NULL) {
            global_unfree_zombie_list = (P_UNFREE_ZOMBIE_LIST)malloc(sizeof(UNFREE_ZOMBIE_LIST));
            global_unfree_zombie_list->header_list = (P_UNFREE_ZOMBIE_MEM)malloc(sizeof(UNFREE_ZOMBIE_MEM));
            global_unfree_zombie_list->header_list->p = NULL;
            global_unfree_zombie_list->header_list->next = NULL;
            global_unfree_zombie_list->tail_list = global_unfree_zombie_list->header_list;
            global_unfree_zombie_list->unfree_count = 0;
            global_unfree_zombie_list->unfree_size = 0;
        }
        
        if (global_unfree_zombie_list->unfree_count > MAX_UNFREE_POINTER * 0.9 || global_unfree_zombie_list->unfree_size > MAX_UNFREE_MEM) {
            if (global_unfree_zombie_list->header_list->next) {
                for (int i = 0; i < FREE_POINTER_NUM && global_unfree_zombie_list->header_list->next && global_unfree_zombie_list->unfree_count>0; i++) {
                    P_UNFREE_ZOMBIE_MEM memToDelete = global_unfree_zombie_list->header_list->next;
                    if (memToDelete == global_unfree_zombie_list->tail_list) {
                        global_unfree_zombie_list->tail_list = global_unfree_zombie_list->header_list;
                    }
                    global_unfree_zombie_list->header_list->next = memToDelete->next;
                    global_unfree_zombie_list->unfree_size -= malloc_size(memToDelete->p);
                    global_unfree_zombie_list->unfree_count--;
                    //                    if (memToDelete->p && [(NSObject *)memToDelete->p isKindOfClass:NSClassFromString(@"QTZombie")]) {
                    //                        free(memToDelete->p);
                    //                        free(memToDelete);
                    //                    }
                    
                    if (memToDelete->p) {
                        free(memToDelete->p);
                    }
                    free(memToDelete);
                }
            }
        }
        
        P_UNFREE_ZOMBIE_MEM unfreeMem = (P_UNFREE_ZOMBIE_MEM)malloc(sizeof(UNFREE_ZOMBIE_MEM));
        unfreeMem->p = p;
        unfreeMem->next = NULL;
        
        global_unfree_zombie_list->tail_list->next = unfreeMem;
        global_unfree_zombie_list->tail_list = unfreeMem;
        global_unfree_zombie_list->unfree_count++;
        global_unfree_zombie_list->unfree_size += malloc_size(p);
    });
}

#pragma mark - QTZombieTest

@interface QTZombieTest : NSObject
@property (nonatomic, copy) NSString *name;
- (void)test;
@end
@implementation QTZombieTest
- (void)dealloc {
    [_name release];
    [super dealloc];
    NSLog(@"QTZombieTest dealloced");
}
- (void)test {
    NSLog(@"QTZombieTest test");
}
@end

#pragma mark - QTZombie

@interface QTZombie : NSObject
+ (void)enableZombie;
+ (void)addClassToZombieService:(NSString *)className;
@end


@implementation QTZombie {
    BOOL _isZombieEnabled;
    NSMutableArray<Class> *_classesThatEnablesZombie;
}

+ (instancetype)sharedZombie {
    static QTZombie* sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        _isZombieEnabled = NO;
        _classesThatEnablesZombie = [[NSMutableArray alloc] init];
        return self;
    }
    return nil;
}

- (void)dealloc {
    [_classesThatEnablesZombie removeAllObjects];
    [_classesThatEnablesZombie release];
    [super dealloc];
}

+ (void)enableZombie {
    [[self sharedZombie] enableZombie];
}

- (void)enableZombie {
    _isZombieEnabled = YES;
}

+ (void)addClassToZombieService:(NSString *)className {
    Class cls = objc_getClass([className UTF8String]);
    QTZombie *zombie = [self sharedZombie];
    [zombie->_classesThatEnablesZombie addObject:cls];
}

+ (BOOL)hasAddClassToZombieService:(Class)cls {
//    return YES;
    QTZombie *zombie = [QTZombie sharedZombie];
    return zombie->_isZombieEnabled
            && ([zombie->_classesThatEnablesZombie containsObject:cls]
                ||[NSStringFromClass(cls) hasPrefix:@"QT"])
            &&![cls isKindOfClass:[UIImage class]]
            &&![cls isKindOfClass:[UIResponder class]]
            &&![cls isSubclassOfClass:[UIResponder class]]
            &&![cls isKindOfClass:NSClassFromString(@"ASDisplayNode")]
            &&![cls isSubclassOfClass:NSClassFromString(@"ASDisplayNode")];
}

@end

@implementation NSObject (Zombie)

+ (void)enableZombie{
    [QTZombie enableZombie];
    [QTZombie addClassToZombieService:@"QTChatFileCache"];
    
//    [QTZombie addClassToZombieService:@"QTZombieTest"];
//    [self testZombie];
}

-(BOOL)zombie_dealloc {
    
    if (![QTZombie hasAddClassToZombieService:object_getClass(self)]) {
        return NO;
    }
    
    objc_destructInstance(self);
    object_setClass(self, [QTZombie class]);
    push(self);
    
    return YES;
}

#pragma mark - Debug

+ (void)testZombie {
//    for (NSInteger i = 0; i<1000; ++i) {
//        __unsafe_unretained QTZombieTest *obj = nil;
//        @autoreleasepool {
//            QTZombieTest *test = [[QTZombieTest alloc] init];
//            obj = test;
//            [test release];
//        }
//        [obj performSelector:@selector(test)];
//    }
}

@end
