rule run_all_of_me:
    input: "output/all.cmp.matrix.png"
    

rule download_genomes:
    output: f1="raw_data/1.fa.gz", 
            f2="raw_data/2.fa.gz",
            f3="raw_data/3.fa.gz",
            f4="raw_data/4.fa.gz",
            f5="raw_data/5.fa.gz"
    shell: """
       wget https://osf.io/t5bu6/download -O {output.f1}
       wget https://osf.io/ztqx3/download -O {output.f2}
       wget https://osf.io/w4ber/download -O {output.f3}
       wget https://osf.io/dnyzp/download -O {output.f4}
       wget https://osf.io/ajvqk/download -O {output.f5}
    """

rule sketch_genomes:
    input:
        "raw_data/{name}.fa.gz"
    output:
        "sigs/{name}.fa.gz.sig"
    shell: """
        sourmash compute -k 31 {input} -o {output}
    """

rule compare_genomes:
    input:
        expand("sigs/{n}.fa.gz.sig", n=[1, 2, 3, 4, 5])
    output:
        cmp = "output/all.cmp",
        labels = "output/all.cmp.labels.txt"
    shell: """
        sourmash compare {input} -o {output.cmp}
    """

rule plot_genomes:
    input:
        cmp = "output/all.cmp",
        labels = "output/all.cmp.labels.txt"
    output:
        "output/all.cmp.matrix.png",
        "output/all.cmp.hist.png",
        "output/all.cmp.dendro.png",
    shell: """
        sourmash plot {input.cmp} --output-dir output
    """
