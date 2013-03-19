//
//  AppDelegate.m
//  MK_iOS_Push
//
//  Created by zucknet on 13/3/19.
//  Copyright (c) 2013年 zucknet. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

//以下推送方法适合 开发调试时使用.... 期待后续更新....

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //消息推送支持的类型
    UIRemoteNotificationType types =
    (UIRemoteNotificationTypeBadge
     |UIRemoteNotificationTypeSound
     |UIRemoteNotificationTypeAlert);
    
    //注册消息推送
    [[UIApplication sharedApplication]registerForRemoteNotificationTypes:types];
    
    //判断程序是不是由推送服务完成的 程序关闭从外面打开提醒时首先调用到的方法
    if (launchOptions) {
        //自定义本地服务
        NSDictionary* pushNotificationKey = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        
        //当用户打开程序时候收到远程通知后执行
        if (application.applicationState != UIApplicationStateActive) {
            
//            NSString *testPushNumber = [NSString stringWithFormat:@"%@",[[pushNotificationKey objectForKey:@"aps"]objectForKey:@"push_type"]];  // 后面objectForKey填写服务器返回类型 然后进行判断
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"推送通知" message:@"当你看到这个通知说明推送服务已启动" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    return YES;
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSLog(@"我的 token is: %@", deviceToken); //如果没有获取到Token 则调用下面方法.....
    
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"获取token时发生错误: %@ ........", error);
}


//程序运行时推送方法
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    //暂时先注释关于图标badge number
    
    //    NSLog(@"received badge number ---%@ ----",[[userInfo objectForKey:@"aps"] objectForKey:@"badge"]);
    //
    //    for (id key in userInfo) {
    //        NSLog(@"key: %@, value: %@", key, [userInfo objectForKey:key]);
    //    }
    //
    //    NSLog(@"the badge number is  %d",  [[UIApplication sharedApplication] applicationIconBadgeNumber]);
    //    NSLog(@"the application  badge number is  %d",  application.applicationIconBadgeNumber);
    //    application.applicationIconBadgeNumber += 1;
    
    //当用户打开程序时候收到远程通知后执行
    if (application.applicationState == UIApplicationStateActive) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                            message:[NSString stringWithFormat:@"\n%@",
                                                                     [[userInfo objectForKey:@"aps"] objectForKey:@"push_type"]]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        
        dispatch_async(dispatch_get_global_queue(0,0), ^{
            //hide the badge
            application.applicationIconBadgeNumber = 0;
        });
        [alertView show];
    }
    
}






@end
