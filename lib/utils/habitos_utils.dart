int contarHabitosCumplidos(List<bool> cumplidos) {
  return cumplidos.where((habito) => habito).length;
}