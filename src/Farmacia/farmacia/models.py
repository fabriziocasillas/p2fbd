from django.db import models


class Cliente(models.Model):
    """
    Modelo que representa un cliente dentro del sistema farmacéutico.

    Attributes:
        id_cliente (int): Identificador único del cliente.
        nombre (str): Nombre del cliente.
        apellido_paterno (str): Apellido paterno.
        apellido_materno (str): Apellido materno.
        fecha_nacimiento (date): Fecha de nacimiento.
        metodo_pago (str): Método de pago preferido.
        calle (str): Calle del domicilio.
        num_int (str): Número interior.
        num_ext (str): Número exterior.
        colonia (str): Colonia del domicilio.
        usuario (str): Nombre de usuario.
        contrasenia (str): Contraseña del usuario.
        numero_tarjeta (str): Número de tarjeta bancaria.
        fecha_vencimiento (date): Fecha de vencimiento de la tarjeta.
        esClienteOnline (bool): Indica si es cliente en línea.
        esClienteFisico (bool): Indica si es cliente físico.
    """

    id_cliente = models.IntegerField(primary_key=True)
    nombre = models.CharField(max_length=50)
    apellido_paterno = models.CharField(max_length=50)
    apellido_materno = models.CharField(max_length=50)
    fecha_nacimiento = models.DateField()
    metodo_pago = models.CharField(max_length=30)
    calle = models.CharField(max_length=100)
    num_int = models.CharField(max_length=10)
    num_ext = models.CharField(max_length=10)
    colonia = models.CharField(max_length=50)
    usuario = models.CharField(max_length=50)
    contrasenia = models.CharField(max_length=50)
    numero_tarjeta = models.CharField(max_length=20)
    fecha_vencimiento = models.DateField()
    esclienteonline = models.BooleanField()
    esclientefisico = models.BooleanField()

    class Meta:
        db_table = 'cliente'
        ordering = ['nombre']

    def __str__(self):
        """
        Regresa una representación en texto del cliente.
        """
        return self.nombre


class Medicamento(models.Model):
    """
    Modelo que representa un medicamento dentro del sistema.

    Attributes:
        id_producto (int): Identificador único del medicamento.
        nombre (str): Nombre del medicamento.
        nombre_generico (str): Nombre genérico.
        nombre_comercial (str): Nombre comercial.
        descripcion (str): Descripción del medicamento.
        laboratorio_fabricante (str): Laboratorio fabricante.
        forma_farmaceutica (str): Forma farmacéutica.
        via_administracion (str): Vía de administración.
        presentacion (str): Presentación del medicamento.
        potencia (str): Potencia del medicamento.
        esteril (bool): Indica si es estéril.
        clasificacion (str): Clasificación del medicamento.
        tipo_control (str): Tipo de control.
        precio_publico (decimal): Precio al público.
        precio_unitario (decimal): Precio unitario.
        fecha_recibimiento (date): Fecha de recibimiento.
        fecha_caducidad (date): Fecha de caducidad.
        preparacion_oficial (str): Preparación oficial.
        preparacion_pediatrica (str): Preparación pediátrica.
        preparacion_dermatologica (str): Preparación dermatológica.
    """

    id_producto = models.IntegerField(primary_key=True)
    nombre = models.CharField(max_length=100)
    nombre_generico = models.CharField(max_length=100)
    nombre_comercial = models.CharField(max_length=100)
    descripcion = models.TextField()
    laboratorio_fabricante = models.CharField(max_length=100)
    forma_farmaceutica = models.CharField(max_length=50)
    via_administracion = models.CharField(max_length=50)
    presentacion = models.CharField(max_length=50)
    potencia = models.CharField(max_length=50)
    esteril = models.BooleanField()
    clasificacion = models.CharField(max_length=50)
    tipo_control = models.CharField(max_length=50)
    precio_publico = models.DecimalField(max_digits=10, decimal_places=2)
    precio_unitario = models.DecimalField(max_digits=10, decimal_places=2)
    fecha_recibimiento = models.DateField()
    fecha_caducidad = models.DateField()
    preparacion_oficial = models.TextField()
    preparacion_pediatrica = models.TextField()
    preparacion_dermatologica = models.TextField()

    class Meta:
        db_table = 'medicamento'
        ordering = ['nombre']

    def __str__(self):
        """
        Regresa una representación en texto del medicamento.
        """
        return self.nombre