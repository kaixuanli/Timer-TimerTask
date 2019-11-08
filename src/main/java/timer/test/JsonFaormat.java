package timer.test;

import com.alibaba.fastjson.JSONObject;

/**
 * @author likaixuan email:likaixuan(a)innodev.com.cn
 * @Date: 2019/8/29 14:38
 * @Version 1.0
 */
public class JsonFaormat {
	public static void main(String[] args) {
//		String oldS = "116.481461 39.9992314,116.4821842 39.9989952,116.4831369 39.9993804,116.4839109 39.9991038,116.48" +
//				"4335 39.9984769,116.4835958 39.9972253,116.4857044 39.9977299,116.4869863 39.9973936,116.4881261 39.9967533,1" +
//				"16.4892702 39.995853,116.4885785 39.9948915,116.4874467 39.994184,116.4869774 39.9934131,116.4841119 39.99414" +
//				"89,116.484394 39.9931752,116.4846459 39.9916269,116.4836815 39.9911792,116.482482 39.9914169,116.481461 39.99" +
//				"09731,116.4803123 39.9908624,116.47923 39.9911572,116.4777861 39.9909767,116.478213 39.9928876,116.4787162 39." +
//				"9940886,116.4780397 39.9943398,116.4754753 39.994184,116.4754594 39.9950423,116.4772042 39.995853,116.475187" +
//				"9 39.9967004,116.4759357 39.9973936,116.4779337 39.9974132,116.4784582 39.9977833,116.4780161 39.9989981,116." +
//				"4782148 40.0001604,116.4799213 39.9990938,116.4807537 39.9989259";
//		String dou = oldS.replace(",","],[");
//		String kong = dou.replace(" ",",");
//		String sb = "[[" +  kong + "]]";
//		System.out.println(sb);
		String jsonStr = "{" +
				"\"data\": {" +
				"\"area\": 0.6725," +
				"\"wkt\": \"116.481461 39.9992314,116.4821842 39.9989952,116.4831369 39.9993804,116.4839109 39.9991038,116.48" +
				"4335 39.9984769,116.4835958 39.9972253,116.4857044 39.9977299,116.4869863 39.9973936,116.4881261 39.9967533,1" +
				"16.4892702 39.995853,116.4885785 39.9948915,116.4874467 39.994184,116.4869774 39.9934131,116.4841119 39.99414" +
				"89,116.484394 39.9931752,116.4846459 39.9916269,116.4836815 39.9911792,116.482482 39.9914169,116.481461 39.99" +
				"09731,116.4803123 39.9908624,116.47923 39.9911572,116.4777861 39.9909767,116.478213 39.9928876,116.4787162 39." +
				"9940886,116.4780397 39.9943398,116.4754753 39.994184,116.4754594 39.9950423,116.4772042 39.995853,116.475187" +
				"9 39.9967004,116.4759357 39.9973936,116.4779337 39.9974132,116.4784582 39.9977833,116.4780161 39.9989981,116." +
				"4782148 40.0001604,116.4799213 39.9990938,116.4807537 39.9989259\"" +
				"}," +
				"\"errcode\": 0," +
				"\"errdetail\": null," +
				"\"errmsg\": \"OK\"}";
		JSONObject jsonObject = JSONObject.parseObject(jsonStr);
		JSONObject dataObject = jsonObject.getJSONObject("data");
        String wkt = dataObject.getString("wkt");
        String comma = wkt.replace(",","],[");
        String space = comma.replace(" ",",");
        String wktJson = "[[" +  space + "]]";
        jsonObject.getJSONObject("data").put("wkt",wktJson);
		System.out.println(jsonObject);
	}
}