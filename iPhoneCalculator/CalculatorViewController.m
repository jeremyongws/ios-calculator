//
//  ViewController.m
//  iPhoneCalculator
//
//  Created by Jeremy Ong on 31/03/2016.
//  Copyright © 2016 Jeremy Ong. All rights reserved.
//

#import "CalculatorViewController.h"

@interface CalculatorViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *calculatorButtons;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property NSString *currentOperator;
@property double valueStored;
@property BOOL justPressedOperator;

@end

@implementation CalculatorViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	for (UIButton *button in self.calculatorButtons) {
		[button addTarget:self action:@selector(onButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	}

}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (IBAction)onButtonPressed:(UIButton *)sender {
	NSString *buttonPressed = sender.titleLabel.text;
	NSUInteger timesOfDot = [[self.numberLabel.text componentsSeparatedByString:@"."] count] - 1;
	
	
	if ([buttonPressed isEqualToString:@"AC"]){
		[self.numberLabel setText:@"0"];
		self.valueStored = 0;
	} else if ([buttonPressed isEqualToString:@"."]){
		if (_justPressedOperator){
				self.numberLabel.text = @"0.";
		}
		if (timesOfDot < 1){
			[self.numberLabel setText:[self.numberLabel.text stringByAppendingString:buttonPressed]];
		}
	}
	
	if ([@[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9"] containsObject:buttonPressed]){
		if (self.numberLabel.text.length == 9){
			return;
		} else if ([self.numberLabel.text isEqualToString:@"0"]){
			[self.numberLabel setText:buttonPressed];
		} else {
			if (_justPressedOperator){
				self.numberLabel.text = buttonPressed;
				self.justPressedOperator = NO;
			} else {
				self.numberLabel.text = [self.numberLabel.text stringByAppendingString:buttonPressed];
			}
		}
	} else if ([@[@"+", @"X", @"-", @"/"] containsObject:buttonPressed]){
		[self calculateValue];
		self.currentOperator = buttonPressed;
		self.justPressedOperator = YES;
		self.valueStored = [self.numberLabel.text doubleValue];
	} else if ([buttonPressed  isEqualToString:@"="]){
		[self calculateValue];
		self.justPressedOperator = NO;
		self.currentOperator = @"";
		self.valueStored = [self.numberLabel.text doubleValue];
	}
}

- (void)calculateValue{
	double result;
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	formatter.numberStyle = NSNumberFormatterDecimalStyle;
	formatter.maximumFractionDigits = 20;
	
	double currentValue = [self.numberLabel.text doubleValue];
	if ([self.currentOperator isEqualToString:@"+"]) {
		result = self.valueStored + currentValue;
	} else if ([self.currentOperator isEqualToString:@"-"]) {
		result = self.valueStored - currentValue;
	} else if ([self.currentOperator isEqualToString:@"X"]){
		result = self.valueStored * currentValue;
	} else if ([self.currentOperator isEqualToString:@"/"]){
		result = self.valueStored / currentValue;
	} else {
		return;
	}
	self.numberLabel.text = [formatter stringFromNumber:[NSNumber numberWithDouble:result]];
}

@end
