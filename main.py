from cliente import Cliente
from clienteedit import ClienteEdit

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
    ced = ClienteEdit()
    while(opc != 0):
        try:
            opc = int(input("Bienvenido al sistema manejador de clientes, presiona "
                            "\n 1 para agregar clientes \n 2 para consultar clientes por ID \n 3 para editar un cliente \n 4 Para eliminar un cliente" \
                            "\n 0 para salir  \n"))
        except ValueError:
            print("eso no es un numero")

        if opc == 1:
            idc = input("dame la id del cliente")
            nmc = input("dame su nombre completo")
            cpc = input("dame su curp")
            tlc = input("dame  su telefono")
            cec = input("dame su correo electrónico ")
            drc = input("dame dirección del cliente")
            ncli = Cliente(idc, nmc, cpc, tlc, cec, drc)
            ced.agregar_cliente(ncli)

        elif opc == 2:
            print("Insumos")
        elif opc == 3:
            print("Clientes")



if __name__ == "__main__":
    main()