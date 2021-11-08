import glob
import pandas as pd
import os

csv_file = '../data/Copy2-MRN_SubjectList_DeIdentified_05-13-16.csv'
out_file = '../results/harmonized_data.csv'
df = pd.read_csv( csv_file )
preproc_dir = '/data/analysis/collaboration/NeuroMark/Data/OSUCH/PrepData_backup/'

print( 'Checking if each row in csv exists in the file system' )
for ii, row in df.iterrows():
    path_ = os.path.join( preproc_dir, row.preproc_dir, row.MRN_ID )
    exist_ = os.path.isdir( path_ )
    if not exist_:
        print( 'Found {} missing from file system, setting Used=0'.format( row.MRN_ID ) )
        df.at[ii,'Used'] = 0

print( 'Checking if each dir in the file system exists in csv' )
for ff in df.preproc_dir.unique():
    for path_ in glob.glob( os.path.join( preproc_dir, ff, '*' ) ):
        id_ = os.path.basename( path_ )
        if not id_ in df.MRN_ID.values:
            print( 'Found {} missing from csv, adding missing row'.format( id_ ) )
            # get diagnosis
            diag_ = id_.split('_')[0]
            used_ = 1
            if diag_ == 'UK':
                diag_ = ''
                used_ = 0
            df = df.append({'MRN_ID': id_,
                        'Diagnosis': diag_,
                        'Used': used_,
                        'preproc_dir': ff}, ignore_index=True)

df.to_csv( out_file, index=False )


