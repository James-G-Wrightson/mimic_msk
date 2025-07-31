# Comparing methods to identify ED visits for Musculoskeletal conditions using the MIMIC-IV-ED database

This project was an analysis of the MIMIC-IV-ED 2.2. database. The aim was to compare how using different algorithms used to define and identify "musculoskeletal conditions" affected estimates for the numbers of emergency department visits  for musculoskeletal conditions. A full descriptions of the background, methods and results can be found in the preprint (ADD PREPRINT LINK). 

## Instructions
To reproduce this analysis, follow these steps in order. 
1. Clone (or download as a zip) this repo, and reopen the readme.md locally
    - The kernel I used to run this analysis was R 4.5.0
        - The necessary packages are installed and loaded using the R package "pacman" at the start of the notebooks

2. First, the MIMICED data for this analysis must be created using the [MIMICED](https://github.com/James-G-Wrightson/MIMICED.git) repo, which included  as a submodule of this repo. 
    - Instructions for creating the data can be found in the [readme](https://github.com/James-G-Wrightson/MIMICED/blob/main/README.md) file for that repo.
    - When you clone this current repo, the submodule will be available in a folder called MIMICED

3. Then, the California (HCAI) data need to be created. To create the data, run the notebook [cali_data.ipynb](ANALYSIS/2_cali_data.ipynb)
    - The HCAI dataset is from [California Department of Health Care Access and Information](https://data.chhs.ca.gov/dataset/hospital-emergency-department-diagnosis-procedure-and-external-cause-codes).  
    - Years 2015-2019 are included. This is because 2015 is the first year ICD10 codes were used (but only from Q3-Q4). After 2019, there is no breakdown between total codes and primary ICD codes, so you don't know how often the primary complaint was MSK pain. 
    - These data have been collated into a .xlsx [file](ANALYSIS/california.xlsx) 

4. Each of the codelists for the musculoskeletal conditions need to be created. We used three ICD code lists to identify MSK conditions:
    - All of the ICD10 M codes from the 2019 [CMS](https://www.cms.gov/medicare/coding-billing/icd-10-codes/icd-10-cm-icd-10-pcs-gem-archive#:~:text=2019%20ICD%2D10%20CM%20%26%20PCS%20files) ICD-10 code list. Use [this](ANALYSIS/3i_Mcodes.ipynb) notebook
    - A list of codes ('power') used to identify MSK conditions in Canada from [Power et al](https://pubmed.ncbi.nlm.nih.gov/35365584/). Use [this](ANALYSIS/3ii_power_codes.ipynb) notebook. 
    - The power codes are ICD-10CA codes in short (3-4 character) format. To get these codes to match the other code lists, they were mapped into ICD-10 WHO codes. the WHO ICD-10 codes were extracted from the Python package [simple_icd_10](https://github.com/StefanoTrv/simple_icd_10/releases), which is the extended code list from th WHO [page](https://icd.who.int/browse10/2019/en#) for the 2019 codes and from there mapped onto the 2019 CMS ICD-10CM codes
    - A list of codes ('hwa') used to identify “less-urgent” MSK conditions in Australia [Thompson et al](https://ro.uow.edu.au/ahsri/375/). Use [this](ANALYSIS/3iii_HWA_codes.ipynb) notebook.
    - The hwa codes were in ICD-10-AM format. Unlike ICD-10-CA, Australia actually provide [maps](https://www.ihacpa.gov.au/resources/icd-10-am-and-achi-mapping-tables) (11th edition) to ICD-10-WHO, and these WHO codes were mapped into the CMS codes
    - There is a [notebook](ANALYSIS/3iv_code_plots.ipynb) for plotting the interactions between the codes
        - The notebook outputs figures as .svg and .png

5. Once the raw data are created, the [analysis](ANALYSIS/4_primary_analysis.ipynb) notebook can be run.
    - The packages required for analysis are installed (if necessary) and loaded at the start of the notebook, using the R package "pacman".
    - The notebook outputs figures as .svg and .png
