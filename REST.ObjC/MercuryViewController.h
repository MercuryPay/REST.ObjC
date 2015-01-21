//
//  MercuryViewController.h
//  REST.ObjC
//
//  Created by Mercury Payment Systems, LLC on 1/8/14.
//  Copyright (c) 2014 Mercury Payement Systems, LLC All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MercuryViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *btnCreditSale;
@property (weak, nonatomic) IBOutlet UIButton *btnCreditReturn;

@property (weak, nonatomic) IBOutlet UIButton *btnGiftSale;
@property (weak, nonatomic) IBOutlet UIButton *btnGiftReturn;

- (IBAction)clickCreditSale:(id)sender;
- (IBAction)clickCreditReturn:(id)sender;

- (IBAction)clickGiftSale:(id)sender;
- (IBAction)clickGiftReturn:(id)sender;

@end
