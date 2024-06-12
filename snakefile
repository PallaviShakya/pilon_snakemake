# Define the configuration
configfile: "config.yaml"

# Define the range of iterations
NUM_ITERATIONS = 6  # Define how many iterations you want

# Rule all for final output
rule all:
    input:
        expand("pilon{version}.fasta", version=range(1, NUM_ITERATIONS + 1))


# Initial alignment rule for the draft genome
rule align_reads_draft:
    input:
        ref=config["p5"],
        reads1=config["reads1"],
        reads2=config["reads2"]
    output:
        sam="NGS0.sam"
    threads: config["threads"]
    shell:
        "bwa mem -t {threads} {input.ref} {input.reads1} {input.reads2} > {output.sam}"

# Subsequent rules to process the output of the previous iteration
rule process_genome:
    input:
        ref=lambda wildcards: f"pilon{int(wildcards.version) - 1}.fasta" if int(wildcards.version) > 1 else config["ref"],
        reads1=config["reads1"],
        reads2=config["reads2"]
    output:
        fasta="pilon{version}.fasta",
        bam="NGS_aligned{version}.bam",
        bai="NGS_aligned{version}.bam.bai"
    threads: config["threads"]
    shell:
        """
        echo "Processing version {wildcards.version}"
        echo "Reference: {input.ref}"
        bwa mem -t {threads} {input.ref} {input.reads1} {input.reads2} | samtools sort -@ {threads} -O bam -o {output.bam}
        samtools index -@ {threads} {output.bam}
        sambamba markdup -t {threads} {output.bam} NGS_aligned{wildcards.version}_marked.bam
        mv NGS_aligned{wildcards.version}_marked.bam {output.bam}
        samtools index -@ {threads} {output.bam}
        java -Xmx205G -jar /group/siddiquegrp/tools/pilon-1.23.jar --threads {threads} --genome {input.ref} --frags {output.bam} --fix snps,indels --changes --output {output.fasta}
        """