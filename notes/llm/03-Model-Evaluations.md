Model evaluation is the **assessment** of a model’s performance and reliability by comparing its predictions against known ground truth on held‑out data. It focuses on how accurately and consistently the model performs the target task, not just on the training data but on new, unseen examples.

Common evaluation metrics
Different tasks use different families of metrics, each highlighting specific aspects of performance.


Classification (discrete labels)

 - Accuracy: Overall fraction of correct predictions.
 - Precision: Fraction of predicted positives that are actually positive.
 - Recall: Fraction of actual positives that the model correctly identifies.
 - F1‑score: Harmonic mean of precision and recall, useful when both matter and data are imbalanced.
 - AUC‑ROC / PR‑AUC: Summarize performance across decision thresholds, especially for imbalanced datasets.


Regression (continuous outputs)

 - Mean Absolute Error (MAE): Average absolute difference between predictions and true values.
 - Root Mean Squared Error (RMSE): Square‑root of mean squared error, penalizing larger errors more.
 - $r^2$ Proportion of variance in the target explained by the model

