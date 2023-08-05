String formatPeriodText(Map<String, dynamic> item) {
  return '${item['startAt'].split(' ')[1]} ~ ${item['endAt'].split(' ')[1]}';
}

String formatUserText(Map<String, dynamic> item) {
  // タグがない場合
  if (item['tags'].isEmpty) {
    return "NULL";
  }

  if (item['tags'].length == 2) {
    return '${item['tags'][0]['name']} \n ${item['tags'][1]['name']}';
  } else {
    return '${item['tags'][0]['name']}';
  }
}

String formatStayUserText(Map<String, dynamic> item) {
  // タグがない場合
  if (item['tags'].isEmpty) {
    return "NULL";
  }
  if (item['tags'].length == 2) {
    return '${item['room']}\n${item['tags'][1]['name']}';
  } else {
    return '${item['room']}\n${item['tags'][0]['name']}';
  }
}
