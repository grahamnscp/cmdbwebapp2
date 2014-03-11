#!/usr/bin/ruby

# Includes
require 'rubygems'
require 'net/ldap'
require 'cgi'

require 'globals.rb'


def output_page_header
  file = File.new("html/header", "r")
  while (line = file.gets)
    puts "#{line}"
  end
end

def output_page_header_list
  file = File.new("html/header_list", "r")
  while (line = file.gets)
    puts "#{line}"
  end
end
def output_page_header_box
  file = File.new("html/header_box", "r")
  while (line = file.gets)
    puts "#{line}"
  end
end

def output_page_footer
  file = File.new("html/footer", "r")
  while (line = file.gets)
    puts "#{line}"
  end
end


#
# Function: read_server_by_fqdn
#
def get_param_fqdn

  cgi = CGI.new
  params = cgi.params # hash with field-names and values
  fqdn = params['fqdn'].to_s

  return fqdn
end



#
# Function: read_server_by_fqdn
#
def read_server_by_fqdn(servername)

  filter1 = Net::LDAP::Filter.eq( "objectclass", "managedServer" )
  filter2 = Net::LDAP::Filter.eq( "hostName", servername )
  filter  = Net::LDAP::Filter.join(filter1, filter2)
  attrs = [ ]

  $conn.search(:base => $basedomain,
               :filter => filter) do |entry|
    server = entry

    return server
  end
end

#
# Function: read_disk_by_dn
#
#def read_disk_by_dn(treebase, entry_number, disk_cn)
def read_disk_by_dn(treebase, entry_number)

  filter1 = Net::LDAP::Filter.eq( "objectclass", "storageDevice" )
  filter2 = Net::LDAP::Filter.eq( "deviceIndex", entry_number )
  filter  = Net::LDAP::Filter.join(filter1, filter2)
  attrs = [ ]

  $conn.search(:base => treebase,
               :filter => filter) do |entry|
    disk = entry

    return disk
  end
end

#
# Function: read_nic_by_dn
#
#def read_nic_by_dn(treebase, entry_number, nic_cn)
def read_nic_by_dn(treebase, entry_number)

  filter1 = Net::LDAP::Filter.eq( "objectclass", "networkDevice" )
  filter2 = Net::LDAP::Filter.eq( "deviceIndex", entry_number )
  filter = Net::LDAP::Filter.join(filter1, filter2)
  attrs = [ ]

  $conn.search(:base => treebase,
               :filter => filter) do |entry|
    nic = entry 

    return nic
  end
end

#
# Function: persistServerEntry
#
def persistServerEntry(dn, mansvr, disk1, disk2, nic1, nic2, nic3, nic4, nic5, nic6, nic7, nic8, nic9, nic10, nic11, nic12)

  #p dn
  #puts "<br><br>"
  #p mansvr
  #puts "<br><br>"
  #p disk1
  #puts "<br><br>"
  #p disk2
  #puts "<br><br>"
  #p nic1
  #puts "<br><br>"
  #p nic2
  #puts "<br><br>"
  #p nic3
  #puts "<br><br>"
  #p nic4
  #puts "<br><br>"
  #p nic5
  #puts "<br><br>"
  #p nic6
  #puts "<br><br>"
  #p nic7
  #puts "<br><br>"
  #p nic8
  #puts "<br><br>"
  #p nic9
  #puts "<br><br>"
  #p nic10
  #puts "<br><br>"
  #p nic11
  #puts "<br><br>"
  #p nic12
  #puts "<br><br>"

  # If entry already exists, delete it first then add it.
  fqdn = mansvr[:hostName].to_s
  result = delete_entry_by_fqdn(fqdn)
  #puts "delete:" + result.to_s + "<br>"

  # Add LDAP Entries
  result = $conn.add(:dn => dn, :attributes => mansvr )
  #puts "add server:" + result.to_s + "<br>"

  if not ["--"].include?(disk1[:cn].to_s) then
    result = $conn.add(:dn => "cn="+disk1[:cn].to_s+","+dn, :attributes => disk1 )
    #puts "add disk1:" + result.to_s + "<br>"
  end

  if not ["--"].include?(disk2[:cn].to_s) then
    result = $conn.add(:dn => "cn="+disk2[:cn].to_s+","+dn, :attributes => disk2 )
    #puts "add disk2:" + result.to_s + "<br>"
  end

  if not ["--"].include?(nic1[:cn].to_s) then
    result = $conn.add(:dn => "cn="+nic1[:cn].to_s+","+dn, :attributes => nic1 )
    #puts "add nic1:" + result.to_s + "<br>"
  end

  if not ["--"].include?(nic2[:cn].to_s) then
    result = $conn.add(:dn => "cn="+nic2[:cn].to_s+","+dn, :attributes => nic2 )
    #puts "add nic2:" + result.to_s + "<br>"
  end

  if not ["--"].include?(nic3[:cn].to_s) then
    result = $conn.add(:dn => "cn="+nic3[:cn].to_s+","+dn, :attributes => nic3 )
    #puts "add nic3:" + result.to_s + "<br>"
  end

  if not ["--"].include?(nic4[:cn].to_s) then
    result = $conn.add(:dn => "cn="+nic4[:cn].to_s+","+dn, :attributes => nic4 )
    #puts "add nic4:" + result.to_s + "<br>"
  end

  if not ["--"].include?(nic5[:cn].to_s) then
    result = $conn.add(:dn => "cn="+nic5[:cn].to_s+","+dn, :attributes => nic5 )
    #puts "add nic5:" + result.to_s + "<br>"
  end

  if not ["--"].include?(nic6[:cn].to_s) then
    result = $conn.add(:dn => "cn="+nic6[:cn].to_s+","+dn, :attributes => nic6 )
    #puts "add nic6:" + result.to_s + "<br>"
  end

  if not ["--"].include?(nic7[:cn].to_s) then
    result = $conn.add(:dn => "cn="+nic7[:cn].to_s+","+dn, :attributes => nic7 )
    #puts "add nic7:" + result.to_s + "<br>"
  end

  if not ["--"].include?(nic8[:cn].to_s) then
    result = $conn.add(:dn => "cn="+nic8[:cn].to_s+","+dn, :attributes => nic8 )
    #puts "add nic8:" + result.to_s + "<br>"
  end

  if not ["--"].include?(nic9[:cn].to_s) then
    result = $conn.add(:dn => "cn="+nic9[:cn].to_s+","+dn, :attributes => nic9 )
    #puts "add nic9:" + result.to_s + "<br>"
  end

  if not ["--"].include?(nic10[:cn].to_s) then
    result = $conn.add(:dn => "cn="+nic10[:cn].to_s+","+dn, :attributes => nic10 )
    #puts "add nic10:" + result.to_s + "<br>"
  end

  if not ["--"].include?(nic11[:cn].to_s) then
    result = $conn.add(:dn => "cn="+nic11[:cn].to_s+","+dn, :attributes => nic11 )
    #puts "add nic11:" + result.to_s + "<br>"
  end

  if not ["--"].include?(nic12[:cn].to_s) then
    result = $conn.add(:dn => "cn="+nic12[:cn].to_s+","+dn, :attributes => nic12 )
    #puts "add nic12:" + result.to_s + "<br>"
  end

  return result
end


#
# function: delete_entry_by_fqdn
#
def delete_entry_by_fqdn(fqdn)

  cn=fqdn.split(".").first
  basedn = "cn=" + cn + "," + $basedomain
  #puts "Deleting basedn: "+basedn+"<br>"

  # Need to delete children first if they exist
  filter = Net::LDAP::Filter.eq( "objectclass", "storageDevice" )
  $conn.search(:base => basedn,
               :filter => filter) do |diskentry|
    subdn = diskentry['dn'].to_s
    result = $conn.delete(:dn => subdn)
    #puts "<blockquote>dn: "+subdn +" -> "+result.to_s+"</blockquote>"
  end
  filter = Net::LDAP::Filter.eq( "objectclass", "networkDevice" )
  $conn.search(:base => basedn,
               :filter => filter) do |nicentry|
    subdn = nicentry['dn'].to_s
    result = $conn.delete(:dn => subdn)
    #puts "<blockquote>dn: "+subdn+" -> " +result.to_s+"</blockquote>"
  end

  result = $conn.delete(:dn => basedn)
  #puts "<blockquote>dn: "+basedn+" -> " +result.to_s+"</blockquote>"

  return result
end


#
# function: read_server_roles
#
def read_server_roles

  filter = Net::LDAP::Filter.eq( "objectclass", "serverRole" )
  attrs = [ ]

  server_roles = Array.new
  $conn.search(:base => $basedomainsr,
               :filter => filter) do |entry|
    server_roles.push "#{entry.cn}"
  end

  return server_roles
end

