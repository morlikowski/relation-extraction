# Approaches
- Which (classes of) models are used to tackle the problem?
- What are core features and design principles underlying these
models?

Both presented approaches conceive relation extraction as a classification problem: Depending on feature values, a given pair of entities is assigned to one of a fixed set of labels, such as "located-in" or "works-at". Likewise, entity recognition is understood as a classification task which entails tagging entity mentions with a label indicating the type of entity that they refer to.  or pairs of mentions are to be labeled as as coreferent or not, i.e.

relations vs relation instances (section 3)

For each type of model I will present where they take this general approach, giving an overview of their core ideas and architecture to highlight how each relates the subtasks of relation extraction.

## Pipeline

Mintz et al. (2009) present a pipeline approach to relation extraction, which is build on the concept of *distant supervision*. In contrast to regular supervised classification, which uses labeled text data to train a classifier, distant supervision does not directly train on prelabeled text. Instead a knowledge base is used to identify entities, whose relation is known, in unlabeled text and use these relation instances to train a classification model which assigns entity pairs to relation labels. Mintz et al. (2009) use the Freebase knowledge base (now acquired and integrated into other services, cf. Google 2014), which unifies structured semantic data from multiple sources, e.g. Wikipedia and MusicBrainz (music database). The authors claim that this has the advantage of being able to use more data and instances, as they do not have to be labeled manually, also allowing the system to be easily trained for different domains. Additionally, as relation names come from an existing knowledge base, they tend to be more canonical than ad-hoc defined ones.

### Principle design and classification model

The basic idea pursued by the authors is that Freebase can be used to identify entities as examples of known relations in order to generate a training set of relation instances. If two entities in a sentence are found to participate in a Freebase relation, the sentence is assumed to express that relation. As individual sentences in isolation might be misleading (in regard to what makes a sentence likely an expression of a certain relation), the features of all sentences which are presumed to be examples of a specific relation are aggregated.

These combined features are then used to train a multi-class logistic regression classifier which learns weights that minimize the effect of noisy features. The resulting model takes an entity pair and a feature vector as input and gives the single most likely relation name (i.e. only one label per instance) and a confidence score as output.

### Features

Alongside named entity tags, the authors use lexical and syntactic features or a combination of both.

Example

< Steven Spielberg, Saving Private Ryan, film-director >
“Steven Spielberg's film Saving
Private Ryan is loosely based ...”
“Allison co-produced the Academy Award-winning
Saving Private Ryan, directed by Steven Spielberg”
- Since the entity pair is in the database, we extract features and combine the
features for both sentences
- Note that each of the sentences alone would be inconclusive

Entity labels are inferred using the Stanford Named Entity Tagger (Finkel et
al. 2005) which tags a token as person, location, organization, miscellaneous or not being a NE ("none"). The employed lexical features are 1) the sequence of words between the two entities, 2) the order of the NEs (which one is first), a window of k tokens 3) to the left of the first and 4) to the right of the second entity and the POS-tags (nouns, verbs, adverbs, adjectives, numbers, foreign words) of the 5) in-between and 6) surrounding words. For each k ∈ {0, 1, 2} a combination of these properties is generated and forms a distinct feature. The syntactic features are generated using the dependency parser MINIPAR (Lin 1998). They include the dependency path between the two entities as well as a so-called window node for each entity, which is connected to the respective entity but not part of the dependency path. Each combination if window nodes and dependency path (including leaving out one or both nodes) yields a single feature. 

Syntactic Features - Example

types of features and their pipeline character
Parsing and Chunking
1. unstructured text
2. *parse* by MINIPAR
3. *chunking* of consecutive words with the same entity type (if consistent with parse tree)

Features - Consequences
- Features are very complex because they are combined from all sentences
- High precision vs. low recall



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
### Evaluation
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



## Joint inference

Singh et al. 2013

### Principle design and classification model

What are graphical models?

Describe the isolated and joint graphical models

- entity recognition
- relation extraction
- coreference resolution

### Features and learning

Problem of inference in "loopy" graphical model

Do they use the same features as Mintz et al.?

### Evaluation

Isolated models vs joint model
