local root =        "/apps/antwerpen/x86_64/centos7/intel-psxe/2020.01"
local clckversion = "2019.8"
local ebversion =   "2020a.01"

local clckroot = root .. "/clck/" .. clckversion

helpstring = 
[[

Description
===========

Intel Cluster Checker, see the Intel documentation for its use.

Do not forget to set CLCK_SHARED_TEMP_DIR to the directory to use
to avoid running in $HOME.
]]

whatisstring = string.gsub( string.gsub(
    [[Description: Intel Cluster Checker CLCKVERSION (Intel Parallel Studio XE version EBVERSION)]],
    "CLCKVERSION", clckversion ), "EBVERSION", ebversion )
whatis( whatisstring )
whatis([[URL:         https://software.intel.com/en-us/intel-parallel-studio-xe]])

conflict('intelclck')

intelmodule = "intel/" .. ebversion
if not isloaded( intelmodule ) then
    load( intelmodule )
end

--
-- License: Comes in via the loaded intel module
--

--
-- CLCK
--
prepend_path( "CPLUS_INCLUDE_PATH", clckroot .. "/include" )
prepend_path( "LIBRARY_PATH",       clckroot .. "/lib/intel64" )
prepend_path( "MANPATH",            clckroot .. "/man" )
prepend_path( "PATH",               clckroot .. "/bin/intel64" )

setenv(       "CLCKROOT",           clckroot )

setenv( "EBROOTINTELCLCK",    clckroot )
setenv( "EBVERSIONINTELCLCK", clckversion )
