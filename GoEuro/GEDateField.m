//
//  GEDateField.m
//  GoEuro
//
//  Created by simon lustgarten on 4/9/14.
//  Copyright (c) 2014 simon lustgarten. All rights reserved.
//

#import "GEDateField.h"

@implementation GEDateField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 14;
        self.placeholder = [[UILabel alloc]init];
        [self addSubview:self.placeholder];
    }
    return self;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
