# Proteomics MultiQC Report

**ID**: `pmultiqc-qc`  
**Version**: 1.0.0  
**Category**: utilities  
**Author**: CauldronGO Team

## Description

Generate comprehensive quality control reports for mass spectrometry proteomics data using pmultiqc

## Runtime

- **Environments**: `python`

- **Entrypoint**: `pmultiqc_runner.py`

## Inputs

| Name | Label | Type | Required | Default | Visibility |
|------|-------|------|----------|---------|------------|
| `input_directory` | Input Directory | directory | Yes | - | Always visible |
| `platform` | Analysis Platform | select (quantms, maxquant, diann, proteobench, mzid, generic) | Yes | generic | Always visible |
| `sdrf_file` | SDRF File (Optional) | file | No | - | Always visible |
| `remove_decoy` | Remove Decoy Peptides | boolean | No | true | Always visible |
| `decoy_affix` | Decoy Identifier | text | No | DECOY_ | Always visible |
| `contaminant_affix` | Contaminant Identifier | text | No | CONT_ | Always visible |
| `affix_type` | Affix Type | select (prefix, suffix) | No | prefix | Always visible |
| `condition_column` | Condition Column (Optional) | text | No | - | Always visible |
| `disable_table` | Disable Large Tables | boolean | No | false | Always visible |

### Input Details

#### Input Directory (`input_directory`)

Directory containing proteomics analysis results. For DIA-NN: must contain report.tsv or report.parquet. For MaxQuant: must contain txt/ folder with results files.


#### Analysis Platform (`platform`)

Select the proteomics analysis platform used to generate the data

- **Options**: `quantms`, `maxquant`, `diann`, `proteobench`, `mzid`, `generic`

#### SDRF File (Optional) (`sdrf_file`)

Optional SDRF (Sample and Data Relationship Format) file to include in analysis


#### Remove Decoy Peptides (`remove_decoy`)

Exclude decoy peptides from identification counts


#### Decoy Identifier (`decoy_affix`)

Prefix or suffix used to identify decoy proteins


#### Contaminant Identifier (`contaminant_affix`)

Prefix or suffix used to identify contaminant proteins


#### Affix Type (`affix_type`)

Whether decoy/contaminant identifiers are prefixes or suffixes

- **Options**: `prefix`, `suffix`

#### Condition Column (Optional) (`condition_column`)

Column name in SDRF file to use for grouping samples into conditions

- **Placeholder**: `condition`

#### Disable Large Tables (`disable_table`)

Skip protein/peptide tables for very large datasets to reduce report size


## Outputs

| Name | File | Type | Format | Description |
|------|------|------|--------|-------------|
| `qc_report` | `multiqc_report.html` | file | html | Interactive HTML quality control report |
| `qc_data` | `multiqc_data` | file | directory | Directory containing raw QC metrics data |

## Requirements

- **Python Version**: >=3.10

### Package Dependencies (Inline)

Packages are defined inline in the plugin configuration:

- `pmultiqc>=0.0.39`
- `multiqc>=1.15`
- `pandas>=2.0.0`
- `click>=8.0.0`

> **Note**: When you create a custom environment for this plugin, these dependencies will be automatically installed.

## Usage

### Via UI

1. Navigate to **utilities** → **Proteomics MultiQC Report**
2. Fill in the required inputs
3. Click **Run Analysis**

### Via Plugin System

```typescript
const jobId = await pluginService.executePlugin('pmultiqc-qc', {
  // Add parameters here
});
```
