package com.hwx.lasUDF;
 
import org.apache.hadoop.hive.ql.exec.UDF;
import org.apache.hadoop.io.Text;

import java.util.StringTokenizer;

public final class lasUDF extends UDF {
  public Text evaluate(final Text rec) {
    if (rec == null) { return null; }

    String[] lines = rec.toString().split("\\||");
    String blockType = null;
    bool curveBlockFound = false;
    for (int i = 0; i < lines.length; i++){
      if (String.contains(lines[i], "~") blockType = lines[i]
        //This line defines a block type
        if (String.contains(lines[i], "~A)
      }
    }
    String esiid = fields[0];

    //convert array of string usages to double usages
    StringTokenizer tokenizer = new StringTokenizer(fields[1], ",");
    double[] daily_usage = new double[tokenizer.countTokens()];
    int index = 0;
    while (tokenizer.hasMoreTokens()){ daily_usage[index++] = Double.parseDouble(tokenizer.nextToken()); }

    //convert array of string temps to double temps
    tokenizer = new StringTokenizer(fields[2], ",");
    double[] daily_temp = new double[tokenizer.countTokens()];
    index = 0;
    while (tokenizer.hasMoreTokens()){ daily_temp[index++] = Double.parseDouble(tokenizer.nextToken()); }

    Vector temp = new DenseVector(daily_temp.length);
    Vector usage = new DenseVector(daily_usage.length);
    usage.assign(daily_usage);
    temp.assign(daily_temp);

    //Call the ThreeSegmentRegressor
    ThreeSegmentRegressor BestModel = new ThreeSegmentRegressor(temp,usage);
    double c1 = BestModel.cut1(); //heating temp
    double c2 = BestModel.cut2(); //cooling temp
    double slope_left = BestModel.slope1();
    double slope_right = BestModel.slope2();
    double baseline = BestModel.baseLine();
    return new Text(esiid + "|" + c1 + "|" + c2 + "|" + slope_left + "|" + slope_right + "|" + baseline + "|" + daily_temp.length);
  }
}
