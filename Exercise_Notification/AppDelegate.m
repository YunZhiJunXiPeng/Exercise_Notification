//
//  AppDelegate.m
//  Exercise_Notification
//
//  Created by 云之君兮鹏 on 16/10/7.
//  Copyright © 2016年 小超人. All rights reserved.
//

#import "AppDelegate.h"
// 引入通知头文件
#import <UserNotifications/UserNotifications.h>


@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // 注册通知在 iOS10 之前
//    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert) categories:nil];
//    [application registerUserNotificationSettings:settings];
//    
     // 注册推送通知,iOS10之后不管是本地通知还是远程推送通知，都将采用注册，以及请求发送的形式
    UNUserNotificationCenter *notificationCenter = [UNUserNotificationCenter currentNotificationCenter];
    notificationCenter.delegate = self;
    /**
     
     用户授权应用程序通知用户需要使用UNUserNotificationCenter通过本地和远程通知。

     @param  option  参数设置支持通知的样式，声音，横幅，弹框，等
     @param  error   错误信息
     @param  granted 授予成功
     */
    [notificationCenter requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError * _Nullable error) {
        
        NSLog(@"授权推送通知---->%d--%@", granted, error);
        
    }];; //
    
    
    
    //1.初始化通知
    
    /*
     UNNotificationContent: 用来具体描述通知的一个类
     一些关键属性：
     attachments   这个数组存储的是 UNNotificationAttachment类 实例对象（UNNotificationAttachment类的作用  当我们想要推送带“图片”和”视频“的通知，就需要靠这个类的实例化方法实现，然后放到这个属性的数组下。注意只能是本地文件，要想使网络的上的先存到本地）
     
     
     
     */
    
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    
    // 应用图标上数字
    content.badge = @100;
    content.title = @"本地推送";
    content.body = @"但使龙城飞将在，通知的详细内容！";  // 没有body的话不会弹出通知
    content.sound = [UNNotificationSound defaultSound];;// 通知 的 声音
    content.launchImageName = @"a.png";
    
    NSString * pathImage =  [[NSBundle mainBundle] pathForResource:@"a"ofType:@"png"]; // 在推送通知上展示的图片路径

    content.attachments = @[ [UNNotificationAttachment attachmentWithIdentifier:@"ShowImage" URL:[NSURL fileURLWithPath:pathImage] options:nil error:nil]]; // 通知附带其他东西 这是给了个图片
    
    // 推送的触发条件 时机
    /*
     UNCalenderNotificaitionTrigger（某时固定触发通知）
     UNLocationNotificaitionTrigger （当进入某一区域触发通知）
     UNTimeIntervalNotificaitionTrigger （时间间隔触发通知）*/
    
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:2.0 repeats:NO];// 2秒后推送 不重复推送
//    UNCalendarNotificationTrigger *timeTrigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:NSDateComponents对象 repeats:重复不]
//    
//    UNLocationNotificationTrigger *locationTrigger = [UNLocationNotificationTrigger triggerWithRegion:区域 repeats:重复与否]
    
  
/*
 设置推送的请求根据  推送的内容  推送时机
 */
UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"PP_Notification" content:content trigger:trigger];

//参数就是触发时机和通知组件

UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
[center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
    
    if (error) {
        
    }
    
}];
    
 
    
    
    return YES;
}

// 这里设置前台展示的类型  声音 弹窗 条幅  默认是不展示的所以一定要设置
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    completionHandler(UNNotificationPresentationOptionAlert|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound);
}

// 处理用户与通知交互后的操作
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
     NSLog(@"%s--->处理通知的交互",__func__);
}





- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
