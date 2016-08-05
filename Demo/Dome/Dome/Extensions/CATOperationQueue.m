//
//  CATOperationQueue.m
//  Dome
//
//  Created by lben on 7/28/16.
//  Copyright © 2016 lben. All rights reserved.
//

#import "CATOperationQueue.h"


NSOperationQueue* CATActionOperationQueue(){
	static dispatch_once_t onceToken;
	static NSOperationQueue *queue = nil;
	dispatch_once(&onceToken, ^{
		queue = [[NSOperationQueue alloc] init];
		queue.maxConcurrentOperationCount = 3;
		queue.qualityOfService = NSQualityOfServiceUtility;
	});
	return queue;
}

@interface CATOperationQueue ()
@end

@implementation CATOperationQueue

+ (void)main:(JSContext *)context
{
	context[@"_executeActionWhenUserInitiated"] = ^(JSValue *funcValue){
		[CATActionOperationQueue() addOperationWithBlock:^{
			[funcValue callWithArguments:nil];
		}];
	};
    
	context[@"_printStock"] = ^(){
		NSLog(@"%@",[NSThread callStackSymbols]);
	};
}

@end
