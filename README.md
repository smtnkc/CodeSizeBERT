# CodeSizeBERT
Automating Software Size Measurement from Code Using Language Models


### DATA SHUFFLING

```bash
python shuffle_data.py --dataset code_cosmic
python shuffle_data.py --dataset code_microm
```

This shuffles:
- ``data/code_cosmic.csv``
- ``data/code_microm.csv``

and creates:
- ``data/code_cosmic-shuffled-data.csv``
- ``data/code_microm-shuffled-data.csv``


### CROSS PREDICTION

We perform 5-fold cross prediction. Cross prediction has to involve training. We use ``codebert`` model. The output models will be named as ``codebert-code_cosmic-<target>`` or ``codebert-code_microm-<target>`` and saved under ``checkpoints/``.

:white_check_mark: 4 targets (``entry``, ``read``, ``write``, ``exit``) on ``code_cosmic`` + 3 targets (``interaction``, ``communication``, ``process``) on``code_microm`` = 7 combinations will be run. 

```bash
python cross_pred.py --dataset code_cosmic --target entry --model codebert
```

This command performs a few things:

1. It runs training on ``data/code_cosmic-shuffled-data.csv`` with 5-fold cross prediction. Each prediction fold involves 5 epochs of training (25 epochs in total).
2. It obtains predictions for each fold (5 epochs) using the model with the lowest MSE.
3. It concatenates the predictions to ``preds/code_cosmic-shuffled-data-predby-codebert-code_cosmic.csv``.
4. It saves the model from with the lowest MSE (in 25 epochs) as the best model.
5. It names the best model as ``checkpoints/codebert-code_cosmic-entry.pt``.
6. It logs the metrics in ``logs/code_cosmic-entry-predby-codebert-code_cosmic.csv``.

### CALCULATE TOTAL CFP AND MicroM VALUES

```bash
python sum_preds.py
```
Adds 2 new columns (``cfp_pred`` and ``microm_pred``) into each CSV file under the ``preds/`` directory.
- ``cfp_pred = entry_pred + read_pred + write_pred + exit_pred``
- ``microm_pred = interaction_pred + communication_pred + process_pred``

Then, it reorders columns.

### CALCULATE METRICS

```bash
python calculate_metrics.py
```

This script processes all prediction files under `preds/` directory and generates 7 CSV files under `stats/` directory:

1. `mse.csv`: Mean Squared Error
2. `mae.csv`: Mean Absolute Error
3. `nmae.csv`: Normalized Mean Absolute Error (MAE divided by mean of actual values)
4. `acc.csv`: Exact Match Accuracy (after rounding predictions)
5. `mmre.csv`: Mean Magnitude of Relative Error
6. `pred30.csv`: PRED(30) - percentage of predictions with MRE <= 0.30
7. `nonzero.csv`: Percentage of non-zero values in actual data

All metric values are rounded to 4 decimal places for consistency.

### Contact

samettenekeci@gmail.com