# LASSO_AUC
mathematical model
Lasso是另一种数据降维方法，该方法不仅适用于线性情况，也适用于非线性情况。
Lasso是基于惩罚的方法对样本数据进行变量选择，通过对原本的系数进行压缩，将原本很小的系数直接压缩至0，从而将这部分系数所对应的变量视为非显著性变量，将不显著的变量直接舍弃
Lasso方法可以达到变量选择的效果，将不显著的变量系数压缩至0，而Ridge方法虽然也对原本的系数进行了一定程度的压缩，但是任一系数都不会压缩至0，最终模型保留了所有的变量。
Lasso回归可以在公式中去掉无用的变量（在这方面比Ridge好一点）。相比之下，Ridge在大多数变量都有用的时候，可以保留全部（比Lasso更好）

Lasso回归复杂度调整的程度由参数lambda来控制，lambda越大模型复杂度的惩罚力度越大，从而获得一个较少变量的模型。
Lasso回归和bridge回归都是Elastic Net广义线性模型的特例。除了参数lambda，还有参数alpha，控制对高相关性数据时建模的形状。
Lasso回归，alpha=1（R语言glmnet的默认值），brigde回归，alpha=0，一般的elastic net 0<alpha<1.

根据Hastie(斯坦福统计学家)， Tibshirani和Wainwright的Statistical Learning with Sparsity（The Lasso and Generalizations），
如下五类模型的变量选择可采用R语言的glmnet包来解决。

这五类模型分别是：
1. 二分类logistic回归模型
2. 多分类logistic回归模型
3.Possion模型
4.Cox比例风险模型
5.SVM
