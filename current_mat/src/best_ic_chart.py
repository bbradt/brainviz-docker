import pandas as pd 

neuromark_ics = '../results/neuromark_ic_labels.csv'
neuromark_ics = pd.read_csv( neuromark_ics, header=None )
# print( neuromark_ics )

ic_stats_files = [
    '../results/line2.txt',
    '../results/line5.txt',
    '../results/line6.txt',
    '../results/line7.txt',
    '../results/line8.txt'
]

domains = pd.unique( neuromark_ics[1] )
print( domains )

# grab IC names
nm_labels_path = '../results/neuromark_ic_labels.csv'
nm_labels = pd.read_csv( nm_labels_path, header=None )

df = pd.DataFrame( columns=domains )
for ff in ic_stats_files:
    ic_stats = pd.read_fwf(ff, header=None)
    print( 'processing', ff )
    row_ = []
    for dd in domains:
        t1 = ic_stats[ ic_stats[4] == dd+':' ]
        t2 = neuromark_ics[ neuromark_ics[1] == dd ].reset_index( drop=True )
        idx = t1[ t1[0] == t1[0].max() ][5].item() - 1
        ic_ = t2.at[idx, 0]
        label_ = nm_labels[ nm_labels[0] == ic_ ][2].item()
        # print( t1, t2, ic_, t1[0].max(), 'times' )
        print( dd, ic_, t1[0].max(), 'times' )
        # row_.append( label_ + ' (' + str(ic_) + ')' )
        row_.append( label_ )
        # break
    df = pd.concat( [ df, pd.DataFrame( [row_], columns=domains ) ] )
    df = df.reset_index(drop=True)

df.to_csv('../results/best_ic_chart.csv')