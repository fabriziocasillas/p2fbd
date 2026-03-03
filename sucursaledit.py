from sucursal import Sucursal
from csvmanager import CSVManager


class SucursalEdit:
    def __init__(self):
        self.csv = CSVManager("sucursales.csv")

    def agregar_sucursal(self, sucursal):
        """Agrega una nueva sucursal al CSV.

        :param sucursal: la sucursal a guardar
        """
        existente = self.buscar_por_id(sucursal.id_sucursal)

        if existente is not None:
            return False

        self.csv.write_row(sucursal.to_csv())
        return True

    def obtener_todas(self):
        """Lee todas las sucursales del CSV.

        :return: lista de objetos Sucursal
        """
        rows = self.csv.read_all()
        return [Sucursal.from_csv_row(r) for r in rows]

    def buscar_por_id(self, ids):
        """Busca una sucursal por su ID.

        :param ids: el id de la sucursal a buscar
        :return: la sucursal encontrada o lista vacia si no existe
        """
        for sucursal in self.obtener_todas():
            if sucursal.id_sucursal == ids:
                return sucursal
        return None

    def eliminar_sucursal(self, ids):
        """Elimina la sucursal con el id dado reescribiendo el CSV sin ella.

        :param ids: el id de la sucursal a eliminar
        """

        cen = self.buscar_por_id(ids)
        if not cen:
            return False
        else:
            sucursales = self.obtener_todas()
            sucursales = [s for s in sucursales if s.id_sucursal != ids]
            self.csv.overwrite([s.to_csv() for s in sucursales])
            return True

    def editar_sucursal(self, suca):
        """Reemplaza la sucursal con el mismo id por la version actualizada.

        :param suca: la sucursal con los datos actualizados
        """
        sucursales = self.obtener_todas()
        encontrada = False

        for i, sucursal in enumerate(sucursales):
            if sucursal.id_sucursal == suca.id_sucursal:
                sucursales[i] = suca
                encontrada = True
                break

        if not encontrada:
            return False

        self.csv.overwrite([s.to_csv() for s in sucursales])
        return True

