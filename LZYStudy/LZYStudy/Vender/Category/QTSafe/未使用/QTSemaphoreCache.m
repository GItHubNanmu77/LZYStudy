//
//  QTSemaphoreCache.m
//  QTCategory
//
//  Created by 张俊博 on 2018/9/3.
//

#import "QTSemaphoreCache.h"
#import <libkern/OSAtomic.h>
#import <pthread.h>
#import <fishhook/fishhook.h>

@interface QTSemaphoreCache : NSObject
{
@protected
    pthread_mutex_t     _mutex;
}

@property (nonatomic, strong) NSMutableDictionary *cache;

+ (QTSemaphoreCache *)sharedInterface;

@end

@implementation QTSemaphoreCache

static QTSemaphoreCache *_instance;
+ (id)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
- (id)copyWithZone:(NSZone *)zone { return _instance; }
- (id)mutableCopyWithZone:(NSZone *)zone { return _instance; }
+ (QTSemaphoreCache *)sharedInterface {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _cache = [NSMutableDictionary dictionary];
        pthread_mutex_init(&_mutex, NULL);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearCache) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearCache) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    pthread_mutex_destroy(&_mutex);
}

- (void)lock
{
    pthread_mutex_lock(&_mutex);
}

- (void)unlock
{
    pthread_mutex_unlock(&_mutex);
}

- (void)clearCache {
    [self lock];
    NSDictionary *dic = self.cache.copy;
    [self unlock];
    
    NSMutableArray *keys = [NSMutableArray array];
    NSMutableArray *values = [NSMutableArray array];
    
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (CFGetRetainCount((__bridge CFTypeRef)obj) == 2) {
            [keys addObject:key];
            [values addObject:obj];
        };
    }];
    
    [self lock];
    [self.cache removeObjectsForKeys:keys];
    [self unlock];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [values enumerateObjectsUsingBlock:^(dispatch_semaphore_t obj, NSUInteger idx, BOOL * _Nonnull stop) {
            while (dispatch_semaphore_signal(obj)) {}
        }];
    });
}


#pragma mark - Public

- (void)setObject:(id)anObject forKey:(id)aKey {
    if (!anObject||!aKey) {
        return;
    }
    [self lock];
    [self.cache setObject:anObject forKey:aKey];
    [self unlock];
}

@end

int32_t semCounter = 0;
static dispatch_semaphore_t (*origianl_dispatch_semaphore_create)(long);
dispatch_semaphore_t qt_dispatch_semaphore_create(long value) {
    dispatch_semaphore_t sem = origianl_dispatch_semaphore_create(value);
    uint32_t _counter = (uint32_t)OSAtomicIncrement32(&semCounter);
    [[QTSemaphoreCache sharedInterface] setObject:sem forKey:@(_counter)];
    return sem;
}

void swizzeSemaphore(int argc, char * argv[]) {
    // 初始化一个 rebinding 结构体
    struct rebinding semaphore_rebinding = { "dispatch_semaphore_create", qt_dispatch_semaphore_create, (void *)&origianl_dispatch_semaphore_create };
    // 将结构体包装成数组，并传入数组的大小，对原符号 dispatch_semaphore_create 进行重绑定
    rebind_symbols((struct rebinding[1]){semaphore_rebinding}, 1);
    // 调用 open 函数
    __unused int fd = open(argv[0], O_RDONLY);
}

void debugTest() {
    void (^blk)(void) = ^{
        dispatch_semaphore_t aSemaphore = dispatch_semaphore_create(1);
        dispatch_semaphore_wait(aSemaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"");
    };
    
//    void (^blk)(void) = ^{
//        dispatch_semaphore_t aSemaphore = dispatch_semaphore_create(0);
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            dispatch_semaphore_wait(aSemaphore, DISPATCH_TIME_FOREVER);
//            NSLog(@"1");
//            NSLog(@"1");
//        });
//    };
    
    blk();
}
