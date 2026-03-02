from cliente import Cliente
from clienteedit import ClienteEdit
from sucursal import Sucursal
from sucursaledit import SucursalEdit


def main():
    option = 4

    while option != 0:
        print(
            "¡¡¡Bienvenido al sistema manejador de la Farmacia de Otro Mundo!!! \n 1. Sucursal \n 2. Insumos \n 3. Clientes \n 0. Salir \n Elige una opción:"
        )
        option = verifica_entrada()
        if option == 0:
            print("Saliendo...")
        elif option == 1:
            print("\nSUCURSALES:")
            menus()
        elif option == 2:
            print("\nINSUMOS:")
        elif option == 3:
            print("\nCLIENTES:")
            menuc()


def menus():
    option = 5
    sed = SucursalEdit()
    while option != 0:
        print(
            "SISTEMA MANEJADOR DE SUCURSALES"
            "\n 1. Agregar sucursal \n 2. Consultar sucursal por ID \n 3. Editar una sucursal \n 4. Eliminar una sucursal \n 0. Salir  \n Elige una opción:"
        )
        option = verifica_entrada()

        if option == 1:
            print("\nIngresa el id de la sucursal: ")
            ids = -1
            while ids == -1:
                ids = verifica_entrada()

            nombre_sucursal = input("Nombre de la sucursal: \n ")
            direccion = input("Direccion: \n ")
            telefono_sucursal = input("Telefono: \n ")
            horario_sucursal = input("Horario de atención: (ej. 08:00-22:00) \n ")
            gerente_sucursal = input("Nombre del gerente: \n ")
            nueva_sucursal = Sucursal(
                ids,
                nombre_sucursal,
                direccion,
                telefono_sucursal,
                horario_sucursal,
                gerente_sucursal,
            )
            sed.agregar_sucursal(nueva_sucursal)
            print("sucursal agregada:")
            print(nueva_sucursal)

        elif option == 2:
            print("\nIngresa el id de la sucursal a buscar:")
            ids = -1
            while ids == -1:
                ids = verifica_entrada()
            sucursal = sed.buscar_por_id(ids)
            if sucursal == []:
                print("INFO: No se encontro la sucursal buscada. \n")
            else:
                print(sucursal)

        elif option == 3:
            print("Sucursal a editar\n")
            print("Ingresa el id de la sucursal: ")
            idsb = -1
            while idsb == -1:
                idsb = verifica_entrada()
            nombre_sucursal = input("Nombre de la sucursal: \n ")
            direccion = input("Direccion: \n ")
            telefono_sucursal = input("Telefono: \n ")
            horario_sucursal = input("Horario de atención: (ej. 08:00-22:00) \n ")
            gerente_sucursal = input("Nombre del gerente: \n ")
            sucursal_editada = Sucursal(
                idsb,
                nombre_sucursal,
                direccion,
                telefono_sucursal,
                horario_sucursal,
                gerente_sucursal,
            )
            try:
                sed.editar_sucursal(sucursal_editada)
                print("INFO: ¡Sucursal editada exitosamente!")
                print(sucursal_editada + "\n")
            except ValueError as e:
                print(f"error: {e}")

        elif option == 4:
            print("Ingresa el id de la sucursal a eliminar: \n")
            idse = -1
            while idse == -1:
                idse = verifica_entrada()
            sucl = sed.buscar_por_id(idse)
            if sucl == []:
                print("INFO: No se encontro la sucursal buscada.")
            else:
                sed.eliminar_sucursal(idse)
                print("INFO: Sucursal eliminada correctamente.")


def menuc():
    option = 5
    ced = ClienteEdit()
    while option != 0:
        print(
            "SISTEMA MANEJADOR DE CLIENTES \n 1. Agregar cliente \n 2. Consultar cliente por ID \n 3. Editar cliente \n 4. Eliminar cliente \n 0. Salir \n Elige una opicón:"
        )
        option = verifica_entrada()

        if option == 1:

            print("\nIngresa la id del cliente: ")
            id_cliente = -1
            while id_cliente == -1:
                id_cliente = verifica_entrada()

            nombre_completo = input("Ingresa nombre completo: \n ")
            curp = input("Ingresa CURP: \n")
            telefono_cliente = input("Ingresa su telefono: \n ")
            correo_cliente = input("Ingresa su e-mail: \n ")
            direccion_cliente = input("Ingresa dirección del cliente:\n")
            nuevo_cliente = Cliente(
                id_cliente,
                nombre_completo,
                curp,
                telefono_cliente,
                correo_cliente,
                direccion_cliente,
            )
            ced.agregar_cliente(nuevo_cliente)
            print("INFO: Cliente agregado correctamente.")
            print(nuevo_cliente)

        elif option == 2:
            print("dame la id del cliente a buscar\n")
            id_cliente = -1
            while id_cliente == -1:
                id_cliente = verifica_entrada()
            cliente = ced.buscar_por_id(id_cliente)
            if cliente == []:
                print("\nINFO: No se encontro el cliente con id: " + id_cliente)
            else:
                print(cliente)

        elif option == 3:
            print("Cliente a editar.")
            print("\nIngresa la id del cliente: ")
            id_cliente_editar = -1
            while id_cliente_editar == -1:
                id_cliente_editar = verifica_entrada()
            nombre_completo = input("Ingresa nombre completo: \n ")
            curp = input("Ingresa CURP: \n ")
            telefono_cliente = input("Ingresa su telefono: \n ")
            correo_cliente = input("Ingresa su e-mail: \n ")
            direccion_cliente = input("Ingresa dirección del cliente:\n")
            cliente_editado = Cliente(
                id_cliente_editar,
                nombre_completo,
                curp,
                telefono_cliente,
                correo_cliente,
                direccion_cliente,
            )
            ced.editar_cliente(cliente_editado)
            print("\nINFO: Cliente editado correctamente. \n")
            print(cliente_editado)
        elif option == 4:
            print("\nIngresa la id del cliente: ")
            id_cliente_eliminar = -1
            while id_cliente_eliminar == -1:
                id_cliente_eliminar = verifica_entrada()
            cliente_a_eliminar = ced.buscar_por_id(id_cliente_eliminar)
            if cliente_a_eliminar == []:
                print(
                    "\nINFO: No se encontro el cliente con id: " + id_cliente_eliminar
                )
            else:
                ced.eliminar_cliente(id_cliente_eliminar)
                print("\nINFO: Cliente Eliminado")


def verifica_entrada():
    try:
        option = int(input(""))
    except ValueError:
        print("¡Ingresa una entrada válida!\n")
        option = -1

    return option


if __name__ == "__main__":
    main()
