from django.urls import path

from django.urls import path

from .views import (
    ClienteApiView,
    ClienteApiId,
    MedicamentoApiView,
    MedicamentoApiId
)

urlpatterns = [
    path('cliente/', ClienteApiView.as_view()),
    path('clienteId/', ClienteApiId.as_view()),

    path('medicamento/', MedicamentoApiView.as_view()),
    path('medicamentoId/', MedicamentoApiId.as_view()),
]