package Async::ORM::Relationship;

use Any::Moose;

sub build {
    my $class  = shift;
    my %params = @_;

    die 'type is required' unless $params{type};

    my @parts = map {ucfirst} split(' ', $params{type});
    my $rel_class = "Async::ORM::Relationship::" . join('', @parts);

    unless (Any::Moose::is_class_loaded($rel_class)) {
        Any::Moose::load_class($rel_class);
    }

    return $rel_class->new(%params);
}

1;
__END__

=head1 NAME

Async::ORM::Relationship - Relationships for Async::ORM

=head1 SYNOPSIS

    my $rel = Async::ORM::Relationship->build(name => 'foo', type => 'many to one');

=head1 DESCRIPTION

    This is a relationship factory that is used internally.

=head1 METHODS

=head2 C<build>

Returns a new relationship instance. Could be one of
L<Async::ORM::Relationship::OneToOne>, L<Async::ORM::Relationship::OneToMany>,
L<Async::ORM::Relationship::ManyToOne>, L<Async::ORM::Relationship::ManyToMany>.

=head1 AUTHOR

Viacheslav Tikhanovskii, C<vti@cpan.org>.

=head1 COPYRIGHT

Copyright (C) 2009, Viacheslav Tikhanovskii.

This program is free software, you can redistribute it and/or modify it under
the same terms as Perl 5.10.

=cut
