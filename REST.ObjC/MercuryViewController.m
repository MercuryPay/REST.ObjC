//
//  MercuryViewController.m
//  REST.ObjC
//
//  Created by Mercury Payment Systems, LLC on 1/8/14.
//  Copyright (c) 2014 Mercury Payement Systems, LLC All rights reserved.
//

#import "MercuryViewController.h"

@interface MercuryViewController ()

@property NSString *url;
@property NSString *merchantID;
@property NSString *merchantPassword;
@property NSString *tranType;
@property NSString *tranCode;

@end

@implementation MercuryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Configure settings to target proper platform
    self.url = @"https://w1.mercurycert.net/PaymentsAPI";
    self.merchantID = @"395347308=E2ETKN";
    self.merchantPassword = @"123E2ETKN";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (IBAction)clickCreditSale:(id)sender {
    
	NSMutableDictionary *dictionary = [NSMutableDictionary new];
    [dictionary setObject:@"1001" forKey:@"InvoiceNo"];
    [dictionary setObject:@"1001" forKey:@"RefNo"];
    [dictionary setObject:@"GitHub REST.ObjC" forKey:@"Memo"];
    [dictionary setObject:@"1.00" forKey:@"Purchase"];
    [dictionary setObject:@"02" forKey:@"LaneID"];
    [dictionary setObject:@"OneTime" forKey:@"Frequency"];
    [dictionary setObject:@"RecordNumberRequested" forKey:@"RecordNo"];
    [dictionary setObject:@"MagneSafe" forKey:@"EncryptedFormat"];
    [dictionary setObject:@"Swiped" forKey:@"AccountSource"];
    [dictionary setObject:@"2F8248964608156B2B1745287B44CA90A349905F905514ABE3979D7957F13804705684B1C9D5641C" forKey:@"EncryptedBlock"];
    [dictionary setObject:@"9500030000040C200026" forKey:@"EncryptedKey"];
    
    [self processTransactionWithDictionary:dictionary andResource:@"/Credit/Sale"];
}

- (IBAction)clickCreditReturn:(id)sender {
    
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    [dictionary setObject:@"1002" forKey:@"InvoiceNo"];
    [dictionary setObject:@"1002" forKey:@"RefNo"];
    [dictionary setObject:@"GitHub REST.ObjC" forKey:@"Memo"];
    [dictionary setObject:@"1.00" forKey:@"Purchase"];
    [dictionary setObject:@"02" forKey:@"LaneID"];    
    [dictionary setObject:@"OneTime" forKey:@"Frequency"];
    [dictionary setObject:@"RecordNumberRequested" forKey:@"RecordNo"];
    [dictionary setObject:@"MagneSafe" forKey:@"EncryptedFormat"];
    [dictionary setObject:@"Swiped" forKey:@"AccountSource"];
    [dictionary setObject:@"2F8248964608156B2B1745287B44CA90A349905F905514ABE3979D7957F13804705684B1C9D5641C" forKey:@"EncryptedBlock"];
    [dictionary setObject:@"9500030000040C200026" forKey:@"EncryptedKey"];
    
    [self processTransactionWithDictionary:dictionary andResource:@"/Credit/Return"];
}

- (IBAction)clickGiftSale:(id)sender {
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    [dictionary setObject:@"1003" forKey:@"InvoiceNo"];
    [dictionary setObject:@"1003" forKey:@"RefNo"];
    [dictionary setObject:@"GitHub REST.ObjC" forKey:@"Memo"];
    [dictionary setObject:@"1.00" forKey:@"Purchase"];
    [dictionary setObject:@"MagneSafe" forKey:@"EncryptedFormat"];
    [dictionary setObject:@"Swiped" forKey:@"AccountSource"];
    [dictionary setObject:@"C8C8F9536826D5450E734953206E7F4DC6812C6858037F5ABF23D9F83F948AF7" forKey:@"EncryptedBlock"];
    [dictionary setObject:@"9012090B06349B000056" forKey:@"EncryptedKey"];
    
    [self processTransactionWithDictionary:dictionary andResource:@"/PrePaid/Sale"];
}

- (IBAction)clickGiftReturn:(id)sender {
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    [dictionary setObject:@"PrePaid" forKey:@"TranType"];
    [dictionary setObject:@"Return" forKey:@"TranCode"];
    [dictionary setObject:@"1004" forKey:@"InvoiceNo"];
    [dictionary setObject:@"1004" forKey:@"RefNo"];
    [dictionary setObject:@"GitHub REST.ObjC" forKey:@"Memo"];
    [dictionary setObject:@"1.00" forKey:@"Purchase"];
    [dictionary setObject:@"MagneSafe" forKey:@"EncryptedFormat"];
    [dictionary setObject:@"Swiped" forKey:@"AccountSource"];
    [dictionary setObject:@"C8C8F9536826D5450E734953206E7F4DC6812C6858037F5ABF23D9F83F948AF7" forKey:@"EncryptedBlock"];
    [dictionary setObject:@"9012090B06349B000056" forKey:@"EncryptedKey"];
    
    [self processTransactionWithDictionary:dictionary andResource:@"/PrePaid/Return"];
}

- (void) processTransactionWithDictionary:(NSDictionary *)dictionary andResource:(NSString *) resource {
   
    // Create a JSON POST
    NSString *urlResource = [NSString stringWithFormat:@"%@%@", self.url, resource];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlResource]];
	[request setTimeoutInterval:30];
	[request setHTTPMethod:@"POST"];
	[request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    // Add Authorization header
    NSString *credentials = [NSString stringWithFormat:@"%@:%@", self.merchantID, self.merchantPassword];
    NSString *base64Credentials = [self base64String:credentials];
    [request addValue:[@"Basic " stringByAppendingString:base64Credentials] forHTTPHeaderField:@"Authorization"];
    
    // Serialize NSDictionary to JSON data
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
    
    // Add JSON data to request body
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: jsonData];
    
    // Process request async
    [NSURLConnection connectionWithRequest:request delegate:self];
    
    [self setBtnState:NO];
    
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Error"
                                                   message: error.localizedDescription
                                                  delegate: self
                                         cancelButtonTitle: nil
                                         otherButtonTitles:@"OK",nil];
    
    [alert show];
    
    [self setBtnState:YES];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    // Deserialize response from REST service
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    NSMutableString *message = [NSMutableString new];
    
    for (NSString *key in [dictionary allKeys])
    {
        [message appendFormat:@"%@: %@;\n", key, [dictionary objectForKey:key]];
    }
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Response"
                                                   message: message
                                                  delegate: self
                                         cancelButtonTitle: nil
                                         otherButtonTitles:@"OK",nil];
    
    [alert show];

     [self setBtnState:YES];
}

- (void)setBtnState:(BOOL) enabled {
    _btnCreditSale.enabled = enabled;
    _btnCreditReturn.enabled = enabled;
    _btnGiftSale.enabled = enabled;
    _btnGiftReturn.enabled = enabled;
}

// Base64 function taken from http://calebmadrigal.com/string-to-base64-string-in-objective-c/
- (NSString *)base64String:(NSString *)str
{
    NSData *theData = [str dataUsingEncoding: NSASCIIStringEncoding];
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

@end
