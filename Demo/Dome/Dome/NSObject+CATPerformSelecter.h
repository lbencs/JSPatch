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
