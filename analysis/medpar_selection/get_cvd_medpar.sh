#!/bin/bash

job_directory=$PWD/.job
mkdir -p .job
mkdir -p .out
mkdir -p ../../data/cvd

job_file="${job_directory}/make_diags.job"

echo "#!/bin/bash
#SBATCH --job-name=make_diags
#SBATCH -c 4 
#SBATCH -p serial_requeue 
#SBATCH --mem=10GB
#SBATCH --time=1-00:00
#SBATCH --output=.out/diag_%a.out
#SBATCH --error=.out/diag_%a.err
#SBATCH --qos=normal
#SBATCH --mail-type=END
#SBATCH --mail-user=anatrisovic@g.harvard.edu

module load python/3.8.5-fasrc01

python select_cvd.py" > $job_file 

sbatch $job_file