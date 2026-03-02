class Sucursal:
    def __init__(
        self,
        id_sucursal: int,
        nombre: str,
        direccion: str,
        telefono: str,
        horario: str,
        gerente: str
    ):
        self.id_sucursal = id_sucursal
        self.nombre = nombre
        self.direccion = direccion
        self.telefono = telefono
        self.horario = horario
        self.gerente = gerente

    def to_csv(self):
        """Devuelve los atributos de la sucursal como lista para escribir en CSV.

        :return: lista con los campos de la sucursal
        """
        return [
            self.id_sucursal,
            self.nombre,
            self.direccion,
            self.telefono,
            self.horario,
            self.gerente
        ]

    @classmethod
    def from_csv_row(cls, row):
        """Crea una instancia de Sucursal a partir de una fila del CSV.

        :param row: lista con los atributos de la sucursal leidos del csv
        :return: una instancia de Sucursal
        """
        return cls(
            int(row[0]),
            row[1],
            row[2],
            row[3],
            row[4],
            row[5]
        )

    def __str__(self):
        return (
            f"Sucursal("
            f"id={self.id_sucursal}, "
            f"nombre='{self.nombre}', "
            f"direccion='{self.direccion}', "
            f"telefono='{self.telefono}', "
            f"horario='{self.horario}', "
            f"gerente='{self.gerente}'"
            f")"
        )
