TMPDIR=./tmp
MONODIX_2=../../apertium-hbs-eng.hbs.dix
MONODIX_1=../../apertium-hbs-eng.eng.dix

if [[ $1 = "1" ]]; then
mkdir -p $TMPDIR
echo "==English->BCMS===========================";
#bash inconsistency.sh eng-hbs_SR > $TMPDIR/eng-hbs_SR.testvoc; bash inconsistency-summary.sh $TMPDIR/eng-hbs_SR.testvoc eng-hbs_SR $MONODIX_1
bash inconsistency.sh eng-hbs_HR > $TMPDIR/eng-hbs_HR.testvoc; bash inconsistency-summary.sh $TMPDIR/eng-hbs_HR.testvoc eng-hbs_HR $MONODIX_1
echo ""

elif [[ $1 = "2" ]]; then
mkdir -p $TMPDIR
echo "==BCMS->English===========================";
bash inconsistency.sh hbs-eng > $TMPDIR/hbs-eng.testvoc; bash inconsistency-summary.sh $TMPDIR/hbs-eng.testvoc hbs-eng $MONODIX_2

elif [[ $1 = "cnjcoo" ]]; then
mkdir -p $TMPDIR
echo "==BCMS->English, cnjcoo===================";
bash inconsistency-cnjcoo.sh hbs-eng > $TMPDIR/hbs-eng-cnjcoo.testvoc; bash inconsistency-summary-cnjcoo.sh $TMPDIR/hbs-eng-cnjcoo.testvoc hbs-eng $MONODIX_2

elif [[ $1 = "cnjsub" ]]; then
mkdir -p $TMPDIR
echo "==BCMS->English, cnjsub===================";
bash inconsistency-cnjsub.sh hbs-eng > $TMPDIR/hbs-eng-cnjsub.testvoc; bash inconsistency-summary-cnjsub.sh $TMPDIR/hbs-eng-cnjsub.testvoc hbs-eng $MONODIX_2

elif [[ $1 = "ij" ]]; then
mkdir -p $TMPDIR
echo "==BCMS->English, ij=======================";
bash inconsistency-ij.sh hbs-eng > $TMPDIR/hbs-eng-ij.testvoc; bash inconsistency-summary-ij.sh $TMPDIR/hbs-eng-ij.testvoc hbs-eng $MONODIX_2

else
    echo
    echo "Usage:"
    echo
    echo "English -> BCMS: " $0 "1"
    echo "BCMS -> English: " $0 "2"
    echo
fi

# Cleanup
rm $TMPDIR/*.tmp
