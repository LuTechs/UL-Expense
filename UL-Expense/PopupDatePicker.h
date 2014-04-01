//
//  PopupDatePicker.h
//  UL-Expense
//
//  Created by Leng Ung on 28/01/13.
//  Copyright (c) 2013 Leng Ung. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PopupDatePickerProtocol;
@interface PopupDatePicker : UIView


@property (readonly) UIView *backgroundView;
@property (readonly) UIView *dateView;
@property(readonly) UIToolbar *toolBar;
@property(readonly) UIBarButtonItem *doneButton;
@property(readonly) UIDatePicker *datePicker;

@property(nonatomic,weak) id delegate;

- (void) showFromView: (UIView *) parentView;
-(void) hide ;
@end

@protocol PopupDatePickerProtocol
@required
- (void)popupDatePickerDidSelectedDate:(NSDate *)date;
@end
