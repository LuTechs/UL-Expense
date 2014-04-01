//
//  SettingViewController.h
//  UL-Expense
//
//  Created by Leng Ung on 22/11/2013.
//  Copyright (c) 2013 Leng Ung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController
@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;
- (IBAction)buttonBackup:(id)sender;
- (IBAction)buttonRestore:(id)sender;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorBacktup;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorRestore;

@end
