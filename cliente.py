
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
        return f"{self.id_cliente},{self.nombre_completo},{self.curp},{self.telefono},{self.correo},{self.direccion}"

    @classmethod
    def from_csv_row(cls, row):
        """basicamente necesita el classmethod, por que si no python espera como un self, pero si no existes 
        al momento de leerte como vas a pasarte a ti mismo, entonces pues el classmetho permite evitar eso, y pues nada
        esto crea un objeto de tipo cliente que toma 

        :param row: lista con los atributos del cliente que viene del csv

        :return: una ijnstancia del cliente
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
            f"Cliente("
            f"id={self.id_cliente}, "
            f"nombre='{self.nombre_completo}', "
            f"curp='{self.curp}', "
            f"telefono='{self.telefono}', "
            f"correo='{self.correo}', "
            f"direccion='{self.direccion}'"
            f")"
        )

    