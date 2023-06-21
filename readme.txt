If running snakemake in a SRUN use this commad to test-run script (specify the number of threads/cores you have in srun):

snakemake -s pop_wgs_starter.smk --use-conda --cores XX --latency-wait 30 -k -n

To run the script for real, do so without the '-n'


snakemake      calls the program
-s	       the path (location/name) to snakefile/script
--use-conda    is required to have programs run in conda enviornments where they are installed
--cores        specify the number of threads snakemake has to work with
--latency-wait increases waittime when looking for file to complete (helpful when lots of things runing at once)
-k             keep going, on to other tasks even if a few failed (e.g. a sample had inadequate amount of sequence to make an assembly)
-n             dry-run, to test the snakefile script is in working order before running

other helpful flags (can use 'snakemake --help' for menu)
-p             prints the shell commands that snakemake will run
--jobs         can be alternative to --cores if indiviual jobs are not managed by "threads" parameter (non-specified default = 1 thread per job)
--rerun-incomplete used if failures occur and script is re-run. 
