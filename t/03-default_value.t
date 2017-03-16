use Test::More;

{
    package One::Two::Three;
    use Moo;
    use MooX::ValidateSubs;
    use Types::Standard qw/Str/;

    validate_subs(
        hash => { 
            params => {
                one => [Str, sub { 'Hello World' }], 
                two => [Str, 'build_two' ], 
                three => [Str],
                four => [Str, 1],
            },
        }
    );

    sub build_two {
        return 'Goodbye World';
    }

    sub hash {
        my ($self, %hash) = @_;
        return %hash;
    }
}

{
    package One::Two::Three::Attributes;
    use Moo;
    use MooX::ValidateSubs;
    use Types::Standard qw/Str/;

    has build_two => ( is => 'ro', default => sub { 'Goodbye World' } );

    validate_subs(
        hash => { 
            params => {
                one => [Str, sub { 'Hello World' }], 
                two => [Str, 'build_two' ], 
                three => [Str],
                four => [Str, 1],
            },
        }
    );
    
    sub hash {
        my ($self, %hash) = @_;
        return %hash;
    }
}

my $maybe = One::Two::Three->new();

my %list = $maybe->hash( three => 'ahhhh' );
is_deeply(\%list, { one => 'Hello World', two => 'Goodbye World', three=>  'ahhhh' }, "list returns 3 key/value pairs");

eval { $maybe->hash };
my $errors = $@;
like( $errors, qr/Undef did not pass type constraint "Str"/, "a list fails");

my $attr = One::Two::Three::Attributes->new();

my %attr_list = $attr->hash( three => 'ahhhh' );
is_deeply(\%attr_list, { one => 'Hello World', two => 'Goodbye World', three=>  'ahhhh' }, "list returns 3 key/value pairs");

eval { $attr->hash };
my $errors = $@;
like( $errors, qr/Undef did not pass type constraint "Str"/, "a list fails");

done_testing();

