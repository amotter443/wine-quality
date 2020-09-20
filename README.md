# wine-quality
>Conducting various ML development efforts using the wine quality dataset

This project was conducted as part of my intensive ML course in the spring of 2019. This micro-project focused on improving competency within 4 specific algorithms: support vector machines (SVM), clustering methods (k-means and hierarchical), random forest (rf), and neural networks (NN). The wine data set provides a useful starting place for many ML developers, given it is already cleaned and contains relatively comprehensible features that do not require significant research. Each algorithm's objective was as follows:
- SVM - Predict wine type (white or red) via binomial classiciation model
- Clustering - Derive unsupervised insights about dataset using various clustering methods and linkage methods
- RF - 1) Predict wine type (white or red) via binomial classiciation model 2) Predict sugar contents in wine using regression-based methods
- NN - Predict sugar contents in wine


Pre-Requisite Understanding 
------
Do research to better understand models before attempting. Code is simple and easy to read/duplicate, understanding is more valuable


Data Dictionary
-------
The wine data source contains 6497 observations of 14 variables. The features contain information about different attributes that are important to the winemaking process. 
- `id` -- id values for the individual wines (removed upon reading in)
- `fixed acidity` -- most acids involved with wine or fixed or nonvolatile (do not evaporate readily)
- `volatile acidity` -- the amount of acetic acid in wine, which at too high of levels can lead to an unpleasant, vinegar taste
- `citric acid` -- the amount of acetic acid in wine, which at too high of levels can lead to an unpleasant, vinegar taste
- `residual sugar` -- the amount of sugar remaining after fermentation stops, it's rare to find wines with less than 1 gram/liter and wines with greater than 45 grams/liter are considered sweet
- `chlorides` -- the amount of salt in the wine
- `free sulfur dioxide` -- the free form of SO2 exists in equilibrium between molecular SO2 (as a dissolved gas) and bisulfite ion; it prevents microbial growth and the oxidation of wine
- `total sulfur dioxide` -- amount of free and bound forms of S02; in low concentrations, SO2 is mostly undetectable in wine, but at free SO2 concentrations over 50 ppm, SO2 becomes evident in the nose and taste of wine
- `density` -- the density of water is close to that of water depending on the percent alcohol and sugar content
- `pH` -- describes how acidic or basic a wine is on a scale from 0 (very acidic) to 14 (very basic); most wines are between 3-4 on the pH scale
- `sulphates` -- a wine additive which can contribute to sulfur dioxide gas (S02) levels, wich acts as an antimicrobial and antioxidant
- `alcohol` -- the percent alcohol content of the wine
- `quality` -- score between 0 and 10
- `type` -- 0 red wine 1 white wine


Usage
-------
- Since each script functions as an individual objective, they can be executed in any order and to any degree of completeness
- For those interested in developing binomial classification experience, run wine_svm.R and the first half of wine_tree.R
- For those interested in developing regression-based modeling experience, run wine_nn.R and the second half of wine_tree.R
- For those interested in unsupervised ML experience or early NN exposure to multi-layer perceptrons, run wine_cluster.R and wine_nn.R respectively


Simplifying The Project
-------
- Might be helpful to do since so much homework is required
RF test every possible mtry 
clustering tables comparing the differences between features
