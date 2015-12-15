//
//  AnimationViewController.m
//  Mars
//
//  Created by jiamai on 15/10/14.
//  Copyright © 2015年 runsdata. All rights reserved.
//

#import "AnimationViewController.h"
#import "POP.h"

@interface AnimationViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *springView;

@end

@implementation AnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.springView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *gestureForSpring = [[UITapGestureRecognizer alloc]init];
    [gestureForSpring addTarget:self action:@selector(changeSize:)];
    [_springView addGestureRecognizer:gestureForSpring];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)changeSize:(UITapGestureRecognizer *)tap{
    POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerSize];
    CGRect rect = _springView.frame;
    if (rect.size.width ==100) {
        springAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(300, 300)];
    }
    else{
        springAnimation.toValue =[NSValue valueWithCGSize:CGSizeMake(100, 100)];
    }
    springAnimation.springBounciness = 20.0;//弹性值
    springAnimation.springSpeed = 20.0;//弹性速度
    [_springView.layer pop_addAnimation:springAnimation forKey:@"changesize"];
}


//- (void)touchesBegan:(nonnull NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
//    POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
//    CGPoint point =  _springView.center;
//    if (point.y == 240) {
//        springAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(point.x, -230)];
//    }else{
//        springAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(point.x, 240)];
//    }
//    springAnimation.springSpeed = 20.0;
//    springAnimation.springBounciness = 20.0;
//    [_springView pop_addAnimation:springAnimation forKey:@"changeposition"];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
