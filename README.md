# Rapid Estimation of Global SST via S-DEIM

This repository contains the MATLAB code needed to reproduce the train/test workflow for the S-DEIM SST experiments.
This project was completed during the 2025 DRUMS REU at NCSU, under the guidance of Mohammad Farazmand and Louisa Ebby. 

## Co-Authors
- Cassidy All
- Kevin Ho
- Maya Magnuski

- Mohammad Farazmand
- Louisa Ebby



## Contents

- `train.m`
- `test.m`
- `functions/LSTM_pred.m`
- `functions/POD.m`
- `functions/RC_pred.m`
- `functions/RC_train.m`
- `functions/error_plot.m`
- `functions/generate_Wr.m`
- `functions/preprocess.m`
- `functions/sensorplacement.m`
- `functions/train_lstm.m`
- `data/lsmask.nc`
- `SDEIM_SST.pdf`

## Data

Download the NOAA OI SST V2 weekly SST file into `data/` before running the workflow:

```powershell
Invoke-WebRequest `
  -Uri "https://downloads.psl.noaa.gov/pub/Datasets/noaa.oisst.v2/sst.wkmean.1990-present.nc" `
  -OutFile "data/sst.wkmean.1990-present.nc"
```

The small land/sea mask file, `data/lsmask.nc`, is tracked in this repository. If missing, it can be downloaded with:

```powershell
Invoke-WebRequest `
  -Uri "https://downloads.psl.noaa.gov/pub/Datasets/noaa.oisst.v2/lsmask.nc" `
  -OutFile "data/lsmask.nc"
```

Dataset reference: NOAA Physical Sciences Laboratory, NOAA Optimum Interpolation SST V2, https://www.psl.noaa.gov/data/gridded/data.noaa.oisst.v2.html

## MATLAB Run Order

Run training first:

```powershell
matlab -batch "train"
```

This generates the following data used by the test script:

- `test_inputs.mat`
- `trained_RC.mat`
- `trained_LSTM.mat`

Then run the test file:

```powershell
matlab -batch "test"
```

## Paper

This repository accompanies:

**Rapid estimation of global sea surface temperatures from sparse streaming in situ observations*  
Cassidy All, Kevin Ho, Maya Magnuski, Christopher Nicolaides, Mohammad Farazmand, and Louisa Ebby.  
arXiv:2601.21913, 2026.  
[arXiv](https://arxiv.org/abs/2601.21913) | [PDF](https://arxiv.org/pdf/2601.21913) | [DOI](https://doi.org/10.48550/arXiv.2601.21913)
