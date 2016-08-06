//
//  NSObject+CATPerformSelecter.h
//  Dome
//
//  Created by lbencs on 7/23/16.
//  Copyright © 2016 lben. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

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


@interface NSObject (CATExtentions)
/*  
 问题
 1. property vs ivar 的差别
 */
+ (NSArray <NSString *> * _Nonnull)at_allPropertyNames;
+ (NSArray <NSString *> * _Nonnull)at_allIvarNames;

- (NSDictionary * _Nonnull)at_modelToJSONObjc;
- (id _Nonnull)at_JSONObjcToModel:(NSDictionary * _Nonnull)jsonObjc;
- (NSArray * _Nonnull)at_JSONObjcArrayToModeArray:(NSArray * _Nonnull)jsonArray;
@end

@interface NSArray (CATExtentions)
- (NSArray * _Nonnull)at_arrayModelToJSONObjc;
@end


@interface CATEncodeTestModel : NSObject <NSCopying>{
    NSString *_ivarName;
}
@property (nonatomic, copy, nonnull) NSString *propertyName;
@property (nonatomic, copy, nonnull) NSDictionary *propertyCaches;
@property (nonatomic, assign) NSInteger propertyInteger;
@property (nonatomic, assign) CGFloat propertyFloat;
@property (nonatomic, assign) double propertyDouble;
@property (nonatomic, assign) BOOL propertyBool;
@property (nonatomic, strong, nullable) CATEncodeTestModel *model;
@property (nonatomic, strong, nullable) NSArray <CATEncodeTestModel *>* modelArray;
@end

