//
//  JCWrapNavigationController.m
//  JCNavigationController
//
//  Created by Jam on 16/3/28.
//  Copyright © 2016年 Jam. All rights reserved.
//

#import "JCWrapNavigationController.h"
#import "JCWrapViewController.h"
#import "UIViewController+JCNavigationControllerExtension.h"

@interface JCWrapNavigationController ()

@end

@implementation JCWrapNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    return [self.navigationController popViewControllerAnimated:animated];
}

- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
    return [self.navigationController popToRootViewControllerAnimated:animated];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
//FEIYU 此处对返回按钮图标做过修改
//    UIImage *backItemImage = [UIImage imageNamed:@"jcnavigationitem_back"];
//    viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backItemImage style:UIBarButtonItemStylePlain target:self action:@selector(didTapBackButton)];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 44.0, 44.0)];
    [button addTarget:self action:@selector(didTapBackButton) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"itemBack"] forState:UIControlStateNormal];
//    [button setImage:[UIImage imageNamed:@"itemBack_Select"] forState:UIControlStateHighlighted];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0f, 0.0, 0.0)];
    
    viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    [self.navigationController pushViewController:[JCWrapViewController wrapViewControllerWithRootController:viewController] animated:animated];
}

- (void)didTapBackButton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion{
    [self.navigationController dismissViewControllerAnimated:flag completion:completion];
    self.viewControllers.firstObject.jcNavigationController = nil;
}


#pragma mark - Public Method

- (void)setBackGestureRecognizerEnable:(BOOL)isEnable {
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        [(JCNavigationViewController *)self.navigationController setBackGestureRecognizerEnable:isEnable];
    }
}

@end
