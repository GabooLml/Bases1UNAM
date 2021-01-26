from django.contrib import admin
from Aplicaciones.gestion.models import *

# Register your models here.
admin.site.register(Producto)
admin.site.register(Proveedor)
admin.site.register(Cliente)
admin.site.register(Pedido)
admin.site.register(Telefono_Provedor)
admin.site.register(Entrega)
admin.site.register(Vende)
admin.site.register(Email)