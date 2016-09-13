#!/bin/bash
pandoc 1_introduction.md 2_approaches.md 3_comparison.md 4_conclusion.md 5_literature.md metadata.yaml --standalone --number-sections -o report.pdf
