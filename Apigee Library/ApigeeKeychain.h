#import <Foundation/Foundation.h>

@interface ApigeeKeychain : NSObject {
}

+ (BOOL)setString:(NSString *)string forKey:(NSString *)key;
+ (NSString *)stringForKey:(NSString *)key;
+ (BOOL)deleteStringForKey:(NSString *)key;

@end
