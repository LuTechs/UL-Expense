//
//  PopupDatePicker.m
//  UL-Expense
//
//  Created by Leng Ung on 28/01/13.
//  Copyright (c) 2013 Leng Ung. All rights reserved.
//

#import "PopupDatePicker.h"

@implementation PopupDatePicker

@synthesize datePicker=_datePicker;
@synthesize toolBar=_toolBar;
@synthesize doneButton=_doneButton;
@synthesize backgroundView=_backgroundView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _backgroundView=[[UIView alloc]initWithFrame:frame];
        _backgroundView.backgroundColor=[UIColor colorWithWhite:0.0 alpha:0.0];
        
        _datePicker=[[UIDatePicker alloc]init];
        _datePicker.datePickerMode=UIDatePickerModeDate;
        _datePicker.locale=[NSLocale currentLocale];
        _datePicker.timeZone=[NSTimeZone systemTimeZone];
        _datePicker.opaque=YES;
        
        _doneButton=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(didSelectDate)];
        _toolBar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 44)];
        _toolBar.barStyle=UIBarStyleDefault;
      
        
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        [_toolBar setItems:@[space, _doneButton]];
        CGRect childFrame = CGRectMake(0, 0, frame.size.width, _datePicker.frame.size.height + _toolBar.frame.size.height);
        
        _dateView=[[UIView alloc]initWithFrame:childFrame];
        [_dateView addSubview:_toolBar];
        [_dateView addSubview:_datePicker];

        childFrame=_datePicker.frame;
        childFrame.origin.y =_toolBar.frame.origin.y+_toolBar.frame.size.height;
        _datePicker.frame=childFrame;
        
        for (UIView * subview in _datePicker.subviews) {
            subview.frame = _datePicker.bounds;
        }
        _backgroundView.alpha=0.0;
        
        [self addSubview:_backgroundView];
        [self addSubview:_dateView];
        
        self.backgroundColor = [UIColor clearColor];

    }
    return self;
}
- (id) init
{
    
    UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
    return [self initWithFrame:mainWindow.frame];
}
-(void) didSelectDate{
  
    
   [ self.delegate popupDatePickerDidSelectedDate:_datePicker.date];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void) showFromView: (UIView *) parentView
{
    self.frame = parentView.bounds;
    CGRect dateViewFrame = _dateView.frame;
    dateViewFrame.origin.y = self.frame.size.height;
    _dateView.frame = dateViewFrame;
    dateViewFrame.origin.y -= _dateView.frame.size.height;
    
    [parentView endEditing:YES];
    [parentView addSubview:self];
    
    
    [UIView animateWithDuration:0.2
                          delay:0.2
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^
     {
         _dateView.frame = dateViewFrame;
         _backgroundView.alpha = 1.0;
     }
                     completion:nil
     ];
}

- (void) hide
{
    
    
    [UIView animateWithDuration:0.2
                          delay:0.2
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:nil
                     completion:nil
     ];
    [self removeFromSuperview];
}

@end
