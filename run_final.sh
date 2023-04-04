#!/bin/bash

job_directory=$PWD/.job
mkdir -p .job
mkdir -p .out

job_file="${job_directory}/final_merge.job"

echo "#!/bin/bash
#SBATCH --job-name=final_merge
#SBATCH -c 4 
#SBATCH -p serial_requeue 
#SBATCH --mem=250GB
#SBATCH --time=1-00:00
#SBATCH --output=.out/final_%a.out
#SBATCH --error=.out/final_%a.err
#SBATCH --qos=normal
#SBATCH --mail-type=END
#SBATCH --mail-user=laurenflynn@hsph.harvard.edu

module load R/4.0.2-fasrc01
export R_LIBS_USER=\$HOME/apps/R_4.0.2
Rscript structuring_final_data.R" > $job_file 

sbatch $job_file