class CarritoItem {
  final int idCategoriaInsumo;
  final int idInsumo;
  final String nombreInsumo;
  int cantidad;
  final double costoUnitario;
  double subtotal;

  CarritoItem({
    required this.idCategoriaInsumo,
    required this.idInsumo,
    required this.nombreInsumo,
    required this.cantidad,
    required this.costoUnitario,
  }) : subtotal = cantidad * costoUnitario;

  void actualizarSubtotal() {
    subtotal = cantidad * costoUnitario;
  }
}
