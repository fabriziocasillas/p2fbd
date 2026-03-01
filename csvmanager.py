import csv
import os

class CSVManager:
    """ Para estandarizar la implementacion para con los archivos csv un unico readerwriter que no
    conoce ni a las clases a ingresar ni a los que las manejoan
    """
    def __init__(self, filename):
        """ para que se pueda escribir en un csv necesitamos el nombre del csv, aqui se inicializa

        :param fliename: el nombre del csv
        """
        self.filename = filename


    def write_row(self, row):
        """_con este metodo escribimos una nueva fila en el archivo

        :param row: una lista con lo que sea que escribamos 
        """
        with open(self.filename, "a", newline="", encoding="utf-8") as f:
            csv.writer(f).writerow(row)

        
    def read_all(self):
        """
        Lee un csv, si no existe, devuelve lista vacia
        , si si, cada elemento de la lista es un fila del csv
        :return: lista de filas del  CSV
        """
        if not os.path.exists(self.filename):
            return []

        with open(self.filename, "r", newline="", encoding="utf-8") as f:
            return list(csv.reader(f))

    def overwrite(self, rows):
        """
        se reescribe el archivo con las filas que le demos, se abre en modo escritura el archivo

        :param rows: filas que se escribirán en el CSV
        """
        with open(self.filename, "w", newline="", encoding="utf-8") as f:
            csv.writer(f).writerows(rows)