#!perl

use Net::Twitter;
use Wx qw(:everything);

package MyFrame;

use base 'Wx::Frame';
# import the event registration function
use Wx::Event qw(EVT_BUTTON EVT_TEXT_ENTER);

my $text;
my $button;
sub new {
    my $ref = shift;
    my $self = $ref->SUPER::new( undef,           # parent window
                                 -1,              # ID -1 means any
                                 'Ctrl + Alt + Tweet',  # title
                                 [-1, -1],        # default position
                                 [600, 90],      # size
                                 );

    $panel = Wx::Panel->new( $self,            # parent window
                                -1,               # ID
                                );
	$self->{panel} =  $panel;
	$text = Wx::TextCtrl->new(
								$panel, 
								-1,
								'', 
								[10,15], 
								[480,20], 
								wxTE_PROCESS_ENTER 
                  );
	$panel->{text} = $text;
	$text->SetMaxLength(140);
    $button = Wx::Button->new( $panel,         # parent window
                                  -1,             # ID
                                  'Tweet',        # label
                                  [500, 13],       # position
                                  [-1, -1],       # default size
                                  );
	$panel->{button} = $button;
	
    # register the OnClick method as an handler for the
    # 'button clicked' event. The first argument is a Wx::EvtHandler
    # that receives the event
    EVT_BUTTON( $self, $button, \&OnClick );
	EVT_TEXT_ENTER( $self, $text, \&OnEnter );
	
    return $self;
}

# this method receives as its first parameter the first argument
# passed to the EVT_BUTTON function. The second parameter
# always is a Wx::Event subclass
sub OnClick {
    my( $self, $event ) = @_;

    $self->SetTitle( 'Sending' );
	my $nt = Net::Twitter->new(
      traits   => [qw/OAuth API::REST/],
      consumer_key        => '47o0eVRvWPp4MBEqwXSg',
      consumer_secret     => '2D4igf5Ly1uG94TpRs8W3Tx2jZ6SDYABXo5TyhGI',
      access_token        => '198279614-r3QTnRbYvXMNx5ViyJZ0kqq3WwYuJW7OZMcByb0d',
      access_token_secret => 'jLiZouwmsTw2xKhNH9H4VcCBhqPBhCtpPPUHxxVIY',
	);

	my $status = $text->GetValue();
	eval { $nt->update($status) };
	if ( $@ ) {
		warn "update failed because: $@\n";
	}
	exit(0);
}
sub OnEnter {
	my ( $self, $tweet ) =shift;
	print "Am I here";
	$self->SetTitle( 'Sending' );
	my $nt = Net::Twitter->new(
      traits   => [qw/OAuth API::REST/],
      consumer_key        => '47o0eVRvWPp4MBEqwXSg',
      consumer_secret     => '2D4igf5Ly1uG94TpRs8W3Tx2jZ6SDYABXo5TyhGI',
      access_token        => '198279614-r3QTnRbYvXMNx5ViyJZ0kqq3WwYuJW7OZMcByb0d',
      access_token_secret => 'jLiZouwmsTw2xKhNH9H4VcCBhqPBhCtpPPUHxxVIY',
	);

	my $status = $tweet->GetValue();
	eval { $nt->update($status) };
	if ( $@ ) {
		warn "update failed because: $@\n";
	}
	exit(0);
}

package MyApp;

use base 'Wx::App';

sub OnInit {
    my $frame = MyFrame->new;
	$frame->Centre('wxBOTH');
    $frame->Show( 1 );
}

package main;

my $app = MyApp->new;
$app->MainLoop;