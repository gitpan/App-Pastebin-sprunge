package App::Pastebin::sprunge;
use perl5i::2;
# ABSTRACT: application for pasting to and reading from sprunge.us
our $VERSION = '0.005'; # VERSION


method new ($class:) {
    my $self;
    if (@ARGV) {                # READ
        $self->{paste_id} = shift @ARGV;
        require WWW::Pastebin::Sprunge::Retrieve;
        $self->{reader} = WWW::Pastebin::Sprunge::Retrieve->new();
    }
    else {                      # WRITE
        require WWW::Pastebin::Sprunge::Create;
        $self->{writer} = WWW::Pastebin::Sprunge::Create->new();
    }
    return bless $self, $class;
}


method run($lang) {
    if ($self->{paste_id}) {    # READ
        $self->{reader}->retrieve($self->{paste_id})
            or warn "Reading paste $self->{paste_id} failed: "
            . $self->{reader}->error() . "\n"
            and exit 1;
        say $self->{reader};
    }
    else {                      # WRITE
        my $text = do { local $/; <STDIN> };
        $self->{writer}->paste($text, lang => $lang)
            or warn 'Paste failed: '
            . $self->{writer}->error() . "\n"
            and exit 1;
        say $self->{writer};
    }
    return;
}

__END__
=pod

=encoding utf-8

=head1 NAME

App::Pastebin::sprunge - application for pasting to and reading from sprunge.us

=head1 VERSION

version 0.005

=head1 SYNOPSIS

    use App::Pastebin::sprunge;
    my $app = App::Pastebin::sprunge->new();
    $app->run();

=head1 DESCRIPTION

B<App::Pastebin::sprunge> provides an application interface to
L<WWW::Pastebin::Sprunge::Create> and L<WWW::Pastebin::Sprunge::Retrieve>,
which allow creating and retrieving pastes on the L<http://sprunge.us> pastebin.

This distribution provides an executable L<sprunge>, which provides a simple
command-line client for L<http://sprunge.us> using this library.

=head1 METHODS

=head2 new

B<new()> is the constructor, and creates an application object. Takes no
parameters.

=head2 run

B<run()> runs the application.

If I<lang> is present, the application will append this to the returned URI.
L<http://sprunge.us> uses L<Pygments|http://pygments.org> for syntax
highlighting.

=head1 AVAILABILITY

The latest version of this module is available from the Comprehensive Perl
Archive Network (CPAN). Visit L<http://www.perl.com/CPAN/> to find a CPAN
site near you, or see L<http://search.cpan.org/dist/App-Pastebin-sprunge/>.

The development version lives at L<http://github.com/doherty/App-Pastebin-sprunge>
and may be cloned from L<git://github.com/doherty/App-Pastebin-sprunge.git>.
Instead of sending patches, please fork this project using the standard
git and github infrastructure.

=head1 SOURCE

The development version is on github at L<http://github.com/doherty/App-Pastebin-sprunge>
and may be cloned from L<git://github.com/doherty/App-Pastebin-sprunge.git>

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests through the web interface at
L<https://github.com/doherty/App-Pastebin-sprunge/issues>.

=head1 AUTHOR

Mike Doherty <doherty@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Mike Doherty.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

