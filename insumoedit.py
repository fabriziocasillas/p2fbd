from insumo import Insumo
from csvmanager import CSVManager


class InsumoEdit:
    def __init__(self):
        self.csv = CSVManager("insumos.csv")

    def agregar_insumo(self, insumo: Insumo):
        filas = self.csv.read_all()

        # Verificar que no exista el ID
        for row in filas:
            if int(row[0]) == insumo.id_producto:
                return False

        self.csv.write_row(insumo.to_csv())
        return True

    def buscar_por_id(self, id_producto: int):
        filas = self.csv.read_all()

        for row in filas:
            if int(row[0]) == id_producto:
                return Insumo.from_csv_row(row)

        return None

    def editar_insumo(self, insumo_editado: Insumo):
        filas = self.csv.read_all()
        nuevas_filas = []
        encontrado = False

        for row in filas:
            if int(row[0]) == insumo_editado.id_producto:
                nuevas_filas.append(insumo_editado.to_csv())
                encontrado = True
            else:
                nuevas_filas.append(row)

        if encontrado:
            self.csv.overwrite(nuevas_filas)

        return encontrado

    def eliminar_insumo(self, id_producto: int):
        filas = self.csv.read_all()
        nuevas_filas = []
        eliminado = False

        for row in filas:
            if int(row[0]) != id_producto:
                nuevas_filas.append(row)
            else:
                eliminado = True

        if eliminado:
            self.csv.overwrite(nuevas_filas)

        return eliminado
