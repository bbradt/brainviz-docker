Abstract
This project arranges ICs  computed by GIFT into six functional domains, including the sub-cortical (SC), 
auditory (AU), sensorimotor (SM), visual (VI), cognitive control (CC) and default mode (DM) domains. 
In each domain, we use forward selection to choose the best IC based on the accuracy on the 
training data. Then we integrate these ICs together to train a SVM classifier and predict test data.

Requirements
This project uses GIFT toolbox and libsvm toolbox. 

Structure
The structure of main.m is as follows:
main.m   # integrate ICs chosen from six domains, and train a SVM classifier by 10-fold cross-validation
├── domain_selection  # select the best IC from each domain
 |        ├──get_ica_comp  # load data
 |        ├──get_ica_comp_validation   #load data for validation
 |        ├──forward_svm     # SVM classifier
 |        ├    ├──svm_manifold
 |        ├──svm_manifold_pd    # predict by SVM