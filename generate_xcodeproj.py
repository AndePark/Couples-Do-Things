#!/usr/bin/env python3
"""Write a minimal but valid Xcode project for Couples Do Things."""
from pathlib import Path

ROOT = Path(__file__).resolve().parent
PROJ = ROOT / "CouplesDoThings.xcodeproj"
PROJ.mkdir(exist_ok=True)

pbx = r"""// !$*UTF8*$!
{
	archiveVersion = 1;
	classes = {
	};
	objectVersion = 56;
	objects = {

/* Begin PBXBuildFile section */
		AA0000010000000000000001 /* CouplesDoThingsApp.swift in Sources */ = {isa = PBXBuildFile; fileRef = AB0000010000000000000001; };
		AA0000010000000000000002 /* Theme.swift in Sources */ = {isa = PBXBuildFile; fileRef = AB0000010000000000000002; };
		AA0000010000000000000003 /* Models.swift in Sources */ = {isa = PBXBuildFile; fileRef = AB0000010000000000000003; };
		AA0000010000000000000004 /* AuthService.swift in Sources */ = {isa = PBXBuildFile; fileRef = AB0000010000000000000004; };
		AA0000010000000000000005 /* CoupleService.swift in Sources */ = {isa = PBXBuildFile; fileRef = AB0000010000000000000005; };
		AA0000010000000000000006 /* ItemService.swift in Sources */ = {isa = PBXBuildFile; fileRef = AB0000010000000000000006; };
		AA0000010000000000000007 /* SessionStore.swift in Sources */ = {isa = PBXBuildFile; fileRef = AB0000010000000000000007; };
		AA0000010000000000000008 /* RootView.swift in Sources */ = {isa = PBXBuildFile; fileRef = AB0000010000000000000008; };
		AA0000010000000000000009 /* SignInView.swift in Sources */ = {isa = PBXBuildFile; fileRef = AB0000010000000000000009; };
		AA000001000000000000000A /* CreateJoinView.swift in Sources */ = {isa = PBXBuildFile; fileRef = AB000001000000000000000A; };
		AA000001000000000000000B /* MainTabView.swift in Sources */ = {isa = PBXBuildFile; fileRef = AB000001000000000000000B; };
		AA000001000000000000000C /* ItemListView.swift in Sources */ = {isa = PBXBuildFile; fileRef = AB000001000000000000000C; };
		AA000001000000000000000D /* ItemEditorView.swift in Sources */ = {isa = PBXBuildFile; fileRef = AB000001000000000000000D; };
		AA000001000000000000000E /* MemoriesView.swift in Sources */ = {isa = PBXBuildFile; fileRef = AB000001000000000000000E; };
		AA000001000000000000000F /* SettingsView.swift in Sources */ = {isa = PBXBuildFile; fileRef = AB000001000000000000000F; };
		AA0000010000000000000010 /* AppConstants.swift in Sources */ = {isa = PBXBuildFile; fileRef = AB0000010000000000000010; };
		AA0000010000000000000011 /* DeepLink.swift in Sources */ = {isa = PBXBuildFile; fileRef = AB0000010000000000000011; };
		AA0000010000000000000012 /* WidgetSnapshot.swift in Sources */ = {isa = PBXBuildFile; fileRef = AB0000010000000000000012; };
		AA0000010000000000000013 /* WidgetDataStore.swift in Sources */ = {isa = PBXBuildFile; fileRef = AB0000010000000000000013; };
		AA0000010000000000000014 /* Assets.xcassets in Resources */ = {isa = PBXBuildFile; fileRef = AB0000010000000000000014; };
		AA0000010000000000000015 /* GoogleService-Info.plist in Resources */ = {isa = PBXBuildFile; fileRef = AB0000010000000000000015; };
		AA0000010000000000000016 /* FirebaseAuth in Frameworks */ = {isa = PBXBuildFile; productRef = PK0000010000000000000001; };
		AA0000010000000000000017 /* FirebaseFirestore in Frameworks */ = {isa = PBXBuildFile; productRef = PK0000010000000000000002; };
		AA0000010000000000000018 /* FirebaseCore in Frameworks */ = {isa = PBXBuildFile; productRef = PK0000010000000000000003; };
		AA0000010000000000000019 /* CouplesDoThingsWidget.appex in Embed Foundation Extensions */ = {isa = PBXBuildFile; fileRef = AB0000010000000000000020; settings = {ATTRIBUTES = (RemoveHeadersOnCopy, ); }; };
		AA000001000000000000001A /* CouplesDoThingsWidget.swift in Sources */ = {isa = PBXBuildFile; fileRef = AB000001000000000000001A; };
		AA000001000000000000001B /* CouplesDoThingsWidgetBundle.swift in Sources */ = {isa = PBXBuildFile; fileRef = AB000001000000000000001B; };
		AA000001000000000000001C /* AppConstants.swift in Sources */ = {isa = PBXBuildFile; fileRef = AB0000010000000000000010; };
		AA000001000000000000001D /* DeepLink.swift in Sources */ = {isa = PBXBuildFile; fileRef = AB0000010000000000000011; };
		AA000001000000000000001E /* WidgetSnapshot.swift in Sources */ = {isa = PBXBuildFile; fileRef = AB0000010000000000000012; };
		AA000001000000000000001F /* WidgetDataStore.swift in Sources */ = {isa = PBXBuildFile; fileRef = AB0000010000000000000013; };
		AA0000010000000000000021 /* Assets.xcassets in Resources */ = {isa = PBXBuildFile; fileRef = AB0000010000000000000021; };
		AA0000010000000000000022 /* WidgetKit.framework in Frameworks */ = {isa = PBXBuildFile; fileRef = AB0000010000000000000022; };
		AA0000010000000000000023 /* SwiftUI.framework in Frameworks */ = {isa = PBXBuildFile; fileRef = AB0000010000000000000023; };
		AA0000010000000000000024 /* AuthenticationServices.framework in Frameworks */ = {isa = PBXBuildFile; fileRef = AB0000010000000000000024; };
/* End PBXBuildFile section */

/* Begin PBXContainerItemProxy section */
		PX0000010000000000000001 /* PBXContainerItemProxy */ = {
			isa = PBXContainerItemProxy;
			containerPortal = PR0000010000000000000001 /* Project object */;
			proxyType = 1;
			remoteGlobalIDString = TG0000010000000000000002;
			remoteInfo = CouplesDoThingsWidget;
		};
/* End PBXContainerItemProxy section */

/* Begin PBXCopyFilesBuildPhase section */
		CP0000010000000000000001 /* Embed Foundation Extensions */ = {
			isa = PBXCopyFilesBuildPhase;
			buildActionMask = 2147483647;
			dstPath = "";
 mar			dstSubfolderSpec = 13;
			files = (
				AA0000010000000000000019 /* CouplesDoThingsWidget.appex in Embed Foundation Extensions */,
			);
			name = "Embed Foundation Extensions";
			runOnlyForDeploymentPostprocessing = 0;
		};
/* End PBXCopyFilesBuildPhase section */

/* Begin PBXFileReference section */
		AB0000010000000000000001 /* CouplesDoThingsApp.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = CouplesDoThingsApp.swift; sourceTree = "<group>"; };
		AB0000010000000000000002 /* Theme.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = Theme.swift; sourceTree = "<group>"; };
		AB0000010000000000000003 /* Models.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = Models.swift; sourceTree = "<group>"; };
		AB0000010000000000000004 /* AuthService.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = AuthService.swift; sourceTree = "<group>"; };
		AB0000010000000000000005 /* CoupleService.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = CoupleService.swift; sourceTree = "<group>"; };
		AB0000010000000000000006 /* ItemService.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = ItemService.swift; sourceTree = "<group>"; };
		AB0000010000000000000007 /* SessionStore.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = SessionStore.swift; sourceTree = "<group>"; };
		AB0000010000000000000008 /* RootView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = RootView.swift; sourceTree = "<group>"; };
		AB0000010000000000000009 /* SignInView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = SignInView.swift; sourceTree = "<group>"; };
		AB000001000000000000000A /* CreateJoinView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = CreateJoinView.swift; sourceTree = "<group>"; };
		AB000001000000000000000B /* MainTabView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = MainTabView.swift; sourceTree = "<group>"; };
		AB000001000000000000000C /* ItemListView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = ItemListView.swift; sourceTree = "<group>"; };
		AB000001000000000000000D /* ItemEditorView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = ItemEditorView.swift; sourceTree = "<group>"; };
		AB000001000000000000000E /* MemoriesView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = MemoriesView.swift; sourceTree = "<group>"; };
		AB000001000000000000000F /* SettingsView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = SettingsView.swift; sourceTree = "<group>"; };
		AB0000010000000000000010 /* AppConstants.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = AppConstants.swift; sourceTree = "<group>"; };
		AB0000010000000000000011 /* DeepLink.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = DeepLink.swift; sourceTree = "<group>"; };
		AB0000010000000000000012 /* WidgetSnapshot.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = WidgetSnapshot.swift; sourceTree = "<group>"; };
		AB0000010000000000000013 /* WidgetDataStore.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = WidgetDataStore.swift; sourceTree = "<group>"; };
		AB0000010000000000000014 /* Assets.xcassets */ = {isa = PBXFileReference; lastKnownFileType = folder.assetcatalog; path = Assets.xcassets; sourceTree = "<group>"; };
		AB0000010000000000000015 /* GoogleService-Info.plist */ = {isa = PBXFileReference; lastKnownFileType = text.plist.xml; path = "GoogleService-Info.plist"; sourceTree = "<group>"; };
		AB0000010000000000000016 /* Info.plist */ = {isa = PBXFileReference; lastKnownFileType = text.plist.xml; path = Info.plist; sourceTree = "<group>"; };
		AB0000010000000000000017 /* CouplesDoThings.entitlements */ = {isa = PBXFileReference; lastKnownFileType = text.plist.entitlements; path = CouplesDoThings.entitlements; sourceTree = "<group>"; };
		AB000001000000000000001A /* CouplesDoThingsWidget.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = CouplesDoThingsWidget.swift; sourceTree = "<group>"; };
		AB000001000000000000001B /* CouplesDoThingsWidgetBundle.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = CouplesDoThingsWidgetBundle.swift; sourceTree = "<group>"; };
		AB0000010000000000000020 /* CouplesDoThingsWidget.appex */ = {isa = PBXFileReference; explicitFileType = "wrapper.app-extension"; includeInIndex = 0; path = CouplesDoThingsWidget.appex; sourceTree = BUILT_PRODUCTS_DIR; };
		AB0000010000000000000021 /* Assets.xcassets */ = {isa = PBXFileReference; lastKnownFileType = folder.assetcatalog; path = Assets.xcassets; sourceTree = "<group>"; };
		AB0000010000000000000022 /* WidgetKit.framework */ = {isa = PBXFileReference; lastKnownFileType = wrapper.framework; name = WidgetKit.framework; path = System/Library/Frameworks/WidgetKit.framework; sourceTree = SDKROOT; };
		AB0000010000000000000023 /* SwiftUI.framework */ = {isa = PBXFileReference; lastKnownFileType = wrapper.framework; name = SwiftUI.framework; path = System/Library/Frameworks/SwiftUI.framework; sourceTree = SDKROOT; };
		AB0000010000000000000024 /* AuthenticationServices.framework */ = {isa = PBXFileReference; lastKnownFileType = wrapper.framework; name = AuthenticationServices.framework; path = System/Library/Frameworks/AuthenticationServices.framework; sourceTree = SDKROOT; };
		AB0000010000000000000025 /* Info.plist */ = {isa = PBXFileReference; lastKnownFileType = text.plist.xml; path = Info.plist; sourceTree = "<group>"; };
		AB0000010000000000000026 /* CouplesDoThingsWidget.entitlements */ = {isa = PBXFileReference; lastKnownFileType = text.plist.entitlements; path = CouplesDoThingsWidget.entitlements; sourceTree = "<group>"; };
		AB0000010000000000000027 /* CouplesDoThings.app */ = {isa = PBXFileReference; explicitFileType = wrapper.application; includeInIndex = 0; path = CouplesDoThings.app; sourceTree = BUILT_PRODUCTS_DIR; };
/* End PBXFileReference section */

/* Begin PBXFrameworksBuildPhase section */
		FW0000010000000000000001 /* Frameworks */ = {
			isa = PBXFrameworksBuildPhase;
			buildActionMask = 2147483647;
			files = (
				AA0000010000000000000024 /* AuthenticationServices.framework in Frameworks */,
				AA0000010000000000000018 /* FirebaseCore in Frameworks */,
				AA0000010000000000000016 /* FirebaseAuth in Frameworks */,
				AA0000010000000000000017 /* FirebaseFirestore in Frameworks */,
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
		FW0000010000000000000002 /* Frameworks */ = {
			isa = PBXFrameworksBuildPhase;
 mar			buildActionMask = 2147483647;
			files = (
				AA0000010000000000000022 /* WidgetKit.framework in Frameworks */,
				AA0000010000000000000023 /* SwiftUI.framework in Frameworks */,
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
/* End PBXFrameworksBuildPhase section */

/* Begin PBXGroup section */
		GR0000010000000000000001 = {
			isa = PBXGroup;
			children = (
				GR0000010000000000000002 /* CouplesDoThings */,
				GR0000010000000000000003 /* CouplesDoThingsWidget */,
				GR0000010000000000000004 /* Shared */,
				GR0000010000000000000005 /* Frameworks */,
				GR0000010000000000000006 /* Products */,
			);
			sourceTree = "<group>";
		};
		GR0000010000000000000002 /* CouplesDoThings */ = {
			isa = PBXGroup;
 mar			children = (
				AB0000010000000000000001 /* CouplesDoThingsApp.swift */,
				AB0000010000000000000002 /* Theme.swift */,
				GR0000010000000000000007 /* Models */,
				GR0000010000000000000008 /* Services */,
				GR0000010000000000000009 /* Views */,
				AB0000010000000000000014 /* Assets.xcassets */,
				AB0000010000000000000015 /* GoogleService-Info.plist */,
				AB0000010000000000000016 /* Info.plist */,
				AB0000010000000000000017 /* CouplesDoThings.entitlements */,
			);
			path = CouplesDoThings;
			sourceTree = "<group>";
		};
		GR0000010000000000000003 /* CouplesDoThingsWidget */ = {
			isa = PBXGroup;
			children = (
				AB000001000000000000001A /* CouplesDoThingsWidget.swift */,
				AB000001000000000000001B /* CouplesDoThingsWidgetBundle.swift */,
				AB0000010000000000000021 /* Assets.xcassets */,
				AB0000010000000000000025 /* Info.plist */,
				AB0000010000000000000026 /* CouplesDoThingsWidget.entitlements */,
			);
			path = CouplesDoThingsWidget;
			sourceTree = "<group>";
		};
		GR0000010000000000000004 /* Shared */ = {
			isa = PBXGroup;
			children = (
				AB0000010000000000000010 /* AppConstants.swift */,
				AB0000010000000000000011 /* DeepLink.swift */,
				AB0000010000000000000012 /* WidgetSnapshot.swift */,
				AB0000010000000000000013 /* WidgetDataStore.swift */,
			);
			path = Shared;
			sourceTree = "<group>";
		};
		GR0000010000000000000005 /* Frameworks */ = {
			isa = PBXGroup;
			children = (
				AB0000010000000000000024 /* AuthenticationServices.framework */,
				AB0000010000000000000022 /* WidgetKit.framework */,
				AB0000010000000000000023 /* SwiftUI.framework */,
			);
			name = Frameworks;
			sourceTree = "<group>";
		};
		GR0000010000000000000006 /* Products */ = {
			isa = PBXGroup;
			children = (
				AB0000010000000000000027 /* CouplesDoThings.app */,
				AB0000010000000000000020 /* CouplesDoThingsWidget.appex */,
			);
			name = Products;
			sourceTree = "<group>";
		};
		GR0000010000000000000007 /* Models */ = {
			isa = PBXGroup;
			children = (
				AB0000010000000000000003 /* Models.swift */,
			);
			path = Models;
			sourceTree = "<group>";
		};
		GR0000010000000000000008 /* Services */ = {
			isa = PBXGroup;
			children = (
				AB0000010000000000000004 /* AuthService.swift */,
				AB0000010000000000000005 /* CoupleService.swift */,
				AB0000010000000000000006 /* ItemService.swift */,
				AB0000010000000000000007 /* SessionStore.swift */,
 mar			);
			path = Services;
			sourceTree = "<group>";
		};
		GR0000010000000000000009 /* Views */ = {
			isa = PBXGroup;
			children = (
				AB0000010000000000000008 /* RootView.swift */,
				AB0000010000000000000009 /* SignInView.swift */,
				AB000001000000000000000A /* CreateJoinView.swift */,
				AB000001000000000000000B /* MainTabView.swift */,
				AB000001000000000000000C /* ItemListView.swift */,
				AB000001000000000000000D /* ItemEditorView.swift */,
				AB000001000000000000000E /* MemoriesView.swift */,
				AB000001000000000000000F /* SettingsView.swift */,
			);
			path = Views;
			sourceTree = "<group>";
		};
/* End PBXGroup section */

/* Begin PBXNativeTarget section */
		TG0000010000000000000001 /* CouplesDoThings */ = {
			isa = PBXNativeTarget;
			buildConfigurationList = CL0000010000000000000001 /* Build configuration list for PBXNativeTarget "CouplesDoThings" */;
			buildPhases = (
				SO0000010000000000000001 /* Sources */,
				FW0000010000000000000001 /* Frameworks */,
				RS0000010000000000000001 /* Resources */,
				CP0000010000000000000001 /* Embed Foundation Extensions */,
			);
			buildRules = (
			);
			dependencies = (
				TD0000010000000000000001 /* PBXTargetDependency */,
			);
			name = CouplesDoThings;
			packageProductDependencies = (
				PK0000010000000000000001 /* FirebaseAuth */,
				PK0000010000000000000002 /* FirebaseFirestore */,
				PK0000010000000000000003 /* FirebaseCore */,
			);
			productName = CouplesDoThings;
			productReference = AB0000010000000000000027 /* CouplesDoThings.app */;
			productType = "com.apple.product-type.application";
		};
		TG0000010000000000000002 /* CouplesDoThingsWidget */ = {
			isa = PBXNativeTarget;
			buildConfigurationList = CL0000010000000000000002 /* Build configuration list for PBXNativeTarget "CouplesDoThingsWidget" */;
			buildPhases = (
				SO0000010000000000000002 /* Sources */,
				FW0000010000000000000002 /* Frameworks */,
				RS0000010000000000000002 /* Resources */,
			);
			buildRules = (
			);
			dependencies = (
			);
			name = CouplesDoThingsWidget;
			productName = CouplesDoThingsWidget;
			productReference = AB0000010000000000000020 /* CouplesDoThingsWidget.appex */;
			productType = "com.apple.product-type.app-extension";
		};
/* End PBXNativeTarget section */

/* Begin PBXProject section */
		PR0000010000000000000001 /* Project object */ = {
			isa = PBXProject;
			attributes = {
				BuildIndependentTargetsInParallel = 1;
				LastSwiftUpdateCheck = 1500;
				LastUpgradeCheck = 1500;
				TargetAttributes = {
					TG0000010000000000000001 = {
						CreatedOnToolsVersion = 15.0;
					};
					TG0000010000000000000002 = {
						CreatedOnToolsVersion = 15.0;
					};
				};
			};
			buildConfigurationList = CL0000010000000000000003 /* Build configuration list for PBXProject "CouplesDoThings" */;
			compatibilityVersion = "Xcode 14.0";
			developmentRegion = en;
			hasScannedForEncodings = 0;
			knownRegions = (
				en,
				Base,
			);
			mainGroup = GR0000010000000000000001;
			packageReferences = (
				PP0000010000000000000001 /* XCRemoteSwiftPackageReference "firebase-ios-sdk" */,
			);
			productRefGroup = GR0000010000000000000006 /* Products */;
			projectDirPath = "";
			projectRoot = "";
			targets = (
				TG0000010000000000000001 /* CouplesDoThings */,
				TG0000010000000000000002 /* CouplesDoThingsWidget */,
			);
		};
/* End PBXProject section */

/* Begin PBXResourcesBuildPhase section */
		RS0000010000000000000001 /* Resources */ = {
			isa = PBXResourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
				AA0000010000000000000014 /* Assets.xcassets in Resources */,
				AA0000010000000000000015 /* GoogleService-Info.plist in Resources */,
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
		RS0000010000000000000002 /* Resources */ = {
			isa = PBXResourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
				AA0000010000000000000021 /* Assets.xcassets in Resources */,
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
/* End PBXResourcesBuildPhase section */

/* Begin PBXSourcesBuildPhase section */
		SO0000010000000000000001 /* Sources */ = {
			isa = PBXSourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
				AA0000010000000000000001 /* CouplesDoThingsApp.swift in Sources */,
				AA0000010000000000000002 /* Theme.swift in Sources */,
				AA0000010000000000000003 /* Models.swift in Sources */,
				AA0000010000000000000004 /* AuthService.swift in Sources */,
				AA0000010000000000000005 /* CoupleService.swift in Sources */,
				AA0000010000000000000006 /* ItemService.swift in Sources */,
				AA0000010000000000000007 /* SessionStore.swift in Sources */,
				AA0000010000000000000008 /* RootView.swift in Sources */,
				AA0000010000000000000009 /* SignInView.swift in Sources */,
				AA000001000000000000000A /* CreateJoinView.swift in Sources */,
				AA000001000000000000000B /* MainTabView.swift in Sources */,
				AA000001000000000000000C /* ItemListView.swift in Sources */,
				AA000001000000000000000D /* ItemEditorView.swift in Sources */,
				AA000001000000000000000E /* MemoriesView.swift in Sources */,
				AA000001000000000000000F /* SettingsView.swift in Sources */,
				AA0000010000000000000010 /* AppConstants.swift in Sources */,
				AA0000010000000000000011 /* DeepLink.swift in Sources */,
				AA0000010000000000000012 /* WidgetSnapshot.swift in Sources */,
				AA0000010000000000000013 /* WidgetDataStore.swift in Sources */,
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
		SO0000010000000000000002 /* Sources */ = {
			isa = PBXSourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
				AA000001000000000000001A /* CouplesDoThingsWidget.swift in Sources */,
				AA000001000000000000001B /* CouplesDoThingsWidgetBundle.swift in Sources */,
				AA000001000000000000001C /* AppConstants.swift in Sources */,
				AA000001000000000000001D /* DeepLink.swift in Sources */,
				AA000001000000000000001E /* WidgetSnapshot.swift in Sources */,
				AA000001000000000000001F /* WidgetDataStore.swift in Sources */,
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
/* End PBXSourcesBuildPhase section */

/* Begin PBXTargetDependency section */
		TD0000010000000000000001 /* PBXTargetDependency */ = {
			isa = PBXTargetDependency;
			target = TG0000010000000000000002 /* CouplesDoThingsWidget */;
			targetProxy = PX0000010000000000000001 /* PBXContainerItemProxy */;
		};
/* End PBXTargetDependency section */

/* Begin XCBuildConfiguration section */
		CF0000010000000000000001 /* Debug */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ALWAYS_SEARCH_USER_PATHS = NO;
				CLANG_ENABLE_MODULES = YES;
				CLANG_ENABLE_OBJC_ARC = YES;
				COPY_PHASE_STRIP = NO;
				DEBUG_INFORMATION_FORMAT = dwarf;
				ENABLE_TESTABILITY = YES;
				GCC_DYNAMIC_NO_PIC = NO;
				GCC_OPTIMIZATION_LEVEL = 0;
				IPHONEOS_DEPLOYMENT_TARGET = 16.0;
				MTL_ENABLE_DEBUG_INFO = INCLUDE_SOURCE;
				ONLY_ACTIVE_ARCH = YES;
				SDKROOT = iphoneos;
				SWIFT_ACTIVE_COMPILATION_CONDITIONS = DEBUG;
				SWIFT_OPTIMIZATION_LEVEL = "-Onone";
				SWIFT_VERSION = 5.0;
			};
			name = Debug;
		};
		CF0000010000000000000002 /* Release */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ALWAYS_SEARCH_USER_PATHS = NO;
				CLANG_ENABLE_MODULES = YES;
				CLANG_ENABLE_OBJC_ARC = YES;
				COPY_PHASE_STRIP = NO;
				DEBUG_INFORMATION_FORMAT = "dwarf-with-dsym";
				IPHONEOS_DEPLOYMENT_TARGET = 16.0;
				MTL_ENABLE_DEBUG_INFO = NO;
				SDKROOT = iphoneos;
				SWIFT_COMPILATION_MODE = wholemodule;
				SWIFT_VERSION = 5.0;
				VALIDATE_PRODUCT = YES;
			};
			name = Release;
		};
		CF0000010000000000000003 /* Debug */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
				CODE_SIGN_ENTITLEMENTS = CouplesDoThings/CouplesDoThings.entitlements;
				CODE_SIGN_STYLE = Automatic;
				CURRENT_PROJECT_VERSION = 1;
				DEVELOPMENT_TEAM = "";
				ENABLE_PREVIEWS = YES;
				GENERATE_INFOPLIST_FILE = YES;
				INFOPLIST_FILE = CouplesDoThings/Info.plist;
				INFOPLIST_KEY_CFBundleDisplayName = "Couples Do Things";
				INFOPLIST_KEY_UIApplicationSceneManifest_Generation = YES;
				INFOPLIST_KEY_UILaunchScreen_Generation = YES;
				INFOPLIST_KEY_UISupportedInterfaceOrientations = UIInterfaceOrientationPortrait;
				IPHONEOS_DEPLOYMENT_TARGET = 16.0;
				LD_RUNPATH_SEARCH_PATHS = "$(inherited) @executable_path/Frameworks";
				MARKETING_VERSION = 1.0;
				PRODUCT_BUNDLE_IDENTIFIER = com.couplesdothings.app;
				PRODUCT_NAME = "$(TARGET_NAME)";
				SUPPORTED_PLATFORMS = "iphoneos iphonesimulator";
				SUPPORTS_MACCATALYST = NO;
				SWIFT_EMIT_LOC_STRINGS = YES;
				SWIFT_VERSION = 5.0;
				TARGETED_DEVICE_FAMILY = 1;
			};
			name = Debug;
		};
		CF0000010000000000000004 /* Release */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
				CODE_SIGN_ENTITLEMENTS = CouplesDoThings/CouplesDoThings.entitlements;
				CODE_SIGN_STYLE = Automatic;
				CURRENT_PROJECT_VERSION = 1;
				DEVELOPMENT_TEAM = "";
				ENABLE_PREVIEWS = YES;
				GENERATE_INFOPLIST_FILE = YES;
				INFOPLIST_FILE = CouplesDoThings/Info.plist;
				INFOPLIST_KEY_CFBundleDisplayName = "Couples Do Things";
				INFOPLIST_KEY_UIApplicationSceneManifest_Generation = YES;
				INFOPLIST_KEY_UILaunchScreen_Generation = YES;
				INFOPLIST_KEY_UISupportedInterfaceOrientations = UIInterfaceOrientationPortrait;
				IPHONEOS_DEPLOYMENT_TARGET = 16.0;
				LD_RUNPATH_SEARCH_PATHS = "$(inherited) @executable_path/Frameworks";
				MARKETING_VERSION = 1.0;
				PRODUCT_BUNDLE_IDENTIFIER = com.couplesdothings.app;
				PRODUCT_NAME = "$(TARGET_NAME)";
				SUPPORTED_PLATFORMS = "iphoneos iphonesimulator";
				SUPPORTS_MACCATALYST = NO;
				SWIFT_EMIT_LOC_STRINGS = YES;
				SWIFT_VERSION = 5.0;
				TARGETED_DEVICE_FAMILY = 1;
			};
			name = Release;
		};
		CF0000010000000000000005 /* Debug */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				CODE_SIGN_ENTITLEMENTS = CouplesDoThingsWidget/CouplesDoThingsWidget.entitlements;
				CODE_SIGN_STYLE = Automatic;
				CURRENT_PROJECT_VERSION = 1;
				GENERATE_INFOPLIST_FILE = YES;
				INFOPLIST_FILE = CouplesDoThingsWidget/Info.plist;
				INFOPLIST_KEY_CFBundleDisplayName = "Couples Do Things";
				IPHONEOS_DEPLOYMENT_TARGET = 16.0;
				LD_RUNPATH_SEARCH_PATHS = "$(inherited) @executable_path/Frameworks @executable_path/../../Frameworks";
				MARKETING_VERSION = 1.0;
				PRODUCT_BUNDLE_IDENTIFIER = com.couplesdothings.app.widget;
				PRODUCT_NAME = "$(TARGET_NAME)";
				SKIP_INSTALL = YES;
				SUPPORTED_PLATFORMS = "iphoneos iphonesimulator";
				SWIFT_EMIT_LOC_STRINGS = YES;
				SWIFT_VERSION = 5.0;
				TARGETED_DEVICE_FAMILY = 1;
			};
			name = Debug;
		};
		CF0000010000000000000006 /* Release */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				CODE_SIGN_ENTITLEMENTS = CouplesDoThingsWidget/CouplesDoThingsWidget.entitlements;
				CODE_SIGN_STYLE = Automatic;
				CURRENT_PROJECT_VERSION = 1;
				GENERATE_INFOPLIST_FILE = YES;
				INFOPLIST_FILE = CouplesDoThingsWidget/Info.plist;
				INFOPLIST_KEY_CFBundleDisplayName = "Couples Do Things";
				IPHONEOS_DEPLOYMENT_TARGET = 16.0;
				LD_RUNPATH_SEARCH_PATHS = "$(inherited) @executable_path/Frameworks @executable_path/../../Frameworks";
				MARKETING_VERSION = 1.0;
				PRODUCT_BUNDLE_IDENTIFIER = com.couplesdothings.app.widget;
				PRODUCT_NAME = "$(TARGET_NAME)";
				SKIP_INSTALL = YES;
				SUPPORTED_PLATFORMS = "iphoneos iphonesimulator";
				SWIFT_EMIT_LOC_STRINGS = YES;
				SWIFT_VERSION = 5.0;
				TARGETED_DEVICE_FAMILY = 1;
			};
			name = Release;
		};
/* End XCBuildConfiguration section */

/* Begin XCConfigurationList section */
		CL0000010000000000000001 /* Build configuration list for PBXNativeTarget "CouplesDoThings" */ = {
			isa = XCConfigurationList;
			buildConfigurations = (
				CF0000010000000000000003 /* Debug */,
				CF0000010000000000000004 /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		};
		CL0000010000000000000002 /* Build configuration list for PBXNativeTarget "CouplesDoThingsWidget" */ = {
			isa = XCConfigurationList;
			buildConfigurations = (
				CF0000010000000000000005 /* Debug */,
				CF0000010000000000000006 /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		};
		CL0000010000000000000003 /* Build configuration list for PBXProject "CouplesDoThings" */ = {
			isa = XCConfigurationList;
			buildConfigurations = (
				CF0000010000000000000001 /* Debug */,
				CF0000010000000000000002 /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		};
/* End XCConfigurationList section */

/* Begin XCRemoteSwiftPackageReference section */
		PP0000010000000000000001 /* XCRemoteSwiftPackageReference "firebase-ios-sdk" */ = {
			isa = XCRemoteSwiftPackageReference;
			repositoryURL = "https://github.com/firebase/firebase-ios-sdk";
			requirement = {
				kind = upToNextMajorVersion;
				minimumVersion = 11.0.0;
			};
		};
/* End XCRemoteSwiftPackageReference section */

/* Begin XCSwiftPackageProductDependency section */
		PK0000010000000000000001 /* FirebaseAuth */ = {
			isa = XCSwiftPackageProductDependency;
			package = PP0000010000000000000001 /* XCRemoteSwiftPackageReference "firebase-ios-sdk" */;
			productName = FirebaseAuth;
		};
		PK0000010000000000000002 /* FirebaseFirestore */ = {
			isa = XCSwiftPackageProductDependency;
			package = PP0000010000000000000001 /* XCRemoteSwiftPackageReference "firebase-ios-sdk" */;
			productName = FirebaseFirestore;
		};
		PK0000010000000000000003 /* FirebaseCore */ = {
			isa = XCSwiftPackageProductDependency;
			package = PP0000010000000000000001 /* XCRemoteSwiftPackageReference "firebase-ios-sdk" */;
			productName = FirebaseCore;
		};
/* End XCSwiftPackageProductDependency section */
	};
	rootObject = PR0000010000000000000001 /* Project object */;
}
"""

# Remove accidental " mar" typos from wrapping
pbx = pbx.replace("\n mar\t\t\t", "\n\t\t\t")
pbx = pbx.replace(" mar", "")

(PROJ / "project.pbxproj").write_text(pbx, encoding="utf-8")
print("Wrote", PROJ / "project.pbxproj")
