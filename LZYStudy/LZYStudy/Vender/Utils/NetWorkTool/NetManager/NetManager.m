//
//  NetManager.m
//  LZYStudy
//
//  Created by cisdi on 2019/5/7.
//  Copyright © 2019 lzy. All rights reserved.
//

#import "NetManager.h"
#import <AFNetworking/AFNetworking.h>
#import "MBProgressHUD.h"

static NetManager *_netManager;

@interface NetManager()
@property (nonatomic, strong) NSURLSessionConfiguration *configuration;
@property (nonatomic, strong) AFURLSessionManager *manager;
@end

@implementation NetManager

+(NetManager *)shareInstance
{
    static dispatch_once_t oneToken;
    
    dispatch_once(&oneToken, ^{
        _netManager = [[NetManager alloc]init];
    });
    return _netManager;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:_configuration];
        AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
        responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json", @"text/javascript",@"text/plain", nil];
        _manager.responseSerializer = responseSerializer;
    }
    return self;
}


- (void)requestPost:(NSString *)url param:(NSDictionary*)params withVC:(UIViewController*)vc successBlock:(void(^)(id resobject))successBlock failurBlock:(void(^)(NSError *error))errorBlock withShowHUD:(BOOL)show{
    [self requestMethod:@"POST" url:url param:params withVC:vc successBlock:successBlock failurBlock:errorBlock withShowHUD:show];
}

- (void)requestGet:(NSString *)url param:(NSDictionary*)params withVC:(UIViewController*)vc successBlock:(void(^)(id resobject))successBlock failurBlock:(void(^)(NSError *error))errorBlock withShowHUD:(BOOL)show{
    [self requestMethod:@"GET" url:url param:params withVC:vc successBlock:successBlock failurBlock:errorBlock withShowHUD:show];
}

- (void)requestMethod:(NSString *)method url:(NSString *)url param:(NSDictionary*)params withVC:(UIViewController*)vc successBlock:(void(^)(id resobject))successBlock failurBlock:(void(^)(NSError *error))errorBlock withShowHUD:(BOOL)show{
    
    MBProgressHUD *hud;
    UIView *view;
    if(vc){
        view = vc.view;
    }else{
        view = [[UIApplication sharedApplication].windows lastObject];
    }
    if(show){
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    
//    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASEURL,url];
    NSString *urlStr = @"";
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:method URLString:urlStr parameters:params error:nil];
    
    NSURLSessionDataTask *dataTask = [self.manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if(show){
//            [MBProgressHUD hideHUDForView:view];
        }
        if (error) {
            NSLog(@"%@\nError: %@", urlStr,error);
            if(errorBlock){
                errorBlock(error);
            }
        } else {
            NSLog(@"%@\n%@\n结果：%@",urlStr,params,responseObject);
//            NSInteger code = [responseObject jk_integerForKey:@"code"];
//            if(code == 403 || code == 201 || code == 401 || code == 404){
//                NSString *msg = [responseObject jk_stringForKey:@"msg"];
//                [MBProgressHUD showToastMessage:msg toView:view];
//            }else {
//                if(successBlock){
//                    successBlock(responseObject);
//                }
//            }
        }
    }];
    [dataTask resume];
}
@end
