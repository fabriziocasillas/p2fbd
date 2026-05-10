from rest_framework import serializers
from .models import Cliente, Medicamento


class ClienteSerializer(serializers.ModelSerializer):
    """
    Serializador para el modelo Cliente.
    """

    class Meta:
        model = Cliente
        fields = '__all__'


class MedicamentoSerializer(serializers.ModelSerializer):
    """
    Serializador para el modelo Medicamento.
    """

    class Meta:
        model = Medicamento
        fields = '__all__'