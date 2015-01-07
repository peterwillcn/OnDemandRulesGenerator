require 'plist'
require 'json'

if ARGV.count < 2
  puts "Usage: ruby #{$0} your_config.mobileconfig rules.json"
  exit
end

plist_filename = ARGV[0]
rules_filename = ARGV[1]

$supported_protocols = ["IKEv2", "IPSec"]
$supported_interfaces = ["cellular", "wifi", "all"]
$supported_actions = ["ondemand", "enable", "disable"]

def rules_generator filename
  result = []
  if File::exist?filename
    hash = JSON::parse(File.read(filename))
    hash.each do |k, v|
      if $supported_actions.include?(v["action"]) && $supported_interfaces.include?(v["interface"])
        dict = {}
        dict["ActionParameters"] = []

        case v["action"]
        when "ondemand"
          dict["Action"] = "EvaluateConnection"
        when "enable"
          dict["Action"] = "Connect"
        when "disable"
          dict["Action"] = "Disconnect"
        end
        
        case v["interface"]
        when "cellular"
          dict["InterfaceTypeMatch"] = "Cellular"
        when "wifi"
          if v.has_key?"ssid"
            dict["InterfaceTypeMatch"] = "WiFi"
            dict["SSIDMatch"] = v["ssid"]
          else
            raise "SSID not included!"
          end
        end

        dict["ActionParameters"] << { "DomainAction" => "ConnectIfNeeded", "Domains" => v["domains"] }
        
        result << dict
      end
    end
  end
  result
end

if content_hash = Plist::parse_xml(plist_filename)
  content_hash["PayloadContent"].each_with_index do |payload, index|
    if payload["PayloadType"] == "com.apple.vpn.managed"
      # we believe that we found this payload is vpn configuration
      protocol = ($supported_protocols & payload.keys).first
      settings = payload[protocol]
      if settings
        # read from list.txt and generate rules here
        content_hash["PayloadContent"][index][protocol]["OnDemandEnabled"] = 0
        content_hash["PayloadContent"][index][protocol]["OnDemandRules"] = rules_generator rules_filename
        File.open(plist_filename, 'w') do |f|
          f.write(content_hash.to_plist)
        end
      end
    end
  end
end