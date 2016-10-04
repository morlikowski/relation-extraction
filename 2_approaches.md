# Approaches

Relation extraction is commonly conceptualized as a classification problem: Depending on feature values, a given pair of entities is assigned to one of a fixed set of labels, such as "located-in" or "works-at". Likewise, entity recognition is understood as a classification task which entails tagging possible entity mentions with a label indicating the type of entity that they refer to. Similarly, in anaphora resolution pairs of mentions are to be labeled as as coreferent or not.

For both pipeline and joint models I will present where the authors take this general approach, giving an overview of their core ideas and architecture to highlight how they relate the subtasks of relation extraction.

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

Singh et al. 2013

### Principle design and classification model

What are graphical models?

Describe the isolated and joint graphical models

- entity recognition

features from Ratinov and Roth (2009)


- relation extraction

features from Zhou et al. 2005

- coreference resolution

### Features and training

Problem of inference in "loopy" graphical model

Do they use the same features as Mintz et al.?

<!-- ### Evaluation

Isolated models vs joint model -->
