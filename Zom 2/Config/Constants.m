//
//  Constants.m
//  Keanu
//
//  Created by Benjamin Erhart on 27.09.18.
//  Copyright © 2018 Guardian Project. All rights reserved.
//

#import "Constants.h"

#define MACRO_STRING_(m) #m
#define MACRO_STRING(m) @MACRO_STRING_(m)

@implementation Constants

+ (NSString *) appGroup {
    return MACRO_STRING(KEANU_APP_GROUP);
}

+ (NSString *) teamId {
    return MACRO_STRING(DEVELOPMENT_TEAM);
}

+ (NSString *) defaultHomeServer {
    return MACRO_STRING(KEANU_DEFAULT_HOME_SERVER);
}

+ (NSString *) defaultIdServer {
    return MACRO_STRING(KEANU_DEFAULT_ID_SERVER);
}

+ (NSString *) pushServer {
    return MACRO_STRING(KEANU_PUSH_SERVER);
}

+ (NSString *) universalLinkHost {
    return MACRO_STRING(KEANU_UNIVERSAL_LINK_HOST);
}

@end
