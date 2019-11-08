package timer.test;

/**
 * 有的组件需要给每个项目都附上值，notePad++替换粘贴也太慢太费时了
 * @author likaixuan email:likaixuan(a)innodev.com.cn
 * @Date: 2019/10/21 14:19
 * @Version 1.0
 */
public class InsertForAllProject {
	public static void main(String[] args) {
		// 原始sql语句,\n保留，控制台换行显示用
//		 String s = "";
		 String s = "INSERT INTO `yunli`.`ilive_project_menu_component` (`name`, `type`, `size`, `unique_identification`, `project_menu_id`, `content`, `deletion`, `display`, `position`, `insert_time`, `update_time`) VALUES ('高新科技地点', 'CHART', NULL, 'sy_gxkjdd', '424', '[{\"lng\":116.457376,\"lat\":40.102836,\"info\":\" \"},{\"lng\":116.46896,\"lat\":40.107521,\"info\":\" \"},{\"lng\":116.473968,\"lat\":40.105511,\"info\":\" \"},{\"lng\":116.422782,\"lat\":40.119107,\"info\":\" \"}]', NULL, '1', NULL, NULL, '2019-10-31 18:32:15');\n";// 待替换的其他项目的id
		int[] ids = {426,428,430,432,434,436,438,440,442,444,446,448,450,485};
		for (int i = 0; i < ids.length; i++){
			String s2 = s.replace("'424'", String.valueOf(ids[i]));
			System.out.println(s2);
		}
	}
}
