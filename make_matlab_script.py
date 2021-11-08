
def make_matlab_script(output_file, dataset, labels,test_dataset, test_labels, modality, folds, percent_voxels, output_directory):
    COMMAND = "main.m "
    COMMAND += " --dataset {dataset} ".format(dataset=dataset)
    COMMAND += " --labels {labels} ".format(labels=labels)
    COMMAND += " --dataset_test {test_dataset} ".format(test_dataset=test_dataset)
    COMMAND += " --labels_test {test_labels} ".format(test_labels=test_labels)
    COMMAND += " --modality {modality} ".format(modality=modality)
    COMMAND += " --folds {folds} ".format(folds=folds)
    COMMAND += " --percent {percent_voxels} ".format(percent_voxels=percent_voxels)
    COMMAND += " --outpath {output_directory} ".format(output_directory=output_directory)
    with open(output_file, "w") as file:
        file.write(COMMAND)