//
//  GEViewController.m
//  GoEuro
//
//  Created by simon lustgarten on 4/9/14.
//  Copyright (c) 2014 simon lustgarten. All rights reserved.
//

#import "GEViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "GEDateField.h"


@interface GEViewController ()

@end

@implementation GEViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    self.scrollView.backgroundColor = [UIColor colorWithRed:138/255.f green:190/255.f blue:227/255.f alpha:1];
    [self.view addSubview:self.scrollView];
    
    self.logoBackground = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, (self.view.bounds.size.height/5) +15)];
    self.logoBackground.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.logoBackground];

    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 15, self.view.bounds.size.width-40, self.view.bounds.size.height/5)];
    [self.imageView setImage:[UIImage imageNamed:@"Logo_Goeuro-1024x196.jpg"]];
    self.imageView.backgroundColor = [UIColor greenColor];
    [self.scrollView addSubview:self.imageView];

    self.startTextField = [[UITextField alloc]initWithFrame:CGRectMake(20, self.imageView.frame.origin.y+self.imageView.frame.size.height+20, self.view.bounds.size.width-40, 40)];
    self.startTextField.backgroundColor = [UIColor whiteColor];
    self.startTextField.borderStyle = UITextBorderStyleRoundedRect;
    [self.startTextField.layer setCornerRadius:14.0f];
    self.startTextField.placeholder = @"From: City, Town or Village";
    [self.scrollView addSubview:self.startTextField];
    
    
    self.currentLocation1 = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-60, self.startTextField.frame.origin.y, 40, 40)];
    self.currentLocation1.layer.cornerRadius = 14; // this value vary as per your desire
    self.currentLocation1.clipsToBounds = YES;
    self.currentLocation1.backgroundColor = [UIColor blueColor];

    [self.scrollView addSubview:self.currentLocation1];

    
    self.endTextField = [[UITextField alloc]initWithFrame:CGRectMake(20, self.startTextField.frame.origin.y+self.startTextField.frame.size.height+20, self.view.bounds.size.width-40, 40)];
    self.endTextField.backgroundColor = [UIColor whiteColor];
    self.endTextField.borderStyle = UITextBorderStyleRoundedRect;
    [self.endTextField.layer setCornerRadius:14.0f];
    self.endTextField.placeholder = @"To: City, Town or Village";
    [self.scrollView addSubview:self.endTextField];

    self.currentLocation2= [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-60, self.endTextField.frame.origin.y, 40, 40)];
    self.currentLocation2.layer.cornerRadius = 14; // this value vary as per your desire
    self.currentLocation2.clipsToBounds = YES;
    self.currentLocation2.backgroundColor = [UIColor blueColor];
    [self.scrollView addSubview:self.currentLocation2];
    
   self.segmentedControl = [[UISegmentedControl alloc]initWithItems:@[@"Round-trip",@"One-way"]];
    self.segmentedControl.frame =CGRectMake(20, self.endTextField.frame.origin.y+self.endTextField.frame.size.height+20, self.view.frame.size.width-40, 40);
    [self.segmentedControl setSelectedSegmentIndex:1];
    [self.scrollView addSubview:self.segmentedControl];
    
    self.dateLabel= [[UILabel alloc]init];
    self.dateLabel.frame =CGRectMake(20, self.segmentedControl.frame.origin.y+self.segmentedControl.frame.size.height+20, self.view.frame.size.width-40, 40);
    self.dateLabel.text = @" Date:";
    self.dateLabel.textColor = [UIColor grayColor];
    self.dateLabel.backgroundColor = [UIColor whiteColor];
    self.dateLabel.layer.cornerRadius = 14;
    self.dateLabel.layer.masksToBounds = YES;
    self.dateLabel.userInteractionEnabled = YES;
//    UITapGestureRecognizer *selectDate =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectDate)];
//    [self.dateLabel addGestureRecognizer:selectDate];
//    selectDate.delegate = self;
    [self.scrollView addSubview:self.dateLabel];

    self.searchBackground = [[UILabel alloc]init];
    self.searchBackground.frame =CGRectMake((self.view.bounds.size.width/2)-41,self.dateLabel.frame.origin.y+self.dateLabel.frame.size.height+19,82,42);
    self.searchBackground.backgroundColor = [UIColor whiteColor];
    self.searchBackground.layer.cornerRadius = 14;
    self.searchBackground.layer.masksToBounds = YES;
    [self.scrollView addSubview:self.searchBackground];

    self.Search= [[UIButton alloc]initWithFrame:CGRectMake((self.view.bounds.size.width/2)-40,self.dateLabel.frame.origin.y+self.dateLabel.frame.size.height+20,80,40)];
    self.Search.layer.cornerRadius = 14; // this value vary as per your desire
    self.Search.clipsToBounds = YES;
    self.Search.backgroundColor = [UIColor colorWithRed:245/255.f green:184/255.f blue:71/255.f alpha:1];
    [self.Search setTitle:@"Search" forState:UIControlStateNormal];
    [self.scrollView addSubview:self.Search];
    
    UITapGestureRecognizer *singleFingerTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap)];
    [self.scrollView addGestureRecognizer:singleFingerTap];
    singleFingerTap.delegate=self;

    
    self.startTextField.delegate = self;
    self.endTextField.delegate = self;
    
    
	// Do any additional setup after loading the view, typically from a nib.
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    // Disallow recognition of tap gestures in the segmented control.
    if ((touch.view == self.dateLabel)) {//change it to your condition
        [self selectDate];
        return NO;
    }
    return YES;
}

-(void)setInitialFrames{
    self.logoBackground.frame = CGRectMake(0, 0, self.view.bounds.size.width, (self.view.bounds.size.height/5) +15);
    self.imageView.frame =CGRectMake(20, 15, self.view.bounds.size.width-40, self.view.bounds.size.height/5);
    self.startTextField.frame = CGRectMake(20, self.imageView.frame.origin.y+self.imageView.frame.size.height+20, self.view.bounds.size.width-40, 40);
    self.currentLocation1.frame =CGRectMake(self.view.bounds.size.width-60, self.startTextField.frame.origin.y, 40, 40);
    self.endTextField.frame = CGRectMake(20, self.startTextField.frame.origin.y+self.startTextField.frame.size.height+20, self.view.bounds.size.width-40, 40);
    self.currentLocation2.frame =CGRectMake(self.view.bounds.size.width-60, self.endTextField.frame.origin.y, 40, 40);
    self.segmentedControl.frame =CGRectMake(20, self.endTextField.frame.origin.y+self.endTextField.frame.size.height+20, self.view.frame.size.width-40, 40);
    self.dateLabel.frame =CGRectMake(20, self.segmentedControl.frame.origin.y+self.segmentedControl.frame.size.height+20, self.view.frame.size.width-40, 40);
    self.searchBackground.frame =CGRectMake((self.view.bounds.size.width/2)-41,self.dateLabel.frame.origin.y+self.dateLabel.frame.size.height+19,82,42);
    self.Search.frame=CGRectMake((self.view.bounds.size.width/2)-40,self.dateLabel.frame.origin.y+self.dateLabel.frame.size.height+20,80,40);
}

-(void)selectDate{
    NSLog(@"Select Date");
}
-(void)handleSingleTap{
    NSLog(@"single tap");
    [self.startTextField resignFirstResponder];
    [self.endTextField resignFirstResponder];
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
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
    NSString *substring = [NSString stringWithString:textField.text];
    substring = [substring stringByReplacingCharactersInRange:range withString:string];
    [self searchAutocompleteEntriesWithSubstring:substring];
    return YES;
}

- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring
{
//    NSMutableArray *autoCompleteArray = [[NSMutableArray alloc]init];
////    [self retrieveData];
//    
//    for(NSString *curString in _staffTableArray)
//    {
//        NSString *lowerCaseCur = [curString lowercaseString];
//        NSRange substringRange = [lowerCaseCur rangeOfString:substring];
//        if (substringRange.location == 0)
//        {
//            [autoCompleteArray addObject:curString];
//        }
//    }
//    if (![substring isEqualToString:@""])
//    {
////        _staffTableArray = [NSMutableArray arrayWithArray:autoCompleteArray];
//    }
////    [_staffListTableView reloadData];
}
- (IBAction)Search:(id)sender {
}
@end
