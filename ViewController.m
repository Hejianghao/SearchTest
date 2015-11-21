//
//  ViewController.m
//  SearchTest
//
//  Created by Johannes on 15/11/9.
//  Copyright © 2015年 何江浩. All rights reserved.
//

#import "ViewController.h"
#import "TableViewController.h"

@interface ViewController (){
    NSString *_preTangshi;
}

@property (nonatomic, strong) IBOutlet UITextField *textField;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *saveItem;

- (IBAction) saveTangShi:(id)sender;

@end

@implementation ViewController

- (void) loadView {
    [super loadView];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    NSLog(@"loadView");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"viewDidLoad");
    _textField.text = _tangshiCtn;
    _preTangshi = _tangshiCtn;
    if (_index < 0) {
        self.navigationItem.rightBarButtonItem = nil;
        [_textField setUserInteractionEnabled:NO];
    } else {
        [_textField becomeFirstResponder];
    }
    
    
}

- (void) viewWillDisappear:(BOOL)animated {
    [_textField resignFirstResponder];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) saveTangShi:(id)sender {
    //先去掉两边的空格
    NSString *text = [_textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSLog(@"text:%@",text);
    //判断是否为空
    if ([text isEqualToString:@""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"Can't be empty!", nil) preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    if ([_preTangshi isEqualToString:_textField.text]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"No change!", nil) preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    [self.delegate updateTangshiWithIndex:_index andContent:text];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
