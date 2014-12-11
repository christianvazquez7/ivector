ubm_train2('train.txt',200,64,10,1,8,'ubm')
train_T('tlist');
[pla, V] = train_dv_vectors('statlist');
model = enroll('ubm_training_files\frf01_f01_solo',V,pla);
score = score(model,'ubm_training_files\frf01_f02_solo',V,pla);



