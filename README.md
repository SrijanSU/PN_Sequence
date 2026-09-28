# PN_Sequence
# PN Sequence and Gold Code Generator (MATLAB)

`pnsequence.m` is an interactive MATLAB script. It builds two binary sequences from user-entered polynomials, checks three sequence properties, and XORs the two sequences into what it reports as a Gold code.

## Requirements

- MATLAB with support for local functions in scripts (R2016b or later).
- Signal Processing Toolbox, for `xcorr`.

The original MATLAB release and toolbox versions are not recorded.

## Run

With this folder on the MATLAB path, run:

```matlab
generate_gold_sequence
```

There are no command-line arguments. The function repeats until both generated sequences have the same length, then prints `Generated Gold Code:`.

For each sequence, `combined_code` asks for:

1. A polynomial whose coefficients are all 1, with terms separated by `+`, for example `x^3 + x^2 + 1`. A bare `x` is degree 1, and the highest power sets the degree.
2. A non-zero initial shift-register state with one bit per degree, written in brackets. For degree 3, for example, enter `[1 0 1]`.

## Sequence Generation

The script runs a Fibonacci-style LFSR for `2^m - 1` steps, where `m` is the polynomial degree.

- Feedback is the XOR of the taps from the polynomial after the leading term is dropped.
- The bit shifted out of the register becomes the next sequence bit.
- If the register does not return to its initial state, the script prints `Something went wrong!` and asks again.

## Property Checks

For the 0/1 sequence of length `N = 2^m - 1`:

- **Balance:** expects one more 1 than 0, the standard m-sequence balance property.
- **Runs:** passes when no run of identical bits is longer than `m`. This checks only the maximum run length, not the full run-distribution property.
- **Autocorrelation:** plots the sequence and `xcorr(..., 'coeff')` using `stem`, and passes when the peak absolute coefficient is at least 0.8.

Normalized `xcorr` equals 1 at lag 0, so the autocorrelation check passes for any nonzero sequence. The script also computes a mapped sequence (`0 → 1`, `1 → -1/N`), but does not use it for autocorrelation.

If all three checks pass, the script reports a PN sequence and returns it. Otherwise it reports failure and calls `combined_code` again, which can repeat until a sequence passes.

## Gold Code Output

`generate_gold_sequence` XORs the two returned sequences when their lengths match. If the lengths differ, both prompts restart.

The script does not verify that the two polynomials form a preferred pair, so the output is a true Gold code only if the inputs satisfy that requirement.

## Files

| File | Role |
|---|---|
| `pnsequence.m` | Contains `generate_gold_sequence`, LFSR generation, and property checks |
| `IMG20220405101910.jpg` | Image in the repository; |

`check_autocorrelation` creates two plots. The script does not save figure files.

## Screenshots

![App Screenshot](Screenshot(28).jpg)
