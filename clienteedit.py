from cliente import Cliente
from csvmanager import CSVManager

class ClienteEdit:
    def __init__(self):
        self.csv = CSVManager("clientes.csv")

    def agregar_cliente(self, cliente):
        """
            pues recibimos un cliente, utilizamos 
            el metodo nativo para convertirlo a a lgo escribible
            en csv y lo escribimos, aunque primero checa antes si ya existe el cliente con la ID

        :param cliente: el cliente a escribir
        :return: true si se agrego, false si no
        """
        existente = self.buscar_por_id(cliente.id_cliente)

        if existente is not None:
            return False

        self.csv.write_row(cliente.to_csv())
        return True

        
    def obtener_todos(self):
        """Utilizamos la funcion del csv manager para
        leer todos los clientes

        :return: una lista con todos los clientes
        """
        rows = self.csv.read_all()
        return [Cliente.from_csv_row(r) for r in rows]

    def buscar_por_id(self, idc):
        """Utilizamos la obtencion de todos los clientes 
        y buscamos la id, si tenemos la id que queremos regresamos ese cliente

        :param idc: la id a buscar

        :return: o un cliente o nada si no hay ningun cliente con esa id
        """
        for cliente in self.obtener_todos():
            if cliente.id_cliente == idc:
                return cliente
        return None

    def eliminar_cliente(self, idc):
        """sobreescribimos todo el csv. si la id de un cliente es la que queremos 
        eliminar, no lo agregamos a los clientes que vamos a escribir, y despues reescribimos todos
        los clientes

        :param idc: la ID del cliente a eliminar
        """

        cen = self.buscar_por_id(idc)
        if not cen:
            return False
        else:
            clientes = self.obtener_todos()
            clientes = [c for c in clientes if c.id_cliente != idc]
            self.csv.overwrite([c.to_csv() for c in clientes])
            return True

    def editar_cliente(self, clia):
        """es casi lo mismo que al eliminar, solo que en lugar de no incluirlo en la lista de clientes a 
        sobreescribir se añade el cliente actualizado el lugar del viejo cliente

        :param clia: el cliente actualizado
        """
        clientes = self.obtener_todos()
        encontrado = False

        for i, cliente in enumerate(clientes):
            if cliente.id_cliente == clia.id_cliente:
                clientes[i] = clia
                encontrado = True
                break

        if not encontrado:
            return False
        self.csv.overwrite([c.to_csv() for c in clientes])
        return True