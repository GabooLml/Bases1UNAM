# Generated by Django 3.1.4 on 2021-01-17 02:04

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('gestion', '0001_initial'),
    ]

    operations = [
        migrations.AlterField(
            model_name='proveedor',
            name='cp',
            field=models.IntegerField(null=True),
        ),
    ]
