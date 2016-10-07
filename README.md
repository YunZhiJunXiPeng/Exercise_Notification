# Exercise_Notification
一个关于推送的小总结！
### 本地推送和远程推送
>  - 远程的推送通知和本地推送通知，都是可以在 App 不在前台运行的时候向其发送相应的消息，这种消息来自服务器下发的最新的数据或者是本地提醒用户要做得事，两种通知在用户手机端展示的效果是一样的，基本上都是用户设置展示成一段信息内容或者是 App 的应用图片相应的标志。
 
>-  使用推送的目的是主要就是让 App 能够通知使用者一些事情，并且不强求 App 必须在前台。


> -  本地推送由 App 端自行调用，只能由当前使用的设备（手机端）发出；远程推送是服务器发送到 APNs（苹果推送通知服务 Apple Push Notification service ），再转发推送到设备上 App
 - 本地推送： 不需要联网，我们只需要在 App 中设置特定的时间提醒使用者要做啥就行了。（例如：按时提醒病人吃药）
 - 远程推送：需要联网，我们的客户端设备和 APNs 服务器会形成一个长连接，设备会向苹果的服务器发送 UIID 和 Bundle ID，苹果的服务器利用加密生成 deviceToken 给用户设备，用户设备将这个 deviceToken 发送给自己的服务器（下发推送消息的服务器），服务器会进行的数据库存储操作。
     -  需要向某设备发送推送消息的时候，如果用户 App 在线使用中， 我们的服务器和 App 建立长连接，把推送的消息通过 deviceToken 区分直接推送到设备。
    - 如果App没有在线使用的话，我们服务器会把要推送的消息和 deviceToken 发送给苹果的服务器，由苹果的服务器根据 deviceToken 找到对应的设备进行消息的推送

------
##### 用户可以设置推送通知展现样式
> 1.App图标上的消息数字,应用图标标记（例如 QQ 红色圆圈显示未读消息数字）
2.屏幕顶部显示横幅展示消息内容
3.锁屏屏幕上显示消息内容
4.声音提醒
5.弹窗提醒吧
6.忘了还有没有，有的话再来补充。

--------
#### iOS 10 之后的改变 
>1. 所有相关通知被统一到了UserNotifications.framework框架中。
2. 增加了撤销、更新、中途还可以修改通知的内容。
3. 通知不在是简单的文本了，可以加入视频、图片，自定义通知的展示
4. 对于权限问题进行了优化，申请权限就比较简单了(本地与远程通知集成在一个方法中)。

-------
###### 上代码 先写个简单的本地通知吧，我发现一写的话内容就好多了慢慢写吧！：
- iOS 之前一般这样注册本地通知,然后就是一些其他的设置
```code 
 //    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert) categories:nil];
//    [application registerUserNotificationSettings:settings]; ```

- 直接看 iOS10代码吧，注册通知并且设置一下样式
```code
 // 注册推送通知,iOS10之后   不管是本地通知还是远程推送通知,都是注册然后发送请求的形式存在。
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
    ```
- ### 代理方法实现：

```code 
// 这里设置前台展示的类型  声音 弹窗 条幅  默认是不展示的所以一定要设置
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    completionHandler(UNNotificationPresentationOptionAlert|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound);
}
// 处理用户与通知交互后的操作 点击了推送消息 打印了结果
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
     NSLog(@"%s--->处理通知的交互",__func__);
}
```



- 初始化一个通知的内容
> - UNNotificationContent: 用来具体描述通知的一个类
     一些关键属性：
    -  attachments    这个数组存储的是 UNNotificationAttachment类 实例对象（UNNotificationAttachment类的作用 : 当我们想要推送带“图片”和”视频“的通知，就需要靠这个类的实例化方法实现，然后放到这个属性的数组下。注意只能是本地文件，要想使网络的上的先存到本地）
   - 其他的属性有时间我再补充今天先说几个，再不写完肯德鸡要撵人了！

```code 
UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
   content.badge = @100; // 应用图标上数字
   content.title = @"本地推送";
   content.sound = [UNNotificationSound defaultSound];;// 通知 的 声音
   content.body = @"但使龙城飞将在，通知的详细内容！";  // 没有body的话不会弹出通知
// 在推送通知上展示的图片路径
 NSString * pathImage =  [[NSBundle mainBundle] pathForResource:@"a"ofType:@"png"];
// 通知附带其他东西 这是给了个图片  根据上边的路径
 content.attachments = @[ [UNNotificationAttachment attachmentWithIdentifier:@"ShowImage" URL:[NSURL fileURLWithPath:pathImage] options:nil error:nil]]; ```

- 设置推送的时机，也就是这个通知怎么去触发
>UNCalenderNotificaitionTrigger（某一时间固定触发通知）
     UNLocationNotificaitionTrigger （当进入某一区域触发通知）
     UNTimeIntervalNotificaitionTrigger （设置时间间隔触发通知）

```code 
// 2秒后推送 不重复推送
UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:2.0 repeats:NO];```

- 设置推送的请求    依据  推送的内容  推送时机

```code 
// 参数  请求的标示符  通知的内容 通知的触发机制
UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"PP_Notification" content:content trigger:trigger];```

- 把这个请求添加给用户通知中心

```code
UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
[center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
    
}];```

##### 效果展示
![](http://upload-images.jianshu.io/upload_images/1523603-e4bf72d71b0b600d.gif?imageMogr2/auto-orient/strip)
