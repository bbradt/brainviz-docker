# first gather the accuracy values then execute this Rscript

# then run the following 
d<-scan("stdin", quiet=TRUE)
cat( paste('min: ', min(d)), 
    paste('max: ', max(d)), 
    paste('median: ', median(d)), 
    paste('mean: ', mean(d), '±', sd(d)), sep="\n")