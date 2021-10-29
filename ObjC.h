//
//  ObjC.h
//  Zom 2
//
//
// from: https://stackoverflow.com/questions/32758811/catching-nsexception-in-swift
//

#ifndef ObjC_h
#define ObjC_h

#import "ObjC.h"

#import <Foundation/Foundation.h>

@interface ObjC : NSObject

+ (BOOL)catchException:(void(^)(void))tryBlock error:(__autoreleasing NSError **)error;

@end

#endif /* ObjC_h */
