0. Make conda environment:
```
conda create -n genome_polish -y
conda activate genome_polish
mamba install -c bioconda pbmm2 bwa samtools sambamba snakemake -y
```

1. Index the unpolished genome using bwa index 
```bwa index <<genome.fa>```

2. Run the first iteration of snakemake 
```sbatch pilon.sh```

3. Generation of first pilon1.fasta file. However, it generates a file called pilon1.fasta.fasta. So I had to keep renaming it to pilon1.fasta. 

4. Index pilon1.fasta using bwa index. Change the "ref" object in snakefile to pilon1.fasta. Repeat the same process again. 


