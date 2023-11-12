# FC_Status
Checks the First Class server's port to verify it is accepting connections


You will need to install the following Perl modules:



  * cpan -i IO::Socket::PortState qw(check_ports);
  * cpan -i Email::Simple;
  * cpan -i Email::Simple::Creator;
  * cpan -i Email::Sender::Simple qw(sendmail);

Create a crontab entry like this:

    5 * * * * /root/FC_Status/scan_fc_list.pl 2>&1 >/dev/null

Edit scan_fc_list.pl for the email address to send notices to and the server and port to test for state.

