#!/bin/sh
# Name: Atomic Archive configuration script
# NOTES
# RHEL4 Red Hat Enterprise Linux ES release 4 (Nahant Update 4) 
# TODO
# DONE 1) Resolve yum for VPS users
# DONE 2) Resolve yum for RHEL users
# 3) Combine with AOOI?

RELEASE=`cat /etc/redhat-release | awk -F\( '{print $1}'`
VERSION="1.0-12"
SERVER=atomicorp.com
ARCH=`uname -i`
REDHAT=0
ATOMIC_VER="1.2"



echo
echo "Atomic Archive installer, version $ATOMIC_VER"
echo
echo "BY INSTALLING THIS SOFTWARE YOU AGREE:"
echo
echo "THIS SOFTWARE AND ALL SOFTWARE PROVIDED IN THIS REPOSITORY IS "
echo "PROVIDED BY ATOMICORP LIMITED AS IS AND ANY EXPRESS OR IMPLIED"
echo "WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED"
echo "WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE"   
echo "ARE DISCLAIMED. IN NO EVENT SHALL ATOMICORP LIMITED, THE COPYRIGHT"
echo "OWNER OR ANY CONTRIBUTOR TO THIS SOFTWARE OR ANY SOFWARE PROVIDED"
echo "BY ATOMICORP LIMITED BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,"
echo "SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT"
echo "LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF"
echo "USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED"
echo "AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,"
echo "STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)"   
echo "ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED" 
echo "OF THE POSSIBILITY OF SUCH DAMAGE."
echo
echo "Configuring the [atomic] yum archive for this system " 
echo

if grep -q "Red Hat Linux release 9  " /etc/redhat-release ; then
  DIST="rh9"
  DIR=redhat/9
  echo
  echo "$RELEASE is no longer supported."
  echo
  exit 1
elif grep -q "Fedora Core release 2 " /etc/redhat-release ; then
  DIST="fc2"
  DIR=fedora/2
  echo
  echo "$RELEASE is no longer supported."
  echo
  exit 1
elif grep -q "Fedora Core release 3 " /etc/redhat-release ; then
  DIST="fc3"
  DIR=fedora/3
  echo
  echo "$RELEASE is no longer supported."
  echo
  exit 1
  #YUMDEPS="fedora-release python-elementtree python-sqlite python-urlgrabber yum"
elif grep -q "Fedora Core release 4 " /etc/redhat-release ; then
  DIST="fc4"
  DIR=fedora/4
  YUMDEPS="fedora-release python-elementtree python-sqlite python-urlgrabber yum"
  PLESKREPO="plesk-fedora"
elif grep -q "Fedora Core release 5 " /etc/redhat-release ; then
  DIST="fc5"
  DIR=fedora/5
  YUMDEPS="fedora-release python-elementtree python-sqlite python-urlgrabber yum"
  PLESKREPO="plesk-fedora"
elif grep -q "Fedora Core release 6 " /etc/redhat-release ; then
  DIST="fc6"
  DIR=fedora/6
  YUMDEPS="fedora-release python-elementtree python-sqlite python-urlgrabber yum rpm-python"
  PLESKREPO="plesk-fedora"
elif grep -q "Fedora release 7 " /etc/redhat-release ; then
  DIST="fc7"
  DIR=fedora/7
  YUMDEPS="fedora-release python-elementtree python-sqlite python-urlgrabber yumrpm-python"
  PLESKREPO="plesk-fedora"
elif grep -q "Fedora release 8 " /etc/redhat-release ; then
  DIST="fc8"
  DIR=fedora/8
  YUMDEPS="fedora-release python-elementtree python-sqlite python-urlgrabber yumrpm-python"
  PLESKREPO="plesk-fedora"
elif grep -q "Fedora release 9 " /etc/redhat-release ; then
  DIST="fc9"
  DIR=fedora/9
  YUMDEPS="fedora-release python-elementtree python-sqlite python-urlgrabber yumrpm-python"
  PLESKREPO="plesk-fedora"
  DISABLE_PLESK=yes
elif grep -q "Fedora release 10 " /etc/redhat-release ; then
  DIST="fc10"
  DIR=fedora/10
  YUMDEPS="fedora-release python-elementtree python-sqlite python-urlgrabber yumrpm-python"
  PLESKREPO="plesk-fedora"
  DISABLE_PLESK=yes
elif grep -q "Fedora release 11 " /etc/redhat-release ; then
  DIST="fc11"
  DIR=fedora/11
  YUMDEPS="fedora-release python-elementtree python-sqlite python-urlgrabber yumrpm-python"
  PLESKREPO="plesk-fedora"
  DISABLE_PLESK=yes
elif grep -q "Fedora release 12 " /etc/redhat-release ; then
  DIST="fc12"
  DIR=fedora/12
  YUMDEPS="fedora-release python-elementtree python-sqlite python-urlgrabber yumrpm-python"
  PLESKREPO="plesk-fedora"
  DISABLE_PLESK=yes
elif grep -q "Fedora release 13 " /etc/redhat-release ; then
  DIST="fc13"
  DIR=fedora/13
  YUMDEPS="fedora-release python-elementtree python-sqlite python-urlgrabber yumrpm-python"
  PLESKREPO="plesk-fedora"
  DISABLE_PLESK=yes
elif egrep -q "Red Hat Enterprise Linux (A|E)S release 3 " /etc/redhat-release ; then
  DIST="el3"
  DIR=redhat/3
  echo
  echo "$RELEASE is not supported at this time, you will need to configure yum manually:"
  echo "see http://$SERVER/channels for instructions"
  echo
  exit 1
elif grep -q "CentOS release 3" /etc/redhat-release ; then
  DIST="el3"
  DIR=centos/3
  echo
  echo "$RELEASE is not supported at this time, you will need to configure yum manually:"
  echo "see http://$SERVER/channels for instructions"
  echo
  exit 1
elif egrep -q "Red Hat Enterprise Linux (A|E|W)S release 4" /etc/redhat-release ; then
  REDHAT=1
  DIST="el4"
  DIR=redhat/4
  YUMDEPS="python-elementtree python-sqlite python-urlgrabber yum sqlite"
  PLESKREPO="plesk-redhat"
elif egrep -q "Red Hat Enterprise Linux.*release 5" /etc/redhat-release ; then
  REDHAT=1
  DIST="el5"
  DIR=redhat/5
  YUMDEPS="rpm-python python-elementtree python-sqlite python-urlgrabber yum sqlite"
  PLESKREPO="plesk-redhat"
elif grep -q "CentOS release 3" /etc/redhat-release ; then
  DIST="el3"
  DIR=centos/3
  YUMDEPS="centos-release python-elementtree python-sqlite python-urlgrabber yum sqlite"
  PLESKREPO="plesk-centos"
elif grep -q "CentOS release 4" /etc/redhat-release ; then
  DIST="el4"
  DIR=centos/4
  YUMDEPS="centos-release python-elementtree python-sqlite python-urlgrabber yum sqlite"
  PLESKREPO="plesk-centos"
elif grep -q "CentOS release 5" /etc/redhat-release ; then
  DIST="el5"
  DIR=centos/5
  YUMDEPS="rpm-python centos-release python-elementtree python-sqlite python-urlgrabber yum sqlite m2crypto"
  PLESKREPO="plesk-centos"
elif grep -q "CloudLinux Server release 5" /etc/redhat-release ; then
  DIST="el5"
  DIR=centos/5
  YUMDEPS="rpm-python centos-release python-elementtree python-sqlite python-urlgrabber yum sqlite m2crypto"
  PLESKREPO="plesk-centos"
else 
  echo "Error: Unable to determine distribution type. Please send the contents of /etc/redhat-release to support@atomicorp.com"
  exit 1
fi

ATOMIC=atomic-release-$VERSION.$DIST.art.noarch.rpm
# for up2date
SOURCES="yum atomic http://www.atomicorp.com/channels/atomic/$DIR/$ARCH"

# Input validation function 
# check_input <msg> <valid responses regex> <default>
# if <default> is passed on as null, then there is no default
# Example: check_input  "Some question (yes/no) " "yes|no"  "yes"
function check_input {
  message=$1
  validate=$2
  default=$3

  while [ $? -ne 1 ]; do
    echo -n "$message "
    read INPUTTEXT < /dev/tty
    if [ "$INPUTTEXT" == "" -a "$default" != "" ]; then
      INPUTTEXT=$default
      return 1
    fi
    echo $INPUTTEXT | egrep -q "$validate" && return 1
    echo "Invalid input"
  done

}


# Yum install function
function installyum {
  opts=$1

  if [ ! -d atomic/yumdeps ]; then
    mkdir -p atomic/yumdeps/
  fi
  cd atomic/yumdeps
  if [ -f $DIST-$ARCH-yumdeps.tar.gz ]; then
    rm -f $DIST-$ARCH-yumdeps.tar.gz
  fi

  #echo "wget -q http://$SERVER/installers/yum/$DIST-$ARCH-yumdeps.tar.gz"
  wget -q http://$SERVER/installers/yum/$DIST-$ARCH-yumdeps.tar.gz || exit 1
  tar zxf $DIST-$ARCH-yumdeps.tar.gz


  for i in $YUMDEPS; do
    rpm --quiet --queryformat=%{NAME} -q $i || INSTALLDEPS="$i*rpm $INSTALLDEPS"
  done

  #echo "DEBUG $INSTALLDEPS"
  rpm -Uvh $opts $INSTALLDEPS

}


echo -n "Installing the Atomic GPG key: "
wget -q http://www.atomicrocketturtle.com/RPM-GPG-KEY.art.txt 1>/dev/null 2>&1
rpm -import RPM-GPG-KEY.art.txt >/dev/null 2>&1
echo "OK"


if [ ! -f /usr/bin/yum ]; then
  
  echo "Yum was not detected. Attempting to resolve.. "
  echo

  # If were on RHEL4, ask if they want to convert to centos, or use up2date
  if [ "$REDHAT" == "1" ]; then
    echo
    echo "Redhat Enterprise Linux Detected.."
    echo "  If you do not have a valid RHEL subscription, this utility can be used"
    echo "  to convert this system to centos. If you do have a valid subscription"
    echo "  just hit enter, or n to continue. The installer will add the [atomic]"
    echo "  channel to up2date, and *attempt* to install yum."
    echo 
    #echo -n "Convert this system to CentOS? (y/n) [Default: no]: "
    #read useyum < /dev/tty
    check_input "Convert this system to CentOS? (y/n) [Default: n]:" "y|n" "n" 
    useyum=$INPUTTEXT

    if [ "$useyum" == "y" ]; then     
      echo "Installing yum from CentOS"
      YUMDEPS="centos-release $YUMDEPS"
      PLESKREPO="plesk-centos"
      installyum
    else
      echo "Attempting to configure [atomic] for up2date"
      if egrep -q "^yum atomic" /etc/sysconfig/rhn/sources ; then
        echo "atomic channel detected"
      else 
        echo $SOURCES >> /etc/sysconfig/rhn/sources
      fi
      echo "Attempting to set up yum for RHEL"
      echo -n "  Installing RPM GPG key: "
      wget -q http://www.atomicorp.com/installers/yum/RPM-GPG-KEY-c4 1>/dev/null 2>&1
      rpm -import RPM-GPG-KEY-c4 >/dev/null 2>&1
      echo "OK"
      installyum "--nodeps"
      YUM=1 
    fi

  else 
    # for everyone else
    installyum
    YUM=1 
  fi

else 
  YUM=1
fi


if [ "$YUM" == "1" ]; then
  echo -n "Downloading $ATOMIC: "
  wget -q http://$SERVER/channels/atomic/$DIR/$ARCH/RPMS/$ATOMIC >/dev/null 2>&1 || exit $?
  if [ -f $ATOMIC ]; then
    rpm -Uvh $ATOMIC >/dev/null 2>&1
  else
    echo "ERROR: $ATOMIC was not downloaded."
    exit 1
  fi
  echo "OK"
fi


if [ -f /etc/yum.repos.d/plesk.repo ]; then
  rm -f /etc/yum.repos.d/plesk.repo
fi


DISABLE_PLESK=yes
if [ "$DISABLE_PLESK" == "yes" ] ; then
  echo
else
 echo 
 echo "Would you like to add the Plesk yum repository to the system?"
 echo 

 check_input "Enable Plesk repository? (y/n) [Default: n]:" "y|n" "n" 
 useplesk=$INPUTTEXT
 
 if [ "$useplesk" == "y" ]; then     
   
   #Version
   echo
   echo "Plesk 8.6 and 9.2 repositories are available:"
   echo "NOTE: Plesk 9 repos are only available for rhel/centos 4 and 5"
   echo
   check_input "Enable Plesk 8.6 or 9.2? (8/9) [Default: 8]:" "8|9" "8"
   PSA_VERSION=$INPUTTEXT
 
 
   # Remove the old repo's
   if [ -f /etc/yum.repos.d/plesk.repo ] ; then
     rm -f /etc/yum.repos.d/plesk.repo
   fi
   
   wget -q -O /etc/yum.repos.d/plesk.repo http://$SERVER/installers/repos/$PLESKREPO-$PSA_VERSION.repo
 
 fi
fi

echo
echo
echo "The Atomic Rocket Turtle archive has now been installed and configured for your system"
echo "The following channels are available:"
echo "  atomic          - [ACTIVATED] - contains the stable tree of ART packages"
echo "  atomic-testing  - [DISABLED]  - contains the testing tree of ART packages"
echo "  atomic-bleeding - [DISABLED]  - contains the development tree of ART packages"
echo
echo

