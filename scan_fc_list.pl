#!/usr/bin/perl

# This tool scans all the entries in the JV-LD database to see
# if they are functional or not

use strict;
use warnings;
use IO::Socket::PortState qw(check_ports);
use Email::Simple;
use Email::Simple::Creator;
use Email::Sender::Simple qw(sendmail);

my $FCHost = "macos.retro-os.live";
my $FCPort = "993";
my $NotifyAddress = "fstltna\@yahoo.com";

# No changes below here
my $CurStatus="";
my $timeout=5;
my $VERSION="1.0";
my $EMAIL_SUBJ="*** FirstClass server status";
my $EMAIL_FROM="info\@macos.retro-os.live";
my $email="";

# If FC server is not accepting connections then send a email
sub FC_Email
{
	# Should we send owner a note?
	if (($CurStatus eq "Unreachable") && ($NotifyAddress ne ""))
	{
		my $CurBody = <<"END_MESSAGE_BODY";
Dear $NotifyAddress,
 
At our last scan of your FirstClass server we could not connect to it. You may want to look into it or disable notifications if you don't want to get these messages in the future.

Next check will be in roughly 1 hour.
 
Regards,
The Admins at MacOS.retro-os.live
END_MESSAGE_BODY
		$email = Email::Simple->create(
		header => [
		       From => $EMAIL_FROM,
		       To => $NotifyAddress,
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
			$FCPort => {},
		}
	);

	my $host_hr = check_ports($FCHost, $timeout, \%port_hash);
	$CurStatus = $host_hr->{tcp}{$FCPort}{open} ? "Active" : "Unreachable";
	my $HostTable = sprintf("%-30s : %-5s : %s", $FCHost, $FCPort, $CurStatus);
	print "$HostTable\n";
	FC_Email();
}

print("FC Check Status ($VERSION)\n");
print("===============================================\n");
$FCHost = "macos.retro-os.live";
$FCPort = "993";
print "Working on '$FCHost' - port '$FCPort'\n";
CheckFC();

exit(0);
