import sys
from nipype.interfaces import gift   

def make_matlab_script(output_file, dataset, labels,test_dataset, output_directory):
    COMMAND = "main_test_only.m "
    COMMAND += " --dataset {dataset} ".format(dataset=dataset)
    COMMAND += " --labels {labels} ".format(labels=labels)
    COMMAND += " --dataset_test {test_dataset} ".format(test_dataset=test_dataset)
    COMMAND += " --modality {modality} ".format(modality=modality)
    COMMAND += " --outpath {output_directory} ".format(output_directory=output_directory)
    COMMAND += "\n"
    with open(output_file, "w") as file:
        file.write(COMMAND)

def make_and_run(output_file, dataset, labels, test_dataset, output_directory):
    matlab_cmd = '/app/groupicatv4.0b/GroupICATv4.0b_standalone/run_groupica.sh /usr/local/MATLAB/MATLAB_Runtime/v91/'
    gift.evalGIFTCommand.set_mlab_paths(matlab_cmd=matlab_cmd, use_mcr=True)
    ec = gift.evalGIFTCommand()
    make_matlab_script(output_file, dataset, labels, test_dataset, output_directory)
    ec.inputs.file_name = output_file
    ec.run()

if __name__=="__main__":
    make_and_run("test.m", sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4])