function grab_correct_figures(output_directory, test_path)
    IC_CSV = readcell('neuromark_ic_labels.csv');
    BEST_CSV = readcell('best_ic_chart.csv');
    our_row = BEST_CSV(2, :);
    for i = 3:length(our_row)
        comp = our_row{i};
        number = extractBetween(comp, '(', ')');
        number = str2num(number{:});
        for j = 1:size(IC_CSV, 1)
            comp_number = IC_CSV{j};
            if number == comp_number
                break;
            end
        end
        realI = j;
        IMG_PATH = [test_path '/gica_cmd_gica_results/mean_comp_' num2str(realI, '%03.f') '.png'];
        IMG_OUT = [output_directory '/figures/mean_comp_' num2str(realI, '%03.f') '.png'];
        if not(isfolder([output_directory, '/figures']))
            mkdir([output_directory, '/figures']);
        end
        copyfile(IMG_PATH, IMG_OUT);
        disp(IMG_OUT);
    end

end