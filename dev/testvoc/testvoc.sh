TMPDIR=./tmp

if [[ $1 = "1" ]]; then
mkdir -p $TMPDIR
echo "==English->BCMS===========================";
bash inconsistency.sh eng-hbs_SR > $TMPDIR/eng-hbs_SR.testvoc; bash inconsistency-summary.sh $TMPDIR/eng-hbs_SR.testvoc eng-hbs_SR
bash inconsistency.sh eng-hbs_HR > $TMPDIR/eng-hbs_HR.testvoc; bash inconsistency-summary.sh $TMPDIR/eng-hbs_HR.testvoc eng-hbs_HR
echo ""

elif [[ $1 = "2" ]]; then
mkdir -p $TMPDIR
echo "==BCMS->English===========================";
bash inconsistency.sh hbs-eng > $TMPDIR/hbs-eng.testvoc; bash inconsistency-summary-parallel.sh $TMPDIR/hbs-eng.testvoc hbs-eng

else
    echo
    echo "Usage:"
    echo
    echo "English -> BCMS: " $0 "1"
    echo "BCMS -> English: " $0 "2"
    echo
fi
