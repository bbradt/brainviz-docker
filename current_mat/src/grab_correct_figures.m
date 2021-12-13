function grab_correct_figures(output_directory, test_path)
    IC_CSV = readcell('neuromark_ic_labels.csv');
    BEST_CSV = readcell('best_ic_chart.csv');
    our_row = BEST_CSV{1, :};
    for i = 2:length(our_row)
        comp = our_row{i};
        number = extractBetween(comp, '(', ')');
        for j = 1:size(IC_CSV, 1)
            comp_number = IC_CSV{j};
            if number == comp_number
                break;
            end
        end
        realI = i - 1;
        IMG_PATH = [test_path '/gica_cmd_gica_results/mean_comp' num2str(realI, '%03.f')];
        IMG_OUT = [OUT_PATH '/figures/mean_comp' num2str(realI, '%03.f')]
        if not(isfolder([test_path, '/figures']))
            mkdir([test_path, '/figures']);
        end
        copyfile(IMG_PATH, IMG_OUT);
        disp(IMG_OUT);
    end

end