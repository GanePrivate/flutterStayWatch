String formatPeriodText(Map<String, dynamic> item) {
  return '${item['startAt'].split(' ')[1]} ~ ${item['endAt'].split(' ')[1]}';
}

String formatUserText(Map<String, dynamic> item) {
  if (item['tags'].length == 2) {
    return '${item['tags'][0]['name']} \n ${item['tags'][1]['name']}';
  } else {
    return '${item['tags'][0]['name']}\n${item['tags'][1]['name']}\n${item['tags'][2]['name']}';
  }
}

String formatStayUserText(Map<String, dynamic> item) {
  if (item['tags'].length == 2) {
    return '${item['room']}\n${item['tags'][1]['name']}';
  } else {
    return '${item['room']}\n${item['tags'][1]['name']} - ${item['tags'][2]['name']}';
  }
}