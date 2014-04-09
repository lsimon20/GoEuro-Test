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
    
    //Fast current location button
    self.currentLocation1 = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-60, self.startTextField.frame.origin.y, 40, 40)];
    self.currentLocation1.layer.cornerRadius = 14; // this value vary as per your desire
    self.currentLocation1.clipsToBounds = YES;
    self.currentLocation1.backgroundColor = [UIColor blueColor];
    [self.scrollView addSubview:self.currentLocation1];

    //Destination
    self.endTextField = [[UITextField alloc]initWithFrame:CGRectMake(20, self.startTextField.frame.origin.y+self.startTextField.frame.size.height+20, self.view.bounds.size.width-40, 40)];
    self.endTextField.backgroundColor = [UIColor whiteColor];
    self.endTextField.borderStyle = UITextBorderStyleRoundedRect;
    [self.endTextField.layer setCornerRadius:14.0f];
    self.endTextField.placeholder = @"To: City, Town or Village";
    [self.scrollView addSubview:self.endTextField];

    //fast current location button for destination
    self.currentLocation2= [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-60, self.endTextField.frame.origin.y, 40, 40)];
    self.currentLocation2.layer.cornerRadius = 14; // this value vary as per your desire
    self.currentLocation2.clipsToBounds = YES;
    self.currentLocation2.backgroundColor = [UIColor blueColor];
    [self.scrollView addSubview:self.currentLocation2];
    
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
    [self.scrollView addSubview:self.Search];
    
    
    //Suggestions TableView
    self.suggestions = [[UITableView alloc]init];
    self.suggestions.userInteractionEnabled = YES;
    self.suggestions.dataSource = self;
    self.suggestions.delegate = self;
    [self.scrollView addSubview:self.suggestions];
    
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

	// Do any additional setup after loading the view, typically from a nib.
}

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
    else if ([touch.view isDescendantOfView:self.suggestions]) {
        

        return NO;
    }
    return YES;
}

-(void)setInitialFrames{
    [UIView animateWithDuration:.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        self.logoBackground.frame = CGRectMake(0, 0, self.view.bounds.size.width, (self.view.bounds.size.height/5) +15);
        self.imageView.frame =CGRectMake(20, 15, self.view.bounds.size.width-40, self.view.bounds.size.height/5);
        self.startTextField.frame = CGRectMake(20, self.imageView.frame.origin.y+self.imageView.frame.size.height+20, self.view.bounds.size.width-40, 40);
        self.currentLocation1.frame =CGRectMake(self.view.bounds.size.width-60, self.startTextField.frame.origin.y, 40, 40);
        self.endTextField.frame = CGRectMake(20, self.startTextField.frame.origin.y+self.startTextField.frame.size.height+20, self.view.bounds.size.width-40, 40);
        self.currentLocation2.frame =CGRectMake(self.view.bounds.size.width-60, self.endTextField.frame.origin.y, 40, 40);
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
    self.suggestions.frame = CGRectMake(0, 0, 0, 0);
}
-(void)setMovedFramesForStart{
    [UIView animateWithDuration:.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.endTextField.frame = CGRectMake(20, self.startTextField.frame.origin.y+self.startTextField.frame.size.height+20+50, self.view.bounds.size.width-40, 40);
        self.currentLocation2.frame =CGRectMake(self.view.bounds.size.width-60, self.endTextField.frame.origin.y, 40, 40);
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
-(void)handleSingleTap{
    NSLog(@"single tap");
    [self setInitialFrames];
    [self.startTextField resignFirstResponder];
    [self.endTextField resignFirstResponder];
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self setInitialFrames];
    [textField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self setInitialFrames];
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    self.suggestions.frame = CGRectMake(32, textField.frame.origin.y+textField.frame.size.height, self.view.bounds.size.width-64, 50);

    if ((textField.frame.origin.y+textField.frame.size.height<self.endTextField.frame.origin.y)) {
        [self setMovedFramesForStart];
    }
    else{
        [self setMovedFramesForEnd];
    }
    
    NSString *substring = [NSString stringWithString:textField.text];
    substring = [substring stringByReplacingCharactersInRange:range withString:string];
    [self searchAutocompleteEntriesWithSubstring:substring];
    return YES;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"Suggestion %i",indexPath.row ]];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20) ];
        [NSString stringWithFormat:@"Suggestion %i",indexPath.row];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"Suggestion %i",indexPath.row];
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

- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring
{

}
- (IBAction)Search:(id)sender {
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
@end
