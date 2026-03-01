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

        
    


if __name__ == "__main__":
    main()