---
services: active-directory
platforms: ios
author: brandwe
---

# An iOS task application with Azure AD B2C using third party libraries

The Microsoft identity platform uses open standards such as OAuth2 and OpenID Connect. This allows developers to leverage any library they wish to integrate with our services. To aid developers in using our platform with other libraries we've written a few walkthroughs like this one to demonstate how to configure third party libraries to connect to the Microsoft identity platform. Most libraries that implement [the RFC6749 OAuth2 spec](https://tools.ietf.org/html/rfc6749) will be able to connect to the Microsoft Identity platform.

## How To Run This Sample

Getting started is simple! To run this sample you will need:

- To install XCode from Apple's Developer website
- Installation of Cocoapods
- An Internet connection
- An Azure subscription (a free trial is sufficient)

### Step 1:  Clone or download this repository

From your shell or command line:

`git clone https://github.com/Azure-Samples/active-directory-ios-native-nxoauth2-b2c.git`

### Step 2: Run the sample using our sample tenant

If you'd like to see the sample working immediately, you can simply run the app as-is without any code changes.

$ pod install
$ open B2CSample.xcworkspacae

Then run on your emulated device of choice.

The default configuration for this application performs sign-in & sign-up using our sample B2C tenant, `fabrikamb2c.onmicrosoft.com`.  It uses one [policy](https://azure.microsoft.com/documentation/articles/active-directory-b2c-reference-policies); a sign-up and sign-on policy named `b2c_1_sisu` aSign up for the app using any of the available account types, and try signing in again with the same account.

### Step 3: Get your own Azure AD B2C tenant

You can also modify the sample to use your own Azure AD B2C tenant.  First, you'll need to create an Azure AD B2C tenant by following [these instructions](https://azure.microsoft.com/documentation/articles/active-directory-b2c-get-started).

### Step 4: Create your own policies

This sample uses one type of policies: a sign-in policy & a sign-up policy.  Create this policy by following [the instructions here](https://azure.microsoft.com/documentation/articles/active-directory-b2c-reference-policies).  You may choose to include as many or as few identity providers as you wish; our sample policies use Facebook, Google, and email-based local accounts.

If you already have existing policies in your B2C tenant, feel free to re-use those.  No need to create new ones just for this sample.

### Step 5: Create your own application

Now you need to create your own appliation in your B2C tenant, so that your app has its own client ID.  You can do so following [the generic instructions here](https://azure.microsoft.com/documentation/articles/active-directory-b2c-app-registration).  Be sure to include the following information in your app registration:

- Enable the **Native Client** setting for your application.
- Copy the client ID generated for your application, so you can use it in the next step.

### Step 6: Configure the sample to use your B2C tenant

Now you can replace the app's default configuration with your own.  Open the `settings.plist` file and replace the following values with the ones you created in the previous steps.  

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>accountIdentifier</key>
	<string>B2C_Acccount</string>
	<key>clientID</key>
	<string><your client ID></string>
	<key>authURL</key>
	<string>https://login.microsoftonline.com/<tenant name>/oauth2/v2.0/authorize?p=<policy name></string>
	<key>loginURL</key>
	<string>https://login.microsoftonline.com/<tenant name>/login</string>
	<key>bhh</key>
	<string>urn:ietf:wg:oauth:2.0:oob</string>
	<key>tokenURL</key>
	<string>https://login.microsoftonline.com/<tenant name>/oauth2/v2.0/token?p=<policy name></string>
	<key>keychain</key>
	<string>com.microsoft.azureactivedirectory.samples.graph.QuickStart</string>
	<key>contentType</key>
	<string>application/x-www-form-urlencoded</string>
	<key>taskAPI</key>
	<string>https://aadb2cplayground.azurewebsites.net</string>
</dict>
</plist>
```

### Step 7:  Run the sample

Clean the solution, rebuild the solution, and run it.  You can now sign up & sign in to your application using the accounts you configured in your respective policies.
