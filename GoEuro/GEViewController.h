//
//  GEViewController.h
//  GoEuro
//
//  Created by simon lustgarten on 4/9/14.
//  Copyright (c) 2014 simon lustgarten. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface GEViewController : UIViewController <UITextFieldDelegate,UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate,NSURLSessionDelegate,CLLocationManagerDelegate>
//UI Objects, in order of apearance.
@property (strong,nonatomic) UIScrollView *scrollView;
@property (strong,nonatomic) UILabel *logoBackground;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UITextField *startTextField;
@property (strong, nonatomic) UITextField *endTextField;
@property (strong,nonatomic) UISegmentedControl *segmentedControl;
@property (strong,nonatomic) UILabel *dateLabel;
@property (strong,nonatomic) UILabel *dateLabelReturn;
@property (strong,nonatomic) UILabel *searchBackground;
@property (strong,nonatomic) UIButton *Search;

@property (strong,nonatomic) UITableView *suggestionsTable;
@property (strong,nonatomic) NSMutableArray *suggestionsData;
@property (strong,nonatomic) UIDatePicker *datePicker;

@property (strong,nonatomic) NSURLSession *session;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;

- (IBAction)Search:(id)sender;
@end
