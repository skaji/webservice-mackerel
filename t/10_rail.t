use strict;
use Test::More;
use Test::Double;
use JSON qw/encode_json decode_json/;

use WebService::Mackerel;

subtest 'post_service_metrics' => sub {
    my $fake_res = encode_json({ "success" => "true" });
    my $mackerel = WebService::Mackerel->new( api_key  => 'testapikey', service_name => 'test' );
    mock($mackerel)->expects('post_service_metrics')->times(1)->returns($fake_res);

    my $res = $mackerel->post_service_metrics([ {"name" => "custom.name_metrics", "time" => "1415609260", "value" => 200} ]);

    is_deeply $res, $fake_res, 'post_service_metrics : response success';

    Test::Double->verify;
    Test::Double->reset;
};

subtest 'create_host' => sub {
    my $fake_res = encode_json({ "id" => "test_host_id" });
    my $mackerel = WebService::Mackerel->new( api_key  => 'testapikey', service_name => 'test' );
    mock($mackerel)->expects('create_host')->times(1)->returns($fake_res);

    my $res = $mackerel->create_host({
            "name"          => "test_hostname",
            "meta"          => { "status" => "maintenance" },
            "interfaces"    => [ { "name" => "eth0", "ipAddress" => "192.168.128.1", "macAddress" => "AA:BB::CC::DD::11::22" } ],
            "roleFullnames" => [ "test:test-role" ],
        });

    is_deeply $res, $fake_res, 'create_host : response success';

    Test::Double->verify;
    Test::Double->reset;
};

subtest 'get_host' => sub {
    my $fake_res = encode_json({
            "createdAt" => 1416151310,
            "id"        => "test_host_id",
            "memo"      => "test memo",
            "role"      => { [ "test-role" ] },
        });
    my $mackerel = WebService::Mackerel->new( api_key  => 'testapikey' );
    mock($mackerel)->expects('get_host')->times(1)->returns($fake_res);

    my $res = $mackerel->get_host("test_host_id");

    is_deeply $res, $fake_res, 'get_host : response success';

    Test::Double->verify;
    Test::Double->reset;
};

subtest 'update_host' => sub {
    my $fake_res = encode_json({ "id" => "test_host_id" });
    my $mackerel = WebService::Mackerel->new( api_key  => 'testapikey' );
    mock($mackerel)->expects('update_host')->times(1)->returns($fake_res);

    my $res = $mackerel->update_host({
            "hostId"        => "test_host_id",
            "data"          => {
                "name"          => "test_hostname",
                "meta"          => { "status" => "maintenance" },
                "interfaces"    => [ { "name" => "eth0", "ipAddress" => "192.168.128.1", "macAddress" => "AA:BB::CC::DD::11::22" } ],
                "roleFullnames" => [ "test:test-role" ],
            },
        });

    is_deeply $res, $fake_res, 'update_host : response success';

    Test::Double->verify;
    Test::Double->reset;
};

subtest 'update_host_status' => sub {
    my $fake_res = encode_json({ "success" => "true" });
    my $mackerel = WebService::Mackerel->new( api_key  => 'testapikey' );
    mock($mackerel)->expects('update_host_status')->times(1)->returns($fake_res);

    my $res = $mackerel->update_host_status({
            "hostId" => "test_host_id",
            "data"   => { "status" => "maintenance" },
        });

    is_deeply $res, $fake_res, 'update_host_status : response success';

    Test::Double->verify;
    Test::Double->reset;
};

subtest 'host_retire' => sub {
    my $fake_res = encode_json({ "success" => "true" });
    my $mackerel = WebService::Mackerel->new( api_key  => 'testapikey' );
    mock($mackerel)->expects('host_retire')->times(1)->returns($fake_res);

    my $res = $mackerel->host_retire("test_host_id");

    is_deeply $res, $fake_res, 'host_retire : response success';

    Test::Double->verify;
    Test::Double->reset;
};

done_testing;
