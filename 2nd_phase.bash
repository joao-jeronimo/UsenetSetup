
#export BACKDIR=`mktemp --tmpdir="$HOME" -d`
export BACKDIR="./backups/"
mkdir -p "$BACKDIR"

#git clone https://github.com/crooks/cleanfeed.git Cleanfeed-git

mkdir /opt/inn2/etc/cleanfeed/
cp Cleanfeed-git/samples/* /opt/inn2/etc/cleanfeed/
cp /opt/inn2/bin/filter/filter_innd.pl "$BACKDIR"/filter_innd.pl
cp Cleanfeed-git/cleanfeed /opt/inn2/bin/filter/filter_innd.pl

# Verificação de sintaxe:
perl -wc /opt/inn2/bin/filter/filter_innd.pl
perl -wc /opt/inn2/etc/cleanfeed/cleanfeed.local

git add .

echo "Caso não haja erros, executar:"
echo "sudo ctlinnd reload filter.perl meow"
git status
echo 'git commit -m "New files update"'


