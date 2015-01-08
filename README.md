## OnDemandRulesGenerator

---

Apple introduced On Demand VPN feature in iOS 8, and we can use this feature to implement domain-based VPN on un-jailbroken iOS devices and provide a better experience than APNS. 

This project can easily generate on demand rules for existing profiles. All you need is written down a set of rules in json, then our generator will take your job.

Open Apple Configurator and generate a new profile and export it, then you use this tool to set on demand rules for your profile.


### Requirement

- `gem install plist`

### Usage

```
ruby OnDemandRulesGenerator.rb your_config.mobileconfig rules.json
```

### Example Rules

Spend few seconds with `rules_example.json` and you will figure it out!

A typical rules should looks like:

```
{
	"Configure_Name": {
		"interface": INTERFACE_TYPE,
		"action": ACTION_TYPE,
		"domains": [...]
	},
	{
		...
	}
}
```

INTERFACE_TYPE is a **String** type value.

| INTERFACE_TYPE | description |
| -------------- | ----------- |
| cellular       | Cellular network (EDGE/3G/4G) |
| wifi           | WiFi network |
| all            | Cellular + WiFi |

**if you choose "wifi" as INTERFACE_TYPE, another key named "ssid" is requried!**

ACTION_TYPE is a **String** type value.

| ACTION_TYPE | description |
| ----------- | ----------- |
| ondemand    | if domain matches, VPN connection will be established under chosen INTERFACE_TYPE |
| enable      | VPN connection will be always established under chosen INTERFACE_TYPE |
| disable     | VPN connection will be always disconnnected under chosed INTERFACE_TYPE |

The key named "domains" is an array containing domain strings.

## References

[Apple Developer - Configuration Profile Reference](https://developer.apple.com/library/prerelease/ios/featuredarticles/iPhoneConfigurationProfileRef/Introduction/Introduction.html)

## To-do

- Maybe a GUI
- Code improvement

### Made with ♥︎ by AustinChou