# Comparison

- What are commonalities, what are differences between the
models?
- Can you make sense of the results (by tracing them back to
the aspects discussed before)?

## General focus: features vs. model

While the Mintz et al. (2009) paper focuses on careful feature engineering and the generation
of large amounts of training data using a knowledge base, Singh et al. (2013) turn their attention to
a more capable model structure and matching efficient algorithms for training and inference.

## Problem description: classification

Both papers conceptualize relation extraction as a classification problem: Depending on feature values, a given pair of entities is assigned to one of a predefined set of relations. Entity tagging and coreference resolution are also addressed with classification models. Furthmore, despite their different vocabulary, both papers use a MaxEnt classifier for relation classification. While Mintz et al. frame their model as a logistic regression classifier and Singh et al. talk about log-linear combinations of parameters and features in their factor functions, both are essentially equal to a maximum entropy classifier as they are log-linear classifiers (cf. Manning & Klein 2003). A MaxEnt classifier can be viewed as a more general formulation of the logistic regression, since it follows a multinomial instead of a binomial distribution.

## Pipeline vs. joint inference

Even tough the distinction between pipeline and joint models has been drawn troughout the previous sections, it is worth to be explicitly addressed again here. As mentioned earlier, the pipeline approach models the subtasks as a series of consecutive models, while joint inference explicitly models the mutual dependencies between the subtasks. The essential difference is formulated by Singh et al. in terms of information flow. In a pipeline model, errors made in previous steps of the information extraction pipeline are just handed over to the next step, even if the following model could provide evidence to correct the previous prediction. Additionally, tasks have to be aligned linearly, even if their order is ambiguous (e.g. does coreference resolution happen before or after relation extraction?). In sum, information just flows in one direction. On the contrary, in a joint model, as exemplified by the discussed graphical model, the tasks are considered simultaneously, so that there is information flow in both directions for interdependent tasks.

Does this make a difference????
"When looking at their results however, the difference seems not that big"

## Compare results and evaluation

How to both models perform, can they be compared?

"So far evaluation has been ignored..."
