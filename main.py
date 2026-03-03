from cliente import Cliente
from clienteedit import ClienteEdit
from sucursal import Sucursal
from sucursaledit import SucursalEdit
from insumo import Insumo
from insumoedit import InsumoEdit


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
            menui()
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
            confirmacion = sed.agregar_sucursal(nueva_sucursal)
            if(confirmacion):
                print("INFO: Sucursal agregada correctamente.")
                print(nueva_sucursal)
            else:
                print("Hubo un error al agregar la sucursal, segurx que no existe la ID??")

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
            encontrado = sed.editar_sucursal(sucursal_editada)
            if (encontrado):
                print("\nINFO: Sucursal editada correctamente. \n")
                print(sucursal_editada)
            else:
                print("Sucursal no encontrada, segurx que esa es la ID?")

        elif option == 4:
            print("Ingresa el id de la sucursal a eliminar: \n")
            idse = -1
            while idse == -1:
                idse = verifica_entrada()
            sucl = sed.eliminar_sucursal(idse)
            if sucl:
                sed.eliminar_sucursal(idse)
                print("INFO: Sucursal eliminada correctamente.")
            else:
                print(
                    "\nINFO: No se encontro la sucursal a eliminar con ese ID" 
                )




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
            confirmacion = ced.agregar_cliente(nuevo_cliente)
            if confirmacion:
                print("INFO: Cliente agregado correctamente.")
                print(nuevo_cliente)
            else:
                print("Hubo un error al agregar cliente, segurx que no existe la ID??")

        elif option == 2:
            print("dame la id del cliente a buscar\n")
            id_cliente = -1
            while id_cliente == -1:
                id_cliente = verifica_entrada()
            cliente = ced.buscar_por_id(id_cliente)
            if cliente == None:
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
            encontrado = ced.editar_cliente(cliente_editado)
            if encontrado:
                print("\nINFO: Cliente editado correctamente. \n")
                print(cliente_editado)
            else:
                print("Cliente no encontrado, seguro que esa es la ID?")
        elif option == 4:
            print("\nIngresa la id del cliente: ")
            id_cliente_eliminar = -1
            while id_cliente_eliminar == -1:
                id_cliente_eliminar = verifica_entrada()
            cliente_a_eliminar = ced.eliminar_cliente(id_cliente_eliminar)
            if cliente_a_eliminar:
                ced.eliminar_cliente(id_cliente_eliminar)
                print("\nINFO: Cliente Eliminado")

            else:
                print(
                    "\nINFO: No se encontro el cliente a eliminar" 
                )

def menui():
    option = 5
    ied = InsumoEdit()

    while option != 0:
        print(
            "SISTEMA MANEJADOR DE INSUMOS \n"
            " 1. Agregar insumo\n"
            " 2. Consultar insumo por ID\n"
            " 3. Editar insumo\n"
            " 4. Eliminar insumo\n"
            " 0. Salir\n"
            " Elige una opción:"
        )

        option = verifica_entrada()

        if option == 1:
            try:
                print("\nIngresa el ID del producto:")
                id_producto = -1
                while id_producto == -1:
                    id_producto = verifica_entrada()

                nombre = input("Nombre del producto:\n ")
                tipo = input("Tipo (Medicamento/Insumo):\n ")

                precio = float(input("Precio:\n "))
                stock = int(input("Stock:\n "))
                fecha_caducidad = input("Fecha de caducidad (YYYY-MM-DD o vacío):\n ")
                id_sucursal = int(input("ID de sucursal:\n "))

                nuevo_insumo = Insumo(
                    id_producto,
                    nombre,
                    tipo,
                    precio,
                    stock,
                    fecha_caducidad,
                    id_sucursal
                )

                confirmacion = ied.agregar_insumo(nuevo_insumo)

                if confirmacion:
                    print("INFO: Insumo agregado correctamente.")
                    print(nuevo_insumo)
                else:
                    print("ERROR: Ya existe un insumo con esa ID.")

            except ValueError as e:
                print("ERROR:", e)

        elif option == 2:
            print("Ingresa el ID del insumo a buscar:")
            id_producto = -1
            while id_producto == -1:
                id_producto = verifica_entrada()

            insumo = ied.buscar_por_id(id_producto)

            if insumo is None:
                print("INFO: No se encontró el insumo.")
            else:
                print(insumo)

        elif option == 3:
            print("Insumo a editar")
            print("Ingresa el ID del producto:")
            id_producto = -1
            while id_producto == -1:
                id_producto = verifica_entrada()

            nombre = input("Nuevo nombre:\n ")
            tipo = input("Nuevo tipo (Medicamento/Insumo):\n ")
            precio = float(input("Nuevo precio:\n "))
            stock = int(input("Nuevo stock:\n "))
            fecha_caducidad = input("Nueva fecha de caducidad:\n ")
            id_sucursal = int(input("Nuevo ID de sucursal:\n "))

            insumo_editado = Insumo(
                id_producto, nombre, tipo, precio, stock, fecha_caducidad, id_sucursal
            )

            encontrado = ied.editar_insumo(insumo_editado)

            if encontrado:
                print("INFO: Insumo editado correctamente.")
                print(insumo_editado)
            else:
                print("ERROR: Insumo no encontrado.")

        elif option == 4:
            print("Ingresa el ID del insumo a eliminar:")
            id_producto = -1
            while id_producto == -1:
                id_producto = verifica_entrada()

            eliminado = ied.eliminar_insumo(id_producto)

            if eliminado:
                print("INFO: Insumo eliminado correctamente.")
            else:
                print("ERROR: Insumo no encontrado.")


def verifica_entrada():
    try:
        option = int(input(""))
    except ValueError:
        print("¡Ingresa una entrada válida!\n")
        option = -1

    return option


if __name__ == "__main__":
    main()
