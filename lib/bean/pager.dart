class Pager<T> {
  int page;
  int size;
  int total;
  int totalSize;
  late int totalPage;
  List<T> rows;

  Pager(this.page, this.size, this.total, this.totalSize, this.rows){
    if (size == 0){
      totalPage = 0;
    }
    if (totalSize % size == 0){
      totalPage = totalSize ~/ size;
    }
    totalPage = totalSize ~/ size + 1;
  }


}