#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { PMULTIQC_QC } from './modules/local/pmultiqc-qc/main'

workflow PIPELINE {
    main:
    PMULTIQC_QC (
        Channel.value(params.input_directory ?: ''),
        Channel.value(params.platform ?: ''),
        params.sdrf_file ? Channel.fromPath(params.sdrf_file).collect() : Channel.of([]),
        Channel.value(params.remove_decoy ?: ''),
        Channel.value(params.decoy_affix ?: ''),
        Channel.value(params.contaminant_affix ?: ''),
        Channel.value(params.affix_type ?: ''),
        Channel.value(params.condition_column ?: ''),
        Channel.value(params.disable_table ?: ''),
    )
}

workflow {
    PIPELINE ()
}
