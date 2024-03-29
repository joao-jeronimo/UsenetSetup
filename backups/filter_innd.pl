# vim: set tabstop=4 shiftwidth=4 expandtab syntax=perl:
#
# Copyright 1999 Jeremy Nixon <jeremy@exit109.com>
# Copyright 2001 Marco d'Itri <md@linux.it>
#
# Modified by Steve Crook <steve@mixmin.net>
# Redistributed in accordance with the terms of the Artistic license.
#
# This software is distributed under the terms of the Artistic License.
# Please see the LICENSE file in the distribution.
#

no warnings "once";

# CHANGE THE BELOW SETTING!
# Directory where cleanfeed.local and the other configuration files live.
# Set this to undef to not use any external file.

#$config_dir = '/usr/local/news/cleanfeed/etc';
$config_dir = '/opt/inn2/etc/cleanfeed';

##############################################################################
# Server configuration
#
# Set $MODE according to what you're running.
# Acceptable values: inn, highwind.
# If you are running a highwind-like server then the value set here is ignored
# and the default from highwind.pl is used.

$MODE ||= 'inn';

##############################################################################
# WARNING: NO USER SERVICEABLE PARTS BELOW THIS LINE
# IF YOU WANT TO CHANGE SOMETHING, PLEASE USE cleanfeed.local
##############################################################################

# default configuration
sub get_config {
    %config = (
    verbose => 1,           # verbose rejection reasons in news.notice/logfile?
    aggressive => 1,            # set to 0 if your lawyers are paranoid
    maxgroups => 14,            # maximum number of groups in a crosspost
    block_binaries => 1,        # block misplaced binaries
    block_all_binaries => 1,    # Reject all binary regardless of distribution
    block_late_cancels => 0,    # block cancels of rejected articles
    block_user_spamcancels => 1,# reject spam cancels
    block_user_cancels => 0,    # accept only spam cancels
    block_extra_reposts => 1,   # block reposts for articles not cancelled

    do_md5 => 1,                # do the md5 checks?
    do_phl => 1,                # do the posting-host/lines EMP check?
    do_phn => 1,                # do the posting-host/newsgroups EMP check?
    do_phr => 1,                # do posting-host (high risk groups) check?
    do_fsl => 1,                # do the from/subject/lines EMP check?
    do_scoring_filter => 1,     # use the scoring filter?
    do_ratio_scoring => 0,      # Score articles based on Caps/Sym/URL ratios?
    bad_url_score => 5,         # What score to apply to bad_url hits

    do_emp_dump => 1,           # dump EMP histories to a file for persistence?
    emp_dump_file => '',        # file to dump EMP histories to

    MD5RateCutoff => 5,         # reject if this many copies are in the history
    MD5RateCeiling => 85,       # only count this high
    MD5RateBaseInterval => 7200,# How long to wait before decrementing the count
    PHLRateCutoff => 20,
    PHLRateCeiling => 80,
    PHLRateBaseInterval => 3600,
    PHNRateCutoff => 150,
    PHNRateCeiling => 200,
    PHNRateBaseInterval => 1800,
    PHRRateCutoff => 10,
    PHRRateCeiling => 80,
    PHRRateBaseInterval => 3600,
    FSLRateCutoff => 20,
    FSLRateCeiling => 40,
    FSLRateBaseInterval => 1800,

    fuzzy_md5 => 1,             # screw around with the body before md5ing?
    fuzzy_max_length => 700,    # don't screw with bodies over this many lines
    md5_max_length => 2000,     # don't md5 articles over this many lines
    trim_interval => 900,       # trim hashes every N seconds
    stats_interval => 3600,     # write status file every N seconds
    MIDmaxlife => 4,            # time to keep rejected message-ids, in hours
    md5_skips_followups => 1,   # avoid MD5 check on articles with References?
    phn_aggressive => 1,        # use path for phn filter when no posting host
    phr_aggressive => 1,        # use path for phr filter when no posting host
    do_mid_filter => 1,         # use the message-id CHECK filter? (INN only)
    do_supersedes_filter => 1,  # do the excessive supersedes filter?
    drop_useless_controls => 1, # drop sendsys, senduuname, version control msg
    drop_ihave_sendme => 1,     # drop ihave, sendme control messages
    bad_rate_reload => 10000,   # Reload bad_* files after this many articles

    low_xpost_maxgroups => 6,   # max xposts in low_xpost_groups
    meow_ext_maxgroups => 2,    # max xposts from meow_groups to other groups
    off_topic1_maxgroups => 2,  # How many off topic groups allowed in a distro
    on_topic1_maxgroups => 5,   # How many on-topic groups allowed in a distro
    on_topic1_mingroups => 2,   # How many on-topic groups req'd to trigger
                                # off-topic filter
    off_topic2_maxgroups => 2,
    on_topic2_maxgroups => 5,
    on_topic2_mingroups => 2,

    binaries_in_mod_groups => 0,    # allow binaries in moderated groups?
    max_base64_lines => 150,    # Allow x lines Base64 encoding in non-bin grps

    block_mime_html => 1,       # block MIME encapsulated HTML
    block_html_multipart => 1,  # block all multipart with html sections
    block_html => 1,            # block native HTML (Content-Type text/html)
    block_html_images => 1,     # block <img src> in non text/plain messages

    active_file => '',  # active file to determine which groups are moderated

    # Logging and pid_file don't work for INN (uses news.notice)
    log_directory => '',
    log_name => '',
    log_accepts => 0,               # include accepted articles in the log?
    max_log_size => 0,
    rotate_file => '',              # rotate log if this file exists
    keep_old_logs => 7,             # how many old logfiles to keep

    pid_file => '',

    # crude stats on what the filter is doing
    statfile => '',
    html_statfile => '',
    inn_syslog_status => 0,         # status to syslog (late-model INN only)

    timer_info => 1,                # timing information (arts/second) in status report?

    debug_batch_directory => '',    # directory for debugging batches
    debug_batch_size => 0,          # max size of batch files before rotation

    ### binaries allowed if groups match
    bin_allowed => '^bin[a.]|\.bin[aei.]|\.bin$|^fur\.artwork'.
        '|^alt\.anonymous\.messages$|^de\.alt\.dateien|^rec\.games\.bolo$'.
        '|^comp\.security\.pgp\.test$|^sfnet\.tiedostot'.
        '|^fido\.|^unidata\.|alt\.security\.keydist'.
        '|^linux\.debian\.bugs\.dist$|^lucky\.freebsd',

    # Groups matching this regex will accept binary UUenc and yEnc files
    # where filename extensions match 'image_extensions'.
    image_allowed => '\.pictures',

    # Extensions on image files that are allowed in 'image_allowed' groups.
    # These are not case sensitive.
    image_extensions => 'jpe?g|png|gif|icon?',

    ### no binaries allowed even if bin_allowed matches
    bad_bin => '\.d$|^alt\.chello',

    ### md5 EMP check not done if groups match
    md5exclude => '^perl\.cpan\.testers',

    ### reject all articles crossposted to groups matching this
    poison_groups => '^alt\.(?:binaires|bainaries)|sexzilla|^newsmon$'.
        '|h[i\d]pcl[o\d]ne|h\.i\.p\.c\.r\.i\.m\.e'.
        ($] >= 5.005 ? '|(?<!free\.)h[i\d]pcr[i\d]m[e\d]'
                    : '|^alt\.hipcrime|^us\.hipcrime|^hipcrime|h\dpcr\dme'),

    ### no checks done if groups match
    allexclude => '^mailing\.|^linux\.',

    ### Exclude matching Newsgroups from the scoring filters
    score_exclude => 'alt\.anonymous\.messages',

    ### MIME HTML allowed here (if block_mime_html is True)
    mime_html_allowed => '^pgsql\.|^relcom\.|^gmane\.',

    ### HTML allowed here (if block_html is True)
    html_allowed => "^relcom\.|^microsoft\.",

    test_groups => '\.test(ing)?(?:$|\.)|^es\.pruebas|^borland\.public\.test2'.
        '|^cern\.testnews',

    ### groups where we restrict crossposts even more than normal
    low_xpost_groups => 'test|jobs|forsale',

    ### Groups where we restrict crossposts with other groups as a result of
    ### the meow wars.  (<4curm4$r1@decaxp.harvard.edu>)
    meow_groups => '^alt\.fan\.karl-malden\.nose|^alt\.flame|^alt\.troll'.
        '|^alt\.alien\.vampire\.flonk\.flonk\.flonk|^alt\.romath'.
        '|^alt\.snuh|^alt\.fan\.natasha',

    ### Topic groups allow administrators to limit crossposting from defined
    ### groups to undefined groups.  The allowed number of groups is defined
    ### in off_topic_maxgroups.
    ### Examples: '\.politi[ck]', '\.pets', '\.sex'
    topic1_groups => '',
    topic2_groups => '',

    ### cancel in these groups are not honored
    no_cancel_groups => '^alt\.religion\.scientology|^news\.admin\.net-abuse|^alt\.config$',

    ### domains starting/ending in "xxx" are never good news
    ### (checked against .com, .net, and .nu tld's only)
# FIXME currently disabled
#   baddomainpat => '[\w\-]+xxx|xxx[\w\-]+',

    ### Exclude these Newsgroups from the From / Subject / Lines filter
    fsl_exclude => 'comp\.lang\.ruby',

    ### Exclude these Newsgroups from the Posting-Host / Lines filter
    phl_exclude => 'comp\.lang\.ruby|^microsoft\.|^alt\.bestjobsusa'.
        '|\.bbs\.|^relcom\.hot-news|^szn\.news\.',

    ### Exclude these Newsgroups from the Posting-Host / Newsgroup filter
    phn_exclude => '^local\.|^alt\.anonymous\.messages'.
        '|^\w+\.bin|^microsoft\.|\.bbs\.|^alt\.bestjobsusa|^mozilla\.'.
        '|^gnus?\.|^alt\.pictures\.|^gmane\.|^fa\.|^stu\.|^corel\.|\.cvs\.'.
        '|\.talk|^lists\.|^microsoft\.|news\.lists\.filters|^perl\.'.
        '|\.marketplace|\.ebay|\.forsale|^relcom\.hot-news|^szn\.news\.'.
        '|^comp\.lang\.python',

    # These hosts create unlinkable Posting-Host headers, rendering them
    # useless for hashing purposes.  In these instances the NPH and PHR filter
    # will use the Path header instead, (if phn_aggressive is true).  The PHL
    # filter will ignore posts from these hosts.
    bad_nph_hosts => 'newsguy\.com|tornevall\.net',
    
    ### Exempt these hosts from the Posting-Host / Lines filter
    phl_exempt => '^localhost$|webtv\.net$|^newscene\.newscene\.com$'.
        '|^freebsd\.csie\.nctu\.edu\.tw$|^ddt\.demos\.su$|^onlyNews customer$'.
        '|localhost\.pld-linux\.org',

    ### Exempt these hosts from the Posting-Host / Newsgroup filter
    phn_exempt => '^localhost$|^127\.0\.0\.1$|localhost\.pld-linux\.org',

    ### Exempt these hosts from the High-Risk Newsgroups filter
    phr_exempt => '^localhost$|^127\.0\.0\.1$',

    ### Exclude these groups from the ratio based scoring filters. (Only used
    ### if do_ratio_scoring is true).
    ratio_exclude => '^cn\.|^tw\.|^japan\.|^fj\.|\.china',

    ### Newsgroups that get frequently flooded.  This defines the groups
    ### processed by the PHR filter.  It should be entirely user-defined.
    flood_groups => '',

    ### posting hosts exempt from excessive supersedes filter
    supersedes_exempt => '^localhost$|^penguin-lust\.mit\.edu$',

    ### refuse articles with these in the message-id (INN only)
    refuse_messageids => 'HeadHunter\.NET>|none\d+\.yet>',

    ### groups expected to contain bodies and/or subject lines from spam
    spam_report_groups => '^(?:news|de)\.admin\.net-abuse'.
        '|news\.lists\.filters|\.nocem|\.spamtrap$|\.spam\.sightings'.
        '|^fr\.usenet\.abus\.rapports|^nl\.internet\.misbruik\.rapport$',

    adult_groups => 'personals|sex|nud[ei]|erot|xxx|lolita'.
    '|neojapan|bondage|fetish|lesbian|porn|tasteless|voyeur|^it\.sesso'.
    '|^alt\.(?:mag[\.a]|redh|stories'.
     '|fan\.(?:air|asp|pret|televisionx|pst|snuf))'.
    '|^alt\.binaries\.(?:aimee|adole|ass\b|great|images\.(?:sun|under)|full'.
     '|linger|pent|pin-?up|nospam|scanm|pictures\.(?:aspa|bc|blon|blueb|bru'.
      '|centerf|coc|girlfr|horny|hussy|strip)|multimedia\.(?:boy|natur))',

    not_adult_groups => 'sexual\.abuse|^soc.sex|^fr\.soc\.homosexualite'.
        '|^alt\.(?:support|teens|answers)',

    faq_groups => '\.faqs?$|\.answers$|^news\.announce\.newgroups$'.
        '|^news\.admin\.hierarchies$',

    local_approved_groups => 'alt\.|news\.admin\.net-abuse\.'.
    '|fr\.misc\.bavardages\.dinosaures|alt\.sysadmin\.recovery'.
    '|alt\.tech-support\.recovery|alt\.dev\.null'

    );

    # Store the Cleanfeed development revision number
    #($version) = q$Revision$ =~ /(\d+)/;
    #($version_date) = q$Date$ =~ /(\d{4}(\-\d{2}){2})/;

    ### List of group patterns that don't allow outside crossposts.
    ### Key is "friendly" name, value is the pattern.
    %Restricted_Groups = (
        cl      => '^cl\.',
        net     => '^net\.',
        bofh    => '^bofh\.',
        'de.alt.dateien' => '^de\.alt\.dateien',
        sdnet   => '^sdnet\.',  # Requested by William Kronert
    );

    # Load up the external config file
    my $local_file = "$config_dir/cleanfeed.local";
    $Local_Conf_Err = 0;
    if ($config_dir and -e $local_file) {
        undef %config_local;
        undef %config_append;
        if (open(CF, $local_file)) {
            my $cf = join('', <CF>);
            close CF;
            eval $cf;
            if ($@) {
                slog('E', "Cannot load $local_file: $@");
                $Local_Conf_Err = 1;
            } else {
                local_config() if defined &local_config;
            }
        } else {
            slog('E', "Cannot open $local_file: $!");
            $Local_Conf_Err = 1;
        }

        # config_local overrides the config settings
        if (%config_local) {
            $config{$_} = $config_local{$_} foreach keys %config_local;
            undef %config_local;
        }
        # config_append adds to the config regexps
        if (%config_append) {
            foreach (qw(bin_allowed bad_bin md5exclude poison_groups
                    allexclude html_allowed mime_html_allowed low_xpost_groups
                    test_groups no_cancel_groups baddomainpat fsl_exclude
                    phl_exempt phl_exclude supersedes_exempt bad_nph_hosts
                    phn_exempt phr_exempt phn_exclude flood_groups
                    refuse_messageids net_abuse_groups spam_report_groups
                    adult_groups not_adult_groups faq_groups ratio_exclude 
                    image_allowed image_extensions meow_groups
                    topic1_groups topic2_groups local_approved_groups)) {
                if (defined $config_append{$_}) {
                    $config{$_} .= "|$config_append{$_}";
                    $config{$_} =~ s/\|\|/\|/g;
                }
                $config{$_} =~ s/^\|//;
                $config{$_} =~ s/\|$//;
            }
            undef %config_append;
        }
    }

    @Restricted_List = keys %Restricted_Groups;

    # Create the logfile path. Will be undefined if logging is broken
    if ($config{log_directory} and $config{log_name}) {
        $Log_File = "$config{log_directory}/$config{log_name}";
    } else {
        undef $Log_File;
    }

    # parse the active file if we've been given one.
    if ($config{active_file}) {
        %Moderated = ();
        if (open(ACTIVE, $config{active_file})) {
            while (<ACTIVE>) {
                chomp;
                my ($group, undef, undef, $flag) = split(/ /);
                $Moderated{$group} = 1 if $flag eq 'm';
            }
            close ACTIVE;
        } else {
            slog('E', "Cannot open $config{active_file}: $!");
        }
    }

    # Try and load base64 decoding functionality.
    eval "use MIME::Base64; 1" or $config{nobase64} = 1;

} # end of get_config()

# Regexps for matching URLs
$TLDs = '(?:[Cc][Oo][Mm]|[Nn][Ee][Tt]|[Oo][Rr][Gg]|[Ee][Dd][Uu]' .
    '|[Cc][Oo]\.[Uu][Kk]|[Ff][Rr]' .
    '|[Cc][Oo][Mm]\.[Aa][Uu]|[Nn][Ll]|[Dd][Ee]|[Nn][Oo]|[Dd][Kk]|[Cc][Hh]' .
    '|[Ss][Ee]|[Nn][Uu]|[Tt][Oo]|[Rr][Uu]|[Uu][Aa]|[Cc][Aa]|[Cc][Xx])';
#$IP = '\d\d\d?\.\d\d?\d?\.\d\d?\d?\.\d\d?\d?\b';
$IP = '(?:\d{1,3}\.){3}\d{1,3}\b';
$StealthIP = '(?:\d{10}|0[0-7]+\.0[0-7]+\.0[0-7]+\.0[0-7]+)';
# Make $WebHost only match if there's nothing before it (requires 5.005).
$WebHost = ($] >= 5.005 ? '(?<![\w.])' : '' ) .
    '(?:[Ww][Ww][Ww]\d?|[Ww][Ee][Bb]\d?|[Mm][Ee][Mm][Bb][Ee][Rr][Ss]' .
    '|[Uu][Ss][Ee][Rr][Ss]?|[Hh][Oo][Mm][Ee])';
$HTTP = '(?:www\.|https?:\/\/)';
$HOST = '[\w\-.]+'; # characters for the hostname
$PORT = '(?::\d+)?'; # always optional
$Hostname = '^(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]+[a-zA-Z0-9])'.
            '(\.([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]+[a-zA-Z0-9]))+)';

$url = $HTTP.$HOST.'|'.$WebHost . $HOST .'\.'. "$TLDs|$HTTP(?:$IP|$StealthIP)";
# requires the http:// part but accepts any hostname or tld, or IP-based url.
$url2 = "$HTTP(?:$HOST|$IP|$StealthIP)";
# http:// is optional if $WebHost matches, any tld accepted.
$url3 = "(?:$HTTP|$WebHost)$HOST";
$stealthURL = "$HTTP(?:$IP|$StealthIP)";
$simpleURL = $HTTP . $HOST . $PORT . '(?:\/[^\s<>]+)?';
# match the whole URL including path (used by body_urls() )
$fullURL = $HTTP . $HOST . $PORT . '(?:\/[^\s<>]+)?'.
    "|(?:$WebHost\.$HOST\.$TLDs)$PORT" . '(?:\/[^\s<>]+)?';
$spacecom = 'www[^a-z\.]+[a-zA-Z0-9\-]+[^a-z\.]+com';
# URL redirection services (Commonly used to obfuscate spam links).
#$shorturl = 'tinyurl\.com|useurl\.us|linkurl\.r8\.org|urlbrief\.com'.
#            '|sites\.google\.com/site/|groups\.google\.com/group/'.
#            '|6x\.to|liteurl\.com|xurl\.jp|c4\.to|da\.ru|beam\.to|doiop\.com'.
#            '|kickme\.to|end\.at|has\.it|hotshorturl\.com';

# for the scoring filter
$sex = 'sex|xxx|fuck';
$free = 'free(?!dom|bsd|ppp|xp)';
$pics = 'pi(?:c|x)';
$drugs = 'ativan|carisoprodol|caverta|\bcialis|diazepam|kamagra|levitra|nizoral'.
         'sildenafil|tadalafil|valium|viagra|vicodin|xanax';
# US Phone 800-123-1234  UK Phone 09096-400141
$phone = '\b[89]\d{2}[\.\s\-_*\)]*\d{2,3}[\.\s\-_*]*\d{4}\b'.
         '|[\s\-_*0][89]\d{2,3}[\s\-_*]+\d{6}';
$desc1 = "hard.?core|teen|asian|extreme|live|outrageous|nasty|awesome|$free|adult";
# ASCII Symbols, excluding space/tab.
$SYMBOL = '[\x21-\x2F\x3A-\x40\x5B-\x60\x7B-\x7E]';
$hws = '(?:[\t ])'; # Horizontal whitespace. (From Perl 5.10, this can be \h.)
$messageid_re = messageid_re();

# Re-enable the following when we fix the false positives in the scoring section.
#$site_desc = "$desc1|password";
#$servPre = "(?:$free|cheap|unlimited|nationwide|$site_desc)";
#$servPost = '(?:$free|minute|samples|800|900|no.?charge)';
#$servStr = "(?:phone.{0,15}(?:$sex|fun)|(?:adult|r.?a.?p.?e|$sex).{0,10}(?:chat|site)".
#    "|(?:$sex).{0,15}(?:show|call|connection|vid(?:eo|s)|dvd)".
#    '|hard.?core.(?:vid(?:eo|s)|dvd|amateur)|900.dateline|(?:mass|bulk).e?-?mail)';
#$services = "(?:$servPre.{0,30}?$servStr)|(?:$servStr.{0,30}?$servPost)";

$free_stuff = "$free.{0,20}(?:password|membership|$pics|chat)".
    "|(?:100\%|total|complete|absolut|all).{0,15}$free".
    '|no.{0,6}(a(?:ge|dult).(?:verification|check)|avs)';

$sex_adjs = "$desc1|$sex|erotic|gay|amateur|lesbian|blow.?job|fetish".
    '|pre.?teen|nude|celeb|school.?girl|bondage|rape|torture';
$porn = "(?:$sex_adjs).{0,25}(?:$pics|video|dvd|image|porn|photo|mpeg)";

$one_point_words = "pre.?teen|\bteen|\bsex|credit|amateur|horne?y".
    '|anal(?!yst)|oral|bondage|breast|vid(?:eo|s)|dvd|kink(?:y|ier)|mistress'.
    '|orgy|erotic|porn|fetish|whore|nympho|sucking|password|membership'.
    '|make.money|fast.cash|orgasm|incest|extreme\b|raunchy|panties|bang'.
    '|taboo|muff\b|(?:young|cute|school).?girl|nasty|torture'.
    'suduc(?:e|tress)|cuckold|wicked|unlimited|masterbat';
$two_point_words = "$drugs".
    '|fuck|sluts|puss(?:y|ies)|\bcum|(?:hidden|live|free|dorm|spy).?cam'.
    '|le[sz]b(?:ian|o)|\btits?\b|dick(?!.?berg)|blow.?job|cock|clit'.
    '|twat|cunt|hard-?core|[^x]xxx|facial|gangbang|strap.on|submissive'.
    '|(?:live|real|innocent).girl|phone.{0,5}(?:sex|fun|play)|she.?male'.
    '|lolita|dildo|whore|fingering|barely.?(?:18|legal)|[gm]ilf|no.?limit'.
    '|uncensored|age.?play|pedo\b|pedophile';

# assorted spamware names found in X-Newreader/X-Mailer/etc headers
$Xbot = '^2\.\d\.(?:\d\d? [a-z]|\d\d?)$|newsgroup bulk mailer'
    . '|calvacade *98|atomicpost|uncle *spam'
    . '|metanews \d|metapost|ng post|girlsdeluxe|usenet replayer'
    . '|express news poster|^superpost auto marketer';

##############################################################################

get_config();
setup_stuff();

# is this a reload?
if (defined $Start_Time) {
    writestats(1) if $MODE eq 'inn';        # write the stats file
} else {
    restore_emp() if $config{do_emp_dump};  # load the saved state
    $Start_Time = time;
}

$Last_Trim = time unless defined $Last_Trim;
$Last_Stats = time unless defined $Last_Stats;
$Do_Log = 0;

##############################################################################
# end of the initialization code
##############################################################################

# Set things up after we've got our configuration.
sub setup_stuff {
    # Try to load up MD5 module (use Digest::MD5, but old MD5 still works).
    if ($config{do_md5}) {
        eval { require Digest::MD5; import Digest::MD5 qw(md5_hex); };
        if ($@) {
            undef $config{do_md5};
            slog('E', 'Cannot load MD5: ' . $@);
        }
    } else {
        undef $config{do_md5};
    }

    # Try to load up Data::Dumper if we want to save the EMP histories.
    if ($config{do_emp_dump}) {
        eval { require Data::Dumper; };
        if ($@) {
            undef $config{do_emp_dump};
            slog('E', 'Cannot load Data::Dumper: ' . $@);
        }
    }

    # Load up IO::File if we want logging.
    if ($Log_File) {
        eval { require IO::File; };
        if ($@) {
            undef $Log_File;
            slog('E', 'Cannot load IO::File: ' . $@);
        }
    }

    # Read all the bad_* files
    read_hashes();

    #Initialise status counters
    %status = ();
    $status{accepted} = 0;
    $status{rejected} = 0;
    $status{refused} = 0;
    $status{do_mid_filter} = 0;

    # initialise the rate filters
    if ($config{do_md5}) {
        $MD5history = new Cleanfeed::RateLimit;
        $MD5history->init($config{MD5RateCutoff}, $config{MD5RateCeiling},
            $config{MD5RateBaseInterval});
    } else {
        undef $MD5history;
    }
    if ($config{do_phl}) {
        $PHLhistory = new Cleanfeed::RateLimit;
        $PHLhistory->init($config{PHLRateCutoff}, $config{PHLRateCeiling},
            $config{PHLRateBaseInterval});
    } else {
        undef $PHLhistory;
    }
    if ($config{do_phn}) {
        $PHNhistory = new Cleanfeed::RateLimit;
        $PHNhistory->init($config{PHNRateCutoff}, $config{PHNRateCeiling},
            $config{PHNRateBaseInterval});
    } else {
        undef $PHNhistory;
    }
    if ($config{do_phr}) {
        $PHRhistory = new Cleanfeed::RateLimit;
        $PHRhistory->init($config{PHRRateCutoff}, $config{PHRRateCeiling},
            $config{PHRRateBaseInterval});
    } else {
        undef $PHRhistory;
    }
    if ($config{do_fsl}) {
        $FSLhistory = new Cleanfeed::RateLimit;
        $FSLhistory->init($config{FSLRateCutoff}, $config{FSLRateCeiling},
            $config{FSLRateBaseInterval});
    } else {
        undef $FSLhistory;
    }
    if ($config{do_supersedes_filter}) {
        $Suphistory = new Cleanfeed::RateLimit;
        $Suphistory->init(0, 50, 900);
    }

    $MIDhistory = new Cleanfeed::Queue;
    $MIDhistory->maxlife($config{MIDmaxlife} * 3600) if $config{MIDmaxlife};

    $timer{time} = time if $config{timer_info} and not $timer{time};
}

sub filter_art {
    $now = time;
    undef $body;
    undef $score;           # String representation of article score
    %state = ();            # Initialize our state hash
    ##### State Keys #####
    # body_has_url;     Bool:   True if body contains a URL
    # file_extension;   Str:    File extension on yEnc or UUencoded binaries
    # cache_is_binary;  Flag:   True if content is Binary
    # localfeed;        Flag:   True if article source is local
    # spamsource;       Flag:   True if article origin is spam friendly
    # xreader;          Str:    Newsreader application, if specified
    # scoreval;         Int:    Numeric representation of article score
    # urlcount;         Int:    Number of URL's in an article
    # charset;          Str:    Article charset (if defined in Content-Type)
    # posting_host:     Str:    Posting host/address
    # injection_host    Str:    Injection host
    # grpcnt:           Int:    Count of groups in Newsgroups header
    # fupcnt            Int:    Count of groups in Followup-To header
    # grpfupcnt:        Int:    Count of combined grpcnt and fupcnt (Unique)
    # lines             Int:    Number of lines reported by inn
    # letters           Int:    Number of letters in the post [a-zA-Z]
    # uppercase         Int:    Number of uppercase letters in the post [A-Z]
    # symbols           Int:    Number of symbols [!"#$%&'()*+,-:;=?@{|}~]

    $status{articles}++;
    $timer{articles}++ if $config{timer_info};

    # count the lines in the article - late-model INN does this for us.
    if (defined $hdr{__LINES__}) {
        $state{lines} = $hdr{__LINES__};
    } else {
        $state{lines} = ($hdr{__BODY__} =~ tr/\n//);
    };
    $lines = $state{lines}; # TODO Remove after grace period.
    #$lines if 0;

    # Study the message BODY.  This used to be in the local config file but
    # this seems more logical.
    # TODO: Make the number of lines configurable.
    if (not $config{nobase64}
    and $hdr{'Content-Transfer-Encoding'} =~ /^base64$/i
    and $hdr{'Content-Type'} =~ /^text/i) {
        $body = lc substr(MIME::Base64::decode($hdr{__BODY__}), 0, 4000);
    } else {
        $body = lc substr($hdr{__BODY__}, 0, 4000);
        study $hdr{__BODY__} if $state{lines} <= 250;
    };

    # Reload the bad_* files every $bad_rate_reload articles accepted
    if ($status{accepted} > 0 and $config{bad_rate_reload} > 0
        and $status{accepted} % $config{bad_rate_reload} == 0
        and $status{accepted} > $status{bad_reloaded}) {
        slog('N', "Reloading bad files after $status{accepted} articles");
        read_hashes();
        # Prevent looping whilst waiting for another accepted article
        $status{bad_reloaded} = $status{accepted};
    };

    # Try and ascertain the source news service.
    if ($hdr{'Injection-Info'} =~ /^$hws*($Hostname)[ \t;]/) {
        $state{injection_host} = "$1"
    } elsif ($hdr{'X-Trace'} =~ /^$hws*($Hostname)$hws/) {
        $state{injection_host} = "$1"
    } else {
        $state{injection_host} = first_path_host($hdr{Path});
    };

    # Try and ascertain the Posting-Host info
    if ($hdr{'Injection-Info'} =~ /posting-host$hws*=$hws*"?([^";]+)/) {
        $state{posting_host} = "$1";
    } elsif ($hdr{'NNTP-Posting-Host'}) {
        $state{posting_host} = $hdr{'NNTP-Posting-Host'};
    } else {
        $state{posting_host} = 0;
    };

    # Provide a user-defined function for tagging posts that are fed from
    # sources the operator considers local.  Note: This includes, but is
    # not limited to articles received via nnrpd.
    if (defined &local_flag_localfeed) {
        $state{localfeed} = local_flag_localfeed();
    };

    # Provide a user-defined function for tagging posts that are fed from
    # sources the operator considers spam friendly.  These could easily be
    # hardcoded but doing so might get me kneecapped.
    if (defined &local_flag_spamsource) {
        $state{spamsource} = local_flag_spamsource();
    };

    # break out newsgroups into an array
    @groups = sort(split(/[,\s]+/, $hdr{Newsgroups}));
    if ($hdr{'Followup-To'}) {
        @followups = split(/[,\s]+/, $hdr{'Followup-To'});
    } else {
        @followups = @groups;
    };

    # Produce a Newsgroups string sorted alphanumerically.  This is
    # useful for filters on Newsgroups where spammers manipulate the
    # distribution in order to generate non-colliding hashes.
    my $sortgrps = join(',', @groups);

    # Create a merged array of groups and followups with no duplicates.
    # This is useful in instances where we consider follow-up groups to be
    # part of the distribution.
    my %merge = ();
    my @grpfup = grep { ! $merge{ $_ }++ } (@groups, @followups);

    # Count the number of groups in the distribution
    $state{grpcnt} = scalar @groups;
    $state{fupcnt} = scalar @followups;
    $state{grpfupcnt} = scalar @grpfup;

    trimhashes() if $now - $Last_Trim >= $config{trim_interval};
    writestats() if $now - $Last_Stats >= $config{stats_interval};

    # Check out the Newsgroups to which the article is posted
    %gr = ();
    for (@groups) {
        foreach my $item (@Restricted_List) {
            $gr{'rg_'.$item}++ if /$Restricted_Groups{$item}/;
        }
        $gr{binary}++ if $config{bin_allowed} and /$config{bin_allowed}/o;
        $gr{image}++ if $config{image_allowed} and /$config{image_allowed}/o;
        $gr{bad_bin}++ if $config{bad_bin} and /$config{bad_bin}/o;
        $gr{html}++ if $config{html_allowed} and /$config{html_allowed}/o;
        $gr{mime_html}++ if $config{mime_html_allowed}
            and /$config{mime_html_allowed}/o;
        $gr{poison}++ if $config{poison_groups}
            and /$config{poison_groups}/o;
        $gr{reports}++ if $config{spam_report_groups}
            and /$config{spam_report_groups}/o;
        $gr{no_cancel}++ if $config{no_cancel_groups}
            and /$config{no_cancel_groups}/o;
        $gr{test}++ if /$config{test_groups}/o;
        $gr{adult}++ if /$config{adult_groups}/o
            and not /$config{not_adult_groups}/o;
        $gr{faq}++ if /$config{faq_groups}/o;
        $gr{ratio}++ if /$config{ratio_exclude}/o;
        $gr{approved}++ if /$config{local_approved_groups}/o;
        if ($config{active_file}) {
            $gr{mod}++ if $Moderated{$_};
        } elsif (defined &INN::newsgroup) {
            $gr{mod}++ if INN::newsgroup($_) eq 'm';
        };

    };

    # As above but check Newsgroups and Followup-To headers
    for (@grpfup) {
        $gr{skip}++ if $config{allexclude} and /$config{allexclude}/o;
        $gr{fslskip}++ if $config{fslexclude} and /$config{fslexclude}/o;
        $gr{md5skip}++ if $config{md5exclude} and /$config{md5exclude}/o;
        $gr{phnskip}++ if $config{phn_exclude} and /$config{phn_exclude}/o;
        $gr{phlskip}++ if $config{phl_exclude} and /$config{phl_exclude}/o;
        $gr{scoreskip}++ if $config{score_exclude}
            and /$config{score_exclude}/o;
        $gr{phrinc}++ if $config{flood_groups} and /$config{flood_groups}/o;
        $gr{low_xpost}++ if $config{low_xpost_groups}
            and /$config{low_xpost_groups}/o;
        $gr{meow}++ if $config{meow_groups}
            and /$config{meow_groups}/o;
        $gr{topic1}++ if $config{topic1_groups}
            and /$config{topic1_groups}/o;
        $gr{topic2}++ if $config{topic2_groups}
            and /$config{topic2_groups}/o;
        $gr{localhier}++ if /^local\./;
    };

    # These only count if all Newsgroups match
    $gr{image} = (($gr{image} + $gr{binary}) >= $state{grpcnt});
    $gr{binary} = ($gr{binary} == $state{grpcnt});
    $gr{reports} = ($gr{reports} == $state{grpcnt});
    $gr{binary} = 0 if $gr{bad_bin};
    $gr{html} = ($gr{html} == $state{grpcnt});
    $gr{mime_html} = ($gr{mime_html} == $state{grpcnt});
    $gr{allmod} = ($gr{mod} == $state{grpcnt});
    $gr{alltest} = ($gr{test} == $state{grpcnt});
    $gr{alladult} = ($gr{adult} == $state{grpcnt});
    $gr{ratio} = ($gr{ratio} == $state{grpcnt});
    $gr{approved} = ($gr{approved} == $state{grpcnt});

    # Same as above but include Followup_To in addition to Newsgroups
    $gr{skip} = ($gr{skip} == $state{grpfupcnt});
    $gr{fslskip} = ($gr{fslskip} == $state{grpfupcnt});
    $gr{md5skip} = ($gr{md5skip} == $state{grpfupcnt});
    $gr{phnskip} = ($gr{phnskip} == $state{grpfupcnt});
    $gr{phlskip} = ($gr{phlskip} == $state{grpfupcnt});
    $gr{scoreskip} = ($gr{scoreskip} == $state{grpfupcnt});
    $gr{alllocal} = ($gr{localhier} == $state{grpfupcnt});

    # If all newsgroups are excluded from filtering, bail now
    return '' if $gr{skip};

    foreach (@Restricted_List) {
        $gr{'rg_'.$_.'_only'} = ($gr{'rg_'.$_} == $state{grpcnt});
    }

    if ($hdr{'Content-Type'} =~ /charset="?([^";\s]+)/io) {
        $state{charset} = lc($1);
    };

    # checks common to all article types #####################################
    return reject("Bad host ($state{posting_host})", 'Bad site')
        if exists $Bad_Hosts{$state{posting_host}}
        or exists $Bad_Hosts_Central{$state{posting_host}};

    @Path_Entries = split(/!/, $hdr{Path});
    foreach (@Path_Entries) {
        return reject("Bad path ($_)", 'Bad site') if exists $Bad_Path{$_};
    }

    # check for the most simple newsagent variations
    if ($hdr{'Message-ID'} =~
            /^<
                (?:cancel\.)*
                [0-9A-F]{8,15}\.[a-z]{4,11}
                \@[a-z]{4,11}\.(?:net|mil|gov|org|edu|com)
            >$/x) {
        if ($hdr{'X-Cancelled-By'}) {
            return reject('Cancel for rejected article');
        } else {
            return reject('NewsAgent', 'Bot signature');
        }
    }

    # This check should only trap articles in inn < 2.6. From that time,
    # Message-ID validation to RFC5536 is integrated.
    if ($hdr{'Message-ID'} !~ $messageid_re) {
        return reject('Bad Message-ID', 'Invalid Header');
    };

    return reject('NewsAgent (Path)')
        if $hdr{Path} =~ /\.(?:posted|mismatch)$/;

    # regular articles #######################################################
    if (not $hdr{Control}) {
        # Good Usenet lines are terminated with CRLF
        $state{badlines} = 0;
        $state{badlines}++ while $hdr{__BODY__} =~ /[^\r]\n/g;
        # lowercase some headers for later
        undef %lch;
        $lch{from}          = lc $hdr{From}
            || return reject('Malformed article');
        $lch{subject}       = lc $hdr{Subject}
            || return reject('Malformed article');
        $lch{'message-id'}  = lc $hdr{'Message-ID'}
            || return reject('Malformed article');
        $lch{sender}        = lc $hdr{Sender} || '';
        $lch{organization}  = lc $hdr{Organization} || '';
        $lch{'content-type'}= lc $hdr{'Content-Type'} || '';

        if (defined &local_filter_first) {
            my @result = local_filter_first();
            return reject(@result) if $result[0];
        }

        # first thing, handle reposts ########################################
        if ($config{block_extra_reposts} and $hdr{Subject} =~ /^REPOST: /
                and $hdr{Path} =~ /!resurrector!/) {
            my ($canid, $canpath);

            $canid = $1 if $hdr{__BODY__} =~
                /\n========= WAS CANCELLED BY =======:.*\nMessage-ID: (.*?)\n/s;
            return reject('Redundant REPOST (cache)')
                if $canid and $MIDhistory->check($canid);
            return reject('Redundant REPOST (ID)')
                if $canid =~ /^<(?:[a-z]{16,17}|[0-9]{10}|[0-9]{10})\@/
                    or $canid =~ /^<(?:cancel\.)*[0-9A-F]{8,15}\.[a-z]{4,11}\@[a-z]{4,11}\.(?:net|mil|gov|org|edu|com)>$/;
        }

        # basic checks on headers ############################################
        if ($gr{adult}) {
            foreach (@Path_Entries) {
                return reject("Bad path ($_)", 'Bad site')
                    if exists $Bad_Adult_Path{$_};
            }
        }
        # If an article is fed locally and contains an Approved header, reject
        # it unless all groups match config{local_approved_groups}.
        if ($state{localfeed} and $hdr{Approved}) {
            return reject("Forged approval: $hdr{Approved}",
                          'Forged Approval')
                unless $gr{approved};
        };

        # Do any elements of the Path appear more than once.
        # TODO Wow, this filter catches a lot.  Too much!  Need to make it a
        #      scoring element rather than a reject.
        #%seen = {};
        #@Path_Entries2 = grep {!$seen{$_}++ } @Path_Entries;
        #return reject('Duplicated Path entry', 'Bad Path')
        #    if (scalar @Path_Entries) != (scalar @Path_Entries2);

        return reject('U2 violation - invalid distribution', 'U2 violation')
            if $gr{rg_net} and $hdr{Distribution} !~ /^[ \t]*4[Gg][Hh][ \t]*$/;

        return reject('U2 violation - excessive crossposting', 'U2 violation')
            if $gr{rg_net} and $state{fupcnt} > 3;

        return reject('bofh violation - excessive crossposting','U2 violation')
            if $gr{rg_bofh} and $state{fupcnt} > 3;

        return reject('bofh violation - invalid distribution', 'U2 violation')
            if $gr{rg_bofh}
                and $hdr{Distribution} !~ /^[ \t]*[Bb][Oo][Ff][Hh][ \t]*$/;

        return reject('Too many newsgroups')
            if $state{fupcnt} > $config{maxgroups};

        return reject('Too many newsgroups (low_xpost)', 'Too many newsgroups')
            if $gr{low_xpost}
                and $state{fupcnt} > $config{low_xpost_maxgroups};

        return reject('Too many newsgroups (meow)', 'Too many newsgroups')
            if $gr{meow}
                #and $gr{meow} != scalar @groups
                and $config{meow_ext_maxgroups}
                and ($state{fupcnt} - $gr{meow}) > $config{meow_ext_maxgroups};

        return reject('Topic Filter (Off-Topic1)', 'Topic Filter')
            if $gr{topic1}
                and $gr{topic1} >= $config{on_topic1_mingroups}
                and $config{off_topic1_maxgroups}
                and $state{fupcnt} - $gr{topic1} > $config{off_topic1_maxgroups};

        return reject('Topic Filter (On-Topic1)', 'Topic Filter')
            if $gr{topic1} and $config{on_topic1_maxgroups}
                and $gr{topic1} > $config{on_topic1_maxgroups};

        return reject('Topic Filter (topic2)', 'Topic Filter')
            if $gr{topic2}
                and $gr{topic2} >= $config{on_topic2_mingroups}
                and $config{off_topic2_maxgroups}
                and $state{fupcnt} - $gr{topic2} > $config{off_topic2_maxgroups};

        return reject('Topic Filter (On-Topic2)', 'Topic Filter')
            if $gr{topic2} and $config{on_topic2_maxgroups}
                and $gr{topic2} > $config{on_topic2_maxgroups};

        return reject('Too many test groups in crosspost',
            'Too many newsgroups') if $gr{test} > 2;

        return reject('Excessively crossposted test article',
            'Too many newsgroups') if $gr{test} and $state{fupcnt} > 4;

        return reject('Adult group ECP', 'Too many newsgroups')
            if $state{fupcnt} > 6 and $gr{adult} > $state{grpcnt} / 2;

        return reject('Poison newsgroup') if $gr{poison} and $state{grpcnt} > 1;

        foreach (@Restricted_List) {
            return reject("hierarchy violation - crosspost outside $_")
                if $gr{'rg_'.$_} and not $gr{'rg_'.$_.'_only'};
        }

        # binaries and MIME checks ###########################################
# XXX this protects the binary filters, but should not be needed anymore
# with (?>...). If your server seems to hang try uncommenting this
        # killer article?
#       return '' if $lines > 8000 and length $hdr{__BODY__} < $lines * 4;

        # short uuencoded html, text, exe, url files
        return reject("UUencoded $1")
            if $state{lines} > 3 and $state{lines} < 2000
                and $hdr{__BODY__} =~ /
                    ^[Bb][Ee][Gg][Ii][Nn]$hws+[0-7]{3,4}$hws+ # begin 666
                    \S?.{0,45}?\S*          # file name
                    \.(                     # file extensions
                        [Tt][Ee]?[Xx][Tt]|
                        [Hh][Tt][Mm][Ll]?|
                        [Ee][Xx][Ee]|
                        [Uu][Rr][Ll]
                    )
                    $hws+                     # end of line
                    (?:
                        ^[ \t|>]*           # skip quoting marks, if any
                        (?>                 # disable backtracking
                        M[\x20-\x60]{60,61} # uuencoded line
                        )
                        $hws*\n               # trailing spaces and end of line
                    ){2,}?                  # 0 or > 2 lines
                /mx;

        # binaries in non-binary newsgroups
        if ($config{block_binaries} or $config{block_all_binaries}) {
            unless ($config{binaries_in_mod_groups} and $gr{allmod}) {
                # We're only interested in binaries
                if (is_binary()) {
                    # Is the binary an image?
                    if ($config{image_extensions}
                    and $state{file_extension} =~ /$config{image_extensions}/) {
                        return reject("Binary Image: misplaced $state{file_extension}")
                        if not $gr{image};
                        # gr{image} is true when distro matches bin_allowed
                        # or image_allowed
                        # gr{binary} is true when distro matches bin_allowed
                    } else {
                        if (not $gr{binary}) {
                            return reject("Binary: misplaced binary");
                    }; # End of misplaced binary check
                    # If configured to reject all binary, we do it last so
                    # misplaced stuff is still highlighted.
                    return reject("Binary Payload")
                    if $config{block_all_binaries};
                }; # End of is_binary
            }; # End of moderated groups
        }; # End of block binaries

        if ($config{block_mime_html} and not $gr{mime_html}) {
            # MIME encapsulated HTML (attached *.html file)
            return reject('HTML file attachment', 'HTML')
                if $lch{'content-type'} =~ /multipart/
                and ($hdr{__BODY__} =~ /^Content-Disposition:.*filename.*\.html?/imo
                or $hdr{__BODY__} =~ /^Content-Base:.*file:.*\.html?/imo);

            # Only one of the following two subsections can be applied,
            # depending on the state of config{block_html_multipart}.  If it's
            # True then all multipart mime with html elements will be
            # rejected.  If it's false, only multipart *without* text/plain
            # elements will be rejected.

            # MIME text/html without text/plain
            return reject('HTML Multipart without Text/Plain.', 'HTML')
                if not $config{block_html_multipart}
                and $lch{'content-type'} =~ /multipart/
                and $hdr{__BODY__} =~ m#^Content-Type:[\t ]+text/html#imo
                and not $hdr{__BODY__} =~ m#^Content-Type:[\t ]+text/plain#imo;

            # MIME HTML regardless of text/plain element
            return reject('HTML Multipart', 'HTML')
                if $config{block_html_multipart}
                and $lch{'content-type'} =~ /multipart/
                and $hdr{__BODY__} =~ m#^Content-Type:[\t ]+text/html#imo;
        };

        # HTML Inline
        if ($config{block_html} and not $gr{html}) {
            # HTML formatted postings
                return reject('HTML post', 'HTML')
                    if $lch{'content-type'} =~ m#text/html#;
        };

        # Some consider <img> tags as a greater evil than other HTML.
        if ($config{block_html_images}
        and $lch{'content-type'} !~ m#text/plain#) {
            return reject('HTML Image Tags', 'HTML')
            if $hdr{__BODY__} =~ /\<img$hws+src/i;
        };

            

        # bot checks #########################################################
        return reject('MID-Bot', 'Bot signature')
            if $lch{'message-id'} =~
                /(?:
                    ^<\d{12}\@[a-z]{10}>$|
                    \@\d+>$|
                    msgidabcxyz\.com>$|
                    no(?:ne|where)\d+\.yet>$|
                    strip_path>$|
                    ^<[^ \t\.]+\@\d+G\d+O\d+O\d+F\d+.com>$
                )/x;

        if ($hdr{'User-Agent'}) {
        } elsif ($hdr{'X-Mailer'}) {
            return reject('Message-ID/X-Mailer bot', 'Bot signature')
                if $hdr{'Message-ID'} =~ /^<(.*)@/
                    and $hdr{'X-Mailer'} eq $1;
        } elsif ($hdr{'X-Newsreader'}) {
            return reject('Smart Post Pro', 'Bot signature')
                if $hdr{'X-Newsreader'} =~ /^[a-z]{7,11}$/
                    and $hdr{From} =~ /^[a-z]{7,13}\@[a-z]{7,12}\.com$/;
        } else {
            my $pathtail = '';
            my $fromhost = '';
            $hdr{Path} =~ /.*!(.*)$/ and $pathtail = $1;
            $hdr{From} =~ /@(.*?)>?$/ and $fromhost = $1;

            # Path/Newsgroups bot, contains just one MIME part
            return reject('PN bot', 'Bot signature')
                if $pathtail eq $hdr{Newsgroups}
                    and $hdr{From} !~ /\Q$pathtail\E\@/
                    and $hdr{'Content-Type'}
                        =~ /^multipart; boundary="_NextPart_/;

            # Path/From/Message-ID bot
            if ($hdr{'Message-ID'} =~ /^<\d{8}\.?\d{4}\@\Q$fromhost\E>$/) {
                return reject('PFM bot path') if $pathtail eq $fromhost;
                return reject('PFM bot misc', 'Bot signature')
                    if $hdr{Subject} !~ / \d+ bytes \(\d+\/\d+\)$/;
            }
        } # no X-Mailer/X-Newsreader/User-Agent header

        $state{xreader} = x_reader();
        return reject("X-Bot ($state{xreader})", 'Bot signature')
            if $state{xreader} =~ /$Xbot/;

        return reject('Email Platinum', 'Bot signature')
            if $lch{organization} =~ /email platinum/;

        if (not $gr{reports} and not $hdr{References}) {
            return reject('Bot - Newsgroup autoposter', 'Bot signature')
                if $hdr{__BODY__}
                    =~ /\n---[\r\n]+[A-Z][a-z \t]{120,}\.?[\r\n]+/;
            return reject('Angle-bracket bot', 'Bot signature')
                if $hdr{__BODY__} =~ /[\r<=>]+\r[\r<=>]+$/m;
        }

        if (defined &local_filter_bot) {
            my @result = local_filter_bot();
            return reject(@result) if $result[0];
        }

        # EMP checks #########################################################
        # create MD5 body checksum hash.
        if ($config{do_md5} and not $gr{md5skip} and not $gr{alltest}
                and not ($hdr{References} and $config{md5_skips_followups})
                and (($config{md5_max_length}
                        and $state{lines} < $config{md5_max_length})
                    or not $config{md5_max_length})
                and $state{lines} > 0 and ($state{lines} > 2
                    or ($state{lines} < 3
                    and $hdr{__BODY__} !~ /^\s{0,8}$/))) {
            my $mbody;
            if ($config{fuzzy_md5}
                    and (($config{fuzzy_max_length}
                            and $state{lines} < $config{fuzzy_max_length})
                        or not $config{fuzzy_max_length})
                    and not is_binary()) {
                $mbody = lc $hdr{__BODY__};
                $mbody =~ s/^(?!http)\S{7,70}\r?$//mg;
                $mbody =~ s/^>+\s.*//mg;  # Strip quoted lines
                $mbody =~ s/\r{3}.*$//mg;
                $mbody =~ s/$hws+$//;
                $mbody =~ s/^[^\n]*\Z//m if $state{lines} > 5;
                $mbody =~ tr/a-z0-9//cd;
            }
            return reject('EMP (md5)', 'EMP')
                if $MD5history->add(md5_hex($mbody || $hdr{__BODY__}));
        }

        if (not $gr{reports}) {
            # create posting-host/lines hash
            if ($config{do_phl} and not $gr{allmod}
            and $state{posting_host} and not $gr{phlskip}
            and not is_binary() and not $gr{alltest}
            and not $state{posting_host} =~ /(?:$config{phl_exempt})/o
            and not $state{injection_host} =~ /(?:$config{bad_nph_hosts})/o
            and not ($gr{binary} and $state{lines} > 100
                and $hdr{Subject} =~ /[\(\[]\d+\/\d+[\)\]]/)) {
                    return reject('EMP (phl)', 'EMP')
                        if $PHLhistory->add("$state{posting_host} $state{lines}");
            }; # End of PHL filter

            # create posting-host/newsgroups hash
            if ($config{do_phn} and not $gr{phrinc} and not $gr{phnskip}
            and not $gr{alltest} and not $gr{allmod}
            and not ($gr{binary} and $state{lines} > 100)) {
                if ($state{posting_host}
                and not $state{injection_host} =~ /(?:$config{bad_nph_hosts})/o) {
                    if (not $state{posting_host} =~ /(?:$config{phn_exempt})/o) {
                        return reject('EMP (phn nph)', 'EMP')
                            if $PHNhistory->add("$state{posting_host} $sortgrps");
                    };
                } elsif ($config{phn_aggressive}) {
                    return reject('EMP (phn path)', 'EMP')
                        if $PHNhistory->add("$state{injection_host} $sortgrps");
                }; # End of aggressive mode
            }; # End of PHN filter

            # create from/subject/lines hash
            if ($config{do_fsl} and not $gr{fslskip} and not $gr{alltest}) {
                my $hash1;
                if (defined $hdr{Sender}) {
                    $hash1 = lc "$hdr{Sender} $hdr{Subject}";
                } else {
                    $hash1 = lc "$hdr{From} $hdr{Subject}";
                };
                $hash1 =~ s/\d+$//;
                $hash1 =~ tr/a-z0-9\@\x80-\xFF//cd;
                $hash1 = "$hash1 $state{lines}";
                return reject('EMP (fsl)', 'EMP') if $FSLhistory->add($hash1);
            }; # End of FSL filter
        }; # not reports groups

        # create high-risk newsgroups hash
        if ($config{do_phr} and $gr{phrinc}
            and not ($gr{binary} and $state{lines} > 100)) {
            if ($state{posting_host}
            and not $state{injection_host} =~ /(?:$config{bad_nph_hosts})/o) {
                if (not $state{posting_host} =~ /(?:$config{phr_exempt})/o) {
                    return reject('EMP (phr nph)', 'EMP')
                        if $PHRhistory->add("$state{posting_host}");
                }
            } elsif ($config{phr_aggressive}) {
                my $server;
                $server = lc "$hdr{Path}";
                $server =~ s/(![^\.]+)+$//; # Strip right-most non-FQDN's
                my $exc_count = ($server =~ tr/!//); # Count Path entries
                # We (probably) don't want to filter our immediate peers.
                if ($exc_count > 1) {
                    $server =~ s/.*!//; # Strip all but the right-most entry.
                    return reject('EMP (phr path)', 'EMP')
                        if $PHRhistory->add("$server");
                }
            }
        } # End of PHR filter

        # Supersedes checks ##################################################
        if ($hdr{Supersedes}) {
            foreach (@Path_Entries) {
                return reject("Supersedes with $_ in path", 'Rogue Supersedes')
                    if exists $Bad_Cancel_Path{$_};
            }
        }

        if ($config{do_supersedes_filter} and $hdr{Supersedes}
            and not $state{posting_host} =~ /$config{supersedes_exempt}/o) {
            my $source;
            if ($state{posting_host}) {
                $source = lc $state{posting_host};
                $source =~ tr/a-z.//cd;
            }

            if ($source) {
                my $max;
                if    ($gr{faq})        { $max = 45 }
                elsif (not ($config{active_file} or defined &INN::newsgroup))
                                        { $max = 10 }
                elsif ($gr{allmod})     { $max = 35 }
                elsif ($gr{mod})        { $max = 10 }
                else                    { $max = 6  }

                return reject('Excessive Supersedes '
                        ."($state{posting_host})", 'Excessive Supersedes')
                    if $Suphistory->add2($source, $max);
            }
        }

        if (defined &local_filter_after_emp) {
            my @result = local_filter_after_emp();
            return reject(@result) if $result[0];
        }

        # bot checks, the second part ########################################
        return reject('Fake multipart bot', 'Bot signature')
            if $hdr{Subject} =~ m#\[(\d+)/(\d+)\]$# and $1 > $2;
        #

        # Reject bad From headers.  We also check Sender and Reply-To headers
        # against the same Regular Expression.
        if ($Bad_From) {
            return reject("Banned Reply-To ($1)", 'Bad Reply-To')
                if $hdr{'Reply-To'} =~ $Bad_From_RE;
            return reject("Banned Sender ($1)", 'Bad Sender')
                if $hdr{Sender} =~ $Bad_From_RE;
            return reject("Banned From ($1)", 'Bad From')
                if $hdr{From} =~ $Bad_From_RE;
        };

        # Reject bad Subject headers.
        return reject("Subject ($1)", 'Bad Subject')
            if $Bad_Subject and $hdr{Subject} =~ $Bad_Subject_RE;

        # Set a flag if the message body contains a URL.  This means later,
        # more complex tests can be bypassed on many messages.
        if ($body =~ /$HTTP/io) {
            $state{body_has_url} = 1;
        };

        # Check payload against bad_body and bad_url files.
        if (not $gr{reports} and not $hdr{References}) {
            return reject("Body ($1)", 'Bad Body')
               if $Bad_Body and $body =~ $Bad_Body_RE;
        };

        # Enforce Altopia policy on Path pre-loading.
        #if ($hdr{Path} =~ /news\.alt\.net!.*[!\.]alt\.net/) {
        #    return reject("TOS Violation")
        #        if ($hdr{Path} !~ /[!\.]alt\.net(!not-for-mail)?$/);
        #};

        # bad words and scoring filter #######################################
        if ($config{do_scoring_filter} and not $gr{reports}
            and not $gr{scoreskip}) {

            #FIXME All that's MIME isn't WebTV
            #$score .= "!!!webtv" if $lch{'content-type'}
            #        =~ m#multipart/(?:related|mixed).*boundary#
            #    and $hdr{'NNTP-Posting-Host'} !~ /webtv\.net$/
            #    and $lch{'message-id'} !~ /webtv\.net>$/;

            # Score the huge volume of commercial sex spam currently posted
            # to these groups. (20110817)
            if ($state{spamsource}) {
                if ($hdr{Newsgroups} =~ /\.sex\.|^alt\.fan\.utb\./) {
                    $score .= "!!!LongSexLine" if $hdr{__BODY__} =~ /^.{150}/m;
                    $score .= "!!SexLines1" if $state{lines} > 50;
                    $score .= "!!SexLines2" if $state{lines} > 100;
                    $score .= "!!!SexURL" if $state{body_has_url};
                    $score .= "!SexNoRef" if not $hdr{References};
                };
            };

            # Score poor netiquette on Follow-up's
            $score .= "!!ExpFup($state{grpcnt}-$state{grpfupcnt})"
                if $state{grpfupcnt} > $state{grpcnt};
            if (not $hdr{'Followup-To'}) {
                $score .= "!NoFup($state{grpcnt})"
                    if $state{grpcnt} > 1 and $state{grpcnt} < 4;
                $score .= "!!NoFup($state{grpcnt})" if $state{grpcnt} >= 4;
            };

            $score .= "!!!!FromURL2" if $lch{from} =~ /$url2/o;
            $score .= "!FromNoLC" if $lch{from} !~ /[a-z]/o;
            $score .= "!FromNo@" if $lch{from} !~ /\@/;
            $score .= "!FromLen" if length($hdr{From}) > 80;

            $score .= "!SubURL" if $lch{subject} =~ /$url/o;
            $score .= "!!!!!SubStealthURL" if $lch{subject} =~ /$stealthURL/o;
            $score .= "!!Sub15Space" if $hdr{Subject} =~ / {15,}[^ ]/;
            # Digits at the end are bad, but not if they are a year
            $score .= "!!!SubDigit" if $hdr{Subject} =~ /[\s~]\d{2,}$/
                and $hdr{Subject} !~ /\D20[0-9]{2}$/;
           
            $score .= "!!!!SubDigitJPG" if $lch{subject} =~ /\s\d{1,3}\.jpg$/;
            $score .= "!SubSymbols" if $hdr{Subject} =~ /^\W{3}/;
            $score .= "!!!SubPhone" if $hdr{Subject} =~ /$phone/;
            $score .= "!SubCR" if $hdr{Subject} =~ /\r/;
            $score .= "!SubLength" if length($hdr{Subject}) > 210;
            $score .= "!!SubNoLC" if $hdr{Subject} !~ /[a-z]/;
            $score .= "!!!SubSpaced" if $hdr{Subject} =~ /(\w$hws+){8}/o;

            # Job Spam
            $score .= "!!!Jobs" if $hdr{Newsgroups} =~ /\.jobs|\.bestjobs/
                and $hdr{From} =~ /job/;

            if ($config{aggressive} and not $gr{alladult}) {
                $score .= "!Sub1Pt($1)" while $lch{subject} =~ /($one_point_words)/go;
                $score .= "!!Sub2Pt($1)" while $lch{subject} =~ /($two_point_words)/go;
                $score .= "!From1Pt" while $lch{from} =~ /$one_point_words/go;
                $score .= "!!From2Pt" while $lch{from} =~ /$two_point_words/go;
                $score .= "!MID1Pt" while $lch{'message-id'} =~ /$one_point_words/go;
                $score .= "!!MID2Pt" while $lch{'message-id'} =~ /$two_point_words/go;
                $score .= "!Org1Pt" while $lch{organization} =~ /$one_point_words/go;
                $score .= "!!Org2Pt" while $lch{organization} =~ /$two_point_words/go;

                local $_ = $lch{subject};
                tr/a-z0-9 //cd;
                #FIXME Next two return false positives.
                #$score .= "!!!!!SubServices" if /$services/o;
                #$score .= "!!!SubSiteDesc" if /$site_desc.{0,20}site/o;
                $score .= "!SubPorn" if /(?:$free_stuff|$porn)/o;
            };

            $score .= "!!SubImage" if $state{lines} < 30
                and $lch{subject}=~ /\w\.(?:jpe?g|gif)/;
            $score .= "!!MalfLines($state{badlines})" if $state{badlines} > 0;
            $score .= "!!!NoOrg" if $lch{organization} =~ /<no organization>/;
            $score .= "!!!!!!!StealthOrg" if $lch{organization} =~ /$stealthURL/o;
            $score .= "!!!!!MIDDigit" if $hdr{'Message-ID'}=~/^<(?:\d{8}\.?\d{4}|\d{4,5})\@/;

            if ($lch{'content-type'} =~ m#^(?:multipart|text/html)#) {
                $score .= "***PGP" if $lch{'content-type'} =~ /^multipart\/signed/;
                $score .= "!!!!!!!HTMLRefresh" if $body =~ /<meta http-equiv=.?refresh/;
                $score .= "!!!!!!!HTMLPopup" if $body =~ /window\.open\(/;
                $score .= "!!!!!!HTMLJava" if $body =~ /<script language=.?javascript/;
                $score .= "!!!!!!HTMLLive" if $body =~ /<script language=.?livescript/;
                $score .= "!!HTMLAlternate" if $body =~ /^content-type:$hws+multipart\/alternative/m;
            };

            #$score .= "!CR" if $body =~ /\r/;
            $score .= "!!!2CR" if $body =~ /\r\r/;
            $score .= "!!Newlines" if $hdr{__BODY__} =~ /(\r?\n){15}/;
            $score .= "!!Phone" if $body =~ /$phone/;
            # Score rates per minute (1.99/m or 1.99 per min)
            $score .= "!!!Rate"
                if $body =~ /\d\.\d{2}\s?(?:[\\\/]\s?m|$hws+per\bmin)/;
            $score .= "!!!!!HttpIP" if $body =~ /$HTTP$IP/o;
            $score .= "!!!!!!!Stealth" if $body =~ /$HTTP$StealthIP/o;
            $score .= "!!!!SpaceCom" if $body =~ /$spacecom/o;
            # Power Post generates lots of spam.
            $score .= "!!!PowerPost" if $hdr{'X-Newsposter'} and not $gr{binary};

            # only URL
            $score .= "!!!!!!OnlyURL"
                if $state{lines} < 3 and $body =~ /^$hws*$url3\S*$hws*$/o;

            if ($state{body_has_url}) {
                if ($Bad_URL) {
                    $score .= "!" x $config{'bad_url_score'} . 'bad_url'
                    if $body =~ $Bad_URL_RE;
                };
                if ($Bad_URL_Central) {
                    $score .= "!" x $config{'bad_url_score'} . 'bad_url_cen'
                    if $body =~ $Bad_URL_Central_RE;
                };

                # Emphasized URL (>>> http://www.foo <<<)
                if (not $hdr{References}) {
                    if ($body =~ /$SYMBOL{3}[\x09\x20]+$simpleURL[\x09\x20]+$SYMBOL{3}/o) {
                        $score .= "!!!EmphURL3";
                    } elsif ($body =~ /$SYMBOL{3}[\x09\x20]+$simpleURL/o) {
                        $score .= "!EmphURL1";
                    };
                }; # End of References
            }; # End of body_has_url

            if ($hdr{References}) {
                if ($hdr{References} =~ /^<[^>]+>\s*</) {
                    $score .= "***Refs";
                } elsif ($hdr{References} =~ /^<[^>]+>\s*$/) {
                    $score .= "**Ref";
                } else {
                    $score .= "!!BadRef";
                };

                if ($state{lines} > 0) {
                    # How much of the post is quoted?
                    $state{reflines} = 0;
                    $state{reflines}++ while $hdr{__BODY__} =~ /^>/mg;
                    $state{pctrefs} = int(($state{reflines} /
                        $state{lines}) * 100) / 100;
                    if ($state{pctrefs} > 0.9 and $state{lines} > 50) {
                        $score .= "!!PctQuote($state{pctrefs})";
                    } elsif ($state{pctrefs} > 0.7 and $state{lines} > 30) {
                        $score .= "!PctQuote($state{pctrefs})";
                    } elsif ($state{reflines} == 0 and $state{lines} > 5) {
                        $score .= "!NoQuote";
                    };
                };
            }; # End of References conditional

            # Long signatures are poor netiquette but not spam, so only
            # give them low scores.
            #$score .= "!SigLen" if $body =~ /\n-- (\r?\n.*){5,}\n\w/;
            #$score .= "!SigLen2" if $body =~ /\n-- (\r?\n.*){9,}\n\w/;

            # Check messages for high ratios of upper case and urls.
            if ($config{do_ratio_scoring} and not $gr{ratio}
            and $state{lines} < 4000 and not is_binary()
            and not $hdr{'Content-Transfer-Encoding'} =~ /base64/
            and not $state{charset} =~ /big5|iso-2022|koi8-r/) {
                $fuzzy = $hdr{__BODY__};
                $state{urlcount} = $fuzzy =~ s/http:\/\/www\.\S+//g;       # Strip urls
                $state{urlcount} += $fuzzy =~ s/$HTTP\S+//g;   # Strip urls
                $state{nonasc} += $fuzzy =~ s/[\x80-\xFF]//g; # Strip non-ascii
                $fuzzy =~ s/[\-=]{5,}//g;           # Strip horizontal rules
                $fuzzy =~ s/[a-zA-Z]{20,}//g;       # Strip long char strings
                $state{letters} = $fuzzy =~ y/a-zA-Z//;    # Count letters
                $state{uppercase} = $fuzzy =~ y/A-Z//;     # Count upper
                $state{symbols} = $fuzzy =~ y/!"#$%&'()*+,-:;=?@{|}~//; # Count syms
                undef $fuzzy;
                # Where non-ASCII chars are present, there should be a charset
                # specified in the Content-Type.
                if (not $state{charset} and $state{nonasc}) {
                    $score .= "!!!NoCharset" if $state{nonasc} > 50;
                };
                if (not $state{charset} =~ /iso-2022|koi8-r/) {
                    if ($state{uppercase} > 50) {
                        $state{capratio} = int(($state{uppercase} /
                            $state{letters}) * 100) / 100;
                        if ($state{capratio} > 0.8) {
                            $score .= "!!!CapRat($state{capratio})";
                        } elsif ($state{capratio} > 0.5) {
                            $score .= "!!CapRat($state{capratio})";
                        } elsif ($state{capratio} > 0.2) {
                            $score .= "!CapRat($state{capratio})";
                        };
                    };
                    if ($state{letters} > 10 and not $hdr{References}) {
                        $state{symratio} = int(($state{symbols} /
                            $state{letters}) * 100) / 100;
                        if ($state{symratio} > 1) {
                            $score .= "!!!SymRat($state{symratio})";
                        } elsif ($state{symratio} > 0.5) {
                            $score .= "!!SymRat($state{symratio})";
                        } elsif ($state{symratio} > 0.3) {
                            $score .= "!SymRat($state{symratio})";
                        };
                    };
                }; # End of charset conditional

                # Grant some slack to posts with no url's in them.
                $score .= "**NoUrl" if $state{urlcount} == 0;
                # Score on URL ratios
                if ($state{lines} > 0 and $state{urlcount} > 1) {
                    $urlscore = 0;
                    $state{urlratio} = int(($state{urlcount} /
                        $state{lines}) * 100) / 100;
                    if ($state{urlratio} > 0.5 and  $state{lines} > 40) {
                        $urlscore = 3;
                    } elsif ($state{urlratio} > 0.3 and  $state{lines} > 10) {
                        $urlscore = 2;
                    } elsif ($state{urlratio} > 0.1 and  $state{lines} > 5) {
                        $urlscore = 1;
                    }; # End of url ratio calculation
                    # Double the score for spamsources
                    $urlscore = $urlscore * 2 if $state{spamsource};
                    # Convert the score integer to text format
                    if ($urlscore > 0) {
                        $score .= "!" x $urlscore . "UrlRat($state{urlratio})";
                    };
                }; # End of url ratio scoring
            }; # End of do_ratio_scoring

            # Grant some slack to adult groups posts, providing they don't
            # originate from a spam source.
            if ($gr{alladult} and not $state{spamsource}) {
                if ($hdr{References}) {
                    $score .= "***Adult";
                } else {
                    $score .= "**Adult" if not $state{body_has_url};
                    $score .= "#Adult+Url" if $state{body_has_url};
                };
            }; # End of Adult slack

            if ($config{active_file} or defined &INN::newsgroup) {
                if ($gr{allmod}) {
                    #$score -= 6;
                    $score .= "******AllMod";
                } elsif ($gr{mod}) {
                    #$score -= 4;
                    $score .= "****Mod";
                };
            };

            $state{scoreval} = ($score =~ tr/!//) - ($score =~ tr/*//);
            return reject("Scoring filter", "Scoring filter")
                if $state{scoreval} > 7;
        }; # End of Scoring filters

        if (defined &local_filter_last) {
            my @result = local_filter_last();
            return reject(@result) if $result[0];
        }

    # cancel messages ########################################################
    } elsif ($hdr{Control} =~ /^$hws*cancel/) {
        foreach (@Path_Entries) {
            return reject("Cancel with $_ in path", 'Rogue cancel')
                if exists $Bad_Cancel_Path{$_};
        }

        return reject('User-issued spam cancel')
            if $config{block_user_spamcancels}
                and $state{injection_host} and $state{posting_host}
                and $hdr{Path} =~ /!cyberspam!/;

        return reject('User-issued cancel')
            if $config{block_user_cancels}
                and not $hdr{Path} =~ /!cyberspam!/;

        return reject('Cancel in forbidden group', 'Rogue cancel')
            if $gr{no_cancel} and not $hdr{Path} =~ /!cyberspam!/;

        if ($config{block_late_cancels}
                and $hdr{Control} =~ /^cancel$hws+(.+)$/) {
            return reject('Cancel for rejected article')
                if $MIDhistory->check($1);
        }

        return reject('Cancel with Supersedes header')
            if $hdr{Supersedes};

        return reject('Rogue cancel (newsgroups)', 'Rogue cancel')
            if grep(/^control(?:\.cancel)?$/, @groups);

        # from Ricardo's "FAQ" + hipcrime signatures
        return reject("Rogue cancel ($1)", 'Rogue cancel')
            if $hdr{Path} =~ /(h[i\d]pcr[i\d]me|(?:hip|hacker|crack|porn|cripple|gimp|cunt|hole|fag|aids|faq|god|hindu|dothead|jew|kike|moslem|towelhead|nazi|kraut|nerd|geek|nigger|redneck|rice|slanteye|spick|whine)cancel|cyberwhin(?:er|ing))/;

        if ($hdr{'X-Cancelled-By'} or $hdr{'X-Canceled-By'}) {
            my $xcb = lc ($hdr{'X-Cancelled-By'} || $hdr{'X-Canceled-By'});
            return reject('Bad X-Cancelled-By', 'Rogue cancel')
                if $xcb !~ /\w\@\w/;
        }

        if (defined &local_filter_cancel) {
            my @result = local_filter_cancel();
            return reject(@result) if $result[0];
        }

    # newgroup and rmgroup messages ##########################################
    } elsif ($hdr{Control} =~ /^$hws*((?:new|rm)group)$hws+(.*)/) {
        my $control_type = $1;
        my $control_group = $2;

        return reject("Bogus $control_type message from Collabra luser",
            'Bad control message')
            if $hdr{Distribution} =~ /collabra-internal/ or $hdr{__BODY__}
                =~ /Control message generated by Netscape Collabra Server/;

        if ($control_group
                =~ /^(?:comp|misc|news|rec|soc|sci|humanities|talk)\./) {
            return reject("Big 8 $control_type message from wrong address",
                    'Bad control message')
                if $hdr{From} !~ /group-admin\@isc\.org/;
        } else {
            return reject("Forged non-big-8 $control_type message supposedly from tale", 'Bad control message')
                if $hdr{From}
                    =~ /(?:group-admin|tale)\@isc\.org|tale\@uunet\.uu\.net/;
        }

        return reject("Unapproved $control_type message",
            'Bad control message') if not $hdr{Approved};

        return reject("Newgroup for poison group $control_group",
            'Bad control message')
            if $control_type eq 'newgroup'
                and $control_group =~ /$config{poison_groups}/o;

        if (defined &local_filter_control) {
            my @result = local_filter_control();
            return reject(@result) if $result[0];
        };

    # other control messages #################################################
    } elsif ($hdr{Control} =~ /^$hws*(\w+)(?:$hws+(.*))?/) {
        my $control_type = $1;
        my $control_group = $2;
    
        return reject("$control_type with Supersedes header")
            if $hdr{Supersedes};

        return reject("Obsolete $1 control message", 'Bad control message')
            if $config{drop_useless_controls}
                and $control_type =~ /^(sendsys|senduuname|version|whogets)$/;
        return reject("Unwanted $1 control message", 'Bad control message')
            if $config{drop_ihave_sendme}
                and $control_type =~ /^(ihave|sendme)$/;

    }
    ##########################################################################

    $status{accepted}++;
    $timer{accepted}++ if $config{timer_info};
    return '';
}

# Return true if the article is a binary, false otherwise.
sub is_binary {
    return $state{cache_is_binary} if defined $state{cache_is_binary};

    # Return False if the article is Base64 encoded.  We want to match binary
    # content, *not* Base64 encoding.
    if ($hdr{'Content-Transfer-Encoding'} =~ /^base64$/i
    and $hdr{'Content-Type'} =~ /^text/i) {
        $state{cache_is_binary} = 0;
        return $state{cache_is_binary};
    };

    # yEnc checks: According to yEnc spec, all encoded parts start with
    # =ybegin.
    if ($body =~ /(?:^|\n)=ybegin$hws+(.+)/o) {
        local $_ = $1;
        if (/line=/ and /size=/ and /name=/) {
                $state{cache_is_binary} = "yEnc Encoded";
                return $state{cache_is_binary};
            };
        };
    };

    # uuEncoded check
    if ($body =~ /(?:^|\n)begin$hws+(.+)/io) {
        local $_ = $1;
        if (/[0-7]{3,4}$hws.*\.(\w{2,4})/o) {
            $state{file_extension} = $1;
            $state{cache_is_binary} = "uuencoded";
            return $state{cache_is_binary};
        };
    };

    if ($hdr{__BODY__} =~ /
        (?:
            [ \t|>]*                     # Skip Quote Marks
            (?>                         # Disable Backtracking
            M[\x20-\x60]{60,61}         # uuencoded line
            )$hws*\x0D?\x0A               # End of line
        ){4}                            # Require at least four encoded lines
    /ox) {
        $state{cache_is_binary} = "uuencoded multi-part";
        return $state{cache_is_binary};
    };

    # We only need to count Base64 lines if the number of lines in the post
    # exceeds the configured Base64 maximum allowed.
    if ($state{lines} > $config{max_base64_lines}) {
        $state{b64lines} = 0;
        $state{b64lines}++
            while $hdr{__BODY__} =~ /^$hws*[A-Za-z0-9\+\/]{59,76}$hws*$/gmo;
        if ($state{b64lines} > $config{max_base64_lines}) {
            $state{cache_is_binary} = "Base64 ($state{b64lines} lines)";
            return $state{cache_is_binary};
        };
    };

    # Message is not binary
    $state{cache_is_binary} = 0;
    return 0;
};

# Extract the right-most FQDN from a Path header
sub first_path_host{
    local $_ = shift;
    s/(![^\.]+)+$//; # Strip RH non-FQDNs
    s/!\.POSTED.*//; # Strip diagnostic host entry
    s/.*!//; # Strip all but RH path entry
    return $_;
};

# Attempt to determine the client software
sub x_reader {
    return  lc $hdr{'X-Newsreader'} ||
            lc $hdr{'User-Agent'}   ||
            lc $hdr{'X-Newsposter'} ||
            lc $hdr{'X-Poster'}     ||
            lc $hdr{'X-Mailer'}     || '';
}

sub reject {
    my ($verbose_reason, $short_reason) = @_;

    if (defined &local_filter_reject) {
        ($verbose_reason, $short_reason) = local_filter_reject(@_);
        return if not $verbose_reason;
    }

    $short_reason = $verbose_reason unless $short_reason;

    if ($config{block_late_cancels}
# XXX $config{block_extra_reposts}
# XXX for reposts       and not $hdr{Control}
        ) {
        $MIDhistory->add($hdr{'Message-ID'});
    }

    $status{rejected}++;

    return $config{verbose} ? $verbose_reason : $short_reason;
}

##############################################################################
# other functions called by INN
##############################################################################

# examine message-id during CHECK and IHAVE transactions (INN only)
sub filter_messageid {
    return '' if not $config{do_mid_filter};
    my ($id) = @_;

    if ($config{refuse_messageids} and $id =~ /$config{refuse_messageids}/io) {
        $status{refused}++;
        return 'No';
    }

    if ($config{block_late_cancels}
            and (($id =~ /^<cancel\.[a-z0-9]{4}\.(.+)/
                    and $MIDhistory->check('<'.$1))
                or ($id =~ /^<cancel\.(.+)/ and $MIDhistory->check('<'.$1)))) {
        $status{refused}++;
        return 'No';
    }

    return '';
}

sub filter_mode {
    if ($config{do_emp_dump}) {
        if ($mode{NewMode} eq 'throttled') {
            dump_emp();
        } elsif ($mode{NewMode} eq 'running') {
            restore_emp() if $mode{Mode} eq 'throttled';
        }
    }

    slog('N', 'Meow unto the greatness of Fluffy, Ruler of All Usenet')
        if lc $mode{reason} eq 'meow';

    return;
}

# a status line in "ctlinnd mode" output (INN only).
# (requires the "mode.patch" to innd or equivalent).
sub filter_stats {
    my $md5hashentries = $MD5history ? $MD5history->count : 0;
    my $phlhashentries = $PHLhistory ? $PHLhistory->count : 0;
    my $phnhashentries = $PHNhistory ? $PHNhistory->count : 0;
    my $phrhashentries = $PHRhistory ? $PHRhistory->count : 0;
    my $fslhashentries = $FSLhistory ? $FSLhistory->count : 0;
  
    my $string = "Pass: $status{accepted}  Reject: $status{rejected}";
    $string .= "  Refuse: $status{refused}" if $config{do_mid_filter};
    $string .= "  MD5: $md5hashentries  PHL: $phlhashentries  PHN: $phnhashentries";
    $string .= "  PHR: $phrhashentries  FSL: $fslhashentries";
    $string .= "  Arts/sec: $timer{rate}  Accept/sec: $timer{accept_rate}"
        if $config{timer_info} and $timer{rate};
    $string .= "  cleanfeed.conf NOT loaded!" if $Local_Conf_Err;

    return $string;
}

##############################################################################
# functions to write the report files
##############################################################################

# Write an HTML statfile
sub write_html_stats {
    if (not open(HTML, ">$config{html_statfile}")) {
        slog('E', "Cannot open $config{html_statfile}: $!");
        return;
    }

    print HTML "<html>\n<head>\n"
    . "<title>Cleanfeed Status</title>\n"
    . "</head>\n<body>\n\n"
    . "<p>\n";
    #print HTML "<b>Cleanfeed Version:</b> $version ($version_date)<br>\n"
    #    if $version and $version_date;
    print HTML "<b>Filter started:</b> " . scalar(localtime $Start_Time) . "<br>\n"
    . "<b>Report generated:</b> " . scalar(localtime) . "<br>\n"
    . 'Uptime: ' . ($now - $Start_Time) . " seconds\n"
    . "\n<p>\n"
    . "<b>Accepted:</b> $status{accepted}<br>\n"
    . "<b>Rejected:</b> $status{rejected}\n";
    print HTML "<br><b>Refused:</b> $status{refused}\n"
        if $config{do_mid_filter};

    if ($config{timer_info} and $timer{rate}) {
        print HTML "\n<p>\n"
        . "Period since last report: $timer{interval} seconds<br>\n"
        . "Articles examined (this period): $timer{rate}/s<br>\n"
        . "Articles accepted (this period): $timer{accept_rate}/s<br>\n"
        . "Articles examined (entire uptime): $timer{total_rate}/s<br>\n"
        . "Articles accepted (entire uptime): $timer{total_accept_rate}/s\n";
    }

    my $md5hashentries = $MD5history ? $MD5history->count : 0;
    my $phlhashentries = $PHLhistory ? $PHLhistory->count : 0;
    my $phnhashentries = $PHNhistory ? $PHNhistory->count : 0;
    my $phrhashentries = $PHRhistory ? $PHRhistory->count : 0;
    my $fslhashentries = $FSLhistory ? $FSLhistory->count : 0;
    my $superentries   = $Suphistory ? $Suphistory->count : 0;
    my $midhistentries = $MIDhistory->count;
    my $md5count = $MD5history ? $MD5history->overflowed : 0;
    my $phlcount = $PHLhistory ? $PHLhistory->overflowed : 0;
    my $phncount = $PHNhistory ? $PHNhistory->overflowed : 0;
    my $phrcount = $PHRhistory ? $PHRhistory->overflowed : 0;
    my $fslcount = $FSLhistory ? $FSLhistory->overflowed : 0;

    print HTML "\n<p>\n"
    . "<b>MD5 entries:</b> $md5hashentries <b>Rejecting:</b> $md5count<br>\n"
    . "<b>PHL entries:</b> $phlhashentries <b>Rejecting:</b> $phlcount<br>\n"
    . "<b>PHN entries:</b> $phnhashentries <b>Rejecting:</b> $phncount<br>\n"
    . "<b>PHR entries:</b> $phrhashentries <b>Rejecting:</b> $phrcount<br>\n"
    . "<b>FSL entries:</b> $fslhashentries <b>Rejecting:</b> $fslcount<br>\n"
    . "<b>MID history:</b> $midhistentries\n";

    print HTML "\n<p>\n<blink>cleanfeed.conf <b>NOT</b> loaded!</blink>\n"
        if $Local_Conf_Err;

    print HTML "\n<p>\nSupersedes entries: $superentries\n";
    if ($Suphistory) {
        print HTML "<ul>\n";
        my $items = $Suphistory->items;
        foreach (sort keys %$items) {
            print HTML "<li>$_: $items->{$_}\n";
        }
        print HTML "</ul>\n";
    }

    print HTML "</body></html>\n";
    close HTML;
}

# write a crude stat file including accept/reject numbers,
# hash sizes, and current configuration
sub writestats {
    my $noreset = $_[0] || 0;
    $Last_Stats = $now unless $noreset;

    timer_stats() if $config{timer_info};

    write_html_stats() if $config{html_statfile};

    return if not ($config{statfile} or $config{inn_syslog_status});

    my $md5hashentries = $MD5history ? $MD5history->count : 0;
    my $phlhashentries = $PHLhistory ? $PHLhistory->count : 0;
    my $phnhashentries = $PHNhistory ? $PHNhistory->count : 0;
    my $phrhashentries = $PHRhistory ? $PHRhistory->count : 0;
    my $fslhashentries = $FSLhistory ? $FSLhistory->count : 0;
    my $superentries   = $Suphistory ? $Suphistory->count : 0;
    my $midhistentries = $MIDhistory->count;

    if ($config{inn_syslog_status}) {
        my $message = 'status: ';
        $message .= "accepted $status{accepted} rejected $status{rejected}";
        $message .= " refused $status{refused}" if $config{do_mid_filter};
        $message .= " md5 $md5hashentries" if $md5hashentries;
        $message .= " phl $phlhashentries" if $phlhashentries;
        $message .= " fsl $fslhashentries" if $fslhashentries;
        $message .= " arts/s $timer{rate} accept/s $timer{accept_rate}"
            if $config{timer_info} and $timer{rate};
        $message .= " WARNING cleanfeed.local NOT loaded" if $Local_Conf_Err;

        slog('N', $message);
    }

    return if not $config{statfile};

    if (not open FILE, ">$config{statfile}") {
        slog('E', "Cannot open $config{statfile}: $!");
        return;
    }
    print FILE "Cleanfeed Version: $version ($version_date)\n"
        if $version and $version_date;
    print FILE 'Filter started: ' . scalar(localtime $Start_Time) . "\n"
    . 'Report generated: ' . scalar(localtime) . "\n"
    . 'Uptime: ' . ($now - $Start_Time) . " seconds\n\n"
    . "Accepted: $status{accepted}\nRejected: $status{rejected}\n";
    print FILE "Refused: $status{refused}\n" if $config{do_mid_filter};
    print FILE "MD5 entries: $md5hashentries\n"
    . "PHL entries: $phlhashentries\n"
    . "PHN entries: $phnhashentries\n"
    . "PHR entries: $phrhashentries\n"
    . "FSL entries: $fslhashentries\n"
    . "MID history: $midhistentries\n\n";
    if ($config{timer_info} and $timer{rate}) {
        print FILE "Articles examined per second: $timer{rate}\n";
        print FILE "Articles accepted per second: $timer{accept_rate}\n";
    }

    print FILE "\ncleanfeed.local NOT loaded! Check file permissions.\n"
        if $Local_Conf_Err;

    print FILE "\nSupersedes entries: $superentries\n";
    if ($Suphistory) {
        my $items = $Suphistory->items;
        foreach (sort keys %$items) {
            print FILE "  $_: $items->{$_}\n";
        }
    }

    print FILE "\n\nCurrent configuration:\n\n";
    foreach my $item (sort keys %config) {
        print FILE "$item: $config{$item}\n"
    }

    # Report on bad_ files read as Hash tables
    print FILE "\n\nBad Hashes from Files:\n\n";
    foreach (qw(Bad_Path Bad_Cancel_Path Bad_Adult_Path Bad_Hosts
                Bad_Hosts_Central)) {
        print FILE "$_:\n";
        if (keys(%$_) > 0) {
            for my $hitem ( sort keys %$_ ) {
                print FILE "$hitem\n";
            };
        } else {
            print FILE "Not Defined\n";
        };
        print FILE "\n";
    };

    # Report on bad_ files read as Regexs
    print FILE "\nBad Regular Expressions from Files:\n\n";
    foreach (qw(Bad_From Bad_Body Bad_Subject Bad_URL Bad_URL_Central)) {
        print FILE "$_:\n$$_\n" if $$_;
        print FILE "$_:\nNot Defined\n\n" if not $$_;
    };

    close FILE;
}

# figure out how many articles per second we're looking at and accepting
# $timer{articles} - how many we've seen since last time
# $timer{accepted} - how many we've accepted since last time
# $timer{time} - time of last check
# $timer{interval} - interval time for this check
# $timer{rate} - articles checked per second during this interval
# $timer{accept_rate} - articles accepted per second during this interval
# $timer{total_rate} - articles checked per second since we've been running
# $timer{total_accept_rate} - art. accepted per second since we've been running
sub timer_stats {
    my $uptime = $now - $Start_Time;

    $timer{interval} = $now - $timer{time} || 1;
    $timer{rate} = (int ($timer{articles} / $timer{interval} * 10)) / 10;
    $timer{accept_rate} = (int ($timer{accepted} / $timer{interval} * 10)) / 10;
    $timer{total_rate} = (int ($status{articles} / $uptime * 10)) / 10;
    $timer{total_accept_rate} = (int ($status{accepted} / $uptime * 10)) / 10;

    $timer{time} = $now;
    $timer{articles} = 0;
    $timer{accepted} = 0;
    return 1;
}

sub trimhashes {
    $MD5history->trim if $MD5history;
    $PHLhistory->trim if $PHLhistory;
    $PHNhistory->trim if $PHNhistory;
    $PHRhistory->trim if $PHRhistory;
    $FSLhistory->trim if $FSLhistory;
    $Suphistory->trim if $Suphistory;
    $MIDhistory->trim;

    # rotate log if necessary
    if ($Do_Log == 1) {
        if (($config{max_log_size} and -s $Log_File > $config{max_log_size})
                or -e $config{rotate_file}) {
            rotate_log();
            unlink $config{rotate_file};
        }
    }       

    $Last_Trim = $now;
}

##############################################################################
# debugging functions to save articles
##############################################################################
sub logart {
    # Output format is controlled at a bit level.
    # Some args are ambiguous, for example if bit 3 (Include Body) is 0 then
    # bits 4 and 5 are ignored.
    # 1(1)   = Include Post Headers
    # 2(2)   = Cleanfeed Internals
    # 3(4)   = Include Body
    # 4(8)   = Truncate Body (On / Off)
    # 5(16)  = Processed Body (Lowercase, Truncated, Base64 Decoded)
    # 6(32)  = Just Posting-Host
    # 7(64)  = Just Newsgroups
    # 8(128) = Just Message-ID
    # 9(256) = Debug Cleanfeed Internals

    my ($file, $info, $format) = @_;
    # Default format value is 15.
    $format ||= 15;

    return if not $config{debug_batch_directory};
    checkrotate("$config{debug_batch_directory}/$file");

    if (not open(LOCAL, ">>$config{debug_batch_directory}/$file")) {
        slog('E', "Cannot open $file: $!");
        return;
    }

    # Begin Header cutmark
    if ($format & 259) {
        print LOCAL "From foo\@bar Thu Jan  1 00:00:01 1970\n";
    };

    # Cleanfeed Internals
    if ($format & 2) {
        print LOCAL "INFO: $info\n" if $info;
        print LOCAL "Score: $score\n" if $score;
        print LOCAL "Binary: $state{cache_is_binary}\n" if $state{cache_is_binary}
            and not $format & 256;
    };

    # Article Headers
    if ($format & 1) {
        foreach (sort keys %hdr) {
            next if $_ eq '__BODY__' or $_ eq '__LINES__';
            print LOCAL "$_: $hdr{$_}\n";
        };
    } else {
        # Just Posting-Host
        print LOCAL "$state{posting_host}\n" if $format & 32;
        # Just Newsgroups
        print LOCAL "$hdr{'Newsgroups'}\n" if $format & 64;
        # Just Message-ID
        print LOCAL "$hdr{'Message-ID'}\n" if $format & 128;
    };

    # Debug Cleanfeed Internals
    if ($format & 256) {
        foreach (sort keys %state) {
            print LOCAL "state{$_}: $state{$_}\n" if $state{$_};
        };
        foreach (sort keys %gr) {
            print LOCAL "gr{$_}: $gr{$_}\n" if $gr{$_};
        };
    };

    # End of headers cutmark
    if ($format & 259) {
        print LOCAL "\n";
    };

    if ($format & 4) {
        # Truncated and processed __BODY__
        if (not $format & 16) {
            # Full, unprocessed body
            print LOCAL "$hdr{__BODY__}\n" if not $format & 8;
            # Truncated, unprocessed body
            print LOCAL substr($hdr{__BODY__}, 0, 4000) . "\n\n"
            if $format & 8 and not is_binary();
            # Make binary even shorter
            print LOCAL substr($hdr{__BODY__}, 0, 320) . "\n\n"
            if $format & 8 and is_binary();
        } else {
            # processed body (Both truncated or not)
            print LOCAL "$body\n\n";
        };
    }; # End of body
    close LOCAL;
    return;
}; # End of logart

sub saveart {
    # We recognise two formatting options:
    # 0: Header and body truncated if over 50 lines (Default)
    # 1: Header and full body regardless of length

    my ($file, $info, $format) = @_;
    $format ||= 0;

    return if not $config{debug_batch_directory};
    checkrotate("$config{debug_batch_directory}/$file");

    if (not open(LOCAL, ">>$config{debug_batch_directory}/$file")) {
        slog('E', "Cannot open $file: $!");
        return;
    }

    # Headers common to all remaining report types.
    print LOCAL "From foo\@bar Thu Jan  1 00:00:01 1970\n";
    print LOCAL "INFO: $info\n" if $info;
    print LOCAL "Score: $score\n" if $score;
    print LOCAL "Binary: $state{cache_is_binary}\n"
        if is_binary();
    foreach (sort keys %hdr) {
        next if $_ eq '__BODY__' or $_ eq '__LINES__';
        print LOCAL "$_: $hdr{$_}\n";
    };

    if ($format == 1) {     # Format 1 - Full message payload.
        print LOCAL "$hdr{__BODY__}\n";
    } elsif ($format == 0) {     # Format 0 - Cropped payload
        print LOCAL substr($hdr{__BODY__}, 0, 3000) . "\n\n";
    } else {    # Undefined format, give up (just headers logged)
        print LOCAL "\n";
    };

    close LOCAL;
    return;
};

# See if batch file is oversized and if so, rotate it
sub checkrotate {
    my ($batchfile) = @_;
    my $num = 1;

    return if not $config{debug_batch_size}
        or -s $batchfile < $config{debug_batch_size};

    $num += 1 while -e "$batchfile.$num";       # Ensure filename is unique
    rename $batchfile, "$batchfile.$num";       # Move it out of the way
}

##############################################################################
# internal state dump and restore
##############################################################################
sub dump_emp {
    return if not $config{emp_dump_file};

    if (not open(DUMP, ">$config{emp_dump_file}")) {
        slog('E', "EMP database could not be dumped: $!");
        return;
    }

    $MD5history->dump('MD5history', \*DUMP) if $MD5history;
    $PHLhistory->dump('PHLhistory', \*DUMP) if $PHLhistory;
    $PHNhistory->dump('PHNhistory', \*DUMP) if $PHNhistory;
    $PHRhistory->dump('PHRhistory', \*DUMP) if $PHRhistory;
    $FSLhistory->dump('FSLhistory', \*DUMP) if $FSLhistory;

    close DUMP;

    slog('N', 'Saved EMP database.');
}

sub restore_emp {
    return if not $config{emp_dump_file} or not -r $config{emp_dump_file};

    do $config{emp_dump_file};

    # delete the data of checks which have been disabled since the last dump
    undef $MD5history if not $config{do_md5};
    undef $PHLhistory if not $config{do_phl};
    undef $PHNhistory if not $config{do_phn};
    undef $PHRhistory if not $config{do_phr};
    undef $FSLhistory if not $config{do_fsl};

    # We can't syslog at startup because INN doesn't provide the callbacks
    # in time
    slog('N', 'Restored EMP database.') if not defined $Start_Time;
}

sub slog {
    return if not defined &INN::syslog;
    INN::syslog(@_);
}

##############################################################################
# parse the data files
##############################################################################
sub read_hashes {
    read_hash('bad_paths', \%Bad_Path);
    read_hash('bad_cancel_paths', \%Bad_Cancel_Path);
    read_hash('bad_adult_paths', \%Bad_Adult_Path);
    read_hash('bad_hosts', \%Bad_Hosts);
    read_hash('bad_hosts_central', \%Bad_Hosts_Central);

    # Bad From Headers
    read_regex('bad_from', \$Bad_From);
    $Bad_From_RE = qr/($Bad_From)/i if $Bad_From;
    # Bad Subject Headers
    read_regex('bad_subject', \$Bad_Subject);
    $Bad_Subject_RE = qr/($Bad_Subject)/i if $Bad_Subject;
    # Bad Body
    read_regex('bad_body', \$Bad_Body);
    $Bad_Body_RE = qr/($Bad_Body)/ if $Bad_Body;
    # Bad URL's in Body
    read_regex('bad_url', \$Bad_URL);
    $Bad_URL_RE = qr/$HTTP\S*($Bad_URL)/i if $Bad_URL;
    # Bad URL's in Body (Central Resource)
    read_regex('bad_url_central', \$Bad_URL_Central);
    $Bad_URL_Central_RE = qr/$HTTP\S*($Bad_URL_Central)/i if $Bad_URL_Central;
};

sub read_hash {
    my ($file, $hash) = @_;

    my @list;
    read_file("$config_dir/$file", \@list);
    %$hash = map { $_ => 1 } @list;
}

sub read_regex {
    my ($file, $regex) = @_;

    my @list;
    read_file("$config_dir/$file", \@list);
    $$regex = join('|', @list);
    $$regex =~ s#\|\|#|#g;
}

sub read_file {
    my ($file, $array) = @_;

    return if not -e $file;
    if (not open(FILE, $file)) {
        slog('E', "Cannot open $file: $!");
        return;
    }
    while (<FILE>) {
        s/#.*//;
        s/^$hws*(.*?)$hws*$/$1/;
        next if /^$/;
        if (/\s/) {
            push @$array, split;
        } else {
            push @$array, $_;
        }
    }
    close FILE;
}

sub messageid_re {
    my $mdtext = '[\x21-\x3d\x3f\x41-\x5a\x5e-\x7e]+';
    my $nofoldliteral = '\[' . $mdtext . '\]';
    my $idright = '(?:' . $mdtext . '|' . $nofoldliteral . ')';
    my $idleft = $mdtext;
    my $msgidcore = $idleft . '\@' . $idright;
    my $msgid = '<' . $msgidcore . '>';
    my $messageid = '^[\x20\x09]*' . $msgid . '[\x20\x09]*$';
    my $messageidre = qr/$messageid/;
    return $messageidre;
};

print $fullURL if 0; # lint food

##############################################################################
# EMP filters
##############################################################################
package Cleanfeed::RateLimit;

use strict;

sub new {
    my $class = shift;
    my $self = {
        ratecutoff => 4,    # reject if this many copies are in the history
        rateceiling => 85,  # only count this high
        ratebaseinterval => 7200, # how long to wait before decrementing count
        history => { },
    };
    bless $self, $class;
    return $self;
}

sub init {
    my ($self, $rco, $rc, $rb) = @_;
    $self->{ratecutoff} = $rco if defined $rco;
    $self->{rateceiling} = $rc if defined $rc;
    $self->{ratebaseinterval} = $rb if defined $rb;

    $self->{dectable} = $self->make_curve_table($self->{rateceiling} + 1,
        $self->{ratebaseinterval});
}

# return true if over ratecutoff
sub add {
    my ($self, $elem) = @_;

    $self->{history}->{$elem}[0] = 0 if not exists $self->{history}->{$elem};
    $self->{history}->{$elem} = [ $self->{history}->{$elem}[0] + 1, time ];
    $self->{history}->{$elem}[0] = $self->{rateceiling}
        if $self->{history}->{$elem}[0] > $self->{rateceiling};

    return 1 if $self->{history}->{$elem}[0] > $self->{ratecutoff};
    return 0;
}

sub add2 {
    my ($self, $elem, $ratecutoff) = @_;

    $self->{history}->{$elem}[0] = 0 if not exists $self->{history}->{$elem};
    $self->{history}->{$elem} = [ $self->{history}->{$elem}[0] + 1, time ];
    $self->{history}->{$elem}[0] = $self->{rateceiling}
        if $self->{history}->{$elem}[0] > $self->{rateceiling};

    return 1 if $self->{history}->{$elem}[0] > $ratecutoff;
    return 0;
}

sub trim {
    my ($self) = @_;
    my $now = time;

    my @del;
    while (my ($id, $val) = each %{$self->{history}}) {
        if ($now - $val->[1] > $self->{dectable}->[$val->[0]]) {
            $self->{history}->{$id}[0]--;
            $self->{history}->{$id}[1] = $now;
        }
        push @del, $id if $self->{history}->{$id}[0] < 1;
    }
    delete @{$self->{history}}{@del};
}

sub count {
    my ($self) = @_;
    return scalar keys %{$self->{history}};
}

sub overflowed {
    my ($self) = @_;
    my $count = 0;

    foreach (keys %{$self->{history}}) {
        $count++ if $self->{history}->{$_}[0] > $self->{ratecutoff};
    }
    return $count;
}

sub dump {
    my ($self, $name, $fd) = @_;

    my $dd = Data::Dumper->new([ $self->{history} ], [ $name.'->{history}' ]);
    $dd->Indent(1);
    print $fd $dd->Dumpxs;
}

sub items {
    my ($self) = @_;

    return {
        map { $_ => @{$self->{history}->{$_}}[0] } keys %{$self->{history}}
    };
}

# Create a lookup table of values on a descending curve
sub make_curve_table {
    my ($self, $xmax, $ymax) = @_;
    my @values;

    for (1..$xmax) {
        $values[$_] = $ymax - int((($_ / $xmax) ** 2) * $ymax);
    }
    return \@values;
}

##############################################################################
package Cleanfeed::Queue;

sub new {
    my $class = shift;
    my $self = {
        maxlife => 3600,
        history => { },
    };
    bless $self, $class;
    return $self;
}

sub add {
    my ($self, $elem) = @_;

    $self->{history}->{$elem} = time;
}

sub check {
    my ($self, $elem) = @_;

    return 1 if exists $self->{history}->{$elem};
    return 0;
}

sub count {
    return scalar keys %{$_[0]->{history}};
}

sub maxlife {
    my $self = $_[0];
    $self->{maxlife} = $_[1] if $_[1];
    $self->{maxlife} = $_[1];
}

sub trim {
    my ($self) = @_;
    my $now = time;

    my @del;
    while (my ($id, $val) = each %{$self->{history}}) {
        push @del, $id if $now - $val > $self->{maxlife};
    }
    delete @{$self->{history}}{@del};
}

1;
