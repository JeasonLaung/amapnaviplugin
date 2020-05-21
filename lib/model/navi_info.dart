
import 'dart:typed_data';

class NaviInfo{

   int curStepRetainDistance;
   String nextRoadName;
   int pathRetainDistance;
   int pathRetainTime;
   List<int> iconBitmap;

   NaviInfo(
       {this.curStepRetainDistance,
          this.nextRoadName,
          this.pathRetainDistance,
          this.pathRetainTime,
          this.iconBitmap});

   NaviInfo.fromJson(Map<String, dynamic> json) {
      curStepRetainDistance = json['curStepRetainDistance'];
      nextRoadName = json['nextRoadName'];
      pathRetainDistance = json['pathRetainDistance'];
      pathRetainTime = json['pathRetainTime'];
      iconBitmap = json['iconBitmap']?.cast<int>()??null;
   }

   Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = new Map<String, dynamic>();
      data['curStepRetainDistance'] = this.curStepRetainDistance;
      data['nextRoadName'] = this.nextRoadName;
      data['pathRetainDistance'] = this.pathRetainDistance;
      data['pathRetainTime'] = this.pathRetainTime;
      data['iconBitmap'] = this.iconBitmap;
      return data;
   }
}