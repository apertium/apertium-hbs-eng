TMPDIR=./tmp
PAIR=hbs-eng
LANGDIR=../..

DIRECTION=$1
PATTERN=$2

if [ -z $DIRECTION ] && [ -Z $PATTERN ]; then
    echo
    echo "Usage:"    
    echo "  bash $0 <direction>";
    echo "  bash $0 <direction> <pattern>";
    echo
    echo "Example:"
    echo "  bash $0 eng-hbs_HR"
    echo "  bash $0 eng-hbs_HR '<np>'"
    echo
    exit
fi

if [[ $DIRECTION = "eng-hbs_HR" ]]; then
    SOURCE="eng"
    TARGET="hbs"
    VARIANT="_HR"
elif [[ $DIRECTION = "eng-hbs_SR" ]]; then
    SOURCE="eng"
    TARGET="hbs"
    VARIANT="_SR"
elif [[ $DIRECTION = "hbs-eng" ]]; then
    SOURCE="hbs"
    TARGET="eng"
else
    echo
    echo "Unknown direction: $DIRECTION";
    echo
    exit
fi

mkdir -p $TMPDIR

if [ -z $PATTERN ]; then
    lt-expand $LANGDIR/apertium-$PAIR.$SOURCE.dix | grep "$PATTERN" > monodix.expanded.tmp
else
    lt-expand $LANGDIR/apertium-$PAIR.$SOURCE.dix > monodix.expanded.tmp
fi

#lt-expand $LANGDIR/apertium-$PAIR.$SOURCE.dix \
cat monodix.expanded.tmp \
    | grep -v 'REGEX' \
    | grep -e ':>:' -e '\w:\w' \
    | sed 's/:>:/%/g' \
    | sed 's/:/%/g' \
    | cut -f2 -d'%' \
    | sed 's/^/^/g' \
    | sed 's/$/$ ^.<sent>$/g' \
    | tee $TMPDIR/tmp_testvoc_analysis.txt \
    | apertium-pretransfer \
    | lt-proc -b $LANGDIR/$SOURCE-$TARGET.autobil.bin \
    | apertium-transfer -b $LANGDIR/apertium-$PAIR.$SOURCE-$TARGET.t1x  $LANGDIR/$SOURCE-$TARGET.t1x.bin \
    | apertium-interchunk $LANGDIR/apertium-$PAIR.$SOURCE-$TARGET.t2x  $LANGDIR/$SOURCE-$TARGET.t2x.bin \
    | apertium-postchunk $LANGDIR/apertium-$PAIR.$SOURCE-$TARGET.t3x  $LANGDIR/$SOURCE-$TARGET.t3x.bin \
    | tee $TMPDIR/tmp_testvoc_transfer.txt \
    | lt-proc -d $LANGDIR/$SOURCE-$TARGET$VARIANT.autogen.bin > $TMPDIR/tmp_testvoc_generation.txt

paste -d _ $TMPDIR/tmp_testvoc_analysis.txt $TMPDIR/tmp_testvoc_transfer.txt $TMPDIR/tmp_testvoc_generation.txt \
    | sed 's/\^.<sent>\$//g' \
    | sed 's/_/   --------->  /g'
