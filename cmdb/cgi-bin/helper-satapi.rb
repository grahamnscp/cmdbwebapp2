#!/usr/bin/ruby
#
# Includes
require 'rubygems'
require 'xmlrpc/client'

require 'globals.rb'

# Globals
@orgid = String.new
@satconn = XMLRPC::Client.new(@sathost,@satapipath,nil,nil,nil,nil,nil,'https',90)
@satconn2 = XMLRPC::Client.new(@sathost,@satapipath,nil,nil,nil,nil,nil,'https',90)
@satsession = @satconn.call('auth.login',@satuser,@satpwd)
@satsession2 = @satconn2.call('auth.login',@satuser,@satpwd)


#
# function: populate_org_id
#
def populate_org_id

  api = "user.getDetails"

  ok, result = @satconn.call2_async(api,@satsession,@satuser)

  if ok
    @orgid = result['org_id'].to_s
    puts "org_id is " + @orgid
  else
    puts "populate_org_id: API Call Failed: " + result
    p result = @satconn.call_async(api,@satsessioni,@satuser)
    exit
  end
end


#
# function: populate_org_name
#
def populate_org_name

  api = "org.getDetails"

  ok, result = @satconn.call2_async(api,@satsession,2)

  if ok
    @orgname = result['org_name'].to_s
    puts "org_name is " + @orgname
  else
    puts "populate_org_name: API Call Failed: " + result
    p result = @satconn.call_async(api,@satsession,2)
    exit
  end
end


#
# function: read_systems
#
def read_systems

  systems = Array.new
  ret_entry = Hash.new

  ok, result = @satconn.call2_async("system.listActiveSystems",@satsession)

  if ok
    result.each do |entry|
      ret_entry['name'] = entry['name']
      ret_entry['id'] = entry['id']
      systems.push ret_entry
    end
  else
    puts "read_systems: API Call Failed: " + result
    exit
  end
  return systems
end


#
# function: read_all_channels
#
def read_all_channels api

  if !api then api="channel.listAllChannels"  end
  channels = Array.new
  ok, result = @satconn.call2_async(api,@satsession)

  if ok
    result.each do |entry|
      channels.push entry['label']
    end
  else
    puts "read_all_channels: API Call Failed: " + result
    p result = @satconn.call_async(api,@satsession)
    exit
  end
  return channels
end


# 
# function: read_base_channels
#
def read_base_channels

  channels = Array.new
  chlabel  = String.new

  api1="channel.listAllChannels"
  api2="channel.software.getDetails"

  ok, result = @satconn.call2_async(api1,@satsession)

  if ok
    result.each do |entry|

      chlabel = entry['label']
      ok2, result2 = @satconn2.call2_async(api2,@satsession2,chlabel.to_s)

      if ok2
        parent_label = result2['parent_channel_label'].to_s
        if parent_label.empty? then
          channels.push chlabel
        else
          #puts "Channel parent label: '"+parent_label+"'"
        end
      else
        puts "read_base_channels: API Call Failed: " + result2.to_s
        p result2 = @satconn2.call_async(api2,@satsession2,chlabel.to_s)
        exit
      end
    end
  else
    puts "read_base_channels: API Call Failed: " + result
    p result = @satconn.call_async(api,@satsession)
    exit
  end

  return channels
end


# 
# function: read_base_channels2
#
def read_base_channels2

  channels = Array.new
  api="channel.software.getDetails"

  alllabels = read_all_channels "channel.listAllChannels"

  alllabels.each do |entry|
    chlabel = entry
    ok, result = @satconn.call2_async(api,@satsession,chlabel.to_s)

    if ok
      parent_label = result['parent_channel_label'].to_s
      if parent_label.empty? then
        channels.push chlabel
      end
    else
      puts "read_base_channels: API Call Failed: " + result2.to_s
      p result2 = @satconn2.call_async(api2,@satsession2,chlabel.to_s)
      exit
    end
  end

  return channels
end


# 
# function: read_child_channels
#
def read_child_channels

  channels = Array.new
  chlabel  = String.new

  api1="channel.listAllChannels"
  api2="channel.software.getDetails"

  ok, result = @satconn.call2_async(api1,@satsession)

  if ok
    result.each do |entry|

      chlabel = entry['label']
      ok2, result2 = @satconn2.call2_async(api2,@satsession2,chlabel.to_s)

      if ok2
        parent_label = result2['parent_channel_label'].to_s
        if !parent_label.empty? then
          channels.push chlabel
        end
      else
        puts "read_child_channels: API Call Failed: " + result2.to_s
        p result2 = @satconn2.call_async(api2,@satsession2,chlabel.to_s)
        exit
      end
    end
  else
    puts "read_child_channels: API Call Failed: " + result
    p result = @satconn.call_async(api,@satsession)
    exit
  end

  return channels
end


# function: read_system_base_channels
#
def read_system_base_channels system

  channels = Array.new

  api = "system.listSubscribableBaseChannels"
  result = @satconn2.call(api,@satsession2,system)
  result.each do |entry|
    channels.push entry['label']
  end

  return channels
end


#
# function: read_system_sub_channels
#
def read_system_sub_channels system

  channels = Array.new

  api ="system.listSubscribedChildChannels"
  result = @satconn2.call(api,@satsession2,system)
  result.each do |entry|
    channels.push entry['label']
  end

  api = "system.listSubscribableChildChannels"
  result = @satconn2.call(api,@satsession2,system)
  result.each do |entry|
    channels.push entry['label']
  end
 
  return channels
end


#
# function: read_activationkeys
#
def read_activationkeys

  api = "activationkey.listActivationKeys"
  actkeys = Array.new

  ok, result = @satconn.call2_async(api,@satsession)

  if ok
    result.each do |entry|
      actkeys.push entry['key']
    end
  else
    puts "read_activationkeys: API Call Failed: " + result
    p result = @satconn.call_async(api,@satsession)
    exit
  end
  return actkeys
end


#
# function: read_kickstarts
#
def read_kickstarts

  populate_org_id

  api = "kickstart.listKickstarts"
  kickstarts = Array.new

  ok, result = @satconn.call2_async(api,@satsession)

  if ok
    result.each do |entry|
      kickstarts.push entry['label']+":"+@orgid+":"+@orgname
    end
  else
    puts "read_kickstarts: API Call Failed: " + result
    p result = @satconn.call_async(api,@satsession)
    exit
  end
  return kickstarts
end


#
# function: test_api
#
def test_api

#BEGIN { $VERBOSE = nil }

puts "Satellite API Version: " + @satconn.call_async('api.getVersion')

populate_org_id
#populate_org_name
puts "org_name = " + @orgname

puts
puts "All Channel Labels: "
start = Time.now
channels = read_all_channels nil
channels.each do |entry|
  puts "\t" + entry
end
puts "Duration: #{Time.now - start} seconds"

puts
puts "Base Channels:"
start = Time.now
bchannels = read_base_channels
bchannels.each do |entry|
  puts "\t" + entry
end
puts "Duration: #{Time.now - start} seconds"
 
puts
puts "Child Channels:"
start = Time.now
cchannels = read_child_channels
cchannels.each do |entry|
  puts "\t" + entry
end
puts "Duration: #{Time.now - start} seconds"

puts
puts "Base Channels2:"
start = Time.now
bchannels2 = read_base_channels2
bchannels2.each do |entry|
  puts "\t" + entry
end
puts "Duration: #{Time.now - start} seconds"
 
puts
puts "All ActivationKey Labels: "
start = Time.now
akeys = read_activationkeys
akeys.each do |entry|
  puts "\t" + entry
end
puts "Duration: #{Time.now - start} seconds"

puts
puts "All Kickstart Labels: "
start = Time.now
kickstarts = read_kickstarts
kickstarts.each do |entry|
  puts "\t" + entry
end
puts "Duration: #{Time.now - start} seconds"

puts
puts "Active systems: "
systems = read_systems

systems.each do |entry|
  puts "  System: " + entry['name'] + ", " + entry['id'].to_s
  
  puts "     Available Base Channel Labels: "
  channels = read_system_base_channels entry['id']
  channels.each do |channel|
    puts "\t" + channel
  end

  puts "     Available Child Channel Labels: "
  channels = read_system_sub_channels entry['id']
  channels.each do |channel|
    puts "\t" + channel
  end
end


end

#
# Main
# 
#

#test_api

