from cliente import Cliente
from csvmanager import CSVManager

class ClienteEdit:
    def __init__(self):
        self.csv = CSVManager("clientes.csv")

    def agregar_cliente(self, cliente):
        """ pues recibimos un cliente, utilizamos 
        el metodo nativo para convertirlo a a lgo escribible
        en csv y lo escribimos

        :param cliente: el cliente a escribir
        """
        self.csv.write_row(cliente.to_csv())

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
        clientes = self.obtener_todos()
        clientes = [c for c in clientes if c.id_cliente != idc]
        self.csv.overwrite([c.to_csv_row() for c in clientes])