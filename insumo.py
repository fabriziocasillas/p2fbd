class Insumo:
    def __init__(
        self,
        id_producto: int,
        nombre: str,
        tipo: str,
        precio: float,
        stock: int,
        fecha_caducidad: str,
        id_sucursal: int,
    ):
        if tipo not in ["Medicamento", "Insumo"]:
            raise ValueError("El tipo debe ser 'Medicamento' o 'Insumo'")

        self.id_producto = id_producto
        self.nombre = nombre
        self.tipo = tipo
        self.precio = precio
        self.stock = stock
        self.fecha_caducidad = fecha_caducidad
        self.id_sucursal = id_sucursal

    def to_csv(self):
        """
        Convierte el objeto en una lista lista para guardarse en CSV
        """
        return [
            self.id_producto,
            self.nombre,
            self.tipo,
            self.precio,
            self.stock,
            self.fecha_caducidad,
            self.id_sucursal,
        ]

    @classmethod
    def from_csv_row(cls, row):
        """
        Crea una instancia de Insumo a partir de una fila del CSV
        """
        return cls(
            int(row[0]), row[1], row[2], float(row[3]), int(row[4]), row[5], int(row[6])
        )

    def __str__(self):
        return (
            f"Insumo("
            f"id={self.id_producto}, "
            f"nombre='{self.nombre}', "
            f"tipo='{self.tipo}', "
            f"precio={self.precio}, "
            f"stock={self.stock}, "
            f"fecha_caducidad='{self.fecha_caducidad}', "
            f"id_sucursal={self.id_sucursal}"
            f")"
        )
