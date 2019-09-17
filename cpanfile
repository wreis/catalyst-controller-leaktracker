requires 'parent' => 0;
requires 'Catalyst::Runtime' => 5.8;
requires 'Devel::Size' => 0;
requires 'Devel::Cycle' => 0;
requires 'Catalyst::Plugin::LeakTracker' => 0;
requires 'Data::Dumper' => 0;
requires 'Template::Declare' => 0.42;
requires 'Number::Bytes::Human' => 0.07;
requires 'YAML::XS' => 0;

on test => sub {
    requires 'Test::More' => 0.88;
    requires 'Test::use::ok' => 0;
};
