from django.shortcuts import render
from rest_framework import status
from rest_framework.views import APIView
from rest_framework.response import Response

from .models import Cliente, Medicamento
from .serializers import ClienteSerializer, MedicamentoSerializer


class ClienteApiView(APIView):
    """
    Vista API para realizar operaciones CRUD sobre Cliente.
    """

    def get(self, request):
        """
        Obtiene todos los clientes.
        """
        serializer = ClienteSerializer(Cliente.objects.all(), many=True)
        return Response(status=status.HTTP_200_OK, data=serializer.data)

    def post(self, request):
        """
        Inserta un nuevo cliente.
        """
        serializer = ClienteSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response(status=status.HTTP_201_CREATED, data=serializer.data)

    def put(self, request):
        """
        Actualiza un cliente existente.
        """
        cliente = Cliente.objects.get(id_cliente=request.data.get('id_cliente'))
        serializer = ClienteSerializer(cliente, data=request.data)

        serializer.is_valid(raise_exception=True)
        serializer.save()

        return Response(status=status.HTTP_200_OK, data=serializer.data)

    def delete(self, request):
        """
        Elimina un cliente utilizando su identificador.
        """
        cliente = Cliente.objects.filter(
            id_cliente=request.data.get('id_cliente')
        ).delete()

        return Response(status=status.HTTP_200_OK, data=cliente)


class ClienteApiId(APIView):
    """
    Vista API para obtener un cliente por ID.
    """

    def get(self, request):
        """
        Obtiene un cliente usando su identificador.
        """
        serializer = ClienteSerializer(
            Cliente.objects.filter(
                id_cliente=request.data.get('id_cliente')
            ),
            many=True
        )

        return Response(status=status.HTTP_200_OK, data=serializer.data)


class MedicamentoApiView(APIView):
    """
    Vista API para realizar operaciones CRUD sobre Medicamento.
    """

    def get(self, request):
        """
        Obtiene todos los medicamentos.
        """
        serializer = MedicamentoSerializer(
            Medicamento.objects.all(),
            many=True
        )

        return Response(status=status.HTTP_200_OK, data=serializer.data)

    def post(self, request):
        """
        Inserta un nuevo medicamento.
        """
        serializer = MedicamentoSerializer(data=request.data)

        serializer.is_valid(raise_exception=True)
        serializer.save()

        return Response(status=status.HTTP_201_CREATED, data=serializer.data)

    def put(self, request):
        """
        Actualiza un medicamento existente.
        """
        medicamento = Medicamento.objects.get(
            id_producto=request.data.get('id_producto')
        )

        serializer = MedicamentoSerializer(
            medicamento,
            data=request.data
        )

        serializer.is_valid(raise_exception=True)
        serializer.save()

        return Response(status=status.HTTP_200_OK, data=serializer.data)

    def delete(self, request):
        """
        Elimina un medicamento usando su identificador.
        """
        medicamento = Medicamento.objects.filter(
            id_producto=request.data.get('id_producto')
        ).delete()

        return Response(status=status.HTTP_200_OK, data=medicamento)


class MedicamentoApiId(APIView):
    """
    Vista API para obtener un medicamento por ID.
    """

    def get(self, request):
        """
        Obtiene un medicamento usando su identificador.
        """
        serializer = MedicamentoSerializer(
            Medicamento.objects.filter(
                id_producto=request.data.get('id_producto')
            ),
            many=True
        )

        return Response(status=status.HTTP_200_OK, data=serializer.data)