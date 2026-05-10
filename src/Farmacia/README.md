# Importante

## Para ejecutar:

Primeramente se necesitan por precondiciones tener la base de datos ya creada y poblada, esto se crea con los archivos `*.sql` en el directorio de nombre `SQL`. 

Una vez creada la base de datos, en el archivo `settings.py` en el campo `DATABASES` configurar las credenciales de la base de datos --la misma usada para crear y poblar--.

El `src` se entrega sin el `.venv`, por lo tanto es importante crearlo e instalar las bibliotecas y requerimientos necesarios:

- Dentro de ../SRC/Farmacia/ ejecutar:
```
python3 -m venv .venv
```
Esto crea el entorno virtual.

- Activarlo:
```
source .venv/bin/activate
```

- Instalar requerimientos:

```
pip install -r requirements.txt
```

- Ejecutar las migraciones requeridas:

```
python manage.py makemigrations
python manage.py migrate
```

- Ejecutar el servidor local:

```
python3 manage.py runserver
```

Y listo, ya se pueden probar las URL's de la API :)
