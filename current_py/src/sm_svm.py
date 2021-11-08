import numpy as np
import glob
import scipy.io as sio
import os 
from sklearn.model_selection import PredefinedSplit, GridSearchCV
from sklearn.svm import SVC
from sklearn import preprocessing
from joblib import Parallel, delayed
import itertools
from scipy.linalg import svdvals
from sklearn.metrics import classification_report, confusion_matrix
from scipy.linalg import fractional_matrix_power

def select_ics( domains ):
    # todo implement domain selection step
    return [ [2], [1], [6], [3], [5], [7] ]

def load_osuch_data( domains, selected_ics, train=True ):
    # the ICA subjects in SVM_manifold_code/output/op99/ are arranged s.t.
    # first 32 subjects are BP, next 34 are MD (and the rest are NC)
    # test/unknown are in op12
    n_bp = 32
    n_mdd = 34
    n_unknown = 12
    n_domains = len( domains )
    n_voxels = 63312
   
    print( 'set number of subjects' )
    if train:
        n_sub = n_bp + n_mdd
        # training labels 
        y = np.vstack( ( np.zeros((n_bp, 1)), np.ones((n_mdd, 1)) ) ).ravel()
        data_path = '../../SVM_manifold_code/output/{}/op99'
    else:
        n_sub = n_unknown
        y = np.array( [1, 2, 1, 2, 1, 1, 2, 2, 1, 2, 2] ) - 1
        data_path = '../../SVM_manifold_code/output/{}/op12'

    print( 'create the empty X matrix' )
    sm_ = np.zeros((n_sub, n_domains, n_voxels))

    print( 'read data' )
    # todo make parallel
    for idx, ii in enumerate( domains ):
        print('loading domain', ii, 'train', train)
        ics = np.array( selected_ics[ idx ] ) - 1
        for jj in range( n_sub ):
            # print( 'loading subject', jj )
            f_ = glob.glob( data_path.format( ii ) + '/*_ica_c{}-1.mat'.format( jj+1 ) )
            dat_ = sio.loadmat( f_[0] )
            sm_[jj, idx, :] =  dat_['ic'][ ics, : ]
    
    print( 'check' )
    if train == True:
        t1 = sio.loadmat( '../../SVM_manifold_code/output/DM/op99/opDM99_ica_c34-1.mat' )
        assert np.all( np.equal( sm_[33, 2, :], t1['ic'][5,:] ) )

    return sm_, y

def normalize_( X ):
    ret_ = np.matmul( X.T, X )
    ret_ = fractional_matrix_power(ret_, -0.5)
    ret_ = np.matmul(X, ret_)
    return ret_

def reimann_distance( X, Y ):
    nic = X.shape[1]
    svd_ = svdvals( np.matmul(X.T, Y) )
    svd_ = np.square( svd_ )
    svd_ = np.sum( svd_ )
    svd_ = svd_ / nic
    svd_ = np.sqrt( svd_ )
    svd_ = np.real( svd_ )
    return svd_

def reimann_kernel( X, Y ):
    nsub_X = X.shape[0]
    nsub_Y = Y.shape[0]

    if np.ndim( X ) == 2:
        # normalize
        ss =preprocessing.StandardScaler( with_std=False )
        X = ss.fit_transform( X.T )
        ss =preprocessing.StandardScaler( with_std=False )
        Y = ss.fit_transform( Y.T )

        # for 2D case kernel is simply the dot product
        dist_ = np.dot(X.T, Y.T)

    elif np.ndim( X ) == 3:
        # normalize
        t1 = Parallel(n_jobs=1)( delayed( normalize_ )( X[i, :, :].T ) for i in range( nsub_X ) )
        X = np.stack(t1)
        t1 = Parallel(n_jobs=1)( delayed( normalize_ )( Y[i, :, :].T ) for i in range( nsub_Y ) )
        Y = np.stack(t1)

        # use projection matrix to compute distance
        # create tuples of pairwise indices of subjects in train(X) and test(Y) set
        idx_ = [(i, j) for i in range(nsub_X) for j in range(nsub_Y)]
        vals_ = Parallel(n_jobs=1)( delayed( reimann_distance )( X[i, :, :], Y[j, :, :] ) for (i,j) in idx_ )
        dist_ = np.zeros( (nsub_X, nsub_Y) )
        for jj in range( len(idx_) ):
            dist_[ idx_[jj] ] = vals_[jj]
        
        dist_ = np.tanh( dist_ )

    return dist_

def load_sm( domains, selected_ics, dataset ):
    if dataset == 'osuch':
        print( 'load osuch data- BP/MDD' )
        X_train, y_train = load_osuch_data( domains=domains, selected_ics=selected_ics, train=True )
        print( 'load osuch data- unknown' )
        X_test, y_test = load_osuch_data( domains=domains, selected_ics=selected_ics, train=False )

    return X_train, X_test, y_train, y_test

def load_osuch_folds():
    t1 = sio.loadmat( '../../SVM_manifold_code/support/indices.mat' )
    return PredefinedSplit( t1['indices'].ravel() )

if __name__ == "__main__":
    n_cpus = int( os.getenv('SLURM_CPUS_PER_TASK') )
    # n_cpus = 1

    print( 'domain selection step' )
    domains = ['AU','CC','DM','SC','SM','VI']
    selected_ics = select_ics( domains )

    print( 'load spatial maps' )
    # X_train, X_test, y_train, y_test = load_sm( domains, selected_ics=selected_ics, dataset='osuch' )

    print( 'load predefined folds' )
    cv = load_osuch_folds()

    svc = SVC( kernel=reimann_kernel )
    param_grid = {'C': [10], 'gamma': [1]}
    clf = GridSearchCV( svc, param_grid, cv=cv, n_jobs=n_cpus, verbose=5 )
    fit_result = clf.fit( X_train, y_train )
    print( 'best CV score', fit_result.best_score_ )

    y_pred = clf.predict( X_test )
    # one of the unknown samples does not have true label
    y_pred = np.delete(y_pred, 4)
    rep_ = classification_report(y_test, y_pred, output_dict=True)
    print( 'Test score', rep_.get('accuracy') )

