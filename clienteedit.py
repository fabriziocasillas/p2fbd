from cliente import Cliente
from csvmanager import CSVManager

class ClienteEdit:
    def __init__(self):
        self.csv = CSVManager("clientes.csv")

    def agregar_cliente(self, cliente):
        self.csv.write_row(cliente.to_csv())

    def obtener_todos(self):
        rows = self.csv.read_all()
        return [Cliente.from_csv_row(r) for r in rows]

    def buscar_por_id(self, id_cliente):
        for cliente in self.obtener_todos():
            if cliente.id_cliente == id_cliente:
                return cliente
        return None

    def eliminar_cliente(self, id_cliente):
        clientes = self.obtener_todos()
        clientes = [c for c in clientes if c.id_cliente != id_cliente]
        self.csv.overwrite([c.to_csv_row() for c in clientes])