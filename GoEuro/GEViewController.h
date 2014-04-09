//
//  GEViewController.h
//  GoEuro
//
//  Created by simon lustgarten on 4/9/14.
//  Copyright (c) 2014 simon lustgarten. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GEViewController : UIViewController <UITextFieldDelegate,UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate>
//UI Objects, in order of apearance.
@property (strong,nonatomic) UIScrollView *scrollView;
@property (strong,nonatomic) UILabel *logoBackground;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UITextField *startTextField;
@property (strong,nonatomic) UIButton *currentLocation1;
@property (strong, nonatomic) UITextField *endTextField;
@property (strong,nonatomic) UIButton *currentLocation2;
@property (strong,nonatomic) UISegmentedControl *segmentedControl;
@property (strong,nonatomic) UILabel *dateLabel;
@property (strong,nonatomic) UILabel *dateLabelReturn;
@property (strong,nonatomic) UILabel *searchBackground;
@property (strong,nonatomic) UIButton *Search;

@property (strong,nonatomic) UITableView *suggestions;
@property (strong,nonatomic) UIDatePicker *datePicker;


- (IBAction)Search:(id)sender;
@end
