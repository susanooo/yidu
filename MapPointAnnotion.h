//
//  MapPointAnnotion.h
//  yidu
//
//  Created by 智超 常 on 12-5-9.
//  Copyright (c) 2012年 広島大学. All rights reserved.
//

#import "BMKPointAnnotation.h"
#import "BMapKit.h"
#import <Foundation/Foundation.h>

@interface MapPointAnnotion : BMKPointAnnotation
{
    int tag;
    NSString *description;

}
@property(nonatomic,assign)int tag;
@property(nonatomic,copy)NSString *description;

@end
