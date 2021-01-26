from django.db import models

# Create your models here.
class Proveedor(models.Model):
    idProveedor = models.AutoField(primary_key = True)
    razonSocial = models.CharField(max_length=100)
    nombre = models.CharField(max_length=50)
    apellidoPaterno = models.CharField(max_length=50)
    apellidoMaterno = models.CharField(max_length=50, null=True,blank=True)
    calle = models.CharField(max_length=50)
    numero = models.SmallIntegerField(null=True)
    cp = models.IntegerField(null=True)
    estado = models.CharField(max_length=50)

    def __str__(self):
        return "{0}".format(self.razonSocial, self.nombre, self.apellidoPaterno)

class Telefono_Provedor(models.Model):
    telefono = models.IntegerField(primary_key = True)
    idProveedor = models.ForeignKey(Proveedor, null=False, blank=False, on_delete=models.CASCADE)
    def __str__(self):
        return "{0}".format(self.telefono)

class Producto(models.Model):
    codigoBarras = models.BigIntegerField()
    marca = models.CharField(max_length=30)
    fecha = models.DateField()
    descripcion = models.CharField(max_length=100)
    stock = models.SmallIntegerField(null=True)
    precioProvedor = models.DecimalField(max_digits=5,decimal_places=2)
    regalo = models.BooleanField(null=True)
    papeleria = models.BooleanField(null=True)
    impresión = models.BooleanField(null=True)
    recarga = models.BooleanField(null=True)
    def __str__(self):
        return "{0} {1}".format(self.codigoBarras, self.marca)

class Cliente(models.Model):
    idCliente = models.AutoField(primary_key=True)
    nombre = models.CharField(max_length=50)
    apellidoPaterno = models.CharField(max_length=50)
    apellidoMaterno = models.CharField(max_length=50, null=True)
    razonSocial = models.CharField(max_length=100)
    calle = models.CharField(max_length=100)
    numero = models.SmallIntegerField()
    cp = models.IntegerField(null=True)
    estado = models.CharField(max_length=50)
    def __str__(self):
        return "{0} {1} {2} {3}".format(self.idCliente, self.nombre, self.apellidoPaterno, self.apellidoMaterno)
    
class Email(models.Model):
    email = models.CharField(max_length=100, primary_key=True)
    idCliente = models.ForeignKey(Cliente, null=False, blank=False,on_delete=models.CASCADE)
    def __str__(self):
        return "{0}".format(self.email)

class Pedido(models.Model):
    numVenta = models.AutoField(primary_key=True)
    fechaVenta = models.DateField()
    totalPago = models.DecimalField(max_digits=5,decimal_places=2)
    idCliente = models.ForeignKey(Cliente, null=False, blank=False, on_delete=models.CASCADE)

class Entrega(models.Model):
    idProveedor = models.ForeignKey(Proveedor, null=False, blank=False, on_delete = models.CASCADE)
    codigoBarras = models.ForeignKey(Producto, null=False, blank=False, on_delete = models.CASCADE)
    def __str__(self):
        return "{0} {1}".format(self.idProveedor, self.codigoBarras)

class Vende(models.Model):
    codigoBarras = models.ForeignKey(Producto, null=False, blank=False, on_delete=models.CASCADE)
    numVenta = models.ForeignKey(Pedido, null=False, blank=False, on_delete=models.CASCADE)
    cantidadArticulo = models.SmallIntegerField()
    totalParcial = models.DecimalField(max_digits=5, decimal_places=2)