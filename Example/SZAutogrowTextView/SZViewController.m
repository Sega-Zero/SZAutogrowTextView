//
//  SZViewController.m
//  SZAutogrowTextView
//
//  Created by Сергей Галездинов on 09/05/2015.
//  Copyright (c) 2015 Сергей Галездинов. All rights reserved.
//

#import "SZViewController.h"
#import <SZAutogrowTextView/SZAutogrowTextView.h>

@interface SZViewController ()<UITextViewDelegate>

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *textInputBottomConstraint;
@property (strong, nonatomic) IBOutlet UITextField *placeholderTextfield;
@property (strong, nonatomic) IBOutlet SZAutogrowTextView *messageTextInput;

@end

@implementation SZViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark Actions

- (IBAction)hideKeyboard:(id)sender {
    [self.messageTextInput resignFirstResponder];
}

#pragma mark keyboard notifications

- (void)keyboardWillBeShown:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;

    self.textInputBottomConstraint.constant = kbSize.height;

    [UIView animateWithDuration:.2 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    self.textInputBottomConstraint.constant = 0;

    [UIView animateWithDuration:.2 animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark TextView delegate

-(void)textViewDidChange:(UITextView *)textView {
    self.placeholderTextfield.placeholder = self.messageTextInput.text.length > 0 ? @"" : NSLocalizedString(@"Enter your message", "placeholder string for message input");
}
@end
