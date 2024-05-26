#!/bin/bash

set -e

PERL_VERSION=${VERSION:-"5.38.2"}
USERNAME="vscode"

git clone https://github.com/tagomoris/xbuild.git
xbuild/perl-install $PERL_VERSION /usr/local

# Install development modules
mirrors=(
    "--mirror http://cpan.metacpan.org/"
    "--mirror ftp://ftp.yz.yamagata-u.ac.jp/pub/lang/cpan/"
    "--mirror ftp://ftp.riken.jp/lang/CPAN/"
    "--mirror ftp://ftp.kddilabs.jp/CPAN/"
    "--mirror ftp://ftp.jaist.ac.jp/pub/CPAN/"
)
export PERL_CPANM_OPT="${mirrors[*]}"

cpanm Perl::LanguageServer Perl::Critic Perl::Tidy App::perlimports
cpanm XMLRPC::Lite --force --notest
cpanm XML::LibXML --notest
cpanm Alien::Libxml2 --notest
cpanm --notest \
    DBI \
    DBD::mysql \
    Digest::SHA \
    Task::Plack \
    XMLRPC::Transport::HTTP::Plack \
    HTML::Parser \
    SOAP::Lite \
    List::Util \
    Storable \
    IO::Uncompress::Gunzip \
    XML::SAX \
    Digest::SHA1 \
    IO::Socket::SSL \
    Net::SSLeay \
    Safe \
    XML::Parser \
    Time::HiRes \
    Mozilla::CA \
    XML::LibXML::SAX \
    Cache::File \
    File::Temp \
    Imager \
    IPC::Run \
    Crypt::DSA \
    MIME::Base64 \
    XML::Atom \
    Cache::Memcached \
    Archive::Tar \
    IO::Compress::Gzip \
    Archive::Zip \
    Net::SMTP \
    Authen::SASL \
    Digest::MD5 \
    Text::Balanced \
    XML::SAX::ExpatXS \
    XML::SAX::Expat

cat << '__END__' >> /home/vscode/.bashrc
# perl
eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib)"
export PATH="$HOME/workspace/local/lib/perl5/bin:$HOME/perl5/lib/perl5/bin:$PATH"

mirrors=(
    "--mirror ftp://ftp.riken.jp/lang/CPAN/"
    "--mirror http://cpan.metacpan.org/"
    "--mirror ftp://ftp.yz.yamagata-u.ac.jp/pub/lang/cpan/"
    "--mirror ftp://ftp.kddilabs.jp/CPAN/"
    "--mirror ftp://ftp.jaist.ac.jp/pub/CPAN/"
)
export PERL_CPANM_OPT="${mirrors[*]}"
export PERL_CARTON_MIRROR="ftp://ftp.riken.jp/lang/CPAN/"
export PERL5LIB="$HOME/workspace/local/lib/perl5:$PERL5LIB"
__END__

mkdir /home/$USERNAME/perl5
chown -R $USERNAME.$USERNAME /home/$USERNAME/perl5


