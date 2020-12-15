//
//  XXXSS.m
//  XXBestZipXX
//
//  Created by wei li on 2019/10/16.
//  Copyright © 2019 LJ. All rights reserved.
//

#import "XXXSS.h"
#import "SettingsModel.h"
#import <objc/objc.h>
#import <objc/runtime.h>
#import <AppKit/AppKit.h>
@protocol TTX <NSObject>

+ (id<TTX>)sharedManager;
- (id<TTX>)model;
- (void)setProEditionAvaliable:(BOOL)Z;
- (void)productsWithIdentifiers_0:(NSSet *)identifiers
                          success:(void (^)(NSArray *products, NSArray *invalidIdentifiers))success
                          failure:(void (^)(NSError *error))failure;

- (void)productsWithIdentifiers:(NSSet *)identifiers
                          success:(void (^)(NSArray *products, NSArray *invalidIdentifiers))success
                          failure:(void (^)(NSError *error))failure;

- (BOOL)hasBoughtProduct:(NSString *)str;

- (BOOL)hasBoughtProVersion;
@end

@interface XXXSS()
@property (nonatomic,copy)id paymentQueueRestoreSuccess;
@property (nonatomic,copy)id paymentQueueRestoreFailure;

@end
@implementation XXXSS
+ (void)load{
    NSLog(@"00000xxxxxxxx");
    
    
    NSUserDefaults *s = [NSUserDefaults standardUserDefaults];
    NSString *str = [s stringForKey:@"com.betterzip.settings"];
    NSLog(@"%@",str);
    if (str.length == 0) {
        [s  setObject:@"b315ed055787c0994d8a7b08b2be9244" forKey:@"c743f6c69347b64850327e356f9e55f4201"];
        [s synchronize];
    }
    else{
        @try {
            NSMutableDictionary *dic =  [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers  error:nil];
            
//            NSNumber *num = dic[@"it"];
            NSDate *date = [NSDate dateWithTimeIntervalSinceNow: 24 * 3600 * 100];
            NSTimeInterval t = [date timeIntervalSince1970];
            dic[@"it"] = @(t);
            
            NSData *dat = [NSJSONSerialization dataWithJSONObject:dic  options:0 error:nil];
            NSString *str2 =  [[NSString alloc] initWithData:dat  encoding:NSUTF8StringEncoding];
            [s setObject:str2 forKey:@"com.betterzip.settings"];
            [s synchronize];
            
            NSLog(@"== %@",str2);
            Class cls = NSClassFromString(@"SettingsModel");
            NSLog(@"cls :%@   ",cls);
            [XXXSS swizzClass:cls oriSel:@selector(trialVersionDays) sel2:@selector(trialVersionDays)];
//            [XXXSS swizzClass:cls oriSel:@selector(proEditionAvaliable) sel2:@selector(proEditionAvaliable)];
//            [XXXSS swizzClass:NSClassFromString(@"CargoBay") oriSel:@selector(productsWithIdentifiers:success:failure:) sel2:@selector(productsWithIdentifiers:success:failure:)];
            
            Class CargoBay = NSClassFromString(@"CargoBay");
            NSLog(@"== %@",CargoBay);
            [XXXSS addMethodTo:CargoBay fromSel:NSSelectorFromString(@"productsWithIdentifiers:success:failure:") toSel:NSSelectorFromString(@"productsWithIdentifiers_0:success:failure:")];
            
            
//
            [XXXSS swizzClass:CargoBay fromClass:CargoBay oriSel:NSSelectorFromString(@"productsWithIdentifiers_0:success:failure:") sel2:NSSelectorFromString(@"productsWithIdentifiers:success:failure:")];
            
            
            
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
       
    }
}


+ (void)swizzClass:(Class) cls  fromClass: (Class) cls2 oriSel:(SEL) oriSel sel2:(SEL)se2{
    
    Method  origin    = class_getInstanceMethod(cls2, oriSel);
    Method  target  = class_getInstanceMethod(cls, se2);
    if (!origin) {
        NSLog(@"origin");
    }
    if (!target) {
        NSLog(@"target");
    }
    
    
    // 然后用我们自己的函数的实现，替换目标函数对应的实现
    IMP impT = method_getImplementation(target);
    IMP impO = method_getImplementation(origin);
    if (!impO) {
        NSLog(@"impO");
    }
    if (!impT) {
        NSLog(@"impT");
    }
    class_replaceMethod(cls, oriSel , impT, method_getTypeEncoding(origin));
    class_replaceMethod(cls2, se2 , impO, method_getTypeEncoding(target));
}


+ (void)swizzClass:(Class) cls  oriSel:(SEL) oriSel sel2:(SEL)se2{
    Method  origin    = class_getInstanceMethod(cls, oriSel);
    Method   target  = class_getInstanceMethod(self, se2);
    
    // 然后用我们自己的函数的实现，替换目标函数对应的实现
    IMP impT = method_getImplementation(target);
    IMP impO = method_getImplementation(origin);
    class_replaceMethod(cls, oriSel , impT, method_getTypeEncoding(origin));
    class_replaceMethod(self, se2 , impO, method_getTypeEncoding(target));
}



+ (void)addMethodTo:(Class) cls   fromSel:(SEL) fromSel toSel:(SEL)se2{
    
    Method  origin    = class_getInstanceMethod(self, fromSel);
    NSLog(@"=1232131");

    
    // 然后用我们自己的函数的实现，替换目标函数对应的实现
    IMP impO = method_getImplementation(origin);
    BOOL r = class_addMethod(cls, se2, impO, method_getTypeEncoding(origin));
    NSLog(@"%s %d",__func__,r);
}


- (NSInteger) trialVersionDays{
    
    static int z = -100;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        z -= arc4random_uniform(300);
    });
    NSLog(@"%s  %d",__FUNCTION__ ,z );
    return z ;
}

- (BOOL)proEditionAvaliable{
    NSLog(@"%s",__FUNCTION__);
    return 0;
}


- (void)productsWithIdentifiers:(NSSet *)identifiers
                        success:(void (^)(NSArray *products, NSArray *invalidIdentifiers))success
                        failure:(void (^)(NSError *error))failure{
    
    
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"%@",identifiers);
  
   
    
    if (success) {
        success(nil,nil);
    }
    return;
    
//    id<TTX> bay = (id<TTX>)self;
//
//
//    void (^success2)(NSArray *products, NSArray *invalidIdentifiers) = ^(NSArray *products, NSArray *invalidIdentifiers){
//        NSLog(@"%@  %@",products,invalidIdentifiers);
//        if (success) {
//
//            success(products,invalidIdentifiers);
//        }
//
//    };
//    void (^failure2)(NSError *error) = ^(NSError *error){
//        NSLog(@"EEE: %@",error);
//        if (failure) {
//            failure(error);
//        }
//
//    };
//
//    [bay  productsWithIdentifiers_0:identifiers success:[success2 copy] failure:[failure2 copy]];
//    return;
}


- (BOOL)hasBoughtProduct:(NSString *)str{
    NSLog(@"%s %@",__func__,str);
    return YES;
}

- (BOOL)hasBoughtProVersion{
    return YES;
}
@end



