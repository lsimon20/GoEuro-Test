//
//  GEViewController.m
//  GoEuro
//
//  Created by simon lustgarten on 4/9/14.
//  Copyright (c) 2014 simon lustgarten. All rights reserved.
//

#import "GEViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface GEViewController ()
@property BOOL startOrFinish;
@end

@implementation GEViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //The container is a Scrollview, this gives space to grow in the future
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    self.scrollView.backgroundColor = [UIColor colorWithRed:138/255.f green:190/255.f blue:227/255.f alpha:1];
    [self.view addSubview:self.scrollView];
    
    //fast UI solution (should be arranged when provided with real logo and art)
    self.logoBackground = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, (self.view.bounds.size.height/5) +15)];
    self.logoBackground.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.logoBackground];

    //Logo
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 15, self.view.bounds.size.width-40, self.view.bounds.size.height/5)];
    [self.imageView setImage:[UIImage imageNamed:@"Logo_Goeuro-1024x196.jpg"]];
    self.imageView.backgroundColor = [UIColor greenColor];
    [self.scrollView addSubview:self.imageView];

    //Start location
    self.startTextField = [[UITextField alloc]initWithFrame:CGRectMake(20, self.imageView.frame.origin.y+self.imageView.frame.size.height+20, self.view.bounds.size.width-40, 40)];
    self.startTextField.backgroundColor = [UIColor whiteColor];
    self.startTextField.borderStyle = UITextBorderStyleRoundedRect;
    [self.startTextField.layer setCornerRadius:14.0f];
    self.startTextField.placeholder = @"From: City, Town or Village";
    [self.scrollView addSubview:self.startTextField];
    
    //Destination
    self.endTextField = [[UITextField alloc]initWithFrame:CGRectMake(20, self.startTextField.frame.origin.y+self.startTextField.frame.size.height+20, self.view.bounds.size.width-40, 40)];
    self.endTextField.backgroundColor = [UIColor whiteColor];
    self.endTextField.borderStyle = UITextBorderStyleRoundedRect;
    [self.endTextField.layer setCornerRadius:14.0f];
    self.endTextField.placeholder = @"To: City, Town or Village";
    [self.scrollView addSubview:self.endTextField];

  
    
    //Round or single trip
    self.segmentedControl = [[UISegmentedControl alloc]initWithItems:@[@"Round-trip",@"One-way"]];
    self.segmentedControl.frame =CGRectMake(20, self.endTextField.frame.origin.y+self.endTextField.frame.size.height+20, self.view.frame.size.width-40, 40);
    [self.segmentedControl setSelectedSegmentIndex:1];
    [self.scrollView addSubview:self.segmentedControl];
    [self.segmentedControl addTarget:self action:@selector(tripChanged) forControlEvents:UIControlEventValueChanged];

    
    
    //Date Selector
    self.dateLabel= [[UILabel alloc]init];
    self.dateLabel.frame =CGRectMake(20, self.segmentedControl.frame.origin.y+self.segmentedControl.frame.size.height+20, self.view.frame.size.width-40, 40);
    self.dateLabel.text = @" Date:";
    self.dateLabel.textColor = [UIColor grayColor];
    self.dateLabel.backgroundColor = [UIColor whiteColor];
    self.dateLabel.layer.cornerRadius = 14;
    self.dateLabel.layer.masksToBounds = YES;
    self.dateLabel.userInteractionEnabled = YES;
    [self.scrollView addSubview:self.dateLabel];
    
    //Date of return Selector
    self.dateLabelReturn= [[UILabel alloc]init];
    self.dateLabelReturn.text = @" Return date:";
    self.dateLabelReturn.textColor = [UIColor grayColor];
    self.dateLabelReturn.backgroundColor = [UIColor whiteColor];
    self.dateLabelReturn.layer.cornerRadius = 14;
    self.dateLabelReturn.layer.masksToBounds = YES;
    self.dateLabelReturn.userInteractionEnabled = YES;
    [self.scrollView addSubview:self.dateLabelReturn];

    //fast UI solution (should be arranged when provided with real logo and art)
    self.searchBackground = [[UILabel alloc]init];
    self.searchBackground.frame =CGRectMake((self.view.bounds.size.width/2)-41,self.dateLabel.frame.origin.y+self.dateLabel.frame.size.height+19,82,42);
    self.searchBackground.backgroundColor = [UIColor whiteColor];
    self.searchBackground.layer.cornerRadius = 14;
    self.searchBackground.layer.masksToBounds = YES;
    [self.scrollView addSubview:self.searchBackground];

    //Search Button
    self.Search= [[UIButton alloc]initWithFrame:CGRectMake((self.view.bounds.size.width/2)-40,self.dateLabel.frame.origin.y+self.dateLabel.frame.size.height+20,80,40)];
    self.Search.layer.cornerRadius = 14; // this value vary as per your desire
    self.Search.clipsToBounds = YES;
    self.Search.backgroundColor = [UIColor colorWithRed:245/255.f green:184/255.f blue:71/255.f alpha:1];
    [self.Search setTitle:@"Search" forState:UIControlStateNormal];
    [self.Search addTarget:self
               action:@selector(searchButtonWasPressed)
     forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.Search];
    
    
    //Suggestions TableView
    self.suggestionsTable = [[UITableView alloc]init];
    self.suggestionsTable.userInteractionEnabled = YES;
    self.suggestionsTable.dataSource = self;
    self.suggestionsTable.delegate = self;
    [self.scrollView addSubview:self.suggestionsTable];
    
    //Sugestions DataArray
    self.suggestionsData = [[NSMutableArray alloc]init];
    
    //Date Picker
    self.datePicker = [[UIDatePicker alloc]init];
    self.datePicker.minimumDate = [NSDate date];
    [self.scrollView addSubview:self.datePicker];
    self.datePicker.frame = CGRectMake(self.view.bounds.size.width, self.view.bounds.size.height, self.view.bounds.size.width, 160);
    [self.datePicker addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];


    
    //Gesture Recognizer
    UITapGestureRecognizer *singleFingerTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap)];
    [self.scrollView addGestureRecognizer:singleFingerTap];
    singleFingerTap.delegate=self;

    //Delegates
    self.startTextField.delegate = self;
    self.endTextField.delegate = self;

    //NSUrlSession
    NSURLSessionConfiguration *sessionConfig =[NSURLSessionConfiguration defaultSessionConfiguration];
    self.session =[NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
    
    //CoreLocation
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    self.locationManager.pausesLocationUpdatesAutomatically = NO;
    [self.locationManager startUpdatingLocation];
}

#pragma mark UI position and behaviour

-(void)setInitialFrames{
    //UI
    [UIView animateWithDuration:.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        self.logoBackground.frame = CGRectMake(0, 0, self.view.bounds.size.width, (self.view.bounds.size.height/5) +15);
        self.imageView.frame =CGRectMake(20, 15, self.view.bounds.size.width-40, self.view.bounds.size.height/5);
        self.startTextField.frame = CGRectMake(20, self.imageView.frame.origin.y+self.imageView.frame.size.height+20, self.view.bounds.size.width-40, 40);
        self.endTextField.frame = CGRectMake(20, self.startTextField.frame.origin.y+self.startTextField.frame.size.height+20, self.view.bounds.size.width-40, 40);
        self.segmentedControl.frame =CGRectMake(20, self.endTextField.frame.origin.y+self.endTextField.frame.size.height+20, self.view.frame.size.width-40, 40);
        self.dateLabel.frame =CGRectMake(20, self.segmentedControl.frame.origin.y+self.segmentedControl.frame.size.height+20, self.view.frame.size.width-40, 40);
        
        if(self.segmentedControl.selectedSegmentIndex==0){
            self.dateLabelReturn.frame =CGRectMake(20, self.dateLabel.frame.origin.y+self.dateLabel.frame.size.height+20, self.view.frame.size.width-40, 40);
            self.searchBackground.frame =CGRectMake((self.view.bounds.size.width/2)-41,self.dateLabelReturn.frame.origin.y+self.dateLabelReturn.frame.size.height+19,82,42);
            self.Search.frame = CGRectMake((self.view.bounds.size.width/2)-40,self.dateLabelReturn.frame.origin.y+self.dateLabelReturn.frame.size.height+20,80,40);
        }
        else{
            self.searchBackground.frame =CGRectMake((self.view.bounds.size.width/2)-41,self.dateLabel.frame.origin.y+self.dateLabel.frame.size.height+19,82,42);
            self.Search.frame = CGRectMake((self.view.bounds.size.width/2)-40,self.dateLabel.frame.origin.y+self.dateLabel.frame.size.height+20,80,40);
        }
        
        self.datePicker.frame = CGRectMake(self.view.bounds.size.width, self.view.bounds.size.height, self.view.bounds.size.width, 160);
    } completion:^(BOOL finished) {
        //completed
    }];
    self.suggestionsTable.frame = CGRectMake(0, 0, 0, 0);
}
-(void)setMovedFramesForStart{
    [UIView animateWithDuration:.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.endTextField.frame = CGRectMake(20, self.startTextField.frame.origin.y+self.startTextField.frame.size.height+20+50, self.view.bounds.size.width-40, 40);
        self.segmentedControl.frame =CGRectMake(20, self.endTextField.frame.origin.y+self.endTextField.frame.size.height+20, self.view.frame.size.width-40, 40);
        self.dateLabel.frame =CGRectMake(20, self.segmentedControl.frame.origin.y+self.segmentedControl.frame.size.height+20, self.view.frame.size.width-40, 40);
        if(self.segmentedControl.selectedSegmentIndex==0){
            self.dateLabelReturn.frame =CGRectMake(20, self.dateLabel.frame.origin.y+self.dateLabel.frame.size.height+20, self.view.frame.size.width-40, 40);
            self.searchBackground.frame =CGRectMake((self.view.bounds.size.width/2)-41,self.dateLabelReturn.frame.origin.y+self.dateLabelReturn.frame.size.height+19,82,42);
            self.Search.frame = CGRectMake((self.view.bounds.size.width/2)-40,self.dateLabelReturn.frame.origin.y+self.dateLabelReturn.frame.size.height+20,80,40);
        }
        else{
            self.searchBackground.frame =CGRectMake((self.view.bounds.size.width/2)-41,self.dateLabel.frame.origin.y+self.dateLabel.frame.size.height+19,82,42);
            self.Search.frame = CGRectMake((self.view.bounds.size.width/2)-40,self.dateLabel.frame.origin.y+self.dateLabel.frame.size.height+20,80,40);
        }
    } completion:^(BOOL finished) {
        //completed
    }];
}

-(void)setMovedFramesForEnd{
    [UIView animateWithDuration:.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, self.scrollView.contentOffset.x +50) animated:YES];
        self.segmentedControl.frame =CGRectMake(20, self.endTextField.frame.origin.y+self.endTextField.frame.size.height+20+50, self.view.frame.size.width-40, 40);
        self.dateLabel.frame =CGRectMake(20, self.segmentedControl.frame.origin.y+self.segmentedControl.frame.size.height+20, self.view.frame.size.width-40, 40);
        if(self.segmentedControl.selectedSegmentIndex==0){
            self.dateLabelReturn.frame =CGRectMake(20, self.dateLabel.frame.origin.y+self.dateLabel.frame.size.height+20, self.view.frame.size.width-40, 40);
            self.searchBackground.frame =CGRectMake((self.view.bounds.size.width/2)-41,self.dateLabelReturn.frame.origin.y+self.dateLabelReturn.frame.size.height+19,82,42);
            self.Search.frame = CGRectMake((self.view.bounds.size.width/2)-40,self.dateLabelReturn.frame.origin.y+self.dateLabelReturn.frame.size.height+20,80,40);
        }
        else{
            self.searchBackground.frame =CGRectMake((self.view.bounds.size.width/2)-41,self.dateLabel.frame.origin.y+self.dateLabel.frame.size.height+19,82,42);
            self.Search.frame = CGRectMake((self.view.bounds.size.width/2)-40,self.dateLabel.frame.origin.y+self.dateLabel.frame.size.height+20,80,40);
        }
    } completion:^(BOOL finished) {
        //completed
    }];
}

-(void)selectDate{
    
    self.datePicker.frame = CGRectMake(0, self.view.bounds.size.height+10, self.view.bounds.size.width, 160);
    [UIView animateWithDuration:.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.datePicker.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width,160);
        [self.scrollView setContentOffset:CGPointMake(0, 160)];
    } completion:^(BOOL finished) {
    }];
}


-(void)dateChanged{
    if(self.startOrFinish){
        self.dateLabel.text = [NSString stringWithFormat: @" %@",[NSDateFormatter localizedStringFromDate:[self.datePicker date]
                                                                                                dateStyle:NSDateFormatterMediumStyle
                                                                                                timeStyle:NSDateFormatterShortStyle]];
        self.dateLabel.textColor=[UIColor blackColor];
    }else{
        self.dateLabelReturn.text =[NSString stringWithFormat: @" %@",[NSDateFormatter localizedStringFromDate:[self.datePicker date]
                                                                                                     dateStyle:NSDateFormatterMediumStyle
                                                                                                     timeStyle:NSDateFormatterShortStyle]];
        self.dateLabelReturn.textColor=[UIColor blackColor];
        
    }
    
}

-(void)tripChanged{
    if(self.segmentedControl.selectedSegmentIndex==0){
        self.dateLabelReturn.frame = self.dateLabel.frame;
        [UIView animateWithDuration:.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.dateLabelReturn.frame =CGRectMake(20, self.dateLabel.frame.origin.y+self.dateLabel.frame.size.height+20, self.view.frame.size.width-40, 40);
            self.searchBackground.frame =CGRectMake((self.view.bounds.size.width/2)-41,self.dateLabelReturn.frame.origin.y+self.dateLabelReturn.frame.size.height+19,82,42);
            self.Search.frame = CGRectMake((self.view.bounds.size.width/2)-40,self.dateLabelReturn.frame.origin.y+self.dateLabelReturn.frame.size.height+20,80,40);
        } completion:^(BOOL finished) {
            
        }];
    }
    else{
        self.dateLabelReturn.frame=CGRectNull;
        [UIView animateWithDuration:.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.searchBackground.frame =CGRectMake((self.view.bounds.size.width/2)-41,self.dateLabel.frame.origin.y+self.dateLabel.frame.size.height+19,82,42);
            self.Search.frame = CGRectMake((self.view.bounds.size.width/2)-40,self.dateLabel.frame.origin.y+self.dateLabel.frame.size.height+20,80,40);
        } completion:^(BOOL finished) {
            
        }];
    }
}

-(void)searchButtonWasPressed{
    if((self.startTextField.text != (NSString*) [NSNull null] && self.startTextField.text.length != 0 )&&(self.endTextField.text != (NSString*) [NSNull null] && self.endTextField.text.length != 0 )){
        UIAlertView *searchAlert = [[UIAlertView alloc] initWithTitle:@"Lets travel!"
                                                              message:[NSString stringWithFormat:@"from :%@ to %@",self.startTextField.text,self.endTextField.text ]
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
        [searchAlert show];
    }
    else{
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Search"
                                                             message:[NSString stringWithFormat:@"Please fill in the information" ]
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
        [errorAlert show];
        
    }
}

#pragma mark gesture recognizers

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ((touch.view == self.dateLabel)) {//change it to your condition
        [self selectDate];
        self.datePicker.minimumDate = [NSDate date];
        self.startOrFinish=true;
        return NO;
    }
    else if(touch.view == self.dateLabelReturn){
        [self selectDate];
        if(![self.dateLabel.text isEqualToString:@" Date:"]){
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"MMM dd, yyyy, h:mm a"];
            self.datePicker.minimumDate = [df dateFromString: self.dateLabel.text];
        }
        self.startOrFinish=false;
        return NO;
    }
    else if ([touch.view isDescendantOfView:self.suggestionsTable]) {
        

        return NO;
    }
    return YES;
}

-(void)handleSingleTap{
    [self setInitialFrames];
    [self.startTextField resignFirstResponder];
//    [self.endTextField resignFirstResponder];
}


#pragma mark textfield delegate methods
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self setInitialFrames];
    [textField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self setInitialFrames];
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [self.suggestionsData removeAllObjects];
    [self.suggestionsTable reloadData];
    [self.locationManager startUpdatingLocation];
    NSString *substring = [NSString stringWithString:textField.text];
    substring = [substring stringByReplacingCharactersInRange:range withString:string];
    [self.session resetWithCompletionHandler:^{
        [[self.session dataTaskWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.goeuro.com/api/v2/position/suggest/de/%@",substring ]]
                completionHandler:^(NSData *data,
                                    NSURLResponse *response,
                                    NSError *error) {
                    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                    [self.suggestionsData removeAllObjects];
                    if (error != nil) {
                    }
                    else {
                        //we proceed to sort the array: but first we need to calculate the distance to us.
                        //we will add the distance to us in a mutable copy of the json and add it to a new array that will be our DataSource
                        [jsonArray enumerateObjectsUsingBlock:^(NSDictionary *dictionary, NSUInteger idx, BOOL *stop) {
                            NSMutableDictionary *dictionaryWithDifference = [dictionary mutableCopy];
                            
                            
                            
                            CLLocation *cityLocation = [[CLLocation alloc]initWithLatitude:[[((NSDictionary *)[dictionary objectForKey:@"geo_position"]) objectForKey:@"latitude"] doubleValue] longitude:[[((NSDictionary *)[dictionary objectForKey:@"geo_position"]) objectForKey:@"longitude"] doubleValue]];
                            
                            [dictionaryWithDifference setObject:[NSString stringWithFormat:@"%lf",[self.location distanceFromLocation: cityLocation]/1000] forKey:@"NewDistance"];
                            [self.suggestionsData addObject:dictionaryWithDifference];
                        }];
                        
                        NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"NewDistance"  ascending:YES];
                        
                        self.suggestionsData=[[self.suggestionsData sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]] mutableCopy];
                        
                            dispatch_async(dispatch_get_main_queue(), ^{
                                if(self.suggestionsData.count >0){
                                    self.suggestionsTable.frame = CGRectMake(32, textField.frame.origin.y+textField.frame.size.height, self.view.bounds.size.width-64, 50);
                                    if ((textField.frame.origin.y+textField.frame.size.height<self.endTextField.frame.origin.y)) {
                                        [self setMovedFramesForStart];
                                    }
                                    else{
                                        [self setMovedFramesForEnd];
                                    }
                                }
                                else{
                                    [self setInitialFrames];
                                }
                                
                            }
                            );
                            [self.suggestionsTable reloadData];
                        }
                    }
                    ] resume];
    }];

    
    
   
    return YES;
}

#pragma mark tableview delegate methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.suggestionsData count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"Suggestion %li",(long)indexPath.row ]];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20) ];
    }
    cell.textLabel.text = [((NSDictionary *)[self.suggestionsData objectAtIndex:indexPath.row]) objectForKey:@"name"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 20;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView.frame.origin.y<self.endTextField.frame.origin.y){
        self.startTextField.text=[tableView cellForRowAtIndexPath:indexPath].textLabel.text;
        [self setInitialFrames];
        [self.startTextField resignFirstResponder];

    }
    else{
        self.endTextField.text=[tableView cellForRowAtIndexPath:indexPath].textLabel.text;
        [self setInitialFrames];
        [self.endTextField resignFirstResponder];

    }
    
}
#pragma mark Location manager

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.location = locations.lastObject;
    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Error while getting core location : %@",error);
    if ([error code] == kCLErrorDenied) {
        //you had denied
    }
//   [manager stopUpdatingLocation];
}


@end
