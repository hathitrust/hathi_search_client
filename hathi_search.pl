#!/usr/bin/perl

use strict;
use warnings;

# cargo cult from zcode --jstever
use open qw( :encoding(UTF-8) :std );
BEGIN {push @INC, '.'}
use File::Basename;
BEGIN {push @INC, dirname(__FILE__)}
# end cargo cult

use LWP::Simple;
use JSON::XS;

use rightsDB;

#use YAML;
use YAML 'LoadFile';
use URI::Escape;
use Data::Dumper;
use Encode;
use Getopt::Std;
use MARC::Record;
use MARC::File::XML(BinaryEncoding => 'utf8');

use File::Basename;
my $prgname = basename($0);

sub usage {
  my $msg = shift;
  $msg and $msg = " ($msg)";
  return "usage: $prgname -c config [-o out_base]$msg\n";
};

our($opt_c, $opt_o);
getopts('c:o:');
$opt_c or die usage("no config file specified");
my $config_file = $opt_c;

my $outbase = '';
$opt_o and do {
  print "output basename from command line\n";
  $outbase = $opt_o;
};

my $config = LoadFile("$config_file.yaml") or die "error loading config file: $!";

$outbase or do {
  $outbase = $config->{"name"} or die "no outbase from config name value";
  print "output basename from config name: $outbase\n";
};

my $out_report_file = $outbase . "_rpt.tsv";
open(REPORT, ">$out_report_file") or die "can't open $out_report_file for output: $!\n";

print REPORT join("\t", 
  "title", 
  "authors", 
  "publisher", 
  "publish date", 
  "enum/chron", 
  "zephir CID", 
  "ht id",
  "rights date",
  "rights attribute",
  "rights reason",
  ), "\n";

my  $rightsDB = rightsDB->new();

my $select = 'http://solr-sdr-catalog.umdl.umich.edu:9033/solr/catalog/select';

#---
#name: virginia_tech
#indexes: 
#  -  author
#  -  author2
#  -  publisher
#terms:
#  - Virginia Tech
#  - VPI
#  - Virginia Polytechnic Institute
#...

print Dumper($config);

my @q_list = ();
foreach my $index ( @{$config->{indexes}} ) {
  foreach my $term ( @{$config->{terms}} ) {
    push @q_list, join(':', $index, process_term($term));
  }
}

sub process_term {
  my $term = shift;
  $term =~ /^".*"$/ and return $term;
  my @term_words = split(/\s+/, $term);
  return '(' . join(" ", map {'+'.$_ } @term_words) . ')';
}

foreach my $search ( @{$config->{searches}} ) {
  push @q_list, "($search)";
}

my $q_orig = join (' OR ', @q_list);
print "q_orig: $q_orig\n";

my $fields = 'id,ht_json,fullrecord,sdrnum,title,author,publishDate,publisher,topicStr';

my $pagesize = 100000;
#my $pagesize = 100;

my $q = uri_escape($q_orig);

##### end setup ####


binmode STDOUT, ':utf8';

# Do an empty first query and get the total out of it.

my $page = 0;
my $start = $pagesize * $page;
my $url = "$select?q=$q&rows=0&start=$start&wt=json&json.nl=arrarr&fl=$fields";

my $result = decode_json(get($url));
my $total = $result->{response}{numFound};
print STDERR "Total for query $q_orig is $total\n";

my $page_cnt;
my $doc_cnt;
my $all_id_cnt = 0;
my $id_cnt = 0;

PAGE:while ($start < $total) {
  $page_cnt++;
  $url = "$select?q=$q&rows=$pagesize&start=$start&wt=json&json.nl=arrarr&fl=$fields";
  my $result = get($url);
  $result = encode("utf8", $result);
  eval { $result = decode_json($result); };
  $@ and do {
    print STDERR "$url: error decoding json:  $@\n";
    print "$result\n";
    exit;
    next PAGE;
  };
  DOC:foreach my $doc (@{$result->{response}{docs}}) {
    $doc_cnt++;
    my $id = $doc->{id};
    my $title = $doc->{title}->[0];
    my $authors = defined($doc->{author}) ? join("; ", @{$doc->{author}}) : "";
    my $subjects = defined($doc->{topicStr}) ? join("; ", @{$doc->{topicStr}}) : "";
    my $sdrnums = defined($doc->{sdrnum}) ? join(", ", @{$doc->{sdrnum}}) : "";
    my $publisher = defined($doc->{publisher}) ? join("; ", @{$doc->{publisher}}) : "";
    my $publishDate = defined($doc->{publishDate}) ? join("; ", @{$doc->{publishDate}}) : "";
    my $ht_json = decode_json(encode("utf8", $doc->{ht_json}));

    my $bib_record;
    my $bib_xml = $doc->{fullrecord};
    ($bib_xml =~ tr/\xA0/ /) and do {
      print STDERR "$id: non-breaking space(s) translated to space\n";
    };
    eval { $bib_record = MARC::Record->new_from_xml($bib_xml); };
    $@ and do {
      print STDERR "problem processing marc xml\n";
      warn $@;
      print STDERR "$bib_xml\n";
    };
    my $f260_data = '';
    my $f260;
    $f260 = $bib_record->field('260') and $f260_data = $f260->as_string('abc');
    $f260_data or print STDERR "$id: no 260 for record\n";

    foreach my $ht_item (@$ht_json) {
      $all_id_cnt++;

      my $enumcron =  defined($ht_item->{enumcron}) ? $ht_item->{enumcron} : "";
      my $enum_pubdate =  defined($ht_item->{enum_pubdate}) ? $ht_item->{enum_pubdate} : "";
      my ($db_rights, $db_reason, $db_dig_source, $db_timestamp, $db_rights_note) = GetRights($ht_item->{htid});
      $db_rights ne $ht_item->{rights}->[0] and print STDERR "$ht_item->{htid}: rights mismatch, db: $db_rights, hathi: $ht_item->{rights}->[0]\n";
      #$db_rights =~ /^(ic|und)/ or next;
      $id_cnt++;

      print REPORT join("\t", 
        $title, 
        $authors, 
        $f260_data,
        "'" . $publishDate, 
        "'" . $enumcron, 
        "'" . $id, 
        $ht_item->{htid},
        $enum_pubdate,
        $db_rights,
        $db_reason,
        ), "\n";
    }
  }
  
  # Increment for next time
  $page++;
  $start = $page * $pagesize;
  print STDERR "page $page_cnt, doc $doc_cnt\n";
}

print "$total results from query\n";
print "$page_cnt pages read\n";
print "$doc_cnt documents read\n";
print "$all_id_cnt all ht items\n";
print "$id_cnt selected ht items\n";

sub GetRights {
  my $ht_id = shift;
  return $rightsDB->GetRightsFromDB($ht_id);
}
