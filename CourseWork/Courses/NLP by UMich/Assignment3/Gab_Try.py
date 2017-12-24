import A, B
from main import parse_data

eng_train = parse_data('data/English-train.xml')
eng_test = parse_data('data/English-dev.xml')

cata_train = parse_data('data/Catalan-train.xml')
cata_test = parse_data('data/Catalan-dev.xml')

span_train = parse_data('data/Spanish-train.xml')
span_test = parse_data('data/Spanish-dev.xml')

# A.run(train, test, language, knn_file, svm_file):

A.run(eng_train,eng_test,'English','KNN-English.answer','SVM-English.answer')
A.run(cata_train,cata_test,'Catalan','KNN-Catalan.answer','SVM-Catalan.answer')
A.run(span_train,span_test,'Spanish','KNN-Spanish.answer','SVM-Spanish.answer')

# B.run(train, test, language, answer)
B.run(eng_train,eng_test,'English','Best-English.answer')
B.run(cata_train,cata_test,'Catalan','Best-Catalan.answer')
B.run(span_train,span_test,'Spanish','Best-Spanish.answer')
