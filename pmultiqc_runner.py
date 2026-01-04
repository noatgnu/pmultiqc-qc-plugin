import click
import os
import subprocess
import shutil
import sys
from pathlib import Path
from typing import Optional, List


def run_pmultiqc_report(
    input_dir: str,
    output_dir: str,
    platform: str = "generic",
    sdrf: Optional[str] = None,
    remove_decoy: bool = True,
    decoy_affix: str = "DECOY_",
    contaminant_affix: str = "CONT_",
    affix_type: str = "prefix",
    condition: Optional[str] = None,
    disable_table: bool = False
):
    """
    Run pmultiqc to generate quality control reports for proteomics data.
    """
    os.makedirs(output_dir, exist_ok=True)

    input_path = Path(input_dir)
    if not input_path.exists():
        raise FileNotFoundError(f"Input path does not exist: {input_dir}")

    analysis_dir = str(input_path.parent) if input_path.is_file() else str(input_path)

    # Find multiqc executable in current python environment
    if sys.platform == "win32":
        multiqc_exe = Path(sys.executable).parent / "multiqc.exe"
    else:
        multiqc_exe = Path(sys.executable).parent / "multiqc"

    if not multiqc_exe.exists():
        multiqc_exe = "multiqc"  # fallback to PATH

    platform_flags = {
        "quantms": "--quantms_plugin",
        "maxquant": "--maxquant_plugin",
        "diann": "--diann_plugin",
        "proteobench": "--proteobench_plugin",
        "mzid": "--mzid_plugin"
    }

    cmd: List[str] = [str(multiqc_exe)]

    if platform in platform_flags:
        cmd.extend([platform_flags[platform], analysis_dir])
    else:
        cmd.append(analysis_dir)

    cmd.extend(["-o", output_dir, "--force"])

    if sdrf and os.path.exists(sdrf):
        shutil.copy(sdrf, analysis_dir)

    # Core multiqc flags (hyphens, no value)
    
    # pmultiqc-specific flags (underscores, with value)
    # Note: These are defined as boolean options in pmultiqc but require explicit values
    
    cmd.extend(["--remove_decoy", str(remove_decoy).lower()])

    if disable_table:
        cmd.append("--disable_table")
    
    # pmultiqc-specific options (underscores, with value)
    if decoy_affix:
        cmd.extend(["--decoy_affix", decoy_affix])
    if contaminant_affix:
        cmd.extend(["--contaminant_affix", contaminant_affix])
    if affix_type:
        cmd.extend(["--affix_type", affix_type])
    if condition:
        cmd.extend(["--condition", condition])

    print(f"Running command: {' '.join(cmd)}")

    try:
        result = subprocess.run(
            cmd,
            check=True,
            capture_output=True,
            text=True,
            cwd=analysis_dir
        )
        print("STDOUT:", result.stdout)
        print("STDERR:", result.stderr)

        report_path = Path(output_dir) / "multiqc_report.html"
        if not report_path.exists():
            raise RuntimeError("MultiQC report was not generated successfully")

        print(f"QC report generated successfully at: {report_path}")
        return str(report_path)

    except subprocess.CalledProcessError as e:
        print(f"Error running MultiQC: {e}")
        print(f"STDOUT: {e.stdout}")
        print(f"STDERR: {e.stderr}")
        raise RuntimeError(f"Failed to generate QC report: {e.stderr}")


@click.command()
@click.option("--input_dir", required=True, help="Input directory or file with proteomics results")
@click.option("--output_dir", required=True, help="Output directory for QC report")
@click.option("--platform", default="generic", help="Analysis platform")
@click.option("--sdrf", default=None, help="SDRF metadata file")
@click.option("--remove_decoy", type=bool, default=True, help="Remove decoy peptides")
@click.option("--decoy_affix", default="DECOY_", help="Decoy identifier")
@click.option("--contaminant_affix", default="CONT_", help="Contaminant identifier")
@click.option("--affix_type", default="prefix", help="Affix type (prefix/suffix)")
@click.option("--condition", default=None, help="Condition column in SDRF")
@click.option("--disable_table", is_flag=True, default=False, help="Disable large tables")
def main(**kwargs):
    run_pmultiqc_report(**kwargs)


if __name__ == "__main__":
    main()