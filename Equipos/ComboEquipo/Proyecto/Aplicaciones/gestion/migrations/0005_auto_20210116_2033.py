# Generated by Django 3.1.4 on 2021-01-17 02:33

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('gestion', '0004_auto_20210116_2027'),
    ]

    operations = [
        migrations.AlterField(
            model_name='proveedor',
            name='idProveedor',
            field=models.AutoField(primary_key=True, serialize=False),
        ),
    ]
