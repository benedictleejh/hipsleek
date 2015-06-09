int get_step(int x) {
  if (x > 10) {
    return 2;
  }
  return 1;
}

int main()  {
  int y, x, step;
  x = y;
  while(y < -2 || y > 2) {
    if (x > 0) {
      y = y - get_step(x);
    } else {
      y = y + get_step(-x);
    }
  }
  return 0;
}
