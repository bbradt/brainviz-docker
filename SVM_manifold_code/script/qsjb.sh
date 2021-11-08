for i in SC AU SM VI CC DM
do
cd ${i}
qsub job${i}12
qsub job${i}99
cd ..
done
