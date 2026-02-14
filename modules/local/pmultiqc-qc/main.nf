process PMULTIQC_QC {
    label 'process_medium'

    container "${ workflow.containerEngine == 'singularity' ?
        'docker://cauldron/pmultiqc-qc:1.0.0' :
        'cauldron/pmultiqc-qc:1.0.0' }"

    input:
    val input_directory
    val platform
    path sdrf_file
    val remove_decoy
    val decoy_affix
    val contaminant_affix
    val affix_type
    val condition_column
    val disable_table

    output:
    
    path "multiqc_report.html", emit: qc_report, optional: true
    path "multiqc_data", emit: qc_data, optional: true
    path "versions.yml", emit: versions

    script:
    def args = task.ext.args ?: ''
    """
    # Build arguments dynamically to match CauldronGO PluginExecutor logic
    ARG_LIST=()

    
    # Mapping for remove_decoy
    VAL="$remove_decoy"
    if [ -n "\$VAL" ] && [ "\$VAL" != "null" ] && [ "\$VAL" != "[]" ]; then
        ARG_LIST+=("--remove_decoy" "\$VAL")
    fi
    
    # Mapping for decoy_affix
    VAL="$decoy_affix"
    if [ -n "\$VAL" ] && [ "\$VAL" != "null" ] && [ "\$VAL" != "[]" ]; then
        ARG_LIST+=("--decoy_affix" "\$VAL")
    fi
    
    # Mapping for contaminant_affix
    VAL="$contaminant_affix"
    if [ -n "\$VAL" ] && [ "\$VAL" != "null" ] && [ "\$VAL" != "[]" ]; then
        ARG_LIST+=("--contaminant_affix" "\$VAL")
    fi
    
    # Mapping for affix_type
    VAL="$affix_type"
    if [ -n "\$VAL" ] && [ "\$VAL" != "null" ] && [ "\$VAL" != "[]" ]; then
        ARG_LIST+=("--affix_type" "\$VAL")
    fi
    
    # Mapping for disable_table
    VAL="$disable_table"
    if [ -n "\$VAL" ] && [ "\$VAL" != "null" ] && [ "\$VAL" != "[]" ]; then
        if [ "\$VAL" = "true" ]; then
            ARG_LIST+=("--disable_table")
        fi
    fi
    
    # Mapping for platform
    VAL="$platform"
    if [ -n "\$VAL" ] && [ "\$VAL" != "null" ] && [ "\$VAL" != "[]" ]; then
        ARG_LIST+=("--platform" "\$VAL")
    fi
    
    # Mapping for condition_column
    VAL="$condition_column"
    if [ -n "\$VAL" ] && [ "\$VAL" != "null" ] && [ "\$VAL" != "[]" ]; then
        ARG_LIST+=("--condition" "\$VAL")
    fi
    
    # Mapping for input_directory
    VAL="$input_directory"
    if [ -n "\$VAL" ] && [ "\$VAL" != "null" ] && [ "\$VAL" != "[]" ]; then
        ARG_LIST+=("--input_dir" "\$VAL")
    fi
    
    # Mapping for sdrf_file
    VAL="$sdrf_file"
    if [ -n "\$VAL" ] && [ "\$VAL" != "null" ] && [ "\$VAL" != "[]" ]; then
        ARG_LIST+=("--sdrf" "\$VAL")
    fi
    
    python /app/pmultiqc_runner.py \
        "\${ARG_LIST[@]}" \
        --output_dir . \
        \${args:-}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        Proteomics MultiQC Report: 1.0.0
    END_VERSIONS
    """
}
