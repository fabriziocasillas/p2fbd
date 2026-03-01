
class Cliente:
    def __init__(
        self,
        id_cliente: int,
        nombre_completo: str,
        curp: str,
        telefono: str,
        correo: str,
        direccion: str
    ):
        self.id_cliente = id_cliente
        self.nombre_completo = nombre_completo
        self.curp = curp
        self.telefono = telefono
        self.correo = correo
        self.direccion = direccion

    def to_csv(self):
        return f"{self.id_cliente},{self.nombre},{self.curp},{self.telefono},{self.correo},{self.direccion}"

    def __str__(self):
        return (
            f"Cliente("
            f"id={self.id_cliente}, "
            f"nombre='{self.nombre_completo}', "
            f"curp='{self.curp}', "
            f"telefono='{self.telefono}', "
            f"correo='{self.correo}', "
            f"direccion='{self.direccion}'"
            f")"
        )
