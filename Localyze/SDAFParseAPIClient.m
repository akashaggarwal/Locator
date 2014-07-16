//
//  SDAFParseAPIClient.m
//  SignificantDates
//
//  Created by Chris Wagner on 7/1/12.
//

#import "SDAFParseAPIClient.h"
#import "AFJSONRequestOperation.h"

static NSString * const kSDFParseAPIBaseURLString = @"https://api.parse.com/1/";
//aggarwal_akasha@yahoo.com
//static NSString * const kSDFParseAPIApplicationId = @"IToimyP9lliu67PNs7NiVvLhlzZ8OiViBx2PEFL4";
//static NSString * const kSDFParseAPIKey = @"YhFWoJNrZbw7GEy7K2df6DUwFZK8hRSAdRsOK1A4";

// aggarwal_akasha@icloud.com
static NSString * const kSDFParseAPIApplicationId = @"jD36OAJeoal3TstpoCixDp0ugsrZzjXreHE1tNbr";
static NSString * const kSDFParseAPIKey = @"pvM4eIqNuwa4wuOmB0ual1ONRBPB5OQkBolj2Rbb";






@implementation SDAFParseAPIClient

+ (SDAFParseAPIClient *)sharedClient {
    static SDAFParseAPIClient *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[SDAFParseAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kSDFParseAPIBaseURLString]];
    }); 
    
    return sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setParameterEncoding:AFJSONParameterEncoding];
        [self setDefaultHeader:@"X-Parse-Application-Id" value:kSDFParseAPIApplicationId];
        [self setDefaultHeader:@"X-Parse-REST-API-Key" value:kSDFParseAPIKey];
    }
    
    return self;
}

- (NSMutableURLRequest *)GETRequestForClass:(NSString *)className parameters:(NSDictionary *)parameters {
    NSMutableURLRequest *request = nil;
    request = [self requestWithMethod:@"GET" path:[NSString stringWithFormat:@"classes/%@", className] parameters:parameters];
    return request;
}

- (NSMutableURLRequest *)GETRequestForAllRecordsOfClass:(NSString *)className updatedAfterDate:(NSDate *)updatedDate {
    NSMutableURLRequest *request = nil;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *limit = @"1000";
    
    
    if (updatedDate) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.'999Z'"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        
        NSString *jsonString = [NSString 
                                stringWithFormat:@"{\"updatedAt\":{\"$gte\":{\"__type\":\"Date\",\"iso\":\"%@\"}}}", 
                                [dateFormatter stringFromDate:updatedDate]];
        
         parameters[@"where"] = jsonString;
    }
    parameters[@"limit"] =limit;
    request = [self GETRequestForClass:className parameters:parameters];
    return request;
}

@end
