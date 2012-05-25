//
//  NSString+UUID.m
//  yidu
//
//  Created by Hongbo Chen on 12-5-13.
//  Copyright (c) 2012年 広島大学. All rights reserved.
//

#import "NSString+UUID.h"

@implementation NSString(UUID)
+(NSString *)newUUIDString{
	// Create a new UUID
	/* kCFAllocatorDefault is a synonym for NULL, if you'd rather use a named constant. */
    CFUUIDRef uuidObj = CFUUIDCreate(kCFAllocatorDefault);
    
    // Get the string representation of the UUID
    NSString *uuidString = (__bridge NSString*)CFUUIDCreateString(kCFAllocatorDefault, uuidObj);
    CFRelease(uuidObj);
    return uuidString;
}
@end