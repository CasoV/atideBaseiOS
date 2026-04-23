//
//  NSDictionary+MyLog.m
//  AutoTest
//
//  Created by 武耀琳 on 2021/12/31.
//

#import "NSDictionary+MyLog.h"

@implementation NSDictionary (MyLog)
- (NSString *)descriptionWithLocale:(id)locale {
    NSArray *allKeys = [self allKeys];
    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"{\t\n "];
    for (NSString *key in allKeys) {
        id value = self[key];
        [str appendFormat:@"\t \"%@\" = %@,\n", key, value];
    }
    [str appendString:@"}"];
    return str;
}
@end
