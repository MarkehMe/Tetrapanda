#! /usr/bin/perl
use Net::LastFM;

die "Error: Please pass in your favourite artists on ARGV" unless @ARGV;

my $lastfm = Net::LastFM->new(
    api_key    => 'b1c4d44d876d48e7cc1797c3735c0f6c',
    api_secret => '4261d263e5a4e3ccd30eb602ae5ebdc9'
);

my @periods = split "overall 7day 1month 3month 6month 12month";

sub getRandomTrack {

    my $top = $lastfm->request(
        method => 'user.getTopTracks',
        user   => 'lyucit',
        period => $periods[rand @periods]
    );
    my $tracks = $top->{"toptracks"}->{"track"};
    my $suggestion = $tracks->[rand @$tracks];
    my $trackname = sprintf "\"%s\" by %s", $suggestion->{"name"}, $suggestion->{"artist"}->{"name"};
    return $trackname;
}

sub getRandomArtist {

    my $top = $lastfm->request(
        method => 'user.getTopArtists',
        user   => 'lyucit',
        limit  => 20,
        period => $periods[rand @periods]
    );
    my $artists = $top->{"topartists"}->{"artist"};
    
    my $suggestion = $artists->[rand @$artists];
    return $suggestion->{"name"};
}

my $criticise = $ARGV[rand @ARGV];

my @trackresponses = (
    "Hmmm, sure. How about %s?", 
    "That's cool and all, but have a listen to %s.", 
    "$criticise? How mainstream. Have you listened to %s?",
    "%s. Listen to it. Now.",
    "I think you might enjoy %s.",
    "Perhaps %s? It's sort of like a $criticise song. Sort of."
);

my @artistresponses = (
    "$criticise is way overrated. Listen to some %s.",
    "Oh, sure, that's nice. Now listen to something from %s.",
    "I can't $criticise has ever made a song better than anything by %s.",
    "You'd like %s. Really!",
    "Oh man, really? $criticise? Check out %s, you'll love them.",
    "Ooooh, $criticise! They're just like how %s would have turned out if they sold out."
);

if (!int(rand(2))) {
    my $template = $trackresponses[rand @trackresponses];
    printf "$template\n", &getRandomTrack();
} else {
    my $template = $artistresponses[rand @artistresponses];
    printf "$template\n", &getRandomArtist();
}

