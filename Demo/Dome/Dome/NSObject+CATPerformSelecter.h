//
//  NSObject+CATPerformSelecter.h
//  Dome
//
//  Created by lbencs on 7/23/16.
//  Copyright © 2016 lben. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSObject (CATPerformSelecter)

- (_Nullable id)at_performSelector:(_Nonnull SEL)aSelector;
- (_Nullable id)at_performSelector:(_Nonnull SEL)aSelector withObject:(_Nullable id)aObject;
- (_Nullable id)at_performSelector:(_Nonnull SEL)aSelector args:(va_list)args;

@end


@interface NSObject (CATRuntime)

- (BOOL)at_testMethodForSelector;

- (BOOL)at_testSwizzleMethod;

- (BOOL)at_testReplaceMethod;
@end


@interface NSObject (CATExtentions)<NSCopying>

/*  
 问题
 1. property vs ivar 的差别
 */
+ (NSArray <NSString *> * _Nonnull)at_allPropertyNames;
+ (NSArray <NSString *> * _Nonnull)at_allIvarNames;

@end


@interface CATEncodeTestModel : NSObject{
    NSString *_ivarName;
}
@property (nonatomic, copy, nonnull) NSString *propertyName;
@property (nonatomic, copy, nonnull) NSDictionary *propertyCaches;
@end

