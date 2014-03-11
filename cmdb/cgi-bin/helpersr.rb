#!/usr/bin/ruby

# Includes
require 'helper.rb'

# Note add server roles basedomain entry to globals.rb :
# $basedomainsr = "ou=Server Roles,dc=my-domain,dc=com"

#
# Function: read_server_role
#
def read_server_role(srcn)

  filter1 = Net::LDAP::Filter.eq( "objectclass", "serverRole" )
  filter2 = Net::LDAP::Filter.eq( "cn", srcn )
  filter  = Net::LDAP::Filter.join(filter1, filter2)
  attrs = [ ]

  $conn.search(:base => $basedomainsr,
               :filter => filter) do |entry|
    serverrole = entry

    return serverrole
  end
end


#
# Function: persist_server_role
#
def persist_server_role(dn, sr)

  #p dn
  #puts "<br>"
  #p sr
  #puts "<br>"

  # If entry already exists, delete it first then add it.
  cn = sr[:cn].to_s

  result = delete_server_role(cn)
  #puts "delete:" + result.to_s + "<br>" #######

  # Add LDAP Entry
  result = $conn.add(:dn => dn, :attributes => sr )
  #puts "add serverrole:" + result.to_s + "<br>" #######

  return result

end


#
# function: delete_server_role
#
def delete_server_role(cn)

  basedn = "cn=" + cn + "," + $basedomainsr
  #puts "Deleting basedn: "+basedn+"<br>"

  result = $conn.delete(:dn => basedn)
  #puts "<blockquote>dn: "+basedn+" -> " +result.to_s+"</blockquote>"

  return result
end

