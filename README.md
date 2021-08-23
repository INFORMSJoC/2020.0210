[![INFORMS Journal on Computing Logo](https://INFORMSJoC.github.io/logos/INFORMS_Journal_on_Computing_Header.jpg)](https://pubsonline.informs.org/journal/ijoc)


This archive is distributed in association with the [INFORMS Journal on
Computing](https://pubsonline.informs.org/journal/ijoc) under the [MIT License](LICENSE).

Supporting material for paper titled: "Variable Bound Tightening and Valid Constraints for Multiperiod Blending", by Yifu Chen and Christos Maravelias.

We provide instances for the multiperiod blending problems tested in our paper. Instances are modified from D’Ambrosio, Linderoth, and Luedtke (2011) (link: https://link.springer.com/chapter/10.1007/978-3-642-20807-2_10). Please find the data for tested instances in the data folder. 

Models can be found under the scripts folder, in which different models mentioned in the paper are defined. All models are implemented in GAMS. 

To run tests, put the data file, model file, and main file (in src folder) under the same folder, and modify the main file to include the preferred data and model files, then run the main file in GAMS.

To test different models mentioned in the paper, please modify the model file accordingly. For each formulation (SourceBased, Proportion, etc.), M1_BigM in the model file corresponds to M^{SB}/M^{PB} in the paper (the original model), M2_VSpec corresponds to M^{UV} (the refourmulated model with structures for bound tightening), and M6_RT corresponds to M^{UV}_{RT} (model with tightening constraints).

Results can be found in the result folder. 
