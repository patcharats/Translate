//
//  ViewController.h
//  Translate
//
//  Created by CBK-Admin on 5/29/2560 BE.
//  Copyright © 2560 CBK-Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource>

@property (strong, nonatomic) IBOutlet UITextField *inputTextfield;
@property (strong, nonatomic) IBOutlet UITextField *fromTexfield;
@property (strong, nonatomic) IBOutlet UITextField *toTextfield;
@property (strong, nonatomic) IBOutlet UITextView *outputTextfield;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segment;

@property (strong, nonatomic) UIPickerView *pickerViewFrom;
@property (strong, nonatomic) UIPickerView *pickerViewTo;

@end

