//
//  SearchViewController.m
//  Localyze
//
//  Created by Valentin Filip on 25/08/2013.
//  Copyright (c) 2013 AppDesignVault. All rights reserved.
//
#define kOFFSET_FOR_KEYBOARD 120

#import "ZipViewController.h"

@implementation ZipViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _titleLabel.font = [UIFont fontWithName:@"Avenir-Book" size:40];
    
    _alternativeLabel.textColor = [UIColor colorWithRed:0.52f green:0.55f blue:0.56f alpha:1.00f];
    _alternativeLabel.font = [UIFont fontWithName:@"Avenir-Book" size:15];
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    _textField.leftView = paddingView;
    _textField.leftViewMode = UITextFieldViewModeAlways;
    
    _textField.font = [UIFont fontWithName:@"Avenir-Black" size:15];
    
    _textField.returnKeyType = UIReturnKeyDone;
    
    _searchButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Black" size:17];
    [_searchButton setTitleColor:[UIColor colorWithRed:0.63f green:0.64f blue:0.69f alpha:1.00f] forState:UIControlStateNormal];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.33f green:0.34f blue:0.38f alpha:1.00f];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapView:)];
    gesture.delegate = self;
    [self.view addGestureRecognizer:gesture];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) 
                                                 name:UIKeyboardWillShowNotification object:self.view.window];
}

- (void)viewWillDisappear:(BOOL)animated {
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil]; 
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.textField = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Actions

- (IBAction)actionSearch:(id)sender {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actionClose:(id)sender {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UIGestureRecognizer delegate

- (void)didTapView:(UIGestureRecognizer *)recognizer {
    [self.view endEditing:YES];
    if (![_textField isFirstResponder] && self.view.frame.origin.y < 0) {
        [self setViewMovedUp:NO];
    }
}


#pragma mark - UITextField delegate


-(void)textFieldDidBeginEditing:(UITextField *)sender {
    if ([sender isEqual:_textField]) {
        if  (self.view.frame.origin.y >= 0) {
            [self setViewMovedUp:YES];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self actionSearch:nil];
    
    return NO;
}


#pragma mark - Keyboard handler

- (void)keyboardWillShow:(NSNotification *)notif {
    if ([_textField isFirstResponder] && self.view.frame.origin.y >= 0) {
        [self setViewMovedUp:YES];
    } else if (![_textField isFirstResponder] && self.view.frame.origin.y < 0) {
        [self setViewMovedUp:NO];
    }
}


- (void)setViewMovedUp:(BOOL)movedUp {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp) {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    } else {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}




@end
