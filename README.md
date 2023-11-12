# FC_Status
Checks the First Class server's port to verify it is accepting connections


You will need to install the following Perl modules:

    ./installdeps.pl

Create a crontab entry like this:

    5 * * * * /root/FC_Status/scan_fc_list.pl 2>&1 >/dev/null

Edit scan_fc_list.pl for the email address to send notices to and the server and port to test for state.

