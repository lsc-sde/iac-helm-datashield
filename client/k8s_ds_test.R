###############################################################################
# DataSHIELD demo of k8s install
###############################################################################

# Load libraries
library(DSI)
library(DSOpal)
library(dsBaseClient)
library(opalr)

###############################################################################
# Use the opal admin package to get server level info

# Set all the options.
options(opal.url = "https://datashield1.liv.ac.uk")
# options(opal.url = "https://landertre-dev.org")

options(opal.username = "administrator",
        opal.password = "P@55w0rd",
        opal.opts = list(ssl_verifyhost = 0, ssl_verifypeer = 0))

# login
o <- opal.login()

# Get some information about the default DataSHIELD profile. If all has gone to
# plan this should show dsBase and resourcer packages installed.
dsadmin.package_descriptions(o, profile = "default")

# dsadmin.profile_init(o, "default")
# dsadmin.profile_enable(o, "default")

opal.datasources(o)


###############################################################################
# Now interact with the server as if you are a user

# Connect to server
builder <- DSI::newDSLoginBuilder()
builder$append(server = "server1",
               url = "https://datashield1.liv.ac.uk",
               user = "administrator",
               password = "P@55w0rd",
               options = "list(ssl_verifyhost = 0, ssl_verifypeer = 0)")
logindata <- builder$build()
connections <- datashield.login(logins = logindata, assign = TRUE)

# Check DataSHIELD
datashield.pkg_status(connections)
datashield.tables(connections)

# Assign the table "test.CNSIM1" to the symbol 'D' Note that the table here
# needs to have been uploaded to opal and it probably needs to be assumed
# as decimals in the ingest process.
datashield.assign.table(connections, 'D', "test.CNSIM4")

# Now start doing stuff with the data in the table linked to 'D'
ds.colnames(x = 'D', datasources = connections)
ds.dim(x = 'D', datasources = connections)
ds.summary(x = 'D$LAB_HDL', datasources = connections)
ds.mean(x = 'D$LAB_HDL', datasources = connections)
datashield.errors()
