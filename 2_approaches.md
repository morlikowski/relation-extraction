# Approaches

Relation extraction is commonly conceptualized as a classification problem: Depending on feature values, a given pair of entities is assigned to one of a fixed set of labels, such as "located-in" or "works-at". Likewise, entity recognition is understood as a classification task which entails tagging possible entity mentions with a label indicating the type of entity that they refer to. Similarly, in anaphora resolution pairs of mentions are to be labeled as as coreferent or not.

For both pipeline and joint models I will present where the authors take this general approach, giving an overview of their core ideas and relevances to highlight how they relate the subtasks of relation extraction.

relations vs relation instances (section 3)

## Pipeline

Mintz et al. (2009) present a pipeline approach to relation extraction which is built on the concept of *distant supervision*. In contrast to regular supervised classification, which uses labeled text data to train a classifier, distant supervision does not directly train on prelabeled text. Instead a knowledge base is used to identify entities, whose relation is known, in unlabeled text. These relation instances are then taken to train a classification model which assigns entity pairs to relation labels. Mintz et al. (2009) use the Freebase knowledge base (now acquired and integrated into other services, cf. Google 2014), which unifies structured semantic data from multiple sources, e.g. Wikipedia and MusicBrainz (music database). The authors claim that this has the advantage of being able to use more data and instances, as they do not have to be labeled manually, also allowing the system to be easily trained for different domains. Additionally, as relation names come from an existing knowledge base, they tend to be more canonical than ad-hoc defined ones.

### Principle design and classification model

The basic idea pursued by the authors is that Freebase can be used to identify entities as examples of known relations in order to generate a training set of relation instances. If two entities in a sentence are found to participate in a Freebase relation, the sentence is assumed to express that relation. As individual sentences in isolation might be misleading (in regard to features which make a sentence likely an expression of a certain relation), the features of all sentences which are presumed to be examples of a specific relation are aggregated.

These combined features are then used to train a multi-class logistic regression classifier which learns weights that minimize the effect of noisy features. The resulting model takes an entity pair and a feature vector as input and gives the single most likely relation name (i.e. only one label per instance) and a confidence score as output.

### Features and training

Alongside named entity tags, the authors use lexical and syntactic features or a combination of both. *Entity labels* are inferred using the Stanford Named Entity Tagger (Finkel et al. 2005) which tags a token as person, location, organization, miscellaneous or not being a NE ("none"). The employed *lexical features* are 1) the sequence of words between the two entities, 2) the order of the NEs (which one is first), a window of *k* tokens 3) to the left of the first and 4) to the right of the second entity and the POS-tags (nouns, verbs, adverbs, adjectives, numbers, foreign words) of the 5) in-between and 6) surrounding words. For each window width *k* from 0 to 2 a combination of these properties is generated and forms a distinct feature. The *syntactic features* are generated using the dependency parser MINIPAR (Lin 1998). They include the dependency path between the two entities as well as a so-called window node for each entity, which is connected to the respective entity but not part of the dependency path. Each possible combination of window nodes and dependency path (including leaving out one or both nodes) yields a single feature. The described features are not used separately, but in conjugation. Thus, two feature values are only identical, if all the described attributes have the same value. This results in very specific and therefore rare features, which leads to high precision and low recall in general.

The described features highlight the system's pipeline character. Errors made by the NE tagger, POS tagger or MINIPAR just trickle down into the relation classifier without the possibility of later correction using evidence from relation extraction. In additon, during training the system chunks consecutive words with the same entity type, if this is consistent with the parse tree. Thus, recognized NEs also depend on the parser's performance in a pipeline manner.

<!---
### Training

Implementation
Text data
- sentence-tokenized (!) Wikipedia dump (1.8 million articles, ø 14.3 sentences per article)
- relatively up-to-date and explicit text
- Freebase entities likely to appear (since it is based on Wikipedia)


A note on Training
classifier needs to see negative data in training:
 - randomly select entity pairs not included in any Freebase relation (accepting false negatives)
 - build feature vector for 'unrelated' relation from these entities
 - random 1% sample of unrelated entities as negative samples (by contrast 98.7% of extracted entities are unrelated)
-->
<!--### Evaluation
 Test Step

- rank relations by confidence score to determine n most likely new relations

- Identify entities with a Named Entity Tagger
- For each pair of entities
-Extract Features
-Append Features for same pair
- Classifier returns the most likely relation and a confidence score for each entity pair


 Testing and evaluation
 - only extract relations not already in training data
 Held-out evaluationgit
 - half of the instances *for each relation* not used in training, used for comparison
 - precision vs recall for lexical, syntactical or both feature types:
   - combination of lexical and syntactic features performs best

 Human evaluation
 - Amazon Mechanical Turk
 - 100 instances on different levels of recall with lexical, syntactical or both feature types
   - mixed result, combination seems to be slightly better
-->


## Joint inference

Singh et al. (2013) present a system for information extraction which jointly models
named entity recognition, relation extraction and coreference resolution. In contrast to
pipeline systems, this prevents cascading errors, as all tasks can reciprocally share
their information (see examples in 1.). The authors claim that their joint model supersedes previous systems, because
it includes three central tasks of information extraction extraction, especially as coreference resolution
often was not considered.

### Principle design and classification model

Singh et al. (2013) describe their system as a *probabilistic graphical model* (cf. Koller & Friedman 2009). In general, these models represent beliefs about specific aspects of the world and can be used in a variety of NLP tasks. Employing *probability theory* and statistics they give formal representations of uncertainty, means to draw inferences based on them and learn them from data. Often encoding probability distributions over a large number of random variables, *graphs* serve as an efficient data structure to deal with their inherent complexity, as the joint distribution of these variables can become exponentially large. Furthermore, templates can be used to describe families of models with similar structure (e.g. a model for NER in arbitrarily long sentences, not just in a seven words sentence). In sum, probabilistic graphical models represent probability distributions and interactions between random variables as graphs.

To formalize their classification models, Singh et al. (2009) use a special kind of probabilistic graphical model, so-called *factor graphs*. A factor graph splits the joint probability distribution of a number of random variables into a product of individual factors, i.e. a bipartite graph with factors and random variables that gives a factorization of their joint probability distribution function by connecting each factor and its input random variables. *Factors* are functions that map a set of random variables to a real value. In the context of classification, a factor can be defined as a (log-linear) combination of model parameters (which are learned from data) and feature functions (which transform input variables into feature values). Factors depend on labels and input variables, so that the whole graph models their joint probability.

The authors first present isolated probabilistic graphical models for entity recognition, relation extraction and coreference resolution.
The entity tagging model takes a potential mention as fixed variable and returns an entity label. Both other models take two entity mentions and their predicted tags as input and return a relation label or boolean value (coreferent or not) respectively. The authors then present a joint graphical model for these tasks that is structurally a combination of the single models.
While the individual models encoded a probability distribution over a single type of labels (e.g. NE tags), the model now gives the unnormalized joint probability distribution over all three tasks. Thus, only the potential mentions are considered to be fixed input, so that the model enables a bi-directional information flow between the tasks trough the entity labels and the respective factors.

### Features and training

As the presented joint model has a complex and 'loopy' graph structure (i.e. it is not a tree), estimating the model parameters from training data is computationally intractable using common techniques.

Piecewise learning

Adapted belief propagation

Our main extension stems from the insight that during inference in NLP models, most of the
variable marginals often peak during the initial stages of inference,
without changing substantially during the rest of the course of in-
ference. Detecting these low-entropy marginals in earlier phases
and fixing to their high-probability values provides benefits to belief
propagation. First, since the domain now contains only a single
value, the factors that neighbor the variable can marginalize much
more efficiently. Second, these fixed variables result in fewer cycles
in the model and allow decomposition of the model into independent
inference problems by partitioning at these fixed variables. Lastly,
factors that only neighbor fixed variables can be effectively removed
during inference, reducing the amount of messages that are passed.
To employ these benefits of value sparsity in belief propagation,
we examine the marginals of all the variables after every iteration
of message passing. When the probability of a value for a variable
goes above a predetermined probability threshold ζ, we set the value
of the variable to its maxiSince belief propagation is not directly applicable, we adapt the
algorithm for inference on our model. Our main extension stems
from the insight that during inference in NLP models, most of the
variable marginals often peak during the initial stages of inference,
without changing substantially during the rest of the course of in-
ference. Detecting these low-entropy marginals in earlier phases
and fixing to their high-probability values provides benefits to belief
propagation. First, since the domain now contains only a single
value, the factors that neighbor the variable can marginalize much
more efficiently. Second, these fixed variables result in fewer cycles
in the model and allow decomposition of the model into independent
inference problems by partitioning at these fixed variables. Lastly,
factors that only neighbor fixed variables can be effectively removed
during inference, reducing the amount of messages that are passed.
To employ these benefits of value sparsity in belief propagation,
we examine the marginals of all the variables after every iteration
of message passing. When the probability of a value for a variable
goes above a predetermined probability threshold ζ, we set the value
of the variable to its maximum probability value, treating it as a
fixed variable for the rest of inference. The parameter ζ directly
controls the computational efficiency and accuracy trade-offmum probability value, treating it as a
fixed variable for the rest of inference. The parameter ζ directly
controls the computational efficiency and accuracy trade-off

The features used in the system are on the mention-, word- and sentence-level. However, feature engineering is not the focus of the paper, so feature definitions are taken from the literature (Ratinov and Roth 2009, Zhou et al. 2005, Soon et al. ????, Bengston and Roth ????).

<!-- ### Evaluation

Isolated models vs joint model -->
