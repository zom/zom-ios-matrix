//
//  Constants.h
//  Keanu
//
//  Created by Benjamin Erhart on 27.09.18.
//  Copyright © 2018 Guardian Project. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject

@property (class, nonatomic, assign, readonly) NSString *appGroup;

@property (class, nonatomic, assign, readonly) NSString *teamId;

@property (class, nonatomic, assign, readonly) NSString *defaultHomeServer;

@property (class, nonatomic, assign, readonly) NSString *defaultIdServer;

@property (class, nonatomic, assign, readonly) NSString *pushServer;

@property (class, nonatomic, assign, readonly) NSString *appGroupId;

@property (class, nonatomic, assign, readonly) NSString *universalLinkHost;

@property (class, nonatomic, assign, readonly) NSString *useNewVerificationBeta;

@end
