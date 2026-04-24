# NonlinearDiffusion

**Pre-process for segmentation task with nonlinear diffusion filters**

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.19724922.svg)](https://doi.org/10.5281/zenodo.19724922)
[![arXiv](https://img.shields.io/badge/arXiv-2604.21422-b31b1b.svg)](https://arxiv.org/abs/2604.21422)
[![License: CC BY 4.0](https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by/4.0/)

## Description

MATLAB implementation of a nonlinear diffusion filter for obtaining piecewise
constant images as a pre-processing step for image segmentation techniques.

The method proposes a new family of diffusivity functions derived from nonlinear
diffusion techniques, related to backward diffusion, whose goal is to split an
image into closed contours with homogenized grey intensity inside and sharp edges.
The filter satisfies well-posedness semi-discrete and full discrete scale-space
requirements, and uses a semi-implicit scheme that connects with an
edge-preserving process. A stopping criterion based on the linear diffusion
setting time is provided, allowing piecewise constant images to be obtained
with low computational effort.

## Repository structure

```
NonlinearDiffusion/
├── demoPiecewiseImageFilter.m   # Main demo script (entry point)
├── aux_NLD/                     # Auxiliary MATLAB functions
│   ├── Difusion_HM.m            # Proposed diffusivity function
│   ├── GradU2_2D.m              # 2D gradient computation
│   ├── Resolv_2Dv000.m          # AOS solver (2D)
│   ├── get_ts.m                 # Stopping time computation
│   ├── aosiso.m                 # Isotropic AOS scheme
│   ├── nldif.m                  # Standard nonlinear diffusion (baseline)
│   ├── RegularizationTV.m       # Total variation regularization (baseline)
│   ├── conv2br.m                # Convolution with boundary conditions
│   ├── div.m                    # Discrete divergence
│   ├── grad.m                   # Discrete gradient
│   ├── gsderiv.m                # Gaussian derivative
│   ├── getoptions.m             # Option parsing utility
│   ├── sum3.m                   # Sum along third dimension
│   └── thomas.m                 # Thomas algorithm (tridiagonal solver)
├── data/                        # Test images (.jpg)
└── ManualSegm/                  # Manual segmentations (.bmp, ground truth)
```

## Requirements

- MATLAB (tested with R2016a and later)
- Image Processing Toolbox (for `edge`, `imdilate`, `bwperim`, `imresize`)

## Usage

Run the main demo from the MATLAB command window:

```matlab
demoPiecewiseImageFilter
```

The script processes all images in `data/` against their manual segmentations
in `ManualSegm/`, applies three filtering approaches (proposed filter,
standard nonlinear diffusion, and total variation), and displays:

- `Figure 1`: filtered images for all methods side by side
- `Figure 2`: Canny edge detections on filtered images

The F-measure (harmonic mean of precision and recall on edges) is printed
to the console for each image and each method.

### Key parameters

| Parameter | Variable | Default | Description |
|-----------|----------|---------|-------------|
| Time step | `dt` | 200 | Diffusion time step |
| Max iterations | `iter_max` | 1000 | Upper bound for iterations |
| Diffusivity exponent | `P_list` | per image | Controls edge sharpness (higher = sharper) |
| TV weight | `lambda_TV` | 0.25 | Fidelity/regularization trade-off for TV baseline |

The parameter `p` in `P_list` is image-dependent. As a guide: low-contrast
images require higher values (e.g. `p = 19–20`), while high-contrast images
work well with lower values (e.g. `p = 2.5–6`).

## Citation

If you use this code in your research, please cite:

```bibtex
@misc{sanguino2026preprocess,
  author       = {Sanguino, Javier and Platero, Carlos and Velasco, Olga},
  title        = {Pre-process for segmentation task with nonlinear diffusion filters},
  year         = {2026},
  publisher    = {arXiv},
  doi          = {10.5281/zenodo.19724922},
  url          = {https://arxiv.org/abs/2604.21422},
  note         = {arXiv:2604.21422}
}
```

- **arXiv preprint**: https://arxiv.org/abs/2604.21422
- **DOI (Zenodo)**: https://doi.org/10.5281/zenodo.19724922

## Authors

- Javier Sanguino
- Carlos Platero
- Olga Velasco

Health Science Technology Group, Universidad Politécnica de Madrid, Spain.

## License

This code is released under the
[Creative Commons Attribution 4.0 International (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/)
license. See the [LICENSE](LICENSE) file for details.
