# Approaches
- Which (classes of) models are used to tackle the problem?
- What are core features and design principles underlying these
models?

Both pipeline and joint inference approaches conceive relation extraction as a classification problem: Depending on feature values, a given pair of entities is assigned to one of a fixed set of labels, such as "located-in" or "works-at". For each type of model I will present where they take this general approach, giving an overview of their core ideas and architecture to highlight how each relates the subtasks of relation extraction.

## Pipeline

Mintz et al. (2009) present a pipeline approach to relation extraction, which is build on the concept of *distant supervision*. In contrast to regular supervised classification, which uses labeled text data to train a classifier, distant supervision does not directly train on prelabeled text. Instead a knowledge base is used to identify entities, whose relation is known, in unlabeled text and use these relation instances to train a classification model which assigns entity pairs to relation labels. Mintz et al. (2009) use the Freebase knowledge base (now acquired and integrated into other services, cf. Google 2014), which unifies structured semantic data from multiple sources, e.g. Wikipedia and MusicBrainz (music database). The authors claim that this has the advantage of being able to use more data and instances, as they do not have to be labeled manually, also allowing the system to be easily trained for different domains. Additionally, as relation names come from an existing knowledge base, they tend to be more canonical than ad-hoc defined ones.

relations vs relation instances (section 3)

### Principle design and classification model

The basic idea pursued by the authors is that Freebase can be used to identify entities as examples of known relations in order to generate a training set of relation instances. If two entities in a sentence are found to participate in a Freebase relation, the sentence is assumed to express that relation. As individual sentences in isolation might be misleading (in regard to what makes a sentence likely an expression of a certain relation), the features of all sentences which are presumed to be examples of a specific relation are aggregated.

These combined features are then used to train a multi-class logistic regression classifier which learns weights that minimize the effect of noisy features. The resulting model takes an entity pair and a feature vector as input and gives the single most likely relation name (only one label per instance) and a confidence score as output.

### Features

types of features and their pipeline character
Parsing and Chunking
1. unstructured text
2. *parse* by MINIPAR
3. *chunking* of consecutive words with the same entity type (if consistent with parse tree)

Example

< Steven Spielberg, Saving Private Ryan, film-director >
“Steven Spielberg's film Saving
Private Ryan is loosely based ...”
“Allison co-produced the Academy Award-winning
Saving Private Ryan, directed by Steven Spielberg”
- Since the entity pair is in the database, we extract features and combine the
features for both sentences
- Note that each of the sentences alone would be inconclusive

Features
- Lexical Features
- Syntactic Features
- Named Entity Tags
-
-
Stanford Named Entity Tagger
person, location, organization, miscellaneous, none

Lexical Features
- The sequence of words located between the two entities
- Part-of-speech tags
- A window of k words to the left and right of the two entities

Syntactic Features
- Dependency path via MINIPAR
- Add window node(s)
- Combine the dependency path with different permutations of window nodes

Syntactic Features - Example

Features - Consequences
- Features are very complex because they are combined from all sentences
- High precision vs. low recall

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
 Held-out evaluation
 - half of the instances *for each relation* not used in training, used for comparison
 - precision vs recall for lexical, syntactical or both feature types:
   - combination of lexical and syntactic features performs best

 Human evaluation
 - Amazon Mechanical Turk
 - 100 instances on different levels of recall with lexical, syntactical or both feature types
   - mixed result, combination seems to be slightly better



## Joint inference

- factor graph
Joint Inference of Entities, Relations, and Coreference
(Singh et al. 2013)