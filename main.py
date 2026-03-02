from cliente import Cliente
from clienteedit import ClienteEdit
from sucursal import Sucursal
from sucursaledit import SucursalEdit

def main():
    opt = 4

    while(opt != 0):
        print("Bienvenido al sistema manejador de la famracia de otro mundo, presiona \n 1 para sucursal \n 2 para insumos \n 3 para clientes \n 0 para salir \n")
        opt = recnum()
        if opt == 0:
            print("Saliendo...")
        elif opt == 1:
            print("Sucursales")
            menus()
        elif opt == 2:
            print("Insumos")
        elif opt == 3:
            print("Clientes")
            menuc()

        

def menus():
    ops = 5
    sed = SucursalEdit()
    while(ops != 0):
        print("Bienvenido al sistema manejador de sucursales, presiona "
              "\n 1 para agregar sucursal \n 2 para consultar sucursal por ID \n 3 para editar una sucursal \n 4 para eliminar una sucursal"
              "\n 0 para salir  \n")
        ops = recnum()

        if ops == 1:
            print("dame el id de la sucursal \n")
            ids = -1
            while(ids == -1):
                ids = recnum()

            nms = input("dame el nombre de la sucursal \n ")
            drs = input("dame la direccion \n ")
            tls = input("dame el telefono \n ")
            hrs = input("dame el horario (ej. 08:00-22:00) \n ")
            grs = input("dame el nombre del gerente \n ")
            nsuc = Sucursal(ids, nms, drs, tls, hrs, grs)
            sed.agregar_sucursal(nsuc)
            print("sucursal agregada:")
            print(nsuc)

        elif ops == 2:
            print("dame el id de la sucursal a buscar\n")
            ids = -1
            while(ids == -1):
                ids = recnum()
            suc = sed.buscar_por_id(ids)
            if suc == []:
                print("no se encontro la sucursal buscada")
            else:
                print(suc)

        elif ops == 3:
            print("sucursal a editar\n")
            print("dame el id de la sucursal \n")
            idsb = -1
            while(idsb == -1):
                idsb = recnum()
            nms = input("dame el nombre de la sucursal \n ")
            drs = input("dame la direccion \n ")
            tls = input("dame el telefono \n ")
            hrs = input("dame el horario (ej. 08:00-22:00) \n ")
            grs = input("dame el nombre del gerente \n ")
            nsuc = Sucursal(idsb, nms, drs, tls, hrs, grs)
            try:
                sed.editar_sucursal(nsuc)
                print("sucursal editada")
                print(nsuc)
            except ValueError as e:
                print(f"error: {e}")

        elif ops == 4:
            print("dame el id de la sucursal a eliminar \n")
            idse = -1
            while(idse == -1):
                idse = recnum()
            sucl = sed.buscar_por_id(idse)
            if sucl == []:
                print("no se encontro la sucursal buscada")
            else:
                sed.eliminar_sucursal(idse)
                print("sucursal eliminada")


def menuc():
    opc = 5
    ced = ClienteEdit()
    while(opc != 0):
        print("Bienvenido al sistema manejador de clientes, presiona "
                            "\n 1 para agregar clientes \n 2 para consultar clientes por ID \n 3 para editar un cliente \n 4 Para eliminar un cliente" \
                            "\n 0 para salir  \n")
        opc = recnum()

        if opc == 1:

            print("dame la id del cliente \n")
            idc = -1
            while(idc==-1):
                idc = recnum()
            
            nmc = input("dame su nombre completo \n ")
            cpc = input("dame su curp \n ")
            tlc = input("dame  su telefono \n ")
            cec = input("dame su correo electrónico \n ")
            drc = input("dame dirección del cliente \n")
            ncli = Cliente(idc, nmc, cpc, tlc, cec, drc)
            ced.agregar_cliente(ncli)
            print("cliente agregado:")
            print(ncli)

        elif opc == 2:
            print("dame la id del cliente a buscar\n")
            idc = -1
            while(idc==-1):
                idc = recnum()
            clie = ced.buscar_por_id(idc)
            if clie == []:
                print("no se encontro el cliente buscado")
            else:
                print(clie)

        elif opc == 3:
            print("cliente a editar\n")
            print("dame la id del cliente \n")
            idcb = -1
            while(idcb==-1):
                idcb = recnum()
            nmc = input("dame su nombre completo \n ")
            cpc = input("dame su curp \n ")
            tlc = input("dame  su telefono \n ")
            cec = input("dame su correo electrónico \n ")
            drc = input("dame dirección del cliente \n")
            ncli = Cliente(idcb, nmc, cpc, tlc, cec, drc)
            ced.editar_cliente(ncli)
            print("cliente editado")
            print(ncli)
        elif opc == 4:
            print("dame la id del cliente \n")
            idce = -1
            while(idce==-1):
                idce = recnum()
            cliel = ced.buscar_por_id(idce)
            if cliel == []:
                print("no se encontro el cliente buscado")
            else:
                ced.eliminar_cliente(idce)
                print("cliente eliminado")

def recnum():
    try:
        opc = int(input(""))
    except ValueError:
        print("eso no es un numero")
        opc = -1

    return opc




if __name__ == "__main__":
    main()