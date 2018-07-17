//
//  AppDelegate.m
//  PolyvVodSDKDemo
//
//  Created by BqLin on 2017/11/9.
//  Copyright © 2017年 BqLin. All rights reserved.
//

#import "AppDelegate.h"
#import "PLVCourseNetworking.h"
#import "PLVCourse.h"
#import <PLVVodSDK/PLVVodSDK.h>
#import "PLVSchool.h"
#import "PLVVodAccountVideo.h"
#import <PLVVodSDK/PLVVodSDK.h>

static NSString * const PLVVodKeySettingKey = @"vodKey_preference";
static NSString * const PLVSdkVersionSettingKey = @"sdkVersion_preference";
static NSString * const PLVApplySettingKey = @"apply_preference";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// Override point for customization after application launch.
	NSError *error = nil;
	PLVSchool *school = [PLVSchool sharedInstance];
	NSString *vodKey = school.vodKey;
	NSString *decodeKey = school.vodKeyDecodeKey;
	NSString *decodeIv = school.vodKeyDecodeIv;
	PLVVodSettings *settings = [PLVVodSettings settingsWithConfigString:vodKey key:decodeKey iv:decodeIv error:&error];
	
	// 读取并替换设置项。出于安全考虑，不建议从 plist 读取加密串，直接在代码中写入加密串更为安全。
	{
		NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
		BOOL enableUserVodKey = [user boolForKey:PLVApplySettingKey];
		if (enableUserVodKey) {
			NSString *userVodKey = [user stringForKey:PLVVodKeySettingKey];
			userVodKey = [userVodKey stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			if (userVodKey.length) {
				settings = [PLVVodSettings settingsWithConfigString:userVodKey error:&error];
			}
		}
	}
	
	NSLog(@"settings: %@", settings);
	if (error) {
		NSLog(@"account settings error: %@", error);
	}
	
	// PLVVodDownloadManager 下载配置
	{
		PLVVodDownloadManager *downloadManager = [PLVVodDownloadManager sharedManager];
		//downloadManager.autoStart = YES;
		// 下载错误统一回调
		downloadManager.downloadErrorHandler = ^(PLVVodVideo *video, NSError *error) {
			NSLog(@"download error: %@\n%@", video.vid, error);
		};
		
		// 若需兼容 1.x.x 版本 SDK 视频，则需解注以下代码
		// 首先需确保 `downloadManager.downloadDir` 与之前版本的下载目录一致，然后调用兼容 1.x.x 离线视频方法
		//downloadManager.downloadDir = <#1.x.x版本的下载目录#>
		//[downloadManager compatibleWithPreviousVideos];
	}
	
	// 接收远程事件
	[[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
	[self becomeFirstResponder];
	[self updateSettingsBundle];
	return YES;
}

- (void)updateSettingsBundle {
	NSString *path = [[NSBundle mainBundle] pathForResource:@"Settings.bundle/Root.plist" ofType:nil];
	NSMutableDictionary *settingsBundleDic = [NSDictionary dictionaryWithContentsOfFile:path].mutableCopy;
	NSString *settingBundleKey = @"PreferenceSpecifiers";
	NSMutableArray *settingsBundles = [settingsBundleDic[settingBundleKey] mutableCopy];
	settingsBundleDic[settingBundleKey] = settingsBundles;
	
	for (int i = 0; i < settingsBundles.count; i++) {
		NSDictionary *dic = settingsBundles[i];
		if ([dic[@"Key"] isEqualToString:PLVSdkVersionSettingKey]) {
			NSMutableDictionary *versionDic = dic.mutableCopy;
			versionDic[@"Title"] = [NSString stringWithFormat:@"SDK 版本：%@", PLVVodSdkVersion];
			[settingsBundles replaceObjectAtIndex:i withObject:versionDic];
			break;
		}
	}
	[settingsBundleDic writeToFile:path atomically:YES];
}

/// 转发远程事件
- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
	[[NSNotificationCenter defaultCenter] postNotificationName:PLVVodRemoteControlEventDidReceiveNotification object:self userInfo:@{PLVVodRemoteControlEventKey: event}];
}

// 为后台下载进行桥接
- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)(void))completionHandler {
    NSLog(@"++++++++ %@ ++++++++ identifier: %@", NSStringFromSelector(_cmd), identifier);

	[PLVVodDownloadManager sharedManager].backgroundCompletionHandler = completionHandler;
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
    
    // save download state 
    [[PLVVodDownloadManager sharedManager] applicationWillTerminate];
}


@end
