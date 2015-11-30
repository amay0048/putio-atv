//
//  File.h
//  putio-atv
//
//  Created by Anthony May on 19/11/2015.
//  Copyright © 2015 The Means. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface File : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (instancetype)initAsRoot;
- (NSString *)getfolderTypeString;

- (void)setObject:(NSObject *)object forChildKey:(NSString *)key;
- (NSMutableDictionary *)getChildren;

@property (nonatomic, copy) NSNumber *identifier;
@property (nonatomic, copy) NSNumber *parentIdentifier;
@property (nonatomic, copy) NSNumber *mpfour;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, strong) NSDate *releaseDate;

@property (nonatomic, copy) NSString *shortDescription;
@property (nonatomic, copy) NSString *mediumDescription;
@property (nonatomic, copy) NSString *longDescription;

@property (nonatomic, strong) NSURL *thumbnailURL;

@property (nonatomic, strong) NSArray *versions;
@property (nonatomic, copy) NSURL *mpfourURL;
@property (nonatomic, copy) NSString *mpfourRoute;

@property (nonatomic, strong) NSMutableDictionary *children;

//@property (nonatomic, strong) EpisodeVersion *originalVersion;
//
//@property (nonatomic, strong) EpisodeVersion *audioDescribedVersion;
//
//@property (nonatomic, strong) EpisodeVersion *signedVersion;

@end
