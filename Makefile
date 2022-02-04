# $Id: Makefile,v 1.25 1999/11/22 20:26:05 mfreeman Exp $
#
# Makefile to create genwrap binaries.
#

# paths to all group root home directories
BILLING_HOME=/home/staff/billing
DVLP_HOME=/home/staff/dvlp
FENG_HOME=/home/staff/feng
MRKTING_HOME=/home/staff/mrkting
NETENG_HOME=/home/staff/neteng
NETOPS_ECO=/home/blah/netops
NETOPS_BLAH=/home/blah/netops
NTENG_HOME=/home/staff/nteng
SALES_HOME=/home/staff/sales
SUPPORT_HOME=/home/blah/netsup
SYSENG_HOME=/home/staff/syseng
WEBOPS_HOME=/home/staff/webops
WEBPUB_HOME=/home/staff/webpub
WEBSUP_HOME=/home/staff/websup

# targets by group
BILLING_TARGETS=dmx
BILLING_INSTALL_TARGETS=dmx-install
DVLP_TARGETS=
DVLP_INSTALL_TARGETS=
FENG_TARGETS=
FENG_INSTALL_TARGETS=
MRKTING_TARGETS=
MRKTING_INSTALL_TARGETS=
NETENG_TARGETS=
NETENG_INSTALL_TARGETS=
NETOPS_TARGETS=
NETOPS_INSTALL_TARGETS=netops-install-timedout netops-install-netreq \
  netops-install-netreqstat
NTENG_TARGETS=
NTENG_INSTALL_TARGETS=
SALES_TARGETS=
SALES_INSTALL_TARGETS=
SUPPORT_TARGETS=
SUPPORT_INSTALL_TARGETS=
SYSENG_TARGETS=
SYSENG_INSTALL_TARGETS=
WEBOPS_TARGETS=
WEBOPS_INSTALL_TARGETS=
WEBPUB_TARGETS=vifconfig
WEBPUB_INSTALL_TARGETS=vifconfig-install
WEBSUP_TARGETS=getenpw
WEBSUP_INSTALL_TARGETS=getenpw-install

TARGETS=$(SYSENG_TARGETS) $(NETENG_TARGETS) $(FENG_TARGETS) \
  $(BILLING_TARGETS) $(DVLP_TARGETS) $(WEBOPS_TARGETS) \
  $(NTENG_TARGETS) $(NETOPS_TARGETS) $(SUPPORT_TARGETS) \
  $(SALES_TARGETS) $(MRKTING_TARGETS) $(WEBPUB_TARGETS) $(WEBSUP_TARGETS)

INSTALL_TARGETS=$(SYSENG_INSTALL_TARGETS) $(NETENG_INSTALL_TARGETS) \
  $(FENG_INSTALL_TARGETS) $(BILLING_INSTALL_TARGETS) \
  $(DVLP_INSTALL_TARGETS) $(WEBOPS_INSTALL_TARGETS) \
  $(NTENG_INSTALL_TARGETS) $(NETOPS_INSTALL_TARGETS) \
  $(SUPPORT_INSTALL_TARGETS) $(SALES_INSTALL_TARGETS) \
  $(MRKTING_INSTALL_TARGETS) $(WEBPUB_INSTALL_TARGETS) \
  $(WEBSUP_INSTALL_TARGETS)

SOURCE=genwrap.c
CC=gcc
CFLAGS=-O2 -Wall
USERNAME_LEGALCHARS=-DLEGALCHARS=\"_\"

###############
# start general

all:	$(TARGETS)

install:	$(INSTALL_TARGETS)

clean:
	rm -f $(TARGETS)

# end general
#############

######################
# start group-specific

################
# start websup
#websu
websu:                $(SOURCE)
	$(CC) $(CFLAGS) -o websu $(SOURCE) \
		-DPATH=\"/home/blah/root/scripts/websu.pl\" \
		-DMINARGS=0 -DMAXARGS=6 -DALLOWFLAGS -DLEGALCHARS=\"-.:/_\"
# fpadmin wrapper
fpadmin:		$(SOURCE)
	$(CC) $(CFLAGS) -o fpadmin $(SOURCE) \
		-DPATH=\"/home/blah/webops/bin/fpadmin.pl\" \
		-DMINARGS=0 -DMAXARGS=6 -DALLOWFLAGS -DLEGALCHARS=\"-.:/_\"
# mkftp
mkftp:		$(SOURCE)
	$(CC) $(CFLAGS) -o mkftp $(SOURCE) \
		-DPATH=\"/home/blah/root/scripts/mkftp.pl\" \
		-DMINARGS=0 -DMAXARGS=8 -DALLOWFLAGS -DLEGALCHARS=\"-.:\"

# ifconfig wrapper
vifconfig:	$(SOURCE)
	$(CC) $(CFLAGS) -o vifconfig $(SOURCE) \
		-DPATH=\"/usr/sbin/ifconfig\" \
		-DMINARGS=1 -DMAXARGS=3 -DALLOWFLAGS -DLEGALCHARS=\"-.:\"

vifconfig-install:	$(WEBSUP_HOME)/sbin/vifconfig

$(WEBSUP_HOME)/sbin/vifconfig:	vifconfig
	cp $? $@
	/usr/bin/chown root $@
	/usr/bin/chgrp websup $@
	/usr/bin/chmod 4510 $@
# getenpw wrapper
getenpw:	$(SOURCE)
	$(CC) $(CFLAGS) -o getenpw $(SOURCE) \
	-DPATH=\"/usr/local/system/bin/getenpw\" \
	-DMINARGS=1 -DMAXARGS=3 -DALLOWFLAGS -DLEGALCHARS=\"-.:\"

getenpw-install:	$(WEBSUP_HOME)/sbin/getenpw

(WEBSUP_HOME)/sbin/getenpw:	getenpw
	cp $? $@
	/usr/bin/chown root $@
	/usr/bin/chgrp websup $@
	/usr/bin/chmod 4510 $@
# end websup

################
################
# start feng

# end feng
################
################
# start neteng

# end neteng
################
##############
# start netops
netops-install-timedout:	$(NETOPS_BLAH)/bin/timedout
netops-install-netreq:	$(NETOPS_ECO)/bin/netreq
netops-install-netreqstat:	$(NETOPS_ECO)/bin/netreqstat

$(NETOPS_BLAH)/bin/timedout:	timedout
	cp $? $@
	/usr/bin/chown root $@
	/usr/bin/chgrp netops $@
	/usr/bin/chmod 4510 $@

$(NETOPS_ECO)/bin/netreq:	netreq
	cp $? $@
	/usr/bin/chown netops:netops $@
	/usr/bin/chmod 4511 $@

$(NETOPS_ECO)/bin/netreqstat:	netreqstat
	cp $? $@
	/usr/bin/chown netops:netops $@
	/usr/bin/chmod 4511 $@

timedout:	$(SOURCE)
	$(CC) $(CFLAGS) -o timedout $(SOURCE) \
		-DPATH=\"/home/blah/netops/bin/timedout.pl\" \
		-DMINARGS=1 -DMAXARGS=1 -DLEGALCHARS=\"-.\"

netreq:	$(SOURCE)
	$(CC) $(CFLAGS) -o netreq $(SOURCE) \
		-DALLOWFLAGS \
	        -DPATH=\"/home/blah/netops/etc/netreq-operation\" \
		-DMINARGS=1 -DMAXARGS=5 -DLEGALCHARS=\"-.\"

netreqstat:	$(SOURCE)
	$(CC) $(CFLAGS) -o netreqstat $(SOURCE) \
		-DALLOWFLAGS \
	        -DPATH=\"/home/blah/netops/etc/netreq-status\" \
		-DMINARGS=1 -DMAXARGS=5 -DLEGALCHARS=\"-.\"

# end netops
############
################
# start syseng

setquota:	$(SOURCE)
		$(CC) $(CFLAGS) -o setquota $(SOURCE) \
		-DPATH=\"/usr/local/system/scripts/setquota.pl\" \
		-DMINARGS=2 -DMAXARGS=999 -DALLOWFLAGS -DLEGALCHARS=\"-_./\"

passwd:		$(SOURCE)
		$(CC) $(CFLAGS) -o $@ $(SOURCE) \
		-DPATH=\"/usr/local/sec/anl/anlpasswd\" \
		-DLEGALCHARS=\"-\" -DALLOWFLAGS -DMINARGS=0 -DMAXARGS=999 \
		-DEFFECTIVE_ID_ONLY

upasswd:	$(SOURCE)
		$(CC) $(CFLAGS) -o $@ $(SOURCE) \
		-DPATH=\"/home/staff/hag/upasswd.pl\" \
		-DLEGALCHARS=\"-\" -DALLOWFLAGS -DMINARGS=0 -DMAXARGS=999 -DUSERARG

# end syseng
################
################
# start webops

IMDS:		$(SOURCE)
		$(CC) $(CFLAGS) -o IMDS $(SOURCE) \
		-DPATH=\"/etc/init.d/IMDS\" -DMINARGS=1 -DMAXARGS=1

# end webops
##############
################
# start billing

# dmx: This wrapper is used by the memberservices stuff on the web.  It is
# run by billing, but needs to be suid root.
dmx:		$(SOURCE)
	$(CC) $(CFLAGS) -o dmx $(SOURCE) \
		-DPATH=\"$(BILLING_HOME)/bin/mservices.pl\" \
		-DMINARGS=1 -DMAXARGS=1

dmx-install:	$(BILLING_HOME)/sbin/dmx

$(BILLING_HOME)/sbin/dmx:	dmx
	cp $? $@
	/usr/bin/chown root $@
	/usr/bin/chgrp billing $@
	/usr/bin/chmod 4510 $@

# end billing
##############


# end group-specific
####################

#####################
# start group-general

syseng:	$(SYSENG_INSTALL_TARGETS)

neteng:	$(NETENG_INSTALL_TARGETS)

feng:	$(FENG_INSTALL_TARGETS)

billing:	$(BILLING_INSTALL_TARGETS)

dvlp:	$(DVLP_INSTALL_TARGETS)

webops:	$(WEBOPS_INSTALL_TARGETS)

nteng:	$(NTENG_INSTALL_TARGETS)

netops:	$(NETOPS_INSTALL_TARGETS)

support:	$(SUPPORT_INSTALL_TARGETS)

sales:	$(SALES_INSTALL_TARGETS)

mrkting:	$(MRKTING_INSTALL_TARGETS)

webpub:	$(WEBPUB_INSTALL_TARGETS)

websup:	$(WEBSUP_INSTALL_TARGETS)

# end group-general
###################
