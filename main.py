from cliente import Cliente

def main():
    opt = 4

    while(opt != 0):
        try:
            opt = int(input("Bienvenido al sistema manejador de la famracia de otro mundo, presiona \n 1 para sucursal \n 2 para insumos \n 3 para clientes \n 0 para salir \n"))
        except ValueError:
            print("eso no es un numero")

        if opt == 0:
            print("Saliendo...")
        elif opt == 1:
            print("Sucursal")
        elif opt == 2:
            print("Insumos")
        elif opt == 3:
            print("Clientes")
            menuc()

        

def menuc():
    opc = 5
    while(opc != 0):
        try:
            opc = int(input("Bienvenido al sistema manejador de clientes, presiona "
                            "\n 1 para agregar clientes \n 2 para consultar clientes por ID \n 3 para editar un cliente \n 4 Para eliminar un cliente" \
                            "\n 0 para salir  \n"))
        except ValueError:
            print("eso no es un numero")

        if opc == 0:
            print("Saliendo...")
        elif opc == 1:
            print("Sucursal")
        elif opc == 2:
            print("Insumos")
        elif opc == 3:
            print("Clientes")



if __name__ == "__main__":
    main()