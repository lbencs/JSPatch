//
//  CATForwardInvocation.m
//  Dome
//
//  Created by lben on 7/28/16.
//  Copyright © 2016 lben. All rights reserved.
//

#import "CATForwardInvocation.h"
#import "Dome-swift.h"


@interface CATForwardInvocation ()
@end

@implementation CATForwardInvocation

- (void)testFunction
{
	NSLog(@"%@",NSStringFromSelector(_cmd));
}
- (BOOL)testFunction:(NSString *)message
{
	return message.length <= 0;
}
- (BOOL)CATTestFunction:(NSString *)message
{
	return message.length > 0;
}
- (NSString *)testFunction:(NSString *)message from:(NSString *)from
{
	return [message stringByAppendingString:from];
}

- (NSString *)CATNotFundMethod:(NSString *)message
{
	return message;
}

- (void)swizzle
{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		[[self class] swizzleMethods:@selector(forwardInvocation:) withSelector:@selector(CATForwardInvocation:)];
		[[self class] swizzleMethods:@selector(testFunction:) withSelector:@selector(CATTestFunction:)];
	});
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
	NSLog(@"%@",NSStringFromSelector(aSelector));
	if ([self respondsToSelector:aSelector]) {
		return [self methodSignatureForSelector:aSelector];
	}else{
		return [self.array methodSignatureForSelector:aSelector];
	}
	return nil;
}
- (void)CATForwardInvocation:(NSInvocation *)anInvocation
{
	NSLog(@"%@",anInvocation.description);
	
	NSLog(@"%@",anInvocation.description);
	id target = [self.array methodSignatureForSelector:[anInvocation selector]] ? _array : self;
	[anInvocation invokeWithTarget:target];
}
- (NSMethodSignature *)CATMethodSignatureForSelector:(SEL)aSelector
{
	NSLog(@"%@",NSStringFromSelector(aSelector));
	return nil;
}



- (NSMutableArray *)array
{
	if (!_array) {
		_array = [[NSMutableArray alloc] init];
	}
	return _array;
}

@end
