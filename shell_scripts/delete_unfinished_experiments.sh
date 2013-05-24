# deletes experiments that don't have the folder 
# "SD_card_contents" or .daq files.
#
# takes one argument, a folder protocol_name containing
# protocol_name/{genotype_names}/{experiment_folders}

# check if it is a directory
if [ -d  $1 ]
then
#    genotype_folders= 1 2 3 
    for {genotype_folder , !ls :wq 
    do
        echo "$genotype_folder"
    done
else
    echo "$1 is not a directory!"
fi

echo "Moving empty experiments to ~/.Trash"
