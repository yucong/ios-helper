//
//  HTTP.m
//  yueyue
//
//  Created by Yu Cong on 12-11-17.
//  Copyright (c) 2012年 Yu Cong. All rights reserved.
//

#import "HTTP.h"

@implementation HTTP

+(void)sendRequestToPath:(NSString*)url method:(NSString*)method params:(NSDictionary*)params  completionHandler:(void (^)(id)) completionHandler 
{
    NSString* finalUrl=[DOMAIN_URL stringByAppendingString:url];
    NSMutableURLRequest* request=[HTTP generateRequestWithURL:finalUrl method:method params:params];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * response, NSData *data, NSError *error) {
        if(!error){
            id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            completionHandler(result);
        }else{
            completionHandler(nil);
        }
    }];
}

+(void)postJsonToPath:(NSString*)url id:object  completionHandler:(void (^)(id)) completionHandler
{
    NSString* finalUrl=[DOMAIN_URL stringByAppendingString:url];
    NSMutableURLRequest  *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:finalUrl]];
    [request setHTTPMethod:@"POST"];
    NSData *body=[NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:nil];
    [request setHTTPBody:body];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * response, NSData *data, NSError *error) {
        if(!error){
            id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            completionHandler(result);
        }else{
            completionHandler(nil);
        }
    }];


}

+(NSMutableURLRequest*)generateRequestWithURL:(NSString*) url method:(NSString*)method params:(NSDictionary*)params
{
    if([method isEqualToString:@"GET"]){
        NSString* finalurl=[NSString stringWithFormat:@"%@?%@",url,[[HTTP generateParamString:params]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSMutableURLRequest  *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:finalurl]];
        [request setHTTPMethod:method];
        return request;
    }
    if([method isEqualToString:@"POST"]){
        NSMutableURLRequest  *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
        [request setHTTPMethod:method];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        NSMutableData *body = [NSMutableData data];
        [body appendData:[[HTTP generateParamString:params]dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPBody:body];
        return request;
    }
    return nil;
}

+(NSString*)generateParamString:(NSDictionary*)params
{
    NSString* result=@"";
    if(!params){
        return result;
    }
    for (NSString *key in [params allKeys]) {
        result=[result stringByAppendingString:[NSString stringWithFormat:@"%@=%@&",key,params[key]]];
    }
    return result;
}

@end
