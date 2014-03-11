#!/usr/bin/ruby

# Globals
$conn = Net::LDAP.new
$conn.host = "cmdb-server.my-domain.com"
$conn.port = "389"
$conn.auth "cn=Manager,dc=my-domain,dc=com", "password"
$basedomain = "ou=Servers,dc=my-domain,dc=com"
$basedomainsr = "ou=Server Roles,dc=my-domain,dc=com"
$domainname = "my-domain.com"
$cmdbapppath = "/var/www/cmdb/cgi-bin/"

# Satellite API:
@sathost = "satellite-server.my-domain.com"
@satapipath = "/rpc/api"
@satuser = "myadmin"
@satpwd = "password"
@orgname = "MyDomainSubOrgName" # Can't find this in the suborg and need satadmin to access org.getDetails(org_id) !

# Form LOV
$lov_location            = $cmdbapppath+"/values/lov_location"
$lov_environment         = $cmdbapppath+"/values/lov_environment"
$lov_operatingsystem     = $cmdbapppath+"/values/lov_operatingsystem"
$lov_osversion           = $cmdbapppath+"/values/lov_osversion"
$lov_nameserver          = $cmdbapppath+"/values/lov_nameserver"
$lov_timeserver          = $cmdbapppath+"/values/lov_timeserver"
#
#Virtual Server related values:
#$lov_vcluster            = $cmdbapppath+"/values/lov_vcluster"
#$lov_vdatacentre         = $cmdbapppath+"/values/lov_vdatacentre"
#$lov_vesxhost            = $cmdbapppath+"/values/lov_vesxhost"
#$lov_vsockets            = $cmdbapppath+"/values/lov_vsockets"
#$lov_vcores              = $cmdbapppath+"/values/lov_vcores"
#
#Read from Satellite API now:
#$lov_cobblerprofile      = $cmdbapppath+"/values/lov_cobblerprofile"
#$lov_rhnactivationkey    = $cmdbapppath+"/values/lov_rhnactivationkey"
#$lov_rhnbasechannel      = $cmdbapppath+"/values/lov_rhnbasechannel"
#$lov_rhnchildchannel     = $cmdbapppath+"/values/lov_rhnchildchannel"
#
#Read from CMDB Now:
#$lov_serverrole          = $cmdbapppath+"/values/lov_serverrole"

#Disk related values:
$lov_diskcn              = $cmdbapppath+"/values/lov_diskcn"
#Used for virtual storage:
#$lov_diskstoragelocation = $cmdbapppath+"/values/lov_diskstoragelocation"

#Network related values
$lov_niccn               = $cmdbapppath+"/values/lov_niccn"
#Used for virtual networking:
#$lov_nicbridge           = $cmdbapppath+"/values/lov_nicbridge"

