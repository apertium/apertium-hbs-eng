TMPDIR=./tmp
PAIR=hbs-eng
LANGDIR=../..

function inconsistencies {

    mkdir -p $TMPDIR

    SOURCE=$1
    TARGET=$2
    VARIANT=$3

    lt-expand $LANGDIR/apertium-$PAIR.$SOURCE.dix \
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
}

if [[ $1 = "eng-hbs_HR" ]]; then
    inconsistencies eng hbs _HR
elif [[ $1 = "eng-hbs_SR" ]]; then
    inconsistencies eng hbs _SR
elif [[ $1 = "hbs-eng" ]]; then
    inconsistencies hbs eng
else
    echo "bash inconsistency.sh <direction>";
fi
