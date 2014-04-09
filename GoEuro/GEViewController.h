//
//  GEViewController.h
//  GoEuro
//
//  Created by simon lustgarten on 4/9/14.
//  Copyright (c) 2014 simon lustgarten. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GEViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *startTextField;
@property (weak, nonatomic) IBOutlet UITextField *endTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end
