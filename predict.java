import weka.classifiers.trees.RandomForest;
import weka.core.Instances;
import weka.core.converters.ConverterUtils.DataSource;

public class predict {

	/**
	 * @param args
	 * @throws Exception 
	 */
	public static void main(String[] args) throws Exception {
		// TODO Auto-generated method stub
		String s = "pictures";
		String str =s+".arff";
		String str1="test_"+s+".arff";
		DataSource source = new DataSource(str);
		Instances data = source.getDataSet();
		// setting class attribute if the data format does not provide this information
		if (data.classIndex() == -1)
			data.setClassIndex(data.numAttributes() - 1);

		//Read test data
		source = new DataSource(str1);
		Instances testdata = source.getDataSet();
		// setting class attribute if the data format does not provide this information
		if (testdata.classIndex() == -1)
			testdata.setClassIndex(testdata.numAttributes() - 1);

		//Train Classifier
		RandomForest rf = new RandomForest();
		rf.buildClassifier(data);

		for (int i=0;i<testdata.numInstances();i++) {
			double[] predictionDistribution = 
					rf.distributionForInstance(testdata.instance(i));
			System.out.println("nom="+predictionDistribution[0]+", win="+
					predictionDistribution[1]);
		}

	}
}
