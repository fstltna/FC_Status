#!/usr/bin/perl

# This tool scans all the entries in the JV-LD database to see
# if they are functional or not

use strict;
use warnings;
use IO::Socket::PortState qw(check_ports);
use Email::Simple;
use Email::Simple::Creator;
use Email::Sender::Simple qw(sendmail);

my $CurHost = "macos.retro-os.live";
my $CurPort = "993";
my $CurNotify = "fstltna\@yahoo.com";

# No changes below here
my $CurStatus="";
my $timeout=5;
my $VERSION="1.0";
my $CONF_FILE="/root/CheckFC/config.ini";
my $EMAIL_SUBJ="*** FirstClass server status";
my $EMAIL_FROM="info\@macos.retro-os.live";
my $email="";

# If FC server is not accepting connections then send a email
sub MarkFC
{
	my($day, $month, $year)=(localtime)[3,4,5];
	$year += 1900;
	$month += 1;
	$month = substr("0".$month, -2);
	$day = substr("0".$day, -2);
	my $timeString="$year-$month-$day";
	# Field5 = date in "0000-00-00"
	# Field6 = status in "Active/Unreachable" format
	# Should we send owner a note?
	if (($CurStatus eq "Unreachable") && ($CurNotify ne ""))
	{
		my $CurBody = <<"END_MESSAGE_BODY";
Dear $CurNotify,
 
At our last scan of your FirstClass server we could not connect to it. You may want to look into it or disable notifications if you don't want to get these messages in the future.

Next check will be in roughly 1 hour.
 
Regards,
The Admins at MacOS.retro-os.live
END_MESSAGE_BODY
		$email = Email::Simple->create(
		header => [
		       From => $EMAIL_FROM,
		       To => $CurNotify,
		       Subject => $EMAIL_SUBJ,
		],
		body => $CurBody);
		sendmail($email);
	}
}

# Checks to see if the FC server is up
sub CheckFC
{
	my %port_hash = (
		tcp => {
			$CurPort => {},
		}
	);

	my $host_hr = check_ports($CurHost, $timeout, \%port_hash);
	$CurStatus = $host_hr->{tcp}{$CurPort}{open} ? "Active" : "Unreachable";
	my $HostTable = sprintf("%-30s : %-5s : %s", $CurHost, $CurPort, $CurStatus);
	print "$HostTable\n";
	MarkFC();
}

print("FC Check Status ($VERSION)\n");
print("===============================================\n");
$CurHost = "macos.retro-os.live";
$CurPort = "993";
$CurNotify = "fstltna\@yahoo.com";
print "Working on '$CurHost' - port '$CurPort'\n";
CheckFC();

exit(0);
